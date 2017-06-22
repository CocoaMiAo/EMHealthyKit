//
//  EMHealthKitMange.m
//  EMHealthyKitDemo
//
//  Created by Eric MiAo on 2017/6/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "EMHealthKitManager.h"
#import "HKHealthStore+EMExtensisons.h"

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"
@implementation EMHealthKitManagerModel

@end


@interface EMHealthKitManager()

@end

@implementation EMHealthKitManager
#pragma mark - **************** 单例创建
+ (id)shareInstance {
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

#pragma mark - **************** 权限相关
#pragma mark - 获取系统健康权限
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion {
    if(HKVersion >= 8.0) {
        if (![HKHealthStore isHealthDataAvailable]) {
            NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit" code: 2 userInfo: [NSDictionary dictionaryWithObject:@"HealthKit is not available in this Device"                                                                      forKey:NSLocalizedDescriptionKey]];
            if (compltion != nil) {
                compltion(false, error);
            }
            return;
        }
        
        if ([HKHealthStore isHealthDataAvailable]) {
            if(self.healthStore == nil)
                self.healthStore = [[HKHealthStore alloc] init];
            /*
             组装需要读写的数据类型
             */
            NSSet *readDataTypes = [self dataTypesRead];
            /*
             注册需要读写的数据类型，也可以在“健康”APP中重新修改
             */
            [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                
                if (success) {
                    if (compltion != nil) {
                        //                        NSLog(@"error->%@", error.localizedDescription);
                        compltion (success, error);
                    }
                    
                } else {
                    compltion (success, error);
                }
                
            }];
        }
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        compltion(0,aError);
    }
}

#pragma mark - 读权限集合
- (NSSet *)dataTypesRead {
    
    
    /** 步数*/
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    /** 行走距离*/
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    HKQuantityType *energyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKQuantityType *oxygenSaturationType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation];
    
    HKQuantityType *dietaryEnergyConsumedType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    
    HKQuantityType *respiratoryRateType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    
    HKQuantityType *bodyTemperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    
    HKQuantityType *bloodGlucoseType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    HKQuantityType *bloodPressureSystolicType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *bloodPressureDiastolicType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    HKQuantityType *bodyMassIndexType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    /** 睡眠数据*/
    //    HKCategoryType *sleepAnalysis = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    //    /** 血压*/
    //    HKCorrelationType *bloodPressure = [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    //    HKCorrelationType *bloodSystolicPressure = [HKCorrelationType correlationTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    //    HKCorrelationType *bloodDiastolicPressure = [HKCorrelationType correlationTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    return [NSSet setWithObjects:stepCountType,distanceType,energyType,heightType,weightType,oxygenSaturationType,dietaryEnergyConsumedType,respiratoryRateType,bodyTemperatureType,bloodGlucoseType,bloodPressureSystolicType,bloodPressureDiastolicType,bodyMassIndexType,nil];
}

