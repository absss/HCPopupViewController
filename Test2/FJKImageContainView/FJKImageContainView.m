//
//  FJKImageContainView.m
//  Test2
//
//  Created by hehaichi on 2019/1/4.
//  Copyright © 2019年 hehaichi. All rights reserved.
//

#import "FJKImageContainView.h"

#define FJKImageItemViewTagBaseCount 2000
#define FJKaddImageItemViewTag 1999

@interface FJKImageItemView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FJKImageItemView
- (void)setImageSource:(id)imageSource {
    NSAssert(imageSource, @"FJKImageItemView设置imageSource时，设置了空的数据源，请检查代码");
    if ([imageSource isKindOfClass:[NSString class]]) {
        // sd_setimage
    } else if ([imageSource isKindOfClass:[UIImage class]]) {
        self.imageView.image = imageSource;
    }
    _imageSource = imageSource;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}
@end


@interface FJKImageContainView ()
@property (nonatomic, assign) CGFloat adjustHeight;
@property (nonatomic, assign) NSInteger row; // 行数
@end
@implementation FJKImageContainView

#pragma mark - Life Cycle
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxCount = NSIntegerMax;
        _verticalSpacing = 16;
        _horizontalPadding = 0;
        _horizontalSpacing = 16;
        _itemWidth = 60;
        _itemHeight = 60;
        _isAdjustHeight = YES;
        _isEdit = YES;
        _adjustHeight = CGRectGetHeight(self.frame);
        
    }
    return self;
}

#pragma mark - Private Method


#pragma mark - Public Method
- (void)relaodData {
    // 没实现两个require方法是不行滴
    self.adjustHeight = CGRectGetHeight(self.frame);
    NSInteger count = [self.delegate numberOfImageItemViewInContainView:self];
    NSInteger actualCount =  count > _maxCount ? _maxCount : count;
    CGFloat maxWidth = CGRectGetWidth(self.frame);
    int row = 1;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[FJKImageItemView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < actualCount; i++) {
        FJKImageItemView * itemView = [self.delegate imageContainView:self imageItemViewForIndex:i];
        CGFloat horizontalPadding = self.horizontalPadding > self.itemWidth ? 0 : self.horizontalPadding;
        CGFloat verticalPadding = self.verticalPadding > self.itemHeight ? 0 : self.verticalPadding;
        itemView.imageView.frame = CGRectMake(horizontalPadding, verticalPadding, self.itemWidth - 2*horizontalPadding , self.itemHeight - 2*verticalPadding);
        [self addSubview:itemView];
        itemView.tag = FJKImageItemViewTagBaseCount + i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [itemView addGestureRecognizer:tap];
    }
    for (int i = 0; i < actualCount; i++) {
        FJKImageItemView * preItemView = (FJKImageItemView *)[self viewWithTag:FJKImageItemViewTagBaseCount + i - 1];
        FJKImageItemView * itemView = (FJKImageItemView *)[self viewWithTag:FJKImageItemViewTagBaseCount + i];
        CGFloat itemWidth = self.itemWidth;
        CGFloat itemHeight = self.itemHeight;
        CGFloat maxX = CGRectGetMaxX(preItemView.frame) + itemWidth;
        if (maxX <= maxWidth - 1) { //同行添加
            CGFloat verticalSpacing = preItemView ? self.verticalSpacing : 0;
            itemView.frame = CGRectMake(CGRectGetMaxX(preItemView.frame) + verticalSpacing, CGRectGetMinY(preItemView.frame), itemWidth, itemHeight);
        } else { // 换行
            itemView.frame = CGRectMake(0, CGRectGetMaxY(preItemView.frame) + self.verticalSpacing, itemWidth, itemHeight);
            row++;
        }
    }
    if (self.isEdit) {
        FJKImageItemView * itemView = [self viewWithTag:FJKaddImageItemViewTag];
        if (count == self.maxCount) { // 如果相等
            [itemView removeFromSuperview];
        } else {
            if (!itemView) {
                itemView = [[FJKImageItemView alloc] init];
                itemView.imageSource = [UIImage imageNamed:@"btn_add"];
                CGFloat horizontalPadding = self.horizontalPadding > self.itemWidth ? 0 : self.horizontalPadding;
                CGFloat verticalPadding = self.verticalPadding > self.itemHeight ? 0 : self.verticalPadding;
                itemView.imageView.frame = CGRectMake(horizontalPadding, verticalPadding, self.itemWidth - 2*horizontalPadding , self.itemHeight - 2*verticalPadding);
                itemView.tag = FJKaddImageItemViewTag;
                [self addSubview:itemView];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [itemView addGestureRecognizer:tap];
            }
            FJKImageItemView * preItemView = (FJKImageItemView *)[self viewWithTag:FJKImageItemViewTagBaseCount + actualCount - 1];
            CGFloat itemWidth = self.itemWidth;
            CGFloat itemHeight = self.itemHeight;
            CGFloat maxX = CGRectGetMaxX(preItemView.frame) + itemWidth;
            if (maxX <= maxWidth - 1) { //同行添加
                CGFloat verticalSpacing = preItemView ? self.verticalSpacing : 0;
                itemView.frame = CGRectMake(CGRectGetMaxX(preItemView.frame) + verticalSpacing, CGRectGetMinY(preItemView.frame), itemWidth, itemHeight);
            } else { // 换行
                itemView.frame = CGRectMake(0, CGRectGetMaxY(preItemView.frame) + self.verticalSpacing, itemWidth, itemHeight);
                row++;
            }
        }
    }
    
    self.row = row;
}

- (CGFloat)selfAdjustHeight {
    return self.adjustHeight;
}

- (FJKImageItemView *)imageItemViewForIndex:(NSInteger)index {
    NSInteger tag = FJKImageItemViewTagBaseCount + index;
    UIView * view =  [self viewWithTag:tag];
    if (![view isKindOfClass:[FJKImageItemView class]]) {
        return nil;
    }
    return (FJKImageItemView *)view;
}

- (BOOL)addImageItemViewWithImageSource:(id)imageSource {
    return YES;
}

- (BOOL)insertImageItemViewWithImageSource:(id)imageSource index:(NSInteger)index {
    return YES;
}

- (BOOL)removeImageItemViewWithindex:(NSInteger)index {
    return YES;
}

- (BOOL)removeImageItemViewWithImageSource:(id)source {
    return YES;
}

- (BOOL)removeLastImageItemView {
    return YES;
}

#pragma mark - Setter
- (void)setRow:(NSInteger)row {
    _row = row;
    if (_isAdjustHeight) { // 调整自身高度
        CGRect rect = self.frame;
        CGFloat maxY = row * self.itemHeight + (row - 1) * self.verticalSpacing;
        rect.size.height = maxY;
        self.adjustHeight = maxY;
        self.frame = rect;
    }
    if ([self.delegate respondsToSelector:@selector(imageContainView:rowsDidChange:)]) {
        [self.delegate imageContainView:self rowsDidChange:row];
    }
}

#pragma mark - Getter

#pragma mark - Target Selector
- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag - FJKImageItemViewTagBaseCount;
    if (index >= 0) {
        NSLog(@"点击了第%ld个标签",index);
        if ([self.delegate respondsToSelector:@selector(imageContainView:didSelectedImageItemViewAtIndex:)]) {
            [self.delegate imageContainView:self didSelectedImageItemViewAtIndex:index];
        }
    } else if (index == -1){
        if ([self.delegate respondsToSelector:@selector(didSelectedAddImageItemViewWithImageContainView:)]) {
            [self.delegate didSelectedAddImageItemViewWithImageContainView:self];
        }
    }
}

@end
