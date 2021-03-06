//
//  ViewController.m
//  EMHealthyKitDemo
//
//  Created by Eric MiAo on 2017/6/15.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "ViewController.h"
#import "EMHealthKitManager/EMHealthKitManager.h"

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
    [btn addTarget:self action:@selector(getData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)getData:(UIButton *)sender {

    [[EMHealthKitManager shareInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            
            [[EMHealthKitManager shareInstance] getStepFromHealthKitComplate:^(NSArray<EMHealthKitManagerModel *> *stepArray) {
                NSMutableArray *arrM = [NSMutableArray array];
                for (int i = 0; i < stepArray.count; i ++) {
                    EMHealthKitManagerModel *model = [stepArray objectAtIndex:i];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *compStart = [calendar components:NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth fromDate:model.startDate];
                    //                    NSString *start = [NSString stringWithFormat:@"%ld  %ld  %ld  %ld",compStart.year,compStart.month,compStart.day,compStart.hour];
                    
                    NSDateComponents *compEnd = [calendar components:NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:model.endDate];
                    NSString *end = [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld点~%ld点",(long)compEnd.year,(long)compEnd.month,(long)compEnd.day,(long)compStart.hour,(long)compEnd.hour];
                    NSString *step = [NSString stringWithFormat:@"%@走了%ld步",end,(long)model.stepCount];
                    
                    [arrM addObject:step];
                }
                NSLog(@"步数统计:%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:(arrM) options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            }];
            
            [[EMHealthKitManager shareInstance] getStepFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"今日步数%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getDistancesFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"距离:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getEnergyFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"活动能量:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getHeightFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"身高:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getWeightFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"体重:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getOxygenSaturationFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"血氧:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getBodyMassIndexFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"体重指数:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getDietaryEnergyConsumedFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"膳食能量:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getRespiratoryRateFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"呼吸速率:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getBodyTemperatureFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"体温:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getBloodGlucoseFromHealthKitWithUnit:nil withCompltion:^(double value, NSError *error) {
                NSLog(@"血糖:%.2f",value);
            }];
            
            [[EMHealthKitManager shareInstance] getBloodPressureFromHealthKitWithUnit:nil withCompltion:^(NSDictionary *valueDic, NSError *error) {
                NSLog(@"血压%@",valueDic);
            }];
            
        } else {
            NSLog(@"获取失败 error: %@",error);
        }
    }];
}


@end
