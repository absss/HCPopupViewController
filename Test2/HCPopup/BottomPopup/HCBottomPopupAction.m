//
//  HCBottomPopupAction.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "HCBottomPopupAction.h"

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
