//
//  ImageViewController.m
//  QRCode
//
//  Created by lisong on 2016/11/1.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "ImageViewController.h"
#import "UIViewController+Message.h"

@interface ImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}

#pragma mark - 从相册选择
- (void)rightBarButtonItemClick:(UIBarButtonItem *)item
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else
    {
        [self showAlertWithTitle:@"提示" message:@"设备不支持访问相册" handler:nil];
    }
}

#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        [self findQRCodeFromImage:image];
    }];
}

#pragma mark - 长按识别二维码
- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [self findQRCodeFromImage:self.imageView.image];
    }
}

- (void)findQRCodeFromImage:(UIImage *)image
{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1)
    {
        CIQRCodeFeature *feature = [features firstObject];
        
        [self showAlertWithTitle:@"扫描结果" message:feature.messageString handler:nil];
    }
    else
    {
        [self showAlertWithTitle:@"提示" message:@"图片里没有二维码" handler:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
