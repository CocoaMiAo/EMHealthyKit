//
//  HealthKitManage.m
//  HealthyDemo
//
//  Created by Eric MiAo on 2017/5/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "HealthKitManage.h"
#import "HealthyDemo/HKHealthStore+AAPLExtensions.h"

/* 1.导入头文件 */
#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

@implementation EMHealthKitManageModel

@end


@interface HealthKitManage()

@end
@implementation HealthKitManage

/**
 *  2.创建单例
 */
+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

/*
 *  3.检查是否支持获取健康数据
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion
{
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
            NSSet *writeDataTypes = [self dataTypesToWrite];
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
    }else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        compltion(0,aError);
    }
}

/*! 3.1
 *  @brief  写权限
 *  @return 集合
 *  设置需要获取的权限:
 */
- (NSSet *)dataTypesToWrite
{
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
    
}

#pragma mark - **************** 读权限设置
/*! 3.2
 *  @brief  读权限
 *  @return 集合
 */
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
    
    /** 睡眠数据*/
//    HKCategoryType *sleepAnalysis = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
//    /** 血压*/
//    HKCorrelationType *bloodPressure = [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
//    HKCorrelationType *bloodSystolicPressure = [HKCorrelationType correlationTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
//    HKCorrelationType *bloodDiastolicPressure = [HKCorrelationType correlationTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    return [NSSet setWithObjects:stepCountType,distanceType,energyType,heightType,weightType,oxygenSaturationType,dietaryEnergyConsumedType,respiratoryRateType,bodyTemperatureType,bloodGlucoseType,bloodPressureSystolicType
            ,bloodPressureDiastolicType,nil];
}

- (void)getSleep:(void(^)(double value, NSError *error))completion {
    HKCategoryType *sleepAnalysis = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sleepAnalysis predicate:[HealthKitManage predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error) {
            completion(0,error);
        } else {
            NSInteger totleSteps = 0;
            for(HKCategorySample *quantitySample in results) {
                NSInteger quantity = quantitySample.value;
                NSString *statusStr = quantity == 0?@"睡觉":@"没睡觉";
                //                HKCategoryTypeIdentifierSleepAnalysis
                //                HKCategoryValueSleepAnalysis
                
                //                NSLog(@"当天睡眠 %@ %@ -- %@",statusStr,quantitySample.startDate,quantitySample.endDate);
            }
            
            completion(totleSteps,error);
        }
    }];
    
    [self.healthStore executeQuery:query];/* 执行查询 */
}

/*
 * 4.获取步数
 */
- (void)getStepCount:(void(^)(double value, NSError *error))completion {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    /**  NSSortDescriptors用来告诉healthStore怎么样将结果排序。
     *
     *   NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
     *
     */
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
     HKSample类所以对应的查询类就是HKSampleQuery。
     下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
     */
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[HealthKitManage predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error) {
            completion(0,error);
        } else {
            
            
            NSInteger totleSteps = 0;
            for(HKQuantitySample *quantitySample in results) {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totleSteps += usersHeight;
            }
            NSLog(@"当天行走步数 = %ld",(long)totleSteps);
            completion(totleSteps,error);
        }
    }];
    
    [self.healthStore executeQuery:query];/* 执行查询 */
}



/**
 *   5.获取公里数
 *   读取步行+跑步距离
 */
- (void)getDistance:(void(^)(double value, NSError *error))completion {
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[HealthKitManage predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(error) {
            completion(0,error);
        } else {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results){
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            NSLog(@"当天行走距离 = %.2f",totleSteps);
            completion(totleSteps,error);
        }
    }];
    [self.healthStore executeQuery:query];
}

- (void)getBlood:(void(^)(double value, NSError *error))completion {
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[HealthKitManage predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(error) {
            completion(0,error);
        } else {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results){
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            NSLog(@"血压 = %.2f",totleSteps);
            completion(totleSteps,error);
        }
    }];
    [self.healthStore executeQuery:query];
}

- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler {
    
    if(HKVersion < 8.0) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        handler(0,aError);
    } else {
        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            HKQuantity *sum = [result sumQuantity];
            
            double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
            NSLog(@"%@卡路里 ---> %.2lf",quantityType.identifier,value);
            if(handler) {
                handler(value,error);
            }
        }];
        [self.healthStore executeQuery:query];
    }
}

#pragma mark - **************** 获取时间段
/*! 6.NSPredicate当天时间段的方法实现
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [self dateChange:[NSDate date]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [self dateChange:[calendar dateFromComponents:components]];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}


/*! 6.NSPredicate当天时间段的方法实现
 *  @brief  小时时间段
 *
 */
+ (NSArray <EMHealthKitManageModel *>*)predicateForSamplesHour {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
   
    NSDate *startDate = [self dateChange:[calendar dateFromComponents:components]];
    NSDateComponents *comp = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:now];
    NSInteger hour = comp.hour;
    NSInteger min = comp.minute;
    
    NSInteger count = min>0?(hour+1):hour;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        EMHealthKitManageModel *model = [[EMHealthKitManageModel alloc] init];
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitHour value:1 toDate:startDate options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
        model.predicate = predicate;
        model.startDate = startDate;
        model.endDate = endDate;
        startDate = endDate;
        [arrayM addObject:model];
    }
    return arrayM;
}

+ (NSDate *)dateChange:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date dateByAddingTimeInterval:interval];
    return date;
}

- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler
{
    if(HKVersion < 8.0)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        handler(0,aError);
    }
    else
    {
        HKSampleType *sampleType =
        [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        
        HKObserverQuery *query =
        [[HKObserverQuery alloc]
         initWithSampleType:sampleType
         predicate:nil
         updateHandler:^(HKObserverQuery *query,
                         HKObserverQueryCompletionHandler completionHandler,
                         NSError *error) {
             if (error) {
                 
                 // Perform Proper Error Handling Here...
                 NSLog(@"*** An error occured while setting up the stepCount observer. %@ ***",
                          error.localizedDescription);
                 handler(0,error);
                 abort();
             }
             [self getStepCount:[HealthKitManage predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
                 handler(value,error);
             }];
         }];
        [self.healthStore executeQuery:query];
    }
}


