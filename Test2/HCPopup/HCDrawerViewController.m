//
//  HCDrawerViewController.m
//  Test2
//
//  Created by hehaichi on 2020/8/7.
//  Copyright © 2020 hehaichi. All rights reserved.
//

#import "HCDrawerViewController.h"

@interface HCDrawerViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *containerView;
@property(nonatomic, strong)UIView *leftView;
@property(nonatomic, strong)UIView *centerView;
@property(nonatomic, strong)UIView *rightView;
@end

@implementation HCDrawerViewController
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[UIView new]];
    [self.view addSubview:self.containerView];
    self.containerView.backgroundColor = UIColor.whiteColor;

    [self.containerView addSubview:self.leftView];
    [self.containerView addSubview:self.centerView];
    [self.containerView addSubview:self.rightView];
    self.containerView.decelerationRate = 0.001;
    
    [self setupSubViews];
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCenterViewAction)];
    [self.centerView addGestureRecognizer:gest];
    
}

- (void)clickCenterViewAction {
    if (self.containerView.contentOffset.x < 1 || self.containerView.contentOffset.x > _leftDrawerWidth+_rightDrawerWidth-1) {
        
    }
   [self.containerView setContentOffset:CGPointMake(_leftDrawerWidth, 0) animated:YES];
}

- (void)setupSubViews {
    if (_leftDrawerWidth <= 0) {
        _leftDrawerWidth = 200;
    }
    if (_rightDrawerWidth <= 0) {
        _rightDrawerWidth = 200;
    }
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat width = CGRectGetWidth(self.view.frame);
    self.containerView.contentSize = CGSizeMake(width+_leftDrawerWidth+_rightDrawerWidth, height);
    
    
    self.leftView.frame = CGRectMake(0, 0, _leftDrawerWidth, height);
    self.centerView.frame = CGRectMake(_leftDrawerWidth, 0, width, height);
    self.rightView.frame = CGRectMake(width+_leftDrawerWidth, 0, _leftDrawerWidth, height);
    self.containerView.alwaysBounceVertical = NO;
    self.containerView.alwaysBounceHorizontal = NO;
    self.containerView.bounces = NO;
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.showsHorizontalScrollIndicator = NO;
    self.containerView.contentOffset = CGPointMake(_leftDrawerWidth, 0);
    self.containerView.delegate = self;
    if (self.leftConroller) {
        [self addChildViewController:self.leftConroller];
        self.leftConroller.view.frame = self.leftView.bounds;
        [self.leftView addSubview:self.leftConroller.view];
    }
    if (self.centerConroller) {
          [self addChildViewController:self.centerConroller];
          self.centerConroller.view.frame = self.centerView.bounds;
          [self.centerView addSubview:self.centerConroller.view];
    }
    if (self.rightConroller) {
          [self addChildViewController:self.rightConroller];
          self.rightConroller.view.frame = self.centerView.bounds;
          [self.rightView addSubview:self.rightConroller.view];
    }
    
}

- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
    }
    return _containerView;;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView new];
    }
    return _rightView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [UIView new];
    }
    return _centerView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX > 0 && offsetX <= _leftDrawerWidth/2) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
         } else if (offsetX > _leftDrawerWidth/2 && offsetX <= _leftDrawerWidth+_rightDrawerWidth/2) {
            [scrollView setContentOffset:CGPointMake(_leftDrawerWidth, 0) animated:YES];
         }
         else if (offsetX >_leftDrawerWidth+_rightDrawerWidth/2 && offsetX <= _leftDrawerWidth+_rightDrawerWidth) {
             [scrollView setContentOffset:CGPointMake(_leftDrawerWidth+_rightDrawerWidth, 0) animated:YES];
         }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > 0 && offsetX <= _leftDrawerWidth/2) {
       [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (offsetX > _leftDrawerWidth/2 && offsetX <= _leftDrawerWidth+_rightDrawerWidth/2) {
       [scrollView setContentOffset:CGPointMake(_leftDrawerWidth, 0) animated:YES];
    }
    else if (offsetX >_leftDrawerWidth+_rightDrawerWidth/2 && offsetX <= _leftDrawerWidth+_rightDrawerWidth) {
        [scrollView setContentOffset:CGPointMake(_leftDrawerWidth+_rightDrawerWidth, 0) animated:YES];
    }
}
@end
