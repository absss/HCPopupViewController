//
//  HCDrawerViewController.h
//  Test2
//
//  Created by hehaichi on 2020/8/7.
//  Copyright © 2020 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCDrawerViewController : UIViewController

/// 左边抽屉宽度,默认200
@property(nonatomic,assign) CGFloat leftDrawerWidth;
/// 右边宽度高度，默认200
@property(nonatomic,assign) CGFloat rightDrawerWidth;

/// 左边的控制器
@property(nonatomic,strong) UIViewController *leftConroller;

/// 右边的控制器
@property(nonatomic,strong) UIViewController *rightConroller;

/// 中间的控制器
@property(nonatomic,strong) UIViewController *centerConroller;
@end


