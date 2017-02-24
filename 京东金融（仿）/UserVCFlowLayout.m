//
//  UserVCFlowLayout.m
//  京东金融（仿）
//
//  Created by 李剑 on 16/10/14.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "UserVCFlowLayout.h"
#import "Macro.h"
#import "SeperatorDecorationView.h"

static CGFloat itemHeight = 87;

@implementation UserVCFlowLayout


static NSString * const seperatorViewKind = @"seperatorDecorationViewKind";

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.itemSize = CGSizeMake(kScreenWidth / 4, itemHeight);
		self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
		self.minimumLineSpacing = 0;
		self.minimumInteritemSpacing = 0;
		[self registerClass:[SeperatorDecorationView class] forDecorationViewOfKind:seperatorViewKind];
	}
	return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
	NSMutableArray *decorationAttributesArray = [[NSMutableArray alloc] init];
	for (UICollectionViewLayoutAttributes *attributes in attributesArray)
	{
		[decorationAttributesArray addObject:[self layoutAttributesForDecorationViewOfKind:seperatorViewKind atIndexPath:attributes.indexPath]];
	}
	return [attributesArray arrayByAddingObjectsFromArray:decorationAttributesArray];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];;
	if (elementKind == seperatorViewKind)
	{
		if (indexPath.section == 0 && indexPath.item != 0)
		{
			UICollectionViewLayoutAttributes *cellLayoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
			attributes.center = CGPointMake(cellLayoutAttributes.frame.origin.x, cellLayoutAttributes.center.y);
			attributes.size = CGSizeMake(1, cellLayoutAttributes.size.height * 0.4);
		}
	}
	return attributes;
}

@end