/*!
 *  @author Lcong, 15-04-20 17:04:03
 *
 *  @brief  获取步数
 *
 *  @param predicate 时间段
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler {
    
    if(HKVersion < 8.0) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        handler(0,aError);
    } else {
        HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        
        [self.healthStore aapl_mostRecentQuantitySampleOfType:stepType predicate:predicate completion:^(NSArray *results, NSError *error) {
            if(error) {
                handler(0,error);
            } else {
//                HKAuthorizationStatus a = [self.healthStore authorizationStatusForType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]];
                NSInteger totleSteps = 0;
                for(HKQuantitySample *quantitySample in results) {
                    HKQuantity *quantity = quantitySample.quantity;
                    HKUnit *heightUnit = [HKUnit countUnit];
                    double usersHeight = [quantity doubleValueForUnit:heightUnit];
                    totleSteps += usersHeight;
                }
                NSLog(@"当天行走步数 = %ld",totleSteps);
                handler(totleSteps,error);
            }
        }];
    }
}


#pragma mark - **************** 获取各项健康数据
- (void)getDistancesFromHealthKit {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//    [self.healthStore aapl_mostRecentQuantitySampleOfType:stepType predicate:[HealthKitManage predicateForSamplesToday] completion:^(NSArray *results, NSError *error) {
//        NSLog(@"%@",results);
//    }];
    [self fetchQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit meterUnit] completion:^(double distancesMeter, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"** 你的公里数为：%.2f",distancesMeter);
            });
        }
    }];
    
}


- (void)getStepFromHealthKitComplate:(void(^)(NSArray <EMHealthKitManageModel *> *stepArray))handler {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSArray *arr = [HealthKitManage predicateForSamplesHour];
    __block NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < arr.count; i ++) {
        EMHealthKitManageModel *model = [arr objectAtIndex:i];
        NSPredicate *predicate = model.predicate;
        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:stepType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            HKQuantity *sum = [result sumQuantity];
            if (!error) {
                NSInteger value = [sum doubleValueForUnit:[HKUnit countUnit]];
                model.stepCount = value;
                [arrM addObject:model];
            }

            
            if (i == arr.count - 1) {
                handler(arrM);
            }
        }];
        
        [self.healthStore executeQuery:query];
    }

}

- (void)getEnergyFromHealthKit {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    [self fetchQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit kilocalorieUnit] completion:^(double energyKilocalorie, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"** 你的消耗能量为：%.2f",energyKilocalorie);
            });
        }
    }];
}

- (void)getHeightFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit meterUnit] completion:^(double heightMeter, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"身高:%.2f",heightMeter);
            });
        }
    }];
}

- (void)getWeightFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit gramUnit] completion:^(double weightGram, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"体重:%.2f",weightGram);
            });
        }
    }];
}

- (void)getOxygenSaturationFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit percentUnit] completion:^(double oxygenSaturationPercent, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"血氧:%.2f",oxygenSaturationPercent);
            });
        }
    }];
}

- (void)getBodyMassIndexFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit countUnit] completion:^(double bodyMassIndexPercentCount, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"体重指数:%.2f",bodyMassIndexPercentCount);
            });
        }
    }];
}

- (void)getDietaryEnergyConsumedFromHealthKit {
//    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
//    [self.healthStore aapl_mostRecentQuantitySampleOfType:stepType predicate:[HealthKitManage predicateForSamplesToday] completion:^(NSArray *results, NSError *error) {
//        NSLog(@"res %@",results);
//    }];
//    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit kilocalorieUnit] completion:^(double dietaryEnergyConsumedCountKilocalorie, NSError *error) {
//        if (!error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"膳食能量:%.2f",dietaryEnergyConsumedCountKilocalorie);
//            });
//        }
//    }];
}

- (void)getRespiratoryRateFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit unitFromString:@"count/min"] completion:^(double respiratoryRate, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"呼吸速率:%.2f",respiratoryRate);
            });
        }
    }];
}

- (void)getBodyTemperatureFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit degreeCelsiusUnit] completion:^(double bodyTemperature, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"体温:%.2f",bodyTemperature);
            });
        }
    }];
}

- (void)getBloodGlucoseFromHealthKit {
    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    [self fetchSampleQuantitySumOfSamplesTodayForType:stepType unit:[HKUnit unitFromString:@"mg/dL"] completion:^(double bloodGlucose, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"血糖:%.2f",bloodGlucose);
            });
        }
    }];
}

- (void)getBloodPressureFromHealthKit {
    HKSampleType *systolic = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKSampleType *diastolic = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    [self fetchSampleQuantitySumOfSamplesTodayForType:systolic unit:[HKUnit millimeterOfMercuryUnit] completion:^(double bloodPressureSystolic, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"血液收缩压:%.2f",bloodPressureSystolic);
            });
        }
    }];
    [self fetchSampleQuantitySumOfSamplesTodayForType:diastolic unit:[HKUnit millimeterOfMercuryUnit] completion:^(double bloodPressureDiastolic, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"血液舒张压:%.2f",bloodPressureDiastolic);
            });
        }
    }];
}



//- (void)getHeightFromHealthKit {
//    HKSampleType *stepType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    NSPredicate *predicate = [HealthKitManage predicateForSamplesToday];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:false];
//    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:predicate limit:1 sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
//        HKQuantitySample *sample = results.firstObject;
//        
//        NSLog(@"身高:%@",sample.quantity);
//    }];
//    
//    [self.healthStore executeQuery:query];
//}



- (void)fetchSampleQuantitySumOfSamplesTodayForType:(HKSampleType *)sampleType unit:(HKUnit *)unit completion:(void (^)(double,NSError *))completionHandler {
    NSPredicate *predicate = [HealthKitManage predicateForSamplesToday];
    
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
    NSPredicate *predicate = [HealthKitManage predicateForSamplesToday];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            completionHandler(value, error);
        }
    }];
    [self.healthStore executeQuery:query];
}

- (void)fetchQuantityArraySumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler {
    NSPredicate *predicate = [HealthKitManage predicateForSamplesToday];
    
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
