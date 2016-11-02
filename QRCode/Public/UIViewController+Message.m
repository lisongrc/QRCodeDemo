//
//  UIAlertController+Message.m
//  QRCode
//
//  Created by lisong on 2016/11/2.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "UIViewController+Message.h"

@implementation UIViewController (Message)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
