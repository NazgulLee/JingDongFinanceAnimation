//
//  CalendarVC.h
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/15.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarVC : UIViewController


@property (nonatomic) NSArray *daysArray;
@property (nonatomic) NSArray *dateComponentsArray;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSDate *mDate;

@end
