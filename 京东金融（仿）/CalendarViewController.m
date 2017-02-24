//
//  CalendarViewController.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/15.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "CalendarViewController.h"

#import "CalendarPageViewController.h"
#import "CalendarVC.h"

#import "DateCollectionViewCell.h"
#import "SectionHeaderView.h"
#import "SectionFooterView.h"
#import "CalendarLeftItemView.h"
#import "CalendarPickerView.h"

#import "WeekInfoParser.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

@interface CalendarViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ActionDelegate>

//@property (nonatomic) UITableView *tableView;
@property (nonatomic)UICollectionView *collectionView;
@property (nonatomic)NSArray *dateComponentsArray;
@property (nonatomic)CalendarPageViewController *calendarPageVC;
@property CGFloat originalCenterYOfCollectionView;
@property (nonatomic)UIBarButtonItem *calendarLeftBarItem;
@property (nonatomic)CalendarPickerView *calendarPickerView;
@property (nonatomic)UIButton *obscureButtonView;

@end

static NSString * const DateCollectionViewCellIdentifier = @"DateCollectionViewCellIdentifier";
static NSString * const HeaderIdentifier = @"HeaderIdentifier";
static NSString * const FooterIdentifier = @"FooterIdentifier";

@implementation CalendarViewController
{

	NSArray *weekdayString;
	BOOL shouldScrollToNextPage;
	BOOL shouldScrollToLastPage;
	BOOL isCalendarPickerViewShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	weekdayString = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	shouldScrollToLastPage = NO;
	shouldScrollToNextPage = NO;
	isCalendarPickerViewShown = NO;
	
	[self configureViews];
	
	self.navigationItem.leftItemsSupplementBackButton = YES;
	self.navigationItem.leftBarButtonItem = self.calendarLeftBarItem;
	
	[self.collectionView registerClass:[DateCollectionViewCell class] forCellWithReuseIdentifier:DateCollectionViewCellIdentifier];
	[self.collectionView registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
	[self.collectionView registerClass:[SectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
	
}

- (void)configureViews
{
	self.view.backgroundColor = backgroundColorWhite;
	self.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:[NSDate date]];
	//[self refreshCalendarLeftBarItem];
	
	[self addChildViewController:self.calendarPageVC];
	//NSLog(@"%f", kScreenHeight);
	self.calendarPageVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 140.0 / 568);
	NSLog(@"%s, %@", __FUNCTION__, NSStringFromCGRect(self.calendarPageVC.view.frame));
	[self.view addSubview:self.calendarPageVC.view];
	[self.calendarPageVC didMoveToParentViewController:self];
	[self setupCalendarPageVCWithDate:[NSDate date]];
//	CalendarVC *vc = [[CalendarVC alloc] init];
//	vc.daysArray = [WeekInfoParser daysArrayForDate:[NSDate date]];
//	vc.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:[NSDate date]];
//	vc.pageIndex = 0;
//	vc.mDate = [NSDate date];
//	[self.calendarPageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	
	[self.view addSubview:self.collectionView];
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.calendarPageVC.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.originalCenterYOfCollectionView = self.collectionView.centerY;
	//NSLog(@"%s, %f", __FUNCTION__, self.originalCenterYOfCollectionView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	return [self nextPageViewController:viewController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	return [self lastPageViewController:viewController];
}

- (UIViewController *)nextPageViewController:(UIViewController *)viewController
{
	CalendarVC *presentVC = (CalendarVC *)viewController;
	NSInteger index = presentVC.pageIndex;
	NSDate *newDate = [self mDateOfWeekOffset:1 byDate:presentVC.mDate];
	CalendarVC *calendarVC = [[CalendarVC alloc] init];
	calendarVC.pageIndex = index + 1;
	calendarVC.mDate = newDate;
	calendarVC.daysArray = [WeekInfoParser daysArrayForDate:newDate];
	calendarVC.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:newDate];
	
	return calendarVC;
}

