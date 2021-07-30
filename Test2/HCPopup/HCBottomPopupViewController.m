//
//  HCBottomPopupViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "HCBottomPopupViewController.h"
#define kDevice_iPhoneX ([[UIScreen mainScreen] bounds].size.height >= 812.0)
#define kDevice_iPhoneX_height(x) (kDevice_iPhoneX ? x + 34 : x)

static CGFloat const HCBottomPopupSelectItemHeight = 50;

@interface HCBottomPopupAction()
@end
@implementation HCBottomPopupAction

+ (instancetype)actionWithTitle:(NSString *)title withSelectedBlock:(HCBottomPopupActionSelectItemBlock)selectBlock withType:(HCBottomPopupActionSelectItemType)type{
    HCBottomPopupAction * action =  [HCBottomPopupAction new];
    action.type = type;
    action.selectBlock = selectBlock;
    action.title = title;
    return action;
}
@end


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

@interface HCBottomPopupViewController ()

@property(nonatomic,strong)NSMutableArray <HCBottomPopupAction *>* actionArray;
@property(nonatomic,assign)BOOL isContainCancel;
@end

@implementation HCBottomPopupViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _actionArray = @[].mutableCopy;
    }
    return self;
}

- (void)subViewsWillLoad {
    self.popupViewCornerRadius = 0;
    [self setupPopViewSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)subViewsDidLoad {
    [self setupSubViews];
    self.popupView.backgroundColor = [UIColor clearColor];
}

#pragma mark -  private method
- (void)setupPopViewSize{
    CGFloat height =  self.actionArray.count * HCBottomPopupSelectItemHeight;
    if (self.isContainCancel) {
        height += 20;
    }
    // 适配iPhone X
    height = kDevice_iPhoneX_height(height);
    
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
    
    if (self.animatingType == HCBasePopupAnimatingTypePresent) {
        NSAssert([toVC isKindOfClass:[HCBasePopupViewController class]], @"请检查代码");
        UIView *popedView = ((HCBasePopupViewController *)toVC).popupView;
        UIView *maskView = ((HCBasePopupViewController *)toVC).maskView;
        [containerView addSubview:toVC.view];
        maskView.alpha = 0;
        CGRect frame = popedView.frame;
        frame.origin = CGPointMake(0, CGRectGetHeight(self.view.frame));
        popedView.frame = frame;
        
        NSTimeInterval duration = 0.4;
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(popedView.frame));
            maskView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        
        NSAssert([fromVC isKindOfClass:[HCBasePopupViewController class]], @"请检查代码");
        UIView *popedView = ((HCBasePopupViewController *)fromVC).popupView;
        UIView *maskView = ((HCBasePopupViewController *)fromVC).maskView;

        NSTimeInterval duration = 0.25;
        maskView.alpha = 1.0;
        [UIView animateWithDuration:duration animations:^{
              popedView.transform = CGAffineTransformMakeTranslation(0,CGRectGetHeight(popedView.frame));
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)setupSubViews {
    UIView * popupView = self.popupView;
    for (HCBottomPopupAction * action in self.actionArray) {
        if (action.type == HCBottomPopupActionSelectItemTypeCancel) {//如果等于取消;
            //将action 移动到数组末尾
            [self.actionArray removeObject:action];
            [self.actionArray addObject:action];
        }
    }
    for (int i = 0; i < self.actionArray.count; i++) {
        __weak typeof(self) weakSelf = self;
        HCBottomPopupAction * action = self.actionArray[i];
        HCBottomPopViewSelectedItemView * sv;
        if (action.type ==  HCBottomPopupActionSelectItemTypeCancel) {
            UIView *svContainView = [[UIView alloc]initWithFrame:CGRectMake(0, i*HCBottomPopupSelectItemHeight + 20, CGRectGetWidth(popupView.frame), kDevice_iPhoneX_height(HCBottomPopupSelectItemHeight))];
            sv = [[HCBottomPopViewSelectedItemView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(popupView.frame), HCBottomPopupSelectItemHeight) withType:action.type];
            sv.backgroundColor = [UIColor whiteColor];
            sv.bottomLine.hidden = YES;
            sv.clickBlock = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (action.selectBlock) {
                    action.selectBlock();
                }
                [strongSelf dismiss];
            };
            svContainView.backgroundColor = [UIColor whiteColor];
            [svContainView addSubview:sv];
            [popupView addSubview:svContainView];
        }else{
            sv = [[HCBottomPopViewSelectedItemView alloc]initWithFrame:CGRectMake(0, i*HCBottomPopupSelectItemHeight, CGRectGetWidth(popupView.frame), HCBottomPopupSelectItemHeight) withType:action.type];
            sv.backgroundColor = [UIColor whiteColor];
            sv.bottomLine.hidden = NO;
            sv.clickBlock = ^{
                if (action.selectBlock) {
                    action.selectBlock();
                }
            };
            [popupView addSubview:sv];
        }
        
        sv.title = action.title;
    }
}
@end
