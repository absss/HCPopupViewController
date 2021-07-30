//
//  HCSidePopupViewController.m
//  Test2
//
//  Created by hehaichi on 2020/8/6.
//  Copyright © 2020 hehaichi. All rights reserved.
//

#import "HCSidePopupViewController.h"

@implementation HCSidePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)subViewsWillLoad {
    [self setupPopViewSize];
    self.maskColor = UIColor.clearColor;
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.maskView addGestureRecognizer:panGest];
    
    
}

static CGPoint origin;
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //获取偏移量
    // 返回的是相对于最原始的手指的偏移量
    CGPoint transP = [pan translationInView:self.popupView];
    NSLog(@"offset:%f",transP.x);
    if (_fromDirection == HCPopupSideFromDirectionLeft) {
        if (transP.x > 0) {
            transP.x = 0;
        }
        if (transP.x < -CGRectGetWidth(self.popupView.frame)) {
            transP.x = CGRectGetWidth(self.popupView.frame);
        }
    }
    // 移动图片控件
    self.popupView.transform = CGAffineTransformTranslate(self.popupView.transform, transP.x, 0 );

    [pan setTranslation:CGPointZero inView:self.popupView];
    NSLog(@"offset:%f",self.popupView.frame.origin.x);
    if (pan.state == UIGestureRecognizerStateBegan) {
        origin = self.popupView.frame.origin;
    } else if(pan.state == UIGestureRecognizerStateEnded){
        CGFloat offsetX = ABS(self.popupView.frame.origin.x - origin.x);
        if (offsetX < CGRectGetWidth(self.popupView.frame)/2) {

            [UIView animateWithDuration:0.2 animations:^{
                CGRect rect = self.popupView.frame;
                rect.origin = origin;
                self.popupView.frame = rect;
            }];
        } else {
            [self dismiss];
        }
       
    }
}

- (void)setupPopViewSize{
    CGFloat w = _sideWidth;
    if (_sideWidth <= 0) {
        w = CGRectGetWidth(self.view.frame)-80;
    }
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
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
        UIView *popedView = ((HCBasePopupViewController *)toVC).popupView;
        UIView *maskView = ((HCBasePopupViewController *)toVC).maskView;

        [containerView addSubview:toVC.view];
        maskView.alpha = 0;
        CGRect frame = popedView.frame;
        CGFloat x;
        if (_fromDirection == HCPopupSideFromDirectionLeft) {
            x = -frame.size.width;
        } else {
            x = CGRectGetWidth(self.view.frame);
        }
        frame.origin = CGPointMake(x, 0);
        popedView.frame = frame;
        
        NSTimeInterval duration = 0.5;
        [UIView animateWithDuration:duration / 2.0 animations:^{
            maskView.alpha = 1.0;
        }];
        
        //回弹动画
         [UIView animateWithDuration:duration / 2.0 animations:^{
             CGFloat offset;
             if (_fromDirection == HCPopupSideFromDirectionLeft) {
                  offset = CGRectGetWidth(popedView.frame);
             } else {
                  offset = -CGRectGetWidth(popedView.frame);
             }
             
             popedView.transform = CGAffineTransformMakeTranslation(offset, 0);
             } completion:^(BOOL finished) {
                 [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        UIView *popedView = ((HCBasePopupViewController *)fromVC).popupView;
        UIView *maskView = ((HCBasePopupViewController *)fromVC).maskView;

        CGFloat x;
        if (_fromDirection == HCPopupSideFromDirectionLeft) {
            x = -CGRectGetWidth(popedView.frame);
        } else {
            x = CGRectGetWidth(popedView.frame);
        }
        NSTimeInterval duration = 0.25;
        maskView.alpha = 1.0;
       [UIView animateWithDuration:duration animations:^{
           maskView.alpha = 0;
            popedView.transform = CGAffineTransformMakeTranslation(x, 0);

       } completion:^(BOOL finished) {
           [transitionContext completeTransition:YES];
       }];
    }
}


@end
