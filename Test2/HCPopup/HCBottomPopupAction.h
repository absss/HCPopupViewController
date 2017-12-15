//
//  HCBottomPopupAction.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HCBottomPopupActionSelectItemType) {
     HCBottomPopupActionSelectItemTypeDefault = 1,
    HCBottomPopupActionSelectItemTypeCancel = 2,
   
};
typedef void(^HCBottomPopupActionSelectItemBlock)(void);

@interface HCBottomPopupAction : NSObject
@property(nonatomic,strong)NSString * title;
@property(nonatomic,assign)HCBottomPopupActionSelectItemType type;
@property(nonatomic,copy)HCBottomPopupActionSelectItemBlock selectBlock;

+ (instancetype)actionWithTitle:(NSString *)title withSelectedBlock:(HCBottomPopupActionSelectItemBlock)selectBlock withType:(HCBottomPopupActionSelectItemType)type;
@end
