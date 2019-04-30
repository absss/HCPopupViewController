//
//  HCPopupCommon.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#ifndef HCPopupCommon_h
#define HCPopupCommon_h

#define kDevice_iPhoneX ([[UIScreen mainScreen] bounds].size.height >= 812.0 )
#define kDevice_iPhoneX_height(x) (kDevice_iPhoneX ? x + 34 : x)


#pragma mark - Block Weak self
#if __has_include(<ReactiveCocoa/ReactiveCocoa.h>)
#import <ReactiveCocoa/ReactiveCocoa.h>
#ifndef spweakify
#define spweakify(...) @weakify(__VA_ARGS__)
#endif

#ifndef spstrongify
#define spstrongify(...) @strongify(__VA_ARGS__)
#endif

#else
#ifndef spweakify
#if DEBUG
#define spweakify(object) @autoreleasepool{} __weak __typeof__(object) weak##_##object = object
#else
#define spweakify(object) @try{} @finally{} {} __weak __typeof__(object) weak##_##object = object
#endif
#endif

#ifndef spstrongify
#if DEBUG
#define spstrongify(object) @autoreleasepool{} __typeof__(object) object = weak##_##object
#else
#define spstrongify(object) @try{} @finally{} __typeof__(object) object = weak##_##object
#endif
#endif

#endif


#endif /* HCPopupCommon_h */
