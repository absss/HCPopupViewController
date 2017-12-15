//
//  HCBottomPopupViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "HCBottomPopupViewController.h"
#import "HCPopupCommon.h"

#define HCBottomPopupSelectItemHeight 50

@interface HCBottomPopViewSelectedItemView:UIButton
@property(nonatomic,strong)UIView * bottomLine;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,copy)dispatch_block_t clickBlock;
@property(nonatomic,assign)HCBottomPopupActionSelectItemType type;

@end
@implementation HCBottomPopViewSelectedItemView
- (instancetype)initWithFrame:(CGRect)frame withType:(HCBottomPopupActionSelectItemType)type{
    if(self = [super initWithFrame:frame]){
        _type = type;
        [self addSubview:self.bottomLine];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self setTitle:_title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
        _bottomLine.backgroundColor = [UIColor blackColor];
        _bottomLine.alpha = 0.1;
    }
    return _bottomLine;
}

- (void)action:(UIButton *)sender{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end

@interface HCBottomPopupViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,HCBasePopupViewControllerDelegate>
{
    HCBasePopupAnimatingType animatingType;
}
@property(nonatomic,strong)NSMutableArray <HCBottomPopupAction *>* actionArray;
@property(nonatomic,assign)BOOL isContainCancel;
@end

@implementation HCBottomPopupViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _actionArray = @[].mutableCopy;
        self.popupViewCornerRadius = 0;
        self.tapMaskDissmiss = YES;
        self.popupDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [self setupPopViewSize];
    [super viewDidLoad];
}

#pragma mark -  private method
- (void)setupPopViewSize{
    CGFloat height =  self.actionArray.count * HCBottomPopupSelectItemHeight;
    if (self.isContainCancel) {
        height += 20;
    }
    self.popupViewSize = CGSizeMake(CGRectGetWidth(self.view.frame),height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public method
- (void)addAction:(HCBottomPopupAction *)action{
    if (![self.actionArray containsObject:action]) {
        if (self.isContainCancel == YES) {
            return;
        }
        if (action.type == HCBottomPopupActionSelectItemTypeCancel && self.isContainCancel == NO) {
            self.isContainCancel = YES;
        }
        [self.actionArray addObject:action];
    }
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
        CGRect frame = popedView.frame;
        frame.origin = CGPointMake(0, CGRectGetHeight(self.view.frame));
        popedView.frame = frame;
        
        NSTimeInterval duration = 0.4;
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.alpha = 1.0;
        }];
        
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(popedView.frame));
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        UIView *popedView = [fromVC.view viewWithTag:1000];
        NSTimeInterval duration = 0.25;
        
        UIButton *closeBtn = [fromVC.view viewWithTag:1001];
        
        [UIView animateWithDuration:duration animations:^{
              popedView.transform = CGAffineTransformMakeTranslation(0,CGRectGetHeight(popedView.frame));
            popedView.alpha = 0;
            closeBtn.alpha = 0;
            //            popedView.transform = CGAffineTransformMakeScale(0.7, 0.7);
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
- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller{
    popupView.backgroundColor = CWIPColorFromHex(0xcccccc);
    popupView.alpha = 0.4;
    for (HCBottomPopupAction * action in self.actionArray) {
        if (action.type == HCBottomPopupActionSelectItemTypeCancel) {//如果等于取消;
            //将action 移动到数组末尾
            [self.actionArray removeObject:action];
            [self.actionArray addObject:action];
        }
    }
    for (int i = 0; i < self.actionArray.count; i++) {
        spweakify(self);
        HCBottomPopupAction * action = self.actionArray[i];
        HCBottomPopViewSelectedItemView * sv;
        if (action.type ==  HCBottomPopupActionSelectItemTypeCancel) {
           sv = [[HCBottomPopViewSelectedItemView alloc]initWithFrame:CGRectMake(0, i*HCBottomPopupSelectItemHeight+20, CGRectGetWidth(popupView.frame), HCBottomPopupSelectItemHeight) withType:action.type];
            
            sv.clickBlock = ^{
                spstrongify(self);
                if (action.selectBlock) {
                    action.selectBlock();
                }
                [self dismiss];
            };
        }else{
            sv = [[HCBottomPopViewSelectedItemView alloc]initWithFrame:CGRectMake(0, i*HCBottomPopupSelectItemHeight, CGRectGetWidth(popupView.frame), HCBottomPopupSelectItemHeight) withType:action.type];
            sv.clickBlock = ^{
                if (action.selectBlock) {
                    action.selectBlock();
                }
            };
        }
        [popupView addSubview:sv];
        sv.title = action.title;
    }
}


@end
