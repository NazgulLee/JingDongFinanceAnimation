//
//  CalendarLeftItemView.h
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/17.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarLeftItemView : UIButton

@property (nonatomic) NSString *monthString;
@property (nonatomic) NSString *yearString;

- (void)toogleArrowImage;

@end