#pragma mark - **************** 获取时间段
#pragma mark - 当天时间段
/*! 6.NSPredicate当天时间段的方法实现
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday:(BOOL)isLatest {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    if (isLatest) {
        startDate = 0;
    }
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

#pragma mark - 当天每小时的时间段
+ (NSArray <EMHealthKitManagerModel *>*)predicateForSamplesHour {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDateComponents *comp = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:now];
    NSInteger hour = comp.hour;
    NSInteger min = comp.minute;
    
    NSInteger count = min>0?(hour+1):hour;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        EMHealthKitManagerModel *model = [[EMHealthKitManagerModel alloc] init];
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitMinute value:59 toDate:startDate options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
        model.predicate = predicate;
        model.startDate = startDate;
        model.endDate = [calendar dateByAddingUnit:NSCalendarUnitMinute value:1 toDate:endDate options:0];
        startDate = model.endDate;
        [arrayM addObject:model];
    }
    return arrayM;
}

#pragma mark - 八小时时间转换
+ (NSDate *)dateChange:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date dateByAddingTimeInterval:interval];
    return date;
}

#pragma mark - **************** 获取各项健康数据
#pragma mark - 步数(当天实时步数总和)
- (void)getStepFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    [self fetchQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit countUnit] completion:^(double stepCount, NSError *error) {
        compltion(stepCount, error);
    }];
}

#pragma mark - 步数
- (void)getStepFromHealthKitComplate:(void(^)(NSArray <EMHealthKitManagerModel *> *stepArray))handler {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSArray *arr = [EMHealthKitManager predicateForSamplesHour];
    __block NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < arr.count; i ++) {
        EMHealthKitManagerModel *model = [arr objectAtIndex:i];
        NSPredicate *predicate = model.predicate;
        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:stepType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            HKQuantity *sum = [result sumQuantity];
            if (!error) {
                NSInteger value = [sum doubleValueForUnit:[HKUnit countUnit]];
                model.stepCount = value;
                [arrM addObject:model];
            }
            if (arrM.count == arr.count) {
                NSArray *array = arrM;
                array = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
                handler(array);
            }
        }];
        [self.healthStore executeQuery:query];
    }
}

#pragma mark - 距离
- (void)getDistancesFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    [self fetchQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit meterUnit] completion:^(double distancesMeter, NSError *error) {
        compltion(distancesMeter, error);
    }];
}

#pragma mark - 活动能量
- (void)getEnergyFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    [self fetchQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit kilocalorieUnit] completion:^(double energyKilocalorie, NSError *error) {
        compltion(energyKilocalorie, error);
    }];
}

#pragma mark - 身高
- (void)getHeightFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit unitFromString:@"cm"] isLatest:YES completion:^(double heightCM, NSError *error) {
        compltion(heightCM, error);
    }];
}

#pragma mark - 体重
- (void)getWeightFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit unitFromString:@"kg"] isLatest:YES completion:^(double weightKG, NSError *error) {
        compltion(weightKG, error);
    }];
}

#pragma mark - 血氧
- (void)getOxygenSaturationFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit percentUnit] isLatest:NO completion:^(double oxygenSaturationPercent, NSError *error) {
        compltion(oxygenSaturationPercent, error);
    }];
}

#pragma mark - 体重指数
- (void)getBodyMassIndexFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit countUnit] isLatest:YES completion:^(double bodyMassIndexPercentCount, NSError *error) {
        compltion(bodyMassIndexPercentCount, error);
    }];
}

#pragma mark - 膳食能量
- (void)getDietaryEnergyConsumedFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
        HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    [self.healthStore emhk_mostRecentQuantitySampleOfType:stepType predicate:[EMHealthKitManager predicateForSamplesToday:NO] completion:^(NSArray *results, NSError *error) {
            double sum = 0;
            for (int i = 0; i < results.count; i ++) {
                HKQuantitySample *sample = [results objectAtIndex:i];
                sum += [sample.quantity doubleValueForUnit:unit!=nil?unit:[HKUnit kilocalorieUnit]];
            }
            
            compltion(sum, error);
        }];
}

#pragma mark - 呼吸速率
- (void)getRespiratoryRateFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit unitFromString:@"count/min"] isLatest:NO completion:^(double respiratoryRate, NSError *error) {
        compltion(respiratoryRate, error);
    }];
}

#pragma mark - 体温
- (void)getBodyTemperatureFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit degreeCelsiusUnit] isLatest:NO completion:^(double bodyTemperature, NSError *error) {
        compltion(bodyTemperature, error);
    }];
}

#pragma mark - 血糖
- (void)getBloodGlucoseFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(double, NSError *))compltion {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:unit!=nil?unit:[HKUnit unitFromString:@"mg/dL"] isLatest:NO completion:^(double bloodGlucose, NSError *error) {
        compltion(bloodGlucose, error);
    }];
}

#pragma mark - 血压
- (void)getBloodPressureFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void (^)(NSDictionary *, NSError *))compltion {
    HKSampleType *systolic = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKSampleType *diastolic = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    [self fetchSampleQuantitySumOfSamplesTodayForType:systolic unit:unit!=nil?unit:[HKUnit millimeterOfMercuryUnit] isLatest:NO completion:^(double bloodPressureSystolic, NSError *error) {
        if (!error) {
            [self fetchSampleQuantitySumOfSamplesTodayForType:diastolic unit:[HKUnit millimeterOfMercuryUnit] isLatest:NO completion:^(double bloodPressureDiastolic, NSError *error) {
                compltion(@{@"low":[NSString stringWithFormat:@"%f",bloodPressureSystolic],@"high":[NSString stringWithFormat:@"%f",bloodPressureDiastolic]}, error);
            }];
        } else {
            compltion(nil, error);
        }
    }];
    
    
}

#pragma mark - **************** 根据时间范围取数据
- (void)fetchSampleQuantitySumOfSamplesTodayForType:(HKSampleType *)sampleType unit:(HKUnit *)unit isLatest:(BOOL)isLatest completion:(void (^)(double,NSError *))completionHandler {
    NSPredicate *predicate = [EMHealthKitManager predicateForSamplesToday:isLatest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:false];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:1 sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        HKQuantitySample *sample = results.firstObject;
        if (completionHandler) {
            double value = [sample.quantity doubleValueForUnit:unit];
            completionHandler(value,error);
        }
    }];
    [self.healthStore executeQuery:query];
}

- (void)fetchQuantitySumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler {
    NSPredicate *predicate = [EMHealthKitManager predicateForSamplesToday:NO];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            completionHandler(value, error);
        }
    }];
    [self.healthStore executeQuery:query];
}

@end
