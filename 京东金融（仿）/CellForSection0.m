//
//  CellForSection0.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/14.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "CellForSection0.h"

@interface CellForSection0()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;


@end

@implementation CellForSection0

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
	self.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview:self.titleLabel];
	[self.contentView addSubview:self.detailLabel];
	
	self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:15]];
	[self.detailLabel sizeToFit];
	
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.detailLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10]];
	
//	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 80, 40)];
//	view.backgroundColor = [UIColor redColor];
//	[self.contentView addSubview:view];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
}


#pragma Accessor Methods
- (UILabel *)titleLabel
{
	if (_titleLabel == nil)
	{
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.font = [UIFont systemFontOfSize:15];
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	return _titleLabel;
}

- (UILabel *)detailLabel
{
	if (_detailLabel == nil)
	{
		_detailLabel = [[UILabel alloc] init];
		_detailLabel.font = [UIFont systemFontOfSize:11];
		_detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
		_detailLabel.backgroundColor = [UIColor clearColor];
	}
	return _detailLabel;
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	self.titleLabel.text = title;
}

- (void)setDetailText:(NSString *)detailText
{
	_detailText = detailText;
	self.detailLabel.text = detailText;
}

@end
