//
//  UIAlertController+Message.h
//  QRCode
//
//  Created by lisong on 2016/11/2.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Message)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler;

@end
