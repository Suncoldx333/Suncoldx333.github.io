//
//  ChessCollectionViewCell.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/17.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChessCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)  UILabel *nameLabel;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong)  UILabel *attackLable;
@property(nonatomic,strong)  UILabel *healthLable;
@property(nonatomic,strong) NSString *attack;
@property(nonatomic,strong) NSString *health;
@property(nonatomic,strong) NSString *t_ag;

@end
