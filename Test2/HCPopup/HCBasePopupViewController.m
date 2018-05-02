//
//  HCCenterPopupViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "HCBasePopupViewController.h"

#define kHCBasePopupViewDefaultSize CGSizeMake(CGRectGetWidth(self.view.frame) * 0.75, CGRectGetHeight(self.view.frame) * 0.6)
@interface HCBasePopupViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>{
    HCBasePopupAnimatingType animatingType;
}
@property(nonatomic,strong)UIView * maskView;

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@end

@implementation HCBasePopupViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tapMaskDissmiss = YES;
        _popupViewCornerRadius = 4;
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popupView];
    [self.maskView addGestureRecognizer:self.tapGesture];
    
    if ([self.popupDelegate respondsToSelector:@selector(hcPopViewController:setupSubViewWithPopupView:)]) {
        [self.popupDelegate hcPopViewController:self setupSubViewWithPopupView:self.popupView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setter
- (void)setPopupViewSize:(CGSize)popupViewSize{
    _popupViewSize = popupViewSize;
    CGPoint center = self.popupView.center;
    CGRect frame = self.popupView.frame;
    frame.size = popupViewSize;
    self.popupView.frame = frame;
    self.popupView.center = center;
    
}

- (void)setPopupViewCornerRadius:(CGFloat)popupViewCornerRadius{
    _popupViewCornerRadius = popupViewCornerRadius;
    _popupView.layer.cornerRadius = popupViewCornerRadius;

}

- (void)setMaskColor:(UIColor *)maskColor{
    _maskColor = maskColor;
    self.maskView.backgroundColor = maskColor;
}

- (void)setPopupViewInsets:(UIEdgeInsets)popupViewInsets{
    _popupViewInsets = popupViewInsets;
    CGPoint center = self.popupView.center;
    center = CGPointMake(center.x+popupViewInsets.left-popupViewInsets.right, center.y+popupViewInsets.top-popupViewInsets.bottom);
    self.popupView.center = center;
}

- (void)setPopupViewCornerRadius:(CGFloat)popupViewCornerRadius{
    _popupViewCornerRadius = popupViewCornerRadius;
    _popupView.layer.cornerRadius = popupViewCornerRadius;
    
}

#pragma mark - getter
- (UIView *)popupView {
    if (!_popupView){
        CGSize size;
        if (self.popupViewSize.width > 0 && self.popupViewSize.height > 0) {
            size = self.popupViewSize;
        }else{
            size = kHCBasePopupViewDefaultSize;
        }
        _popupView = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x - size.width/2+self.popupViewInsets.left - self.popupViewInsets.right, self.view.center.y -size.height/2+self.popupViewInsets.top - self.popupViewInsets.bottom, size.width, size.height)];
        _popupView.backgroundColor = [UIColor whiteColor];
        _popupView.layer.cornerRadius = self.popupViewCornerRadius;
        _popupView.layer.masksToBounds = YES;
        _popupView.tag = 1000;
      
    }
    return _popupView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.view.frame];
        _maskView.backgroundColor = self.maskColor?self.maskColor:[[UIColor blackColor]colorWithAlphaComponent:0.5];
        [_maskView addGestureRecognizer:self.tapGesture];
    }
    return _maskView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapGesture;
}

#pragma mark - target selector
- (void)closeAction {
    [self dismiss];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    if ([self.popupDelegate respondsToSelector:@selector(hcPopViewController:didTapMaskViewWithMaskView:)]) {
        [self.popupDelegate hcPopViewController:self didTapMaskViewWithMaskView:self.maskView];
    }
    if (self.tapMaskDissmiss) {
       [self dismiss];
    }
}

#pragma mark - dismiss
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissdWithCompletion:(void (^ __nullable)(void))completion {
    [self dismissViewControllerAnimated:YES completion:completion];
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
        popedView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        
        NSTimeInterval duration = 0.5;
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.alpha = 1.0;
        }];
        
        
        CGFloat damping = 0.55;
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

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
