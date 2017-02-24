//
//  CellForSection1.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/14.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "CellForSection1.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

@interface CellForSection1 ()
@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) UILabel *weekDayLabel;
@property (nonatomic) UILabel *newsLabel1;
@property (nonatomic) UILabel *newsLabel2;
@end

@implementation CellForSection1
{
	NSTimer *timer;
	NSArray *weekdayStrings;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self configureViews];
	}
	return self;
}

- (void)configureViews
{
	self.contentView.clipsToBounds = YES;
	//self.contentView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview:self.dayLabel];
	[self.contentView addSubview:self.weekDayLabel];
	
	self.dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 / 6 constant:0]];
	[self.dayLabel sizeToFit];
	

	self.weekDayLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.weekDayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.weekDayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 / 6 constant:0]];
	[self.weekDayLabel sizeToFit];
	
	UIView *seperatorView = [[UIView alloc] init];
	seperatorView.size = CGSizeMake(1, 0.34 * self.contentView.bounds.size.height);
	seperatorView.center = CGPointMake(kScreenWidth / 6, self.contentView.bounds.size.height / 2);
	seperatorView.backgroundColor = backgroundColorWhite;
	[self.contentView addSubview:seperatorView];
	
	UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
	arrowImageView.center = CGPointMake(11 * kScreenWidth / 12 + arrowImageView.size.width, self.contentView.bounds.size.height / 2);
	[self.contentView addSubview: arrowImageView];
	
	[self.contentView addSubview:self.newsLabel1];
	[self.contentView addSubview:self.newsLabel2];
	
	self.newsLabel1.translatesAutoresizingMaskIntoConstraints = NO;
	[self.newsLabel1 sizeToFit];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsLabel1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsLabel1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:arrowImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:-kScreenWidth / 48]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsLabel1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:seperatorView attribute:NSLayoutAttributeRight multiplier:1 constant:kScreenWidth / 36]];
	
	self.newsLabel2.translatesAutoresizingMaskIntoConstraints = NO;
	[self.newsLabel2 sizeToFit];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsLabel2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:self.contentView.bounds.size.height]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsLabel2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:arrowImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:-kScreenWidth / 48]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsLabel2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:seperatorView attribute:NSLayoutAttributeRight multiplier:1 constant:kScreenWidth / 36]];
	
	weekdayStrings = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	self.newsArray = @[@"签到：每日签到可领京豆，前去签到领京豆京豆京豆京豆", @"早报：你买的第一套房，比后面升值了多少多少多少"];
	self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
	NSDateComponents *components = [self dateComponentsOfToday];
	NSInteger day = components.day;
	NSInteger weekday = components.weekday;
	self.day = [NSString stringWithFormat:@"%ld", day];
	self.weekDay = weekdayStrings[weekday - 1];
	

}
//重置两个newsLabel的位置和内容
- (void)resetNewsLabels
{
	self.newsLabel1.centerY = self.contentView.centerY;
	self.newsLabel1.text = @"";
	self.newsLabel2.centerY = self.contentView.centerY + self.contentView.bounds.size.height;
	self.newsLabel2.text = @"";
}

- (NSDateComponents *)dateComponentsOfToday
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	calendar.locale = [NSLocale currentLocale];
	calendar.timeZone = [NSTimeZone localTimeZone];
	NSDate *date = [NSDate date];
	//NSLog(@"%@", date.description);
	NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
	return components;
}

- (void)startAnimatingNews
{
	
	[UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		if (self.newsLabel1.centerY < self.newsLabel2.centerY)
		{
			self.newsLabel2.centerY = self.contentView.centerY;
			self.newsLabel1.centerY = self.contentView.centerY - self.contentView.bounds.size.height;
		}
		else
		{
			self.newsLabel1.centerY = self.contentView.centerY;
			self.newsLabel2.centerY = self.contentView.centerY - self.contentView.bounds.size.height;
		}
		
	}completion:^(BOOL finished){
		
		if (self.newsLabel1.centerY < self.newsLabel2.centerY)
		{
			self.newsLabel1.centerY = self.contentView.centerY + self.contentView.bounds.size.height;
		}
		else
		{
			self.newsLabel2.centerY = self.contentView.centerY + self.contentView.bounds.size.height;
		}
	}];
	
//	[UIView animateWithDuration:0.5 animations:^{
//		if (self.newsLabel1.centerY < self.newsLabel2.centerY)
//		{
//			self.newsLabel2.centerY = self.contentView.centerY;
//			self.newsLabel1.centerY = self.contentView.centerY - self.contentView.bounds.size.height;
//		}
//		else
//		{
//			self.newsLabel1.centerY = self.contentView.centerY;
//			self.newsLabel2.centerY = self.contentView.centerY - self.contentView.bounds.size.height;
//		}
//		
//	}completion:^(BOOL finished){
//		
//		if (self.newsLabel1.centerY < self.newsLabel2.centerY)
//		{
//			self.newsLabel1.centerY = self.contentView.centerY + self.contentView.bounds.size.height;
//		}
//		else
//		{
//			self.newsLabel2.centerY = self.contentView.centerY + self.contentView.bounds.size.height;
//		}
//	}];
}

#pragma mark Accessor methods
- (UILabel *)dayLabel
{
#warning label显示的时间应当随着日期的变化自动变化
	if (_dayLabel == nil)
	{
		_dayLabel = [[UILabel alloc] init];
		_dayLabel.backgroundColor = [UIColor clearColor];
		_dayLabel.font = [UIFont systemFontOfSize:23];
	}

	return _dayLabel;
}

- (UILabel *)weekDayLabel
{
	if (_weekDayLabel == nil)
	{
		_weekDayLabel = [[UILabel alloc] init];
		_weekDayLabel.backgroundColor = [UIColor clearColor];
		_weekDayLabel.font = [UIFont systemFontOfSize:12];
	}
	
	return _weekDayLabel;
}

- (UILabel *)newsLabel1
{
	if (_newsLabel1 == nil)
	{
		_newsLabel1 = [[UILabel alloc] init];
		_newsLabel1.font = [UIFont systemFontOfSize:15];
		_newsLabel1.backgroundColor = [UIColor clearColor];
	}
	
	return _newsLabel1;
}

- (UILabel *)newsLabel2
{
	if (_newsLabel2 == nil)
	{
		_newsLabel2 = [[UILabel alloc] init];
		_newsLabel2.font = [UIFont systemFontOfSize:15];
		_newsLabel2.backgroundColor = [UIColor clearColor];
	}
	
	return _newsLabel2;
}

- (void)setDay:(NSString *)day
{
	_day = day;
	self.dayLabel.text = day;
}

- (void)setWeekDay:(NSString *)weekDay
{
	_weekDay = weekDay;
	self.weekDayLabel.text = weekDay;
}

-(void)setNewsArray:(NSArray *)newsArray
{
	if (timer) [timer invalidate];
	[self resetNewsLabels];
	
	_newsArray = newsArray;
	self.newsLabel1.text = self.newsArray[0];
	self.newsLabel2.text = self.newsArray[1];
	timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startAnimatingNews) userInfo:nil repeats:YES];
}

#pragma preapre for reuse
- (void)prepareForReuse
{
	[super prepareForReuse];
//	[timer invalidate];
//	timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startAnimatingNews) userInfo:nil repeats:YES];
}

@end
