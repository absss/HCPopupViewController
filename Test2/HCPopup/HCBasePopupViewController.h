//
//  HCCenterPopupViewController.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HCBasePopupAnimatingType) {
    HCBasePopupAnimatingTypePresent = 1,
    HCBasePopupAnimatingTypeDismiss = 2,
};

@interface HCBasePopupViewController : UIViewController

/**
 弹出框视图
 */
@property (nonatomic, strong) UIView * _Nullable popupView;

/**转场动画类型*/
@property (nonatomic, assign ,readonly) HCBasePopupAnimatingType animatingType;
/**
 遮罩视图
 */
@property (nonatomic, strong) UIView * maskView;

/**
 设置弹出视图距离中心的偏移量，默认0
 */
@property (nonatomic, assign) UIEdgeInsets popupViewInsets;

/**
 弹出视图的尺寸
 */
@property (nonatomic, assign) CGSize popupViewSize;

/**
 遮罩颜色
 */
@property (nonatomic, strong) UIColor * _Nullable maskColor;

/**
 弹出动画时间
 */
@property (nonatomic, assign) NSTimeInterval animatedTimeInterval;

/**
 是否点击遮罩时dissmiss
 */
@property (nonatomic, assign) BOOL tapMaskDissmiss;

/**
 弹出框的圆角
 */
@property (nonatomic, assign) CGFloat popupViewCornerRadius;

/**
 点击遮罩的回调
 */
@property (nonatomic, copy) void (^maskViewTapHandler)(UIView * maskView);

//dissmiss
- (void)dismiss;
- (void)dismissdWithCompletion:(void (^ __nullable)(void))completion;

//To be override
/*在这个方法里面设置属性*/
- (void)subViewsWillReload;
/*在这个方法里面添加子视图*/
- (void)subViewsDidReload;
/**在这个方法里面写转场动画*/
- (void)viewController:(HCBasePopupViewController *)controller animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
@end
