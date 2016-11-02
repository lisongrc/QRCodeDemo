//
//  CreateViewController.m
//  QRCode
//
//  Created by lisong on 2016/11/1.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "CreateViewController.h"
#import "UIViewController+Message.h"

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRandomColor kRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define qrImageSize CGSizeMake(300,300)

@interface CreateViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = [self createQRImageWithString:@"小松哥" size:qrImageSize];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self createButtonDidClick:nil];
    
    return YES;
}

#pragma mark - Methods
- (IBAction)createButtonDidClick:(UIButton *)sender
{
    [self.textField resignFirstResponder];
    
    if (self.textField.text.length > 0)
    {
        self.imageView.image = [self createQRImageWithString:self.textField.text size:qrImageSize];
    }
    else
    {
        [self showAlertWithTitle:@"提示" message:@"请先输入文字" handler:nil];
    }
}

- (IBAction)changeColorButtonDidClick:(UIButton *)sender
{
    UIImage *image = [self createQRImageWithString:self.textField.text size:qrImageSize];
    
    self.imageView.image = [self changeColorForQRImage:image backColor:kRandomColor frontColor:kRandomColor];
}

- (IBAction)addSamllImageButtonDidClick:(UIButton *)sender
{
    self.imageView.image = [self addSmallImageForQRImage:self.imageView.image];
}

/** 生成指定大小的黑白二维码 */
- (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    NSLog(@"%@",qrFilter.inputKeys);
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    //放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

/** 为二维码改变颜色 */
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor
{
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",[CIImage imageWithCGImage:image.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor],
                             nil];
    
    return [UIImage imageWithCIImage:colorFilter.outputImage];
}

/** 在二维码中心加一个小图 */
- (UIImage *)addSmallImageForQRImage:(UIImage *)qrImage
{
    UIGraphicsBeginImageContext(qrImage.size);
    
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    UIImage *image = [UIImage imageNamed:@"small"];
    
    CGFloat imageW = 50;
    CGFloat imageX = (qrImage.size.width - imageW) * 0.5;
    CGFloat imgaeY = (qrImage.size.height - imageW) * 0.5;
    
    [image drawInRect:CGRectMake(imageX, imgaeY, imageW, imageW)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
