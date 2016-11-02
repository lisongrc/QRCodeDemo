//
//  MaskView.m
//  QRCode
//
//  Created by lisong on 2016/11/1.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()

@property (nonatomic, strong) CALayer *lineLayer;

@end

@implementation MaskView

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 300;
    CGFloat pickingFieldHeight = 300;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2, (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    //填充使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
//    CGFloat dash[2] = {4,4};
//    [pickingFieldPath setLineDash:dash count:2 phase:0];
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)didMoveToSuperview
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [self.layer addSublayer:self.lineLayer];
    
    [self resumeAnimation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)stopAnimation
{
    [self.lineLayer removeAnimationForKey:@"translationY"];
}

- (void)resumeAnimation
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 1.5;
    basic.repeatCount = NSIntegerMax;
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
}

- (CALayer *)lineLayer
{
    if (!_lineLayer)
    {
        _lineLayer = ({
        
            CALayer *layer = [CALayer layer];
            layer.contents = (id)[UIImage imageNamed:@"line"].CGImage;
            layer.frame = CGRectMake((self.frame.size.width - 300) / 2, (self.frame.size.height - 300) / 2, 300, 2);
            
            layer;
        });
    }
    
    return _lineLayer;
}

@end