- (UIViewController *)lastPageViewController:(UIViewController *)viewController
{
	CalendarVC *presentVC = (CalendarVC *)viewController;
	NSInteger index = presentVC.pageIndex;
	NSDate *newDate = [self mDateOfWeekOffset:-1 byDate:presentVC.mDate];
	CalendarVC *calendarVC = [[CalendarVC alloc] init];
	calendarVC.pageIndex = index - 1;
	calendarVC.mDate = newDate;
	calendarVC.daysArray = [WeekInfoParser daysArrayForDate:newDate];
	calendarVC.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:newDate];

	return calendarVC;
}

- (NSDate *)mDateOfWeekOffset: (NSInteger)offset byDate: (NSDate *)date
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	calendar.locale = [NSLocale currentLocale];
	calendar.timeZone = [NSTimeZone localTimeZone];
	NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:7 * offset toDate:date options:NSCalendarMatchStrictly];
	return newDate;
}


- (NSInteger)dayOfDate: (NSDate *)date
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	calendar.locale = [NSLocale currentLocale];
	calendar.timeZone = [NSTimeZone localTimeZone];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components = [calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
	
	 return components.day;
}
- (NSInteger)dayOfDaysOffset: (NSInteger)offset byDate: (NSDate *)date
{
//	NSDate *date = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	calendar.locale = [NSLocale currentLocale];
	calendar.timeZone = [NSTimeZone localTimeZone];
	NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:offset toDate:date options:NSCalendarMatchStrictly];
	//@{[NSNumber numberWithUnsignedInteger:NSCalendarWrapComponents]: @NO}
	//NSDate *date = [NSDate dateWithTimeInterval:86400 * offset sinceDate:[NSDate date]];
	return [self dayOfDate:newDate];
}



#pragma UIPageViewControllerDelegte

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
	if (completed)
	{
		CalendarVC *previousCalendarVC = (CalendarVC *)previousViewControllers[0];
		CalendarVC *currentCalendarVC = (CalendarVC *)pageViewController.viewControllers[0];
		self.dateComponentsArray = currentCalendarVC.dateComponentsArray;
		
		//[self refreshCalendarLeftBarItem];
		
		if (previousCalendarVC.pageIndex < currentCalendarVC.pageIndex)
		{
			[UIView animateWithDuration:0.5 animations:^{
				self.collectionView.centerX = self.view.centerX - self.view.size.width;
			}completion:^(BOOL finished){
				self.collectionView.centerX = self.view.centerX;
				[self.collectionView reloadData];
			}];
		}
		else
		{
			//self.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:previousCalendarVC.mDate byWeekOffset:-1];
			[UIView animateWithDuration:0.5 animations:^{
				self.collectionView.centerX = self.view.centerX + self.view.size.width;
			}completion:^(BOOL finished){
				self.collectionView.centerX = self.view.centerX;
				[self.collectionView reloadData];
			}];
		}

	}
	
}

#pragma mark Accessor Methods
- (UICollectionView *)collectionView
{
	if (_collectionView == nil)
	{
		
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight * 60.0 / 568);
		flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
		flowLayout.minimumInteritemSpacing = 0;
		flowLayout.minimumLineSpacing = 10;
		CGFloat labelHeight = 50;
		flowLayout.headerReferenceSize = CGSizeMake(self.view.size.width, labelHeight);
		flowLayout.footerReferenceSize = CGSizeMake(self.view.size.width, labelHeight);
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
		_collectionView.backgroundColor = backgroundColorWhite;
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.contentInset = UIEdgeInsetsMake(-labelHeight, 0, -labelHeight, 0);
		_collectionView.layer.zPosition = -1;
		//_collectionView.collectionViewLayout = flowLayout;
	}
	return _collectionView;
}

