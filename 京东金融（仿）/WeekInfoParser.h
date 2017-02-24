//
//  WeekInfoParser.h
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/16.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekInfoParser : NSObject

//@property (nonatomic) NSDate *mDate;
//@property (nonatomic, readonly) NSArray *daysArray;
//@property (nonatomic, readonly) NSArray *dateComponentsArray;

+ (NSArray *)daysArrayForDate:(NSDate *)date;
+ (NSArray *)daysArrayForDate:(NSDate *)date byWeekOffset:(NSInteger)offset;
+ (NSArray *)daysArrayForDate:(NSDate *)date byMonthOffset:(NSInteger)offset;

+ (NSArray *)dateComponentsArrayForDate: (NSDate *)date;
+ (NSArray *)dateComponentsArrayForDate: (NSDate *)date byWeekOffset:(NSInteger)offset;
+ (NSArray *)dateComponentsArrayForDate: (NSDate *)date byMonthOffset:(NSInteger)offset;

+ (instancetype)weekParser;

@end
