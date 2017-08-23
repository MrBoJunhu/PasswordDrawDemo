//
//  PasswordView.m
//  PasswordDrawDemo
//
//  Created by BillBo on 2017/8/22.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "PasswordView.h"

@interface PasswordView () {
   
    BOOL drawOver;
    
    BOOL isLegitimate;
    
    BOOL hasSettedPassword;
    
    BOOL checkRight;
    
}


@property (nonatomic, strong) NSMutableArray *btnArray;

/**
 九宫格的中心点集合
 */
@property (nonatomic, strong) NSMutableArray *btnCenterArray;

/**
 需要绘制的点集合
 */
@property (nonatomic, strong) NSMutableArray *drawPointArray;

/**
 临时存储点
 */
@property (nonatomic, strong) NSMutableArray *tempTagArray;

/**
 绘制结束回调
 */
@property (nonatomic, copy) drawOverBlock drawBlock;

/**
 密码
 */
@property (nonatomic, copy) NSString *passwordString;

@end

@implementation PasswordView

- (NSMutableArray *)btnCenterArray{
    
    if (!_btnCenterArray) {
        
        self.btnCenterArray = [NSMutableArray array];
        
    }
    
    return _btnCenterArray;
    
}

- (NSMutableArray *)btnArray {
    
    if (!_btnArray) {
        
        self.btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
    
}

- (NSMutableArray *)tempTagArray {
    
    if (!_tempTagArray) {
        
        self.tempTagArray = [NSMutableArray array];
        
    }
    
    return _tempTagArray;
    
}

- (NSMutableArray *)drawPointArray {
    
    if (!_drawPointArray) {
        
        self.drawPointArray = [NSMutableArray array];
        
    }
    
    return _drawPointArray;
    
}

#pragma mark -


- (instancetype)initWithFrame:(CGRect)frame  drawComplete:(drawOverBlock)complete{
    
    if (self = [super initWithFrame:frame]) {
        
        self.drawBlock = complete;
        
        self.backgroundColor = [UIColor orangeColor];
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
   
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    
    if (drawOver) {
        
        if (isLegitimate) {
           
            if (hasSettedPassword) {
                
                if (checkRight) {
                    
                    CGContextSetRGBStrokeColor(ctx, 0, 255, 0, 1);
                    
                }else{
                    
                    CGContextSetRGBStrokeColor(ctx, 255, 0, 0, 1);
                    
                }

            }else{
                
                CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
                
            }
            
        }else{
           
            CGContextSetRGBStrokeColor(ctx, 255, 0, 0, 1);
            
        }
        
    }
    
    CGContextSetLineWidth(ctx, 10);
    
    NSUInteger count = self.drawPointArray.count;
    
    CGPoint totalPoints[count];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        NSValue *pointValue = self.drawPointArray[i];
        
        totalPoints[i] = pointValue.CGPointValue;
        
    }
    
    CGContextAddLines(ctx,totalPoints , self.drawPointArray.count);
    
    CGContextDrawPath(ctx, kCGPathStroke);
    
}


- (void)layoutSubviews {
    
    [self createUI];
    
}

- (void)createUI {
    
    CGFloat btn_Width = 40;
    
    CGFloat btn_Height = 40;
    
    CGFloat space = (self.frame.size.width- 3 * btn_Width) / 4;
    
    NSUInteger  tag = 1;
    
    for (NSUInteger i = 0; i < 3; i ++) {
        
        for (NSUInteger j = 0; j < 3; j++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //注意此处, 否则touchBegin touchMove 无法捕获到btn上的事件
            btn.userInteractionEnabled = NO;
            
            btn.frame = CGRectMake(space + (btn_Width + space) * (j % 3), space + ( space + btn_Height) * (i % 3), btn_Width, btn_Height);
            
            btn.layer.cornerRadius = btn_Width/2;
            
            btn.backgroundColor = [UIColor lightGrayColor];
            
            [self setButton:btn borderColor:[UIColor blackColor]];
            
            btn.layer.borderWidth = 2;
            
            [self.btnArray addObject:btn];
            
            btn.tag = tag;
           
            tag ++;
            
            CGPoint center = btn.center;
            
            NSValue  * centerValue = [NSValue valueWithCGPoint:center];
            
            [self.btnCenterArray addObject:centerValue];
            
            [self addSubview:btn];

        }
        
    }
    
}

- (void)removeAllSubviews {
    
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview];
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  
    [self clearDrawLine];
    
    UITouch *touch = [touches anyObject];
    
    UIView *touchView = touch.view;
    
    CGPoint touchPoint = [touch locationInView:touchView];
    
    for (NSUInteger i = 0 ; i  < self.btnArray.count; i ++) {
        
        UIButton *btn = (UIButton *)self.btnArray[i];
        
        if (CGRectContainsPoint(btn.frame, touchPoint)) {
        
            //开始的点在 btn 的 frame 内
            
            NSValue *value = [NSValue valueWithCGPoint:btn.center];
            
            if (![self.drawPointArray containsObject:value]) {
               
                [self setButton:btn borderColor:[UIColor whiteColor]];
                
                [self.drawPointArray addObject:value];
            
                [self.tempTagArray addObject:[NSNumber numberWithInteger:btn.tag]];
            
            }
            
        }
        
    }
 
    [self setNeedsDisplay];
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    UIView *touchView = touch.view;
    
    CGPoint touchPoint = [touch locationInView:touchView];
    
    for (NSUInteger i = 0 ; i  < self.btnArray.count; i ++) {
        
        UIButton *btn = (UIButton *)self.btnArray[i];
        
        if (CGRectContainsPoint(btn.frame, touchPoint)) {
            
            //开始的点在 btn 的 frame 内
            
            NSValue *value = [NSValue valueWithCGPoint:btn.center];
            
            if (![self.drawPointArray containsObject:value]) {
                
                [self setButton:btn borderColor:[UIColor whiteColor]];
                
                [self.drawPointArray addObject:value];
               
                [self.tempTagArray addObject:[NSNumber numberWithInteger:btn.tag]];
            
            }
            
        }
        
    }
    
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    drawOver = YES;
    
    NSUInteger count = self.drawPointArray.count;
    
     isLegitimate = (count < 4 || count > 9) ? NO : YES;
    
    NSString *psd = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
    
    if (!isLegitimate) {
        
        [self.tempTagArray removeAllObjects];
        
    }
    
    self.passwordString = [self.tempTagArray componentsJoinedByString:@""];
    
    hasSettedPassword = psd ? YES : NO;
    
    checkRight = [psd isEqualToString:self.passwordString] ? YES : NO;
    
    for (UIButton *btn in self.btnArray) {
        
        if (!isLegitimate) {
            
            if (btn.layer.borderColor == [UIColor whiteColor].CGColor) {
                
                [self setButton:btn borderColor:[UIColor redColor]];
                
            }
            
        }else{
            
            if (psd) {
              
                //密码校验
                if (btn.layer.borderColor == [UIColor whiteColor].CGColor) {
                    
                    if (checkRight) {
                        //密码验证正确
                        
                        [self setButton:btn borderColor:[UIColor greenColor]];

                    }else{
                        
                        [self setButton:btn borderColor:[UIColor redColor]];

                    }
                    
                }
                
            }else{
                
                if (btn.layer.borderColor == [UIColor whiteColor].CGColor) {
                    
                    
                }else{
                    
                    [self setButton:btn borderColor:[UIColor blackColor]];
                    
                }
                
            }
            
        }
        
    }
    
    [self setNeedsDisplay];
    
    if (self.drawBlock) {
        
        self.drawBlock(self.passwordString);
   
    }
    
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}

- (void)clearDrawLine {
   
    drawOver = NO;
    
    checkRight = NO;
    
    isLegitimate = NO;
    
    [self.drawPointArray removeAllObjects];
    
    [self.tempTagArray removeAllObjects];
 
    for (UIButton *btn in self.btnArray) {
        
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
    
    [self setNeedsDisplay];
    
}


- (void)setButton:(UIButton *)sender title:(NSString *)title {
    
    [sender setTitle:title forState:UIControlStateNormal];
    
}

- (void)setButton:(UIButton *)sender borderColor:(UIColor *)color{
    
    sender.layer.borderColor = color.CGColor;
    
}


@end
