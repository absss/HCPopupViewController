//
//  FJKTagContainView.m
//  FangGeek
//
//  Created by hehaichi on 2018/12/24.
//  Copyright © 2018年 FangGeek. All rights reserved.
//

#import "FJKTagContainView.h"

#define FJKTagItemViewTagBaseCount 1000
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]


@interface FJKTagItemView ()
@end

@implementation FJKTagItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        self.userInteractionEnabled = YES;
        self.isSelected = NO;
        self.layer.cornerRadius = 1.5;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (!isSelected) {
        self.textColor = ColorFromHex(0x4C4C4C);
        self.backgroundColor = ColorFromHex(0xF7F7F7);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        self.textColor = ColorFromHex(0xf95e69);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = ColorFromHex(0xf95e69).CGColor;
    }
}
@end


@interface FJKTagContainView ()
@property (nonatomic, assign) CGFloat adjustHeight;
@property (nonatomic, assign) NSInteger row; // 行数
@end


@implementation FJKTagContainView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _verticalSpacing = 10;
        _horizontalSpacing = 10;
        _horizontalPadding = 7.5;
        _tagHeight = 20;
        _isAdjustHeight = YES;
        _adjustHeight = CGRectGetHeight(frame);
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    if (self.isAdjustHeight) {
        frame.size.height = self.adjustHeight;
    }
    [super setFrame:frame];
}

#pragma mark - Public Method
- (void)relaodData {
    // 没实现两个require方法是不行滴
    self.adjustHeight = CGRectGetHeight(self.frame);
    NSInteger count = [self.delegate numberOfTagItemInTagContainView:self];
    CGFloat maxWidth = CGRectGetWidth(self.frame);
    int row = 1;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[FJKTagItemView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < count; i++) {
        FJKTagItemView * itemView = [self.delegate tagContainView:self tagItemViewForIndex:i];
        [self addSubview:itemView];
        itemView.tag = FJKTagItemViewTagBaseCount + i;
        itemView.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [itemView addGestureRecognizer:tap];
    }
    for (int i = 0; i < count; i++) {
        FJKTagItemView * preItemView = (FJKTagItemView *)[self viewWithTag:FJKTagItemViewTagBaseCount + i - 1];
        FJKTagItemView * itemView = (FJKTagItemView *)[self viewWithTag:FJKTagItemViewTagBaseCount + i];
        CGFloat itemWidth = [self rectForTag:itemView.text font:itemView.font] + 2 * self.horizontalPadding;
        CGFloat itemHeight = self.tagHeight;
        CGFloat maxX = CGRectGetMaxX(preItemView.frame) + itemWidth;
        if (maxX <= maxWidth - 1) { //同行添加
            CGFloat verticalSpacing = preItemView ? self.verticalSpacing : 0;
            itemView.frame = CGRectMake(CGRectGetMaxX(preItemView.frame) + verticalSpacing, CGRectGetMinY(preItemView.frame), itemWidth, itemHeight);
        } else { // 换行
            itemView.frame = CGRectMake(0, CGRectGetMaxY(preItemView.frame) + self.verticalSpacing, itemWidth, itemHeight);
            row++;  
        }
    }
    self.row = row;
}

- (FJKTagItemView *)tagItemViewForIndex:(NSInteger)index {
    NSInteger tag = FJKTagItemViewTagBaseCount + index;
    UIView * view =  [self viewWithTag:tag];
    if (![view isKindOfClass:[FJKTagItemView class]]) {
        return nil;
    }
    return (FJKTagItemView *)view;
}

- (CGFloat)selfAdjustHeight {
    return self.adjustHeight;
}

- (void)setRow:(NSInteger)row {
    _row = row;
    if (_isAdjustHeight) { // 调整自身高度
        CGRect rect = self.frame;
        CGFloat maxY = row * self.tagHeight + (row - 1) * self.verticalSpacing;
        rect.size.height = maxY;
        self.adjustHeight = maxY;
        self.frame = rect;
    }
    if ([self.delegate respondsToSelector:@selector(tagContainView:rowsDidChange:)]) {
        [self.delegate tagContainView:self rowsDidChange:row];
    }
}

#pragma mark - Pirvate Method
- (NSArray <NSNumber *>*)selectedTagIndexs {
    NSInteger count = [self.delegate numberOfTagItemInTagContainView:self];
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        FJKTagItemView * itemView = (FJKTagItemView *)[self viewWithTag:FJKTagItemViewTagBaseCount + i];
        if (!itemView) {
            continue;
        }
        if (itemView.isSelected) {
            [temp addObject:@(i)];
        }
    }
    return temp.copy;
}


- (CGFloat)rectForTag:(NSString *)tag font:(UIFont *)font{
    CGRect rect = [tag boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return CGRectGetWidth(rect);
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag - FJKTagItemViewTagBaseCount;
    NSLog(@"点击了第%ld个标签",index);
    if ([self.delegate respondsToSelector:@selector(tagContainView:didSelectedIndex:)]) {
        [self.delegate tagContainView:self didSelectedIndex:index];
    }
}
@end
