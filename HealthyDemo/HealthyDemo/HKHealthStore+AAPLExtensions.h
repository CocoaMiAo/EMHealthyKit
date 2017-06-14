//
//  HKHealthStore+AAPLExtensions.h
//  HealthyDemo
//
//  Created by Eric MiAo on 2017/6/13.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (AAPLExtensions)
- (void)aapl_mostRecentQuantitySampleOfType:(HKSampleType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;
@end
