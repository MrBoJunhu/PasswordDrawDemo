//
//  PasswordView.h
//  PasswordDrawDemo
//
//  Created by BillBo on 2017/8/22.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPasswordKey @"password_key"

typedef void(^drawOverBlock)(NSString *passwordString);

@interface PasswordView : UIView

/**
 绘制指纹锁
 @param frame frame description
 @param complete complete description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame drawComplete:(drawOverBlock)complete;

/**
 清空绘制的密码
 */
- (void)clearDrawLine;


@end
