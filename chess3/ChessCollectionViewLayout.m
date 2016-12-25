//
//  ChessCollectionViewLayout.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/19.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "ChessCollectionViewLayout.h"

@implementation ChessCollectionViewLayout

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    return size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    if (indexPath.item < 5) {
        frame.origin.x         = indexPath.item*60;
        frame.origin.y         = 0;
        frame.size.width       = 30;
        frame.size.height      = 30;
        layoutAttributes.frame = frame;
    }
    if (indexPath.item < 7 &&indexPath.item > 4) {
        frame.origin.x         = indexPath.item*180-870;
        frame.origin.y         = 30;
        frame.size.width       = 30;
        frame.size.height      = 30;
        layoutAttributes.frame = frame;
    }
    if (indexPath.item > 6) {
        frame.origin.x         = indexPath.item*30-210;
        frame.origin.y         = 90;
        frame.size.width       = 30;
        frame.size.height      = 30;
        layoutAttributes.frame = frame;
    }
    
    return layoutAttributes;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 16; i++) {
        NSIndexPath *index                                 = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:index];
        [array addObject:layoutAttributes];
    }
    return array;
}
@end
