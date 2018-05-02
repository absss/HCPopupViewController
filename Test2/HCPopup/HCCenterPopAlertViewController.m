//
//  HCCenterPopAlertViewController.m
//  Test2
//
//  Created by hehaichi on 2018/4/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "HCCenterPopAlertViewController.h"

@interface HCCenterPopAlertViewController (){
    HCBasePopupAnimatingType animatingType;
}


@end

@implementation HCCenterPopAlertViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.popupViewCornerRadius = 5;
        self.tapMaskDissmiss = YES;
        self.popupDelegate = self;
    }
    return self;
}
- (void)viewDidLoad {
    [self setupPopViewSize];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupPopViewSize{
    CGFloat w = CGRectGetWidth(self.view.frame)-80;
    CGFloat h = w * 0.618;
    self.popupViewSize = CGSizeMake(w,h);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.animatedTimeInterval>0?self.animatedTimeInterval:0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (animatingType == HCBasePopupAnimatingTypePresent) {
        UIView *popedView = [toVC.view viewWithTag:1000];
        [containerView addSubview:toVC.view];
        popedView.alpha = 0;
        popedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        
        NSTimeInterval duration = 0.5;
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.alpha = 1.0;
        }];
        
        CGFloat damping = 1.0;
        //回弹动画
        [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:1.0 / damping options:0 animations:^{
            popedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        UIView *popedView = [fromVC.view viewWithTag:1000];
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration animations:^{
            popedView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    animatingType = HCBasePopupAnimatingTypePresent;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    animatingType = HCBasePopupAnimatingTypeDismiss;
    return self;
}
#pragma mark - HCBasePopupViewControllerDelegate
- (void)hcPopViewController:(UIViewController *)controller setupSubViewWithPopupView:(UIView *)popupView{
    popupView.backgroundColor = CWIPColorFromHex(0xcccccc);
   
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


@end