- (CalendarPageViewController *)calendarPageVC
{
	if (_calendarPageVC == nil)
	{
		_calendarPageVC = [[CalendarPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
		_calendarPageVC.delegate = self;
		_calendarPageVC.dataSource = self;
	}
	
	return _calendarPageVC;
}

- (UIBarButtonItem *)calendarLeftBarItem
{
	if (_calendarLeftBarItem == nil)
	{
		CalendarLeftItemView *itemButton = [[CalendarLeftItemView alloc] init];
//		itemButton.yearString = @"2016";
//		itemButton.monthString = @"10月";
		CGSize mSize = itemButton.size;
		itemButton.frame = CGRectMake(-mSize.width / 2, -mSize.height / 2, mSize.width, mSize.height);
		[itemButton addTarget:self action:@selector(didClickCalendarLeftBarItem:) forControlEvents:UIControlEventTouchUpInside];
		_calendarLeftBarItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
	}
	
	return _calendarLeftBarItem;
}

- (CalendarPickerView *)calendarPickerView
{
	if (_calendarPickerView == nil)
	{
		_calendarPickerView = [[CalendarPickerView alloc] init];
		_calendarPickerView.size = CGSizeMake(kScreenWidth, 0.5 * kScreenHeight);
		_calendarPickerView.center = CGPointMake(kScreenWidth / 2, -_calendarPickerView.size.height / 2);
		_calendarPickerView.pickerViewDelegate = self;
		_calendarPickerView.pickerViewDataSource = self;
		_calendarPickerView.actionDelegate = self;
		_calendarPickerView.layer.zPosition = 10;
		[self.view addSubview:_calendarPickerView];
	}
	
	return _calendarPickerView;
}

- (UIView *)obscureButtonView
{
	if (_obscureButtonView == nil)
	{
		_obscureButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
		_obscureButtonView.backgroundColor = [UIColor blackColor];
		_obscureButtonView.alpha = 0;
		[_obscureButtonView addTarget:self action:@selector(hideCalendarPickerView) forControlEvents:UIControlEventTouchUpInside];
		_obscureButtonView.frame = self.view.bounds;
		[self.view addSubview:_obscureButtonView];
		//_obscureView.layer.zPosition = 1;
	}
	
	return _obscureButtonView;
}

- (void)setDateComponentsArray:(NSArray *)dateComponentsArray
{
	_dateComponentsArray = dateComponentsArray;
	[self refreshCalendarLeftBarItem];
}



#pragma UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DateCollectionViewCellIdentifier forIndexPath:indexPath];
	NSDateComponents *components = (NSDateComponents *)self.dateComponentsArray[indexPath.item];
	cell.day = [NSString stringWithFormat:@"%ld", components.day];
	cell.weekday = weekdayString[components.weekday - 1];
	cell.yearAndMonth = [NSString stringWithFormat:@"%ld年%ld月", components.year, components.month];
	
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		if (kind == UICollectionElementKindSectionHeader)
		{
			SectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
			headerView.tag = 1001;
			return headerView;
		}
		if (kind == UICollectionElementKindSectionFooter)
		{
			SectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
			footerView.tag = 1002;
			return footerView;
		}
	}
	return nil;
	
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	UILabel *headerViewTipLabel = ((SectionHeaderView *)[self.collectionView viewWithTag:1001]).tipLabel;
	UILabel *footerViewTipLabel = ((SectionFooterView *)[self.collectionView viewWithTag:1002]).tipLabel;
	CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
	//NSLog(@"%f", offsetY);
	if (offsetY < -50)
	{
		//NSLog(@"%s offsetY < -60", __FUNCTION__);
		headerViewTipLabel.text = @"松手查看上一周";
		shouldScrollToLastPage = YES;
		shouldScrollToNextPage = NO;//不能同为yes
	}
	else
	{
		shouldScrollToLastPage = NO;
		headerViewTipLabel.text = @"下拉查看上一周";
		if (offsetY > 120)
		{
			//NSLog(@"%s offsetY > 550", __FUNCTION__);
			footerViewTipLabel.text = @"松手查看下一周";
			shouldScrollToNextPage = YES;
		}
		else
		{
			footerViewTipLabel.text = @"上拉查看上一周";
			shouldScrollToNextPage = NO;
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	//CGPoint offset = scrollView.contentOffset;
	if (shouldScrollToNextPage)
	{
		
		CalendarVC *nextCalendarVC = (CalendarVC *)[self nextPageViewController:self.calendarPageVC.viewControllers[0]];
		self.dateComponentsArray = nextCalendarVC.dateComponentsArray;

		[self.calendarPageVC setViewControllers:@[nextCalendarVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){
			shouldScrollToNextPage = NO;
		}];
		[self.collectionView viewWithTag:1002].hidden = YES;
		__weak typeof (self) weakSelf = self;
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			__strong typeof(self) strongSelf = weakSelf;
			strongSelf.collectionView.centerY = strongSelf.originalCenterYOfCollectionView - kScreenHeight;
		} completion:^(BOOL finished){
			if (finished)
			{
				__strong typeof(self) strongSelf = weakSelf;
				
				[strongSelf.collectionView reloadData];
				strongSelf.collectionView.contentOffset = CGPointMake(0, 122);
				[NSThread sleepForTimeInterval:0.2];
				strongSelf.collectionView.centerY = strongSelf.originalCenterYOfCollectionView;
				
			}
		}];
	}
	if (shouldScrollToLastPage)
	{
		//scrollView.contentOffset = offset;
		CalendarVC *lastCalendarVC = (CalendarVC *)[self lastPageViewController:self.calendarPageVC.viewControllers[0]];
		self.dateComponentsArray = lastCalendarVC.dateComponentsArray;
		//[self refreshCalendarLeftBarItem];
		
		[self.calendarPageVC setViewControllers:@[lastCalendarVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished){
			shouldScrollToLastPage = NO;
		}];
		[self.collectionView viewWithTag:1001].hidden = YES;
		__weak typeof (self) weakSelf = self;
		//__strong typeof(self) strongSelf = weakSelf;
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			__strong typeof(self) strongSelf = weakSelf;
			strongSelf.collectionView.centerY = strongSelf.originalCenterYOfCollectionView + strongSelf.collectionView.size.height;
		} completion:^(BOOL finished){
			if (finished)
			{
				__strong typeof(self) strongSelf = weakSelf;
				
				[strongSelf.collectionView reloadData];
				strongSelf.collectionView.contentOffset = CGPointMake(0, 50);
				[NSThread sleepForTimeInterval:0.2];
				strongSelf.collectionView.centerY = strongSelf.originalCenterYOfCollectionView;
				
			}
		}];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.collectionView viewWithTag:1001].hidden = NO;
	[self.collectionView viewWithTag:1002].hidden = NO;
}

