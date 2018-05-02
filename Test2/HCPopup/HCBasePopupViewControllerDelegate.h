//
//  HCBasePopupViewControllerDelegate.h
//  Test2
//
//  Created by hehaichi on 2018/4/28.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCBasePopupViewControllerDelegate <NSObject>
/**
 在这个协议方法中自定义你的弹出框中的内容,该方法在viewDidLoad中调用，
 请在viewDidLoad方法调用之前指定协议对象
 
 @param popupView 弹框view
 */
- (void)hcPopViewController:(UIViewController *)controller setupSubViewWithPopupView:(UIView *)popupView;

- (void)hcPopViewController:(UIViewController *)controller  didTapMaskViewWithMaskView:(UIView *)maskView;
@end
