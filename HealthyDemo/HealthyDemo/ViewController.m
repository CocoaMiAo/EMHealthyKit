//
//  ViewController.m
//  HealthyDemo
//
//  Created by Eric MiAo on 2017/5/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitManage.h"
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100 , 100, 100, 100);
    btn.backgroundColor = [UIColor magentaColor];
    [btn setTitle:@"获取" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(abc:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)abc:(UIButton *)sender {
    [[HealthKitManage shareInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            
//            [HealthKitManage predicateForSamplesHour];
            
//            [[HealthKitManage shareInstance] getStepCount:^(double value, NSError *error) {
//                if (value) {
//                    NSLog(@"step:%@",@(value));
//                } else {
//                    NSLog(@"step error: %@",error);
//                }
//            }];
//            [[HealthKitManage shareInstance] getDistance:^(double value, NSError *error) {
//                if (value) {
//                    NSLog(@"distance %@",@(value));
//                } else {
//                    NSLog(@"distance error: %@",error);
//                }
//            }];
//            
//            [[HealthKitManage shareInstance] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
//                NSLog(@"real step  %@  error:%@",@(value),error.description);
//            }];
//
//            [[HealthKitManage shareInstance] getDistancesFromHealthKit];
            [[HealthKitManage shareInstance] getStepFromHealthKitComplate:^(NSArray<EMHealthKitManageModel *> *stepArray) {
                NSMutableArray *arrM = [NSMutableArray array];
                for (int i = 0; i < stepArray.count; i ++) {
                    EMHealthKitManageModel *model = [stepArray objectAtIndex:i];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *compStart = [calendar components:NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth fromDate:model.startDate];
//                    NSString *start = [NSString stringWithFormat:@"%ld  %ld  %ld  %ld",compStart.year,compStart.month,compStart.day,compStart.hour];
                    
                    NSDateComponents *compEnd = [calendar components:NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:model.endDate];
                    NSString *end = [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld点~%ld点",compEnd.year,compEnd.month,compEnd.day,compStart.hour,compEnd.hour];
                    NSString *step = [NSString stringWithFormat:@"%@走了%ld步",end,model.stepCount];
    
                    [arrM addObject:step];
                }
                NSLog(@"%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:(arrM) options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            }];
            
//            [[HealthKitManage shareInstance] getEnergyFromHealthKit];
//            [[HealthKitManage shareInstance] getHeightFromHealthKit];
//            [[HealthKitManage shareInstance] getWeightFromHealthKit];
//            [[HealthKitManage shareInstance] getOxygenSaturationFromHealthKit];
//            [[HealthKitManage shareInstance] getBodyMassIndexFromHealthKit];
//            [[HealthKitManage shareInstance] getDietaryEnergyConsumedFromHealthKit];
//            [[HealthKitManage shareInstance] getRespiratoryRateFromHealthKit];
//            [[HealthKitManage shareInstance] getBodyTemperatureFromHealthKit];
//            [[HealthKitManage shareInstance] getBloodGlucoseFromHealthKit];
//            [[HealthKitManage shareInstance] getBloodPressureFromHealthKit];

            //            [[HealthKitManage shareInstance] getBlood:^(double value, NSError *error) {
            //                if (value) {
            //                    NSLog(@"blood %@",@(value));
            //                } else {
            //                    NSLog(@"blood error: %@",error);
            //                }
            //            }];
            //
            //            [[HealthKitManage shareInstance] getSleep:^(double value, NSError *error) {
            //                if (value) {
            //                    NSLog(@"sleep %@",@(value));
            //                } else {
            //                    NSLog(@"sleep error: %@",error);
            //                }
            //            }];
            //
            //
            //            [[HealthKitManage shareInstance] getKilocalorieUnit:[HealthKitManage predicateForSamplesToday] quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
            //                if(error)
            //                {
            //                    NSLog(@"卡路里 error = %@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
            //                }
            //                else
            //                {
            //                    NSLog(@"获取到的卡路里 ＝ %.2lf",value);
            //                }
            //            }];
            
            
            
        } else {
            NSLog(@"获取失败 error: %@",error);
        }
    }];
}


@end
