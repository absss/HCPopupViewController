//
//  HCCenterPopAlertViewController.m
//  Test2
//
//  Created by hehaichi on 2018/4/3.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "HCCenterPopAlertViewController.h"

@interface HCCenterPopAlertViewController ()
@end

@implementation HCCenterPopAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)subViewsWillReload {
    [self setupPopViewSize];
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

- (void)viewController:(HCBasePopupViewController *)controller animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (self.animatingType == HCBasePopupAnimatingTypePresent) {
        NSAssert([toVC isKindOfClass:[HCBasePopupViewController class]], @"请检查代码");
        UIView *popedView = ((HCBasePopupViewController *)toVC).popupView;
        [containerView addSubview:toVC.view];
        popedView.alpha = 0;
        popedView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        
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
        NSAssert([fromVC isKindOfClass:[HCBasePopupViewController class]], @"请检查代码");
        UIView *popedView = ((HCBasePopupViewController *)fromVC).popupView;
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration animations:^{
            popedView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
