//
//  WeekInfoParser.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/16.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "WeekInfoParser.h"

@implementation WeekInfoParser
{
	
}

+ (instancetype)weekParser
{
	static WeekInfoParser *weekParser;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		weekParser = [[WeekInfoParser alloc] init];
	});
	return weekParser;
}

//- (NSArray *)dateComponentsArray
//{
//	if (self.mDate == nil) return nil;
//	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:7];
//	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//	NSDateComponents *components = [[NSDateComponents alloc] init];
//	NSInteger day = [calendar component:NSCalendarUnitDay fromDate:self.mDate];
//	for (NSInteger i = 0; i < 7; i++)
//	{
//		NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitDay value: i + 1 - day toDate:self.mDate options:NSCalendarMatchStrictly];
//		components = [calendar components:NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:newDate];
//		[array addObject:components];
//	}
//	return [NSArray arrayWithArray:array];
//}
//
//- (NSArray *)daysArray
//{
//	NSArray *componentsArray = self.dateComponentsArray;
//	NSMutableArray *daysArray = [[NSMutableArray alloc] initWithCapacity:7];
//	for (NSInteger i = 0; i < 7; i++)
//	{
//		NSInteger day = ((NSDateComponents *)componentsArray[i]).day;
//		[daysArray addObject:[NSNumber numberWithInteger:day]];
//	}
//	return [NSArray arrayWithArray:daysArray];
//}

+ (NSArray *)dateComponentsArrayForDate:(NSDate *)date
{
	if (date == nil) return nil;
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:7];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
	//NSLog(@"day: %ld", weekday);
	for (NSInteger i = 0; i < 7; i++)
	{
		NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitDay value: i + 1 - weekday toDate:date options:NSCalendarMatchStrictly];
		components = [calendar components:NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:newDate];
		[array addObject:components];
	}
	return [NSArray arrayWithArray:array];
}

+ (NSArray *)dateComponentsArrayForDate: (NSDate *)date byWeekOffset:(NSInteger)offset
{
	if (date == nil) return nil;
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:offset * 7 toDate:date options:NSCalendarMatchStrictly];
	return [self dateComponentsArrayForDate:newDate];
}

+ (NSArray *)dateComponentsArrayForDate: (NSDate *)date byMonthOffset:(NSInteger)offset
{
	if (date == nil) return nil;
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:offset toDate:date options:NSCalendarMatchStrictly];
	return [self dateComponentsArrayForDate:newDate];
}

+ (NSArray *)daysArrayForDate:(NSDate *)date
{
	NSArray *componentsArray = [self dateComponentsArrayForDate:date];
	NSMutableArray *daysArray = [[NSMutableArray alloc] initWithCapacity:7];
	for (NSInteger i = 0; i < 7; i++)
	{
		NSInteger day = ((NSDateComponents *)componentsArray[i]).day;
		[daysArray addObject:[NSNumber numberWithInteger:day]];
	}
	return [NSArray arrayWithArray:daysArray];
}

+ (NSArray *)daysArrayForDate:(NSDate *)date byWeekOffset:(NSInteger)offset
{
	NSArray *componentsArray = [self dateComponentsArrayForDate:date byWeekOffset:offset];
	NSMutableArray *daysArray = [[NSMutableArray alloc] initWithCapacity:7];
	for (NSInteger i = 0; i < 7; i++)
	{
		NSInteger day = ((NSDateComponents *)componentsArray[i]).day;
		[daysArray addObject:[NSNumber numberWithInteger:day]];
	}
	return [NSArray arrayWithArray:daysArray];
}

+ (NSArray *)daysArrayForDate:(NSDate *)date byMonthOffset:(NSInteger)offset
{
	NSArray *componentsArray = [self dateComponentsArrayForDate:date byMonthOffset:offset];
	NSMutableArray *daysArray = [[NSMutableArray alloc] initWithCapacity:7];
	for (NSInteger i = 0; i < 7; i++)
	{
		NSInteger day = ((NSDateComponents *)componentsArray[i]).day;
		[daysArray addObject:[NSNumber numberWithInteger:day]];
	}
	return [NSArray arrayWithArray:daysArray];
}

@end
