//
//  HCCenterPopupViewController.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCPopupCommon.h"
#import "HCBasePopupViewControllerDelegate.h"

@interface HCBasePopupViewController : UIViewController

/**
 弹出框视
 */
@property(nonatomic,strong,)UIView * _Nullable popupView;
/**
 弹出框相对于中心点的偏移量，如果你不想让弹出框在中心点弹出，
 或者由于导航栏的缘故，弹出框距离中心点有偏移，请设置此属性，默认为0
 */
@property(nonatomic,assign)UIEdgeInsets popupViewInsets;

/**
 弹出框大小
 */
@property(nonatomic,assign)CGSize popupViewSize;

/**
 遮罩的颜色
 */
@property(nonatomic,strong)UIColor * _Nullable maskColor;


/**
 弹出动画时间
 */
@property(nonatomic,assign)NSTimeInterval animatedTimeInterval;


/**
 点击遮罩dissmiss吗 默认为YES
 */
@property(nonatomic,assign)BOOL tapMaskDissmiss;

@property(nonatomic,assign)CGFloat popupViewCornerRadius;

@property(nonatomic,weak)id<HCBasePopupViewControllerDelegate>popupDelegate;

- (void)dismiss;

- (void)dismissdWithCompletion:(void (^ __nullable)(void))completion;


@end
