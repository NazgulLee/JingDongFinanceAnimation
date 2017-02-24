//
//  CalendarVC.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/15.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "CalendarVC.h"
#import "Macro.h"

@interface CalendarVC ()

@property (nonatomic) NSArray *dayLabels;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
	[self configureViews];
	
}

- (void)configureViews
{
	NSArray *weekdayStrings = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	NSMutableArray *dayLabelArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < 7; i++)
	{
		UILabel *label = [[UILabel alloc] init];
		label.text = weekdayStrings[i];
		label.font = [UIFont systemFontOfSize:13];
		label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
		[self.view addSubview:label];
		label.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:(2 * i + 1) * kScreenWidth / 14]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:kScreenHeight * 16.0 / 568]];
		//[label sizeToFit];
		
		UILabel *dayLabel = [[UILabel alloc] init];
		dayLabel.font = [UIFont systemFontOfSize:17];
		//dayLabel.textColor = backgroundColorWhite;
		[self.view addSubview:dayLabel];
		dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:dayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeCenterY multiplier:1 constant:kScreenHeight * 32.0 / 568]];
		//[dayLabel sizeToFit];
		dayLabel.text = [NSString stringWithFormat:@"%ld", [(NSNumber *)self.daysArray[i] integerValue]];

		[dayLabelArray addObject:dayLabel];
	}
	//NSLog(@"%s %lu", __FUNCTION__, (unsigned long)dayLabelArray.count);
	self.dayLabels = [NSArray arrayWithArray:dayLabelArray];
	//NSLog(@"%s %lu", __FUNCTION__, (unsigned long)self.dayLabels.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Accessor methods
-(void)setDaysArray:(NSArray *)daysArray
{
	//NSLog(@"%s %@", __FUNCTION__, daysArray);
	//NSLog(@"%s %lu", __FUNCTION__, (unsigned long)self.dayLabels.count);
	_daysArray = daysArray;
//	for (int i = 0; i < daysArray.count; i++)
//	{
//		((UILabel *)self.dayLabels[i]).text = [NSString stringWithFormat:@"%ld", [(NSNumber *)daysArray[i] integerValue]];
//	}
}

- (void)setDateComponentsArray:(NSArray *)dateComponentsArray
{
	_dateComponentsArray = dateComponentsArray;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
