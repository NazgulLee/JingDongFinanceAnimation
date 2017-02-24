//
//  UserViewController.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/14.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "UserViewController.h"

#import "UserVCFlowLayout.h"
#import "CellForSection0.h"
#import "CellForSection1.h"
#import "UIView+FrameProcessor.h"
#import "Macro.h"

#import "CalendarViewController.h"

@interface UserViewController ()<UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@end

static NSString * const section0CellIdentifier = @"section0CellIdentifier";
static NSString * const section1CellIdentifier = @"section1CellIdentifier";
//extern CGFloat itemHeight;
//static CGFloat itemHeight = 87;//UserVCFlowLayout.m中定义，第一个section的高度
static CGFloat finalItemHeight = 32;//用户头像在navigationBar上的最终大小

@implementation UserViewController
{
	NSArray *titleArray;
	NSArray *detailTextArray;
	UIImageView *avatarImageView;
	CGFloat itemHeight;
	//NSArray *weekdayStrings;
	//Boolean isDragging;
	//CGFloat originYOfAvatarImageView;
}

- (instancetype)init
{
	self = [super initWithCollectionViewLayout:[[UserVCFlowLayout alloc] init]];

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	self.tabBarController.navigationController.navigationBar.translucent = NO;
//	self.tabBarController.navigationController.navigationBar.barTintColor = [UIColor redColor];
	
	titleArray = @[@"", @"95.6", @"低", @"去签到"];
	detailTextArray = @[@"", @"小白信用", @"我的保障", @"会员中心"];
//	weekdayStrings = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	itemHeight = ((UserVCFlowLayout *)self.collectionView.collectionViewLayout).itemSize.height;

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
	self.title = @"我";//设置 tabbar item显示的名字
	[self configureViews];
    // Register cell classes
    [self.collectionView registerClass:[CellForSection0 class] forCellWithReuseIdentifier:section0CellIdentifier];
	[self.collectionView registerClass:[CellForSection1 class] forCellWithReuseIdentifier:section1CellIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureViews
{
	UIView *bkView = [[UIView alloc] initWithFrame:self.view.bounds];
	bkView.backgroundColor = backgroundColorWhite;
	self.collectionView.backgroundView = bkView;
	
	UIView *leftItem = [[UIView alloc] init];
	avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
	[leftItem addSubview:avatarImageView];
	avatarImageView.frame = CGRectMake(0, itemHeight / 2, 45, 45);
	avatarImageView.clipsToBounds = YES;
	avatarImageView.layer.cornerRadius = avatarImageView.size.width / 2;
	
	self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];

	//NSLog(@"%@", NSStringFromCGRect([avatarImageView convertRect:avatarImageView.bounds toView:self.view]));
}

#pragma mark <UIScrollViewDelegate>
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//	
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
	//NSLog(@"offsetY: %f", offsetY);
	CGFloat scale = 1;
	if (offsetY < 0)
	{
		avatarImageView.y = itemHeight / 2 - offsetY;
		avatarImageView.transform = CGAffineTransformMakeScale(1, 1);
		avatarImageView.x = 0;
	}
	else
	{
		scale = MAX(finalItemHeight * 2 / itemHeight, 1 -  (1 - finalItemHeight * 2 / itemHeight) * offsetY / (itemHeight / 2 + finalItemHeight / 2));
		avatarImageView.transform = CGAffineTransformMakeScale(scale, scale);
		avatarImageView.y = MAX(- finalItemHeight / 2, itemHeight / 2 - offsetY);
		avatarImageView.x = 0;
		//NSLog(@"scale: %f", scale);
	}

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 15;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
	if (section == 0) return 4;
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 0)
	{
		CellForSection0 *cell = (CellForSection0 *)[collectionView dequeueReusableCellWithReuseIdentifier:section0CellIdentifier forIndexPath:indexPath];
		cell.title = titleArray[indexPath.item];
		cell.detailText = detailTextArray[indexPath.item];
		return cell;
	}
	
	if (indexPath.section == 1)
	{
		CellForSection1 *cell = (CellForSection1 *)[collectionView dequeueReusableCellWithReuseIdentifier:section1CellIdentifier forIndexPath:indexPath];
		return cell;
	}
	CellForSection0 *cell = (CellForSection0 *)[collectionView dequeueReusableCellWithReuseIdentifier:section0CellIdentifier forIndexPath:indexPath];

    return cell;
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

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize itemSize = ((UserVCFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
	if (indexPath.section != 0)
	{
		itemSize.width = kScreenWidth;
		itemSize.height = 60;
	}
	return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	UIEdgeInsets inset = ((UserVCFlowLayout *)self.collectionView.collectionViewLayout).sectionInset;
	if (section == 1) inset.bottom = 10;
	return inset;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1)
	{
		CalendarViewController *calendarVC = [[CalendarViewController alloc] init];
		calendarVC.edgesForExtendedLayout = UIRectEdgeNone;
//		UIViewController *vc = [[UIViewController alloc] init];
//		vc.view.backgroundColor = [UIColor whiteColor];
		[self.navigationController pushViewController:calendarVC animated:YES];
	}
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
