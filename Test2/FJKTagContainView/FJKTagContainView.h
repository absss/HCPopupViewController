//
//  FJKTagContainView.h
//  FangGeek
//
//  Created by hehaichi on 2018/12/24.
//  Copyright © 2018年 FangGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FJKTagContainView;
@class FJKTagItemView;

@protocol FJKTagContainViewDelegate <NSObject>

@required
- (NSInteger)numberOfTagItemInTagContainView:(FJKTagContainView *)tagContainView; // 有多少个tag，不实现这两个直接给你崩掉哦
- (FJKTagItemView *)tagContainView:(FJKTagContainView *)tagContainView tagItemViewForIndex:(NSInteger)index; // 每个tag对应的view

@optional
- (void)tagContainView:(FJKTagContainView *)tagContainView didSelectedIndex:(NSInteger)index; // 点击某个tag
- (void)tagContainView:(FJKTagContainView *)tagContainView rowsDidChange:(NSInteger)rows; // tag行数发生改变,提醒你应该改变frame了
@end


@interface FJKTagItemView : UILabel
/**
 是否被选中，默认为NO
 */
@property (nonatomic, assign) BOOL isSelected;
@end


@interface FJKTagContainView : UIView
@property (nonatomic, assign) CGFloat verticalSpacing;      // tag与tag的垂直间距
@property (nonatomic, assign) CGFloat horizontalSpacing;    // tag与tag的水平间距
@property (nonatomic, assign) CGFloat horizontalPadding;    // tag文本与边框之间的水平内边距
@property (nonatomic, assign) CGFloat tagHeight; // 行高
@property (nonatomic, weak) id<FJKTagContainViewDelegate> delegate;
@property (nonatomic, assign) BOOL isAdjustHeight; // 是否适应高度
@property (nonatomic, readonly, assign) CGFloat selfAdjustHeight; // 实际自适应高度

/**
 重新reload
 */
- (void)relaodData;

/**
 被选中的indexs
 */
- (NSArray <NSNumber *>*)selectedTagIndexs;

/**
 获取单个FJKTagItemView
 */
- (FJKTagItemView *)tagItemViewForIndex:(NSInteger)index;
@end

