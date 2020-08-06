//
//  HCSidePopupViewController.h
//  Test2
//
//  Created by hehaichi on 2020/8/6.
//  Copyright © 2020 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBasePopupViewController.h"

typedef NS_ENUM(NSInteger, HCPopupSideFromDirection) {
    HCPopupSideFromDirectionLeft = 0,
    HCPopupSideFromDirectionRight = 1,
};
@interface HCSidePopupViewController : HCBasePopupViewController
@property (nonatomic, assign) HCPopupSideFromDirection fromDirection;
@end

