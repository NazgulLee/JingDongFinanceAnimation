//
//  SectionHeaderView.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/16.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) [self configureViews];
	
	return self;
}

- (void)configureViews
{
	//self.backgroundColor = [UIColor redColor];
	[self addSubview:self.tipLabel];
	self.tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (UILabel *)tipLabel
{
	if (_tipLabel == nil)
	{
		_tipLabel = [[UILabel alloc] init];
		_tipLabel.font = [UIFont systemFontOfSize:14];
		_tipLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
		_tipLabel.backgroundColor = [UIColor clearColor];
		_tipLabel.text = @"下拉查看上一周";
	}
	
	return _tipLabel;
}

@end
