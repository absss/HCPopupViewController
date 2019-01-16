//
//  FJKImageContainView.h
//  Test2
//
//  Created by hehaichi on 2019/1/4.
//  Copyright © 2019年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJKImageContainView;
@class FJKImageItemView;


@protocol FJKImageContainViewDelegate <NSObject>

@required
// 下面两个方法必须实现
- (NSInteger)numberOfImageItemViewInContainView:(FJKImageContainView *)tagContainView;
- (FJKImageItemView *)imageContainView:(FJKImageContainView *)imageContainView imageItemViewForIndex:(NSInteger)index;

@optional
- (void)imageContainView:(FJKImageContainView *)imageContainView didSelectedImageItemViewAtIndex:(NSInteger)index; // 选中某个视图
- (void)didSelectedAddImageItemViewWithImageContainView:(FJKImageContainView *)imageContainView; // 点击添加视图
- (NSError *)imageContainView:(FJKImageContainView *)imageContainView imageDidLoadWithImageItemViewAtIndex:(NSInteger)index; // 图片加载完毕,返回失败信息
- (void)imageContainView:(FJKImageContainView *)imageContainView rowsDidChange:(NSInteger)rows; // 行高发生改变
@end


@interface FJKImageItemView : UIView
// 图片数据源，支持url、UIImage、NSData
@property (nonatomic, copy) id imageSource;
// 是否允许删除
@property (nonatomic, assign) BOOL enableDelete;
@end

@interface FJKImageContainView : UIView
@property (nonatomic, assign) NSInteger maxCount; // 最大允许个数
@property (nonatomic, assign) CGFloat verticalSpacing;      // 图片与图片的垂直间距
@property (nonatomic, assign) CGFloat horizontalSpacing;    // 图片与图片的水平间距
@property (nonatomic, assign) CGFloat verticalPadding;      // 图片与view边界之间的垂直内边距，默认为0
@property (nonatomic, assign) CGFloat horizontalPadding;    // 图片与view边界之间的水平内边距，默认为0
@property (nonatomic, assign) CGFloat itemHeight; // 图片高度
@property (nonatomic, assign) CGFloat itemWidth; // 图片宽度
@property (nonatomic, weak) id<FJKImageContainViewDelegate> delegate;
@property (nonatomic, assign) BOOL isAdjustHeight; // 是否适应高度
@property (nonatomic, readonly, assign) CGFloat selfAdjustHeight; // 实际自适应高度
@property (nonatomic, assign) BOOL isEdit; // 是否可添加

/**
 重新reload
 */
- (void)relaodData;

/**
 获取单个FJKTagItemView
 */
- (FJKImageItemView *)imageItemViewForIndex:(NSInteger)index;


// FIXME:添加或移除图片时，一定要记得同步修改好你的数据源，或者可以使用更简单的方式，修改数据源后直接relaodData
/**
 添加一个图片
 */
- (BOOL)addImageItemViewWithImageSource:(id)imageSource;

/**
 插入一张图
 */
- (BOOL)insertImageItemViewWithImageSource:(id)imageSource index:(NSInteger)index;

/**
 移除一张图
 */
- (BOOL)removeImageItemViewWithindex:(NSInteger)index;

/**
 移除一张图
 */
- (BOOL)removeImageItemViewWithImageSource:(id)source;

/**
 移除最后一张
 */
- (BOOL)removeLastImageItemView;
@end

