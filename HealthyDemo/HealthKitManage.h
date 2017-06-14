//
//  HealthKitManage.h
//  HealthyDemo
//
//  Created by Eric MiAo on 2017/5/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <HealthKit/HealthKit.h>
#import <UIKit/UIKit.h>

@interface EMHealthKitManageModel : NSObject
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger stepCount;

@end


@interface HealthKitManage : NSObject

@property(nonatomic,strong)HKHealthStore *healthStore;

/**
 *  2.创建单例
 */
+ (id)shareInstance;

/*
 *  3.检查是否支持获取健康数据
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

/*
 *  4.获取步数
 */
- (void)getStepCount:(void(^)(double value, NSError *error))completion;

/**
 *  5.获取公里数
 *  读取步行+跑步距离
 */
- (void)getDistance:(void(^)(double value, NSError *error))completion;

- (void)getBlood:(void(^)(double value, NSError *error))completion;

- (void)getSleep:(void(^)(double value, NSError *error))completion;

- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;
/*!
 *  @author Lcong, 15-04-20 18:04:32
 *
 *  @brief  获取卡路里
 *
 *  @param predicate    时间段
 *  @param quantityType 样本类型
 *  @param handler      回调
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;

+ (NSPredicate *)predicateForSamplesToday;
+ (NSArray <NSPredicate *>*)predicateForSamplesHour;
- (void)getDistancesFromHealthKit;
- (void)getStepFromHealthKitComplate:(void(^)(NSArray <EMHealthKitManageModel *> *stepArray))handler;
- (void)getEnergyFromHealthKit;
- (void)getHeightFromHealthKit;
- (void)getWeightFromHealthKit;
- (void)getOxygenSaturationFromHealthKit;
- (void)getBodyMassIndexFromHealthKit;
- (void)getDietaryEnergyConsumedFromHealthKit;
- (void)getRespiratoryRateFromHealthKit;
- (void)getBodyTemperatureFromHealthKit;
- (void)getBloodGlucoseFromHealthKit;
- (void)getBloodPressureFromHealthKit;
@end
