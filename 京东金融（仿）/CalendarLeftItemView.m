//
//  CalendarLeftItemView.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/17.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "CalendarLeftItemView.h"

@interface CalendarLeftItemView ()

@property (nonatomic) UILabel *monthLabel;
@property (nonatomic) UILabel *yearLabel;
@property (nonatomic) UIImageView *arrowImageView;

@end

@implementation CalendarLeftItemView

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self configureViews];
	}
	return self;
}

- (void)configureViews
{
	//self.backgroundColor = [UIColor redColor];
	[self addSubview:self.yearLabel];
	[self addSubview:self.monthLabel];
	[self addSubview:self.arrowImageView];
	
//	self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
//	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
//	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	//[self addConstraint:[NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	
	self.yearLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.yearLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.monthLabel attribute:NSLayoutAttributeRight multiplier:1 constant:2]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.yearLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.monthLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	//[self addConstraint:[NSLayoutConstraint constraintWithItem:self.yearLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	
	//[self sizeToFit];
	
	self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.yearLabel attribute:NSLayoutAttributeRight multiplier:1 constant:2]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.yearLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (CGSize)sizeThatFits:(CGSize)size
{
	[self.yearLabel sizeToFit];
	[self.monthLabel sizeToFit];
	return CGSizeMake(self.monthLabel.bounds.size.width + self.yearLabel.bounds.size.width + self.arrowImageView.bounds.size.width, self.monthLabel.bounds.size.height);
	//return CGSizeMake(100, 100);
}

- (void)toogleArrowImage
{
	self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
}

#pragma mark - Accessor methods
- (UILabel *)monthLabel
{
	if (_monthLabel == nil)
	{
		_monthLabel = [[UILabel alloc] init];
		_monthLabel.font = [UIFont systemFontOfSize:17];
		_monthLabel.backgroundColor = [UIColor clearColor];
	}
	
	return _monthLabel;
}

- (UILabel *)yearLabel
{
	if (_yearLabel == nil)
	{
		_yearLabel = [[UILabel alloc] init];
		_yearLabel.font = [UIFont systemFontOfSize:12];
		_yearLabel.backgroundColor = [UIColor clearColor];
		_yearLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
	}
	
	return _yearLabel;
}

- (UIImageView *)arrowImageView
{
	if (_arrowImageView == nil)
	{
		CGFloat width = 8;
		UIGraphicsBeginImageContext(CGSizeMake(width, width / 2));
		UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
		[trianglePath moveToPoint:CGPointMake(0, 0)];
		[trianglePath addLineToPoint:CGPointMake(width, 0)];
		[trianglePath addLineToPoint:CGPointMake(width / 2, width / 2)];
		[trianglePath closePath];
		[[UIColor blackColor] set];
		[trianglePath stroke];
		[trianglePath fill];
		UIImage *arrowImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		_arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
		
	}
	return _arrowImageView;
}

- (void)setMonthString:(NSString *)monthString
{
	_monthString = monthString;
	self.monthLabel.text = monthString;
	[self sizeToFit];
}

- (void)setYearString:(NSString *)yearString
{
	_yearString = yearString;
	self.yearLabel.text = yearString;
	[self sizeToFit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
