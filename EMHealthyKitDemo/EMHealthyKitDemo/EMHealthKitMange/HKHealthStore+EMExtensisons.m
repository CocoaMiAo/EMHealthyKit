//
//  HKHealthStore+EMExtensisons.m
//  EMHealthyKitDemo
//
//  Created by Eric MiAo on 2017/6/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "HKHealthStore+EMExtensisons.h"

@implementation HKHealthStore (EMExtensisons)
- (void)emhk_mostRecentQuantitySampleOfType:(HKSampleType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion {
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        if (completion) {
            completion(results, error);
        }
    }];
    
    [self executeQuery:query];
}
@end
