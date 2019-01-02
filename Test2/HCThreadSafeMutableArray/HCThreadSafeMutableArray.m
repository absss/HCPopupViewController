//
//  HCThreadSafeMutableArray.m
//  Test2
//
//  Created by hehaichi on 2018/12/13.
//  Copyright © 2018年 hehaichi. All rights reserved.
//

#import "HCThreadSafeMutableArray.h"
#import <pthread.h>


@interface HCThreadSafeMutableArray()
{
    pthread_mutex_t _lock;
    CFMutableArrayRef _array;
}

@end

@implementation HCThreadSafeMutableArray

#pragma mark - required

- (id)init {
    self = [super init];
    if (self) {
        _array = CFArrayCreateMutable(kCFAllocatorDefault, 10,  &kCFTypeArrayCallBacks);
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _array = CFArrayCreateMutable(kCFAllocatorDefault, capacity,  &kCFTypeArrayCallBacks);
    }
    return self;
}

- (NSUInteger)count {
    pthread_mutex_lock(&_lock);
    NSUInteger result = CFArrayGetCount(_array);
    pthread_mutex_unlock(&_lock);
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    id result;
    pthread_mutex_lock(&_lock);
    NSUInteger count = CFArrayGetCount(_array);
    result = index<count ? CFArrayGetValueAtIndex(_array, index) : nil;
    pthread_mutex_unlock(&_lock);
    return result;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    NSUInteger blockindex = index;
    pthread_mutex_lock(&_lock);
    if (!anObject)
        return;
    NSUInteger count = CFArrayGetCount(_array);
    if (blockindex > count) {
        blockindex = count;
    }
    CFArrayInsertValueAtIndex(_array, index, (__bridge const void *)anObject);
    pthread_mutex_unlock(&_lock);
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    pthread_mutex_lock(&_lock);
    NSUInteger count = CFArrayGetCount(_array);
    if (index < count) {
        CFArrayRemoveValueAtIndex(_array, index);
    }
    pthread_mutex_unlock(&_lock);
}

- (void)addObject:(id)anObject {
    pthread_mutex_lock(&_lock);
    if (!anObject)
        return;
    CFArrayAppendValue(_array, (__bridge const void *)anObject);
    pthread_mutex_unlock(&_lock);
}

- (void)removeLastObject {
    pthread_mutex_lock(&_lock);
    NSUInteger count = CFArrayGetCount(_array);
    if (count > 0) {
        CFArrayRemoveValueAtIndex(_array, count-1);
    }
    pthread_mutex_unlock(&_lock);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    pthread_mutex_lock(&_lock);
    if (!anObject)
        return;
    NSUInteger count = CFArrayGetCount(_array);
    if (index < count) {
        CFArraySetValueAtIndex(_array, index, (__bridge const void*)anObject);
    }
    pthread_mutex_unlock(&_lock);
}

#pragma mark - Optional
- (void)removeAllObjects {
    pthread_mutex_lock(&_lock);
    CFArrayRemoveAllValues(_array);
    pthread_mutex_unlock(&_lock);
}

- (NSUInteger)indexOfObject:(id)anObject{
    if (!anObject) return NSNotFound;
    NSUInteger result;
    pthread_mutex_lock(&_lock);
    NSUInteger count = CFArrayGetCount(_array);
    result = CFArrayGetFirstIndexOfValue(_array, CFRangeMake(0, count), (__bridge const void *)(anObject));
    pthread_mutex_unlock(&_lock);
    return result;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
