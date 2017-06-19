//
//  EMHealthKitMange.h
//  EMHealthyKitDemo
//
//  Created by Eric MiAo on 2017/6/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIKit.h>

@interface EMHealthKitManageModel : NSObject /** 获取步长时的数据对象*/
@property (nonatomic, strong) NSPredicate *predicate; /** 时间参数*/
@property (nonatomic, strong) NSDate *startDate; /** 开始时间*/
@property (nonatomic, strong) NSDate *endDate; /** 结束时间*/
@property (nonatomic, assign) NSInteger stepCount; /** 步数*/

@end
@interface EMHealthKitMange : NSObject
@property(nonatomic,strong)HKHealthStore *healthStore; /** 调用系统健康方法的对象*/

/**
 * 创建单例
 */
+ (id)shareInstance;

/*
 * 检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

/**
 * 获取今日距离
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getDistancesFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日步数(今日实时总步数)
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getStepFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日步数(每小时获取)
 * @param handler 回调
 */
- (void)getStepFromHealthKitComplate:(void(^)(NSArray <EMHealthKitManageModel *> *stepArray))handler;

/**
 * 获取今日活动能量
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getEnergyFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取最新身高
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getHeightFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取最新体重
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getWeightFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日血氧
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getOxygenSaturationFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取最新体重指数
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getBodyMassIndexFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日膳食能量
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getDietaryEnergyConsumedFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日最新呼吸速率
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getRespiratoryRateFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日最新体温
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getBodyTemperatureFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日最新血糖
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调
 */
- (void)getBloodGlucoseFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(double value, NSError *error))compltion;

/**
 * 获取今日最新血压
 * @param unit 单位(默认单位传入nil)
 * @param compltion 回调 valueDic 包含low和high字段，代表高压低压
 */
- (void)getBloodPressureFromHealthKitWithUnit:(HKUnit *)unit withCompltion:(void(^)(NSDictionary *valueDic, NSError *error))compltion;
@end