#pragma mark Calendar picker
- (void)didClickCalendarLeftBarItem:(id)sender
{
	
	
	if (isCalendarPickerViewShown)
	{
		[self hideCalendarPickerView];
	}
	else
	{
		[self showCalendarPickerView];
	}
}

- (void)setupCalendarPickerView
{
	NSDateComponents *currentComponents = [self currentDateComponents];
	NSInteger currentYear = currentComponents.year;
	NSInteger currentMonth = currentComponents.month;
	
	NSDateComponents *selectedComponents = (NSDateComponents *)self.dateComponentsArray[6];
	NSInteger selectedYear = selectedComponents.year;
	NSInteger selectedMonth = selectedComponents.month;
	[self.calendarPickerView selectRow:selectedYear - currentYear inComponent:0 animated:NO];
	if (selectedYear != currentYear)
	{
		[self.calendarPickerView reloadComponent:1];
		[self.calendarPickerView selectRow:selectedMonth - 1 inComponent:1 animated:NO];
	}
	else
	{
		[self.calendarPickerView selectRow:selectedMonth - currentMonth inComponent:1 animated:NO];
	}
}

- (void)showCalendarPickerView
{
	self.obscureButtonView.hidden = NO;
	[self setupCalendarPickerView];
	
	[self toogleCalendarLeftItem];
	[UIView animateWithDuration:0.3 animations:^{
		self.calendarPickerView.centerY = self.calendarPickerView.size.height / 2;
		self.obscureButtonView.alpha = 0.8;
	}completion:^(BOOL finished){
		if (finished)
		{
			isCalendarPickerViewShown = YES;
		}
	}];
	
}

- (void)hideCalendarPickerView
{
	[self toogleCalendarLeftItem];
	[UIView animateWithDuration:0.3 animations:^{
		self.calendarPickerView.centerY = -self.calendarPickerView.size.height / 2;
		self.obscureButtonView.alpha = 0;
	}completion:^(BOOL finished){
		if (finished)
		{
			self.obscureButtonView.hidden = YES;
			isCalendarPickerViewShown = NO;
		}
	}];
	
}

