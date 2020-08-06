//
//  MainViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//



#import "MainViewController.h"
#import "HCBasePopupViewController.h"
#import "HCCenterPopAlertViewController.h"
#import "HCBottomPopupViewController.h"
#import "HCSidePopupViewController.h"

#define UIViewGetter(NAME) \
- (UIView *)NAME {\
if (!_##NAME) {\
_##NAME = [UIView new];\
}\
return _##NAME;\
}

#define UIImageViewGetter(NAME,IMAGE) \
- (UIImageView *)NAME {\
if (!_##NAME) {\
_##NAME = [UIImageView new];\
_##NAME.contentMode = UIViewContentModeScaleAspectFill;\
_imageView.image = IMAGE;\
}\
return _##NAME;\
}

#define UILabelGetter(NAME,TEXT_COLOR,FONT,TEXT,TEXT_ALIGN,NUMBER_OF_LINE) \
- (UILabel *)NAME {\
if (!_##NAME) {\
_##NAME = [[UILabel alloc]init];\
_##NAME.textColor = TEXT_COLOR;\
_##NAME.textAlignment = TEXT_ALIGN;\
_##NAME.numberOfLines = NUMBER_OF_LINE;\
_##NAME.font = FONT;\
_##NAME.text = TEXT;\
}\
return _##NAME;\
}
//通过颜色来生成一个纯色图片
UIImage * imageWithSize(CGSize size,UIColor *color){
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@interface MainViewController ()

@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
    self.title = @"主页";
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)setupSubViews {
    UIImage * img = imageWithSize(CGSizeMake(1, 1), UIColor.greenColor);
    
    NSArray *arr = @[@"基础弹出框",@"中心弹出框",@"底部弹出框",@"从左边弹出",@"从右边弹出"];
    int i= 0;
    for (NSString *title in arr) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [self.view addSubview:button];
        UIView * preView = [self.view viewWithTag:100+i-1];
        if (preView) {
              button.frame = CGRectMake(20, CGRectGetMaxY(preView.frame)+10, CGRectGetWidth(self.view.frame)-40, 44);
        } else {
            button.frame = CGRectMake(20,100, CGRectGetWidth(self.view.frame)-40, 44);

        }
      
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
   
}

- (void)action:(UIButton *)sender {
    if (sender.tag  == 100) {
        HCBasePopupViewController * bc =  [[HCBasePopupViewController alloc]init];
          [self presentViewController:bc animated:YES completion:nil];
    } else if (sender.tag == 101) {
        HCCenterPopAlertViewController * pc =  [[HCCenterPopAlertViewController alloc]init];
           [self presentViewController:pc animated:YES completion:nil];
    } else if (sender.tag == 102) {
        HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
        HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"选择项1" withSelectedBlock:^{
                NSLog(@"点击选项1");
        } withType:HCBottomPopupActionSelectItemTypeDefault];
        HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"选择项2" withSelectedBlock:^{
                NSLog(@"点击选项2");
        } withType:HCBottomPopupActionSelectItemTypeDefault];
        HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"选择项3" withSelectedBlock:^{
                NSLog(@"点击选项3");
        } withType:HCBottomPopupActionSelectItemTypeDefault];
         HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
        [pc addAction:action1];
        [pc addAction:action2];
        [pc addAction:action3];
        [pc addAction:action4];
        

        [self presentViewController:pc animated:YES completion:nil];
    } else if (sender.tag == 103) {
        HCSidePopupViewController * pc =  [[HCSidePopupViewController alloc]init];
        pc.fromDirection = HCPopupSideFromDirectionLeft;
        [self presentViewController:pc animated:YES completion:nil];
    } else if (sender.tag == 104) {
        HCSidePopupViewController * pc =  [[HCSidePopupViewController alloc]init];
        pc.fromDirection = HCPopupSideFromDirectionRight;
        [self presentViewController:pc animated:YES completion:nil];
    }
}


@end
