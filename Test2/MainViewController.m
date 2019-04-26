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

@interface MainViewController ()

@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    
    button.frame = CGRectMake(self.view.center.x - 30, self.view.center.y -15, 60, 30);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)action{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"弹出框样式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"中心弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 代码在这里.........
        HCCenterPopAlertViewController * pc =  [[HCCenterPopAlertViewController alloc]init];
        [self presentViewController:pc animated:YES completion:nil];
    }];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"基础弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 代码在这里.........
        HCBasePopupViewController * bc =  [[HCBasePopupViewController alloc]init];
        [self presentViewController:bc animated:YES completion:nil];
    }];
    
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"底部弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    [ac addAction:actionCancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

@end