- (void)refreshCalendarLeftBarItem
{
	NSDateComponents *maxComponents = (NSDateComponents *)self.dateComponentsArray[6];
	NSInteger month = maxComponents.month;
	NSInteger year = maxComponents.year;
//	CalendarLeftItemView *leftItem = (CalendarLeftItemView *)self.calendarLeftBarItem.customView;
//	leftItem.monthString = [NSString stringWithFormat:@"%ld月", month];
//	leftItem.yearString = [NSString stringWithFormat:@"%ld", year];
	[self updateCalendarLeftBarItemWithMonth:month andYear:year];
}

- (void)updateCalendarLeftBarItemWithMonth:(NSInteger)month andYear:(NSInteger)year
{
	CalendarLeftItemView *leftItem = (CalendarLeftItemView *)self.calendarLeftBarItem.customView;
	leftItem.monthString = [NSString stringWithFormat:@"%ld月", month];
	leftItem.yearString = [NSString stringWithFormat:@"%ld", year];
}

- (void)toogleCalendarLeftItem
{
	CalendarLeftItemView *leftItem = (CalendarLeftItemView *)self.calendarLeftBarItem.customView;
	[leftItem toogleArrowImage];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0) return 3;
	else if ([pickerView selectedRowInComponent:0] == 0) return 12 - [self currentDateComponents].month + 1;
	return 12;
}

- (NSDateComponents *)currentDateComponents
{
	NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
	NSDate *date = [NSDate date];
	return [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
}


#pragma mark UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return kScreenWidth / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return kScreenHeight * 44.0 / 568;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0) return [NSString stringWithFormat:@"%ld年", [self currentDateComponents].year + row];
	else if ([pickerView selectedRowInComponent:0] == 0) return [NSString stringWithFormat:@"%ld月", [self currentDateComponents].month + row];
	return [NSString stringWithFormat:@"%ld月", row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0) [pickerView reloadComponent:1];
}

#pragma mark ActionDelegate
- (void)didClickOKButton
{
	NSLog(@"didClickOKButton");
	NSDateComponents *currentComponents = [self currentDateComponents];
	NSInteger currentYear = currentComponents.year;
	NSInteger currentMonth = currentComponents.month;
	
	NSInteger selectedYear = [self.calendarPickerView selectedRowInComponent:0] + currentYear;
	NSInteger selectedMonth;
	if (currentYear == selectedYear) selectedMonth = currentMonth + [self.calendarPickerView selectedRowInComponent:1];
	else selectedMonth = 1 + [self.calendarPickerView selectedRowInComponent:1];
	[self updateCalendarLeftBarItemWithMonth:selectedMonth andYear:selectedYear];

	
	[self hideCalendarPickerView];
	
	NSDateComponents *newComponents = [[NSDateComponents alloc] init];
	[newComponents setDay:1];
	[newComponents setMonth:selectedMonth];
	[newComponents setYear:selectedYear];
	NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
	NSDate *newDate = [calendar dateFromComponents:newComponents];
	self.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:newDate];
	[self.collectionView reloadData];
	[self setupCalendarPageVCWithDate:newDate];
}

- (void)didClickCancelButton
{
	NSLog(@"didClickCancelButton");
	[self hideCalendarPickerView];
}

- (void)setupCalendarPageVCWithDate:(NSDate *)date
{
	CalendarVC *vc = [[CalendarVC alloc] init];
	vc.daysArray = [WeekInfoParser daysArrayForDate:date];
	vc.dateComponentsArray = [WeekInfoParser dateComponentsArrayForDate:[NSDate date]];
	vc.pageIndex = 0;
	vc.mDate = date;
	[self.calendarPageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


//- (UITableView *)tableView
//{
//	if (_tableView == nil)
//	{
//		_tableView = [[UITableView alloc] init];
//		_tableView.dataSource = self;
//		_tableView.delegate = self;
//
//	}
//	return _tableView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
