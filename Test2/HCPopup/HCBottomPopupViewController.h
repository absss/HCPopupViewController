//
//  HCBottomPopupViewController.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBasePopupViewController.h"
#import "HCBottomPopupAction.h"

@interface HCBottomPopupViewController : HCBasePopupViewController
- (void)addAction:(HCBottomPopupAction *)action;
@end
