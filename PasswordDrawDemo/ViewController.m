//
//  ViewController.m
//  PasswordDrawDemo
//
//  Created by BillBo on 2017/8/22.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "ViewController.h"

#import "PasswordView.h"

@interface ViewController () {
    
    UIButton *clearBtn;
    
}

@property (nonatomic, strong)  PasswordView *pswView;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"指纹密码";
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    __block NSString * pas = [userDefaults objectForKey:kPasswordKey];
   
    
    self.pswView = [[PasswordView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width) drawComplete:^(NSString *passwordString) {
       
        pas = [userDefaults objectForKey:kPasswordKey];
      
        if (passwordString.length > 0) {
            
            if (pas) {
                
                NSLog(@"当前存储的密码是 : %@", pas);
                
                if (![passwordString isEqualToString:pas]) {
                    
                    NSLog(@"密码错误, 请重新绘制!");
                    
                }else{
                    
                    NSLog(@"恭喜你密码输入正确啦!");
                }
                
            }else{
                
                [userDefaults setObject:passwordString forKey:kPasswordKey];
                
                NSLog(@"密码设置成功!");
            
            }
            
        }else{
            
            NSLog(@"密码绘制不合法请重新绘制(4 ~ 9 位有效密码)");
            
        }
        
        [self addClearBtn:pas];
        
    }];
    
    [self.view addSubview:_pswView];
    
    [self addClearBtn:pas];
    
}

- (void)addClearBtn:(NSString *)pas {
    
    if (!pas.length) {
        
        return;
        
    }
    
    if (clearBtn) {
      
        [clearBtn removeFromSuperview];
    }
    
    clearBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat clearBtn_Width = 200;
    
    clearBtn.frame = CGRectMake(_pswView.center.x - clearBtn_Width/2, CGRectGetMaxY(_pswView.frame) + 8, clearBtn_Width, 40);
    
    [clearBtn setTitle:@"重新设置密码" forState:UIControlStateNormal];
    
    [clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    clearBtn.backgroundColor = [UIColor lightGrayColor];
    
    [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:clearBtn];

}


- (void)clearAction {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
    
    [_pswView clearDrawLine];
    
    NSLog(@"密码已清除!");
    
}



- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];

}


@end
