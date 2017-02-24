//
//  DateCollectionViewCell.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/16.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "DateCollectionViewCell.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

@interface DateCollectionViewCell ()

@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) UILabel *weekdayLabel;
@property (nonatomic) UILabel *yearAndMonthLabel;

@end

@implementation DateCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) [self configureViews];
	return self;
}

- (void)configureViews
{
	self.contentView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview:self.dayLabel];
	[self.contentView addSubview:self.weekdayLabel];
	[self.contentView addSubview:self.yearAndMonthLabel];
	
	self.dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.contentView.size.width / 12]];
	
	UIView *seperatorView = [[UIView alloc] init];
	[self.contentView addSubview:seperatorView];
	seperatorView.backgroundColor = backgroundColorWhite;
	seperatorView.size = CGSizeMake(1, self.contentView.size.height * 0.34);
	seperatorView.center = CGPointMake(self.contentView.size.width / 6, self.contentView.size.height / 2);
	//		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:seperatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	//		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:seperatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.contentView.size.width / 6]];
	
	self.weekdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.weekdayLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:seperatorView attribute:NSLayoutAttributeCenterX multiplier:1 constant:self.contentView.size.width / 18]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.weekdayLabel attribute:NSLayoutAttributeBottom relatedBy:1 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	
	self.yearAndMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.yearAndMonthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.weekdayLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.yearAndMonthLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

#pragma Accessor methods
- (UILabel *)dayLabel
{
	if (_dayLabel == nil)
	{
		_dayLabel = [[UILabel alloc] init];
		_dayLabel.backgroundColor = [UIColor clearColor];
		_dayLabel.font = [UIFont systemFontOfSize:30];
	}
	
	return _dayLabel;
}

- (UILabel *)weekdayLabel
{
	if (_weekdayLabel == nil)
	{
		_weekdayLabel = [[UILabel alloc] init];
		_weekdayLabel.backgroundColor = [UIColor clearColor];
		_weekdayLabel.font = [UIFont systemFontOfSize:12];
	}
	
	return _weekdayLabel;
}

- (UILabel *)yearAndMonthLabel
{
	if (_yearAndMonthLabel == nil)
	{
		_yearAndMonthLabel = [[UILabel alloc] init];
		_yearAndMonthLabel.backgroundColor = [UIColor clearColor];
		_yearAndMonthLabel.font = [UIFont systemFontOfSize:12];
	}
	
	return _yearAndMonthLabel;
}

- (void)setDay:(NSString *)day
{
	_day = day;
	self.dayLabel.text = day;
}

- (void)setWeekday:(NSString *)weekday
{
	_weekday = weekday;
	self.weekdayLabel.text = weekday;
}

- (void)setYearAndMonth:(NSString *)yearAndMonth
{
	_yearAndMonth = yearAndMonth;
	self.yearAndMonthLabel.text = yearAndMonth;
}


@end
