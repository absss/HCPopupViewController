//
//  MainViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<HCBasePopupViewControllerDelegate>

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
        pc.popupDelegate = self;
//        pc.insets = UIEdgeInsetsMake(0, 15, 0, 0);//设置弹出框的偏移量
//        pc.popupViewSize = CGSizeMake(200, 300);//设置弹出框的尺寸
        [self presentViewController:pc animated:YES completion:nil];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"底部弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 代码在这里.........
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
    [ac addAction:actionCancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - HCBasePopupViewControllerDelegate
- (void)hcPopViewController:(UIViewController *)controller setupSubViewWithPopupView:(UIView *)popupView{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(popupView.frame)/2 -40, CGRectGetWidth(popupView.frame), 80)];
    label.text = @"实现- (void)hcPopViewController:(UIViewController *)controller setupSubViewWithPopupView:(UIView *)popupView这个协议方法来自定义你的弹出框内容";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [popupView addSubview:label];
}

- (void)didTapMaskViewWithMaskView:(UIView *)maskView withController:(UIViewController *)controller{
    NSLog(@"点击遮罩");
}
@end
