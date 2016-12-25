//
//  ChessCollectionView.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/17.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessCollectionViewCell.h"

@protocol WhichIsSelecitedProtocol <NSObject>

-(void)SelectedWithName:(NSString *)name
                 Attack:(NSString *)attack
                 Health:(NSString *)health;
-(void)SelecteNewChess;
-(void)ShowCardWithName:(NSString *)name;

@end

@interface ChessCollectionView : UICollectionView

+(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout delegate:(id<WhichIsSelecitedProtocol>)delegate2;
-(void)GetAttack:(NSString *)attack AndHealth:(NSString *)health;
-(BOOL)IsCHessChoose;


@end
