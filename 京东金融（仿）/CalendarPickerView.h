//
//  CalendarPickerView.h
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/17.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionDelegate <NSObject>

- (void)didClickOKButton;
- (void)didClickCancelButton;

@end

@interface CalendarPickerView : UIView

@property (nonatomic) id<UIPickerViewDelegate> pickerViewDelegate;
@property (nonatomic) id<UIPickerViewDataSource> pickerViewDataSource;
@property (nonatomic) id<ActionDelegate>actionDelegate;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)reloadComponent:(NSInteger)component;

@end
