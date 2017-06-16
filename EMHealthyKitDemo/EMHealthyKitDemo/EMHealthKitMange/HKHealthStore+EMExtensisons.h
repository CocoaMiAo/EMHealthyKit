//
//  HKHealthStore+EMExtensisons.h
//  EMHealthyKitDemo
//
//  Created by Eric MiAo on 2017/6/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (EMExtensisons)

/**
 * 获取某一项指标系统提供的所有结果
 * @param quantityType 指标类型
 * @param predicate 时间点
 * @param completion 回调
 */
- (void)emhk_mostRecentQuantitySampleOfType:(HKSampleType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;

@end
