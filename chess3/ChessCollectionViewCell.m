//
//  ChessCollectionViewCell.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/17.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "ChessCollectionViewCell.h"

@interface ChessCollectionViewCell ()

@property(nonatomic,strong)NSMutableDictionary *chessDic;
@property(nonatomic,strong)NSMutableArray *nameArray;

@end

@implementation ChessCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CAShapeLayer *shapelayer = [CAShapeLayer layer];
        shapelayer.path          = [[self getpath] CGPath];
        shapelayer.borderWidth   = 2.f;
        shapelayer.strokeColor   = [[UIColor blackColor]CGColor];
        shapelayer.fillColor     = [[UIColor clearColor]CGColor];
        [self.layer addSublayer:shapelayer];
//        self.layer.mask          = shapelayer;
//        self.layer.borderWidth   = 2.f;
//        self.layer.borderColor   = [[UIColor blackColor]CGColor];
        [self makeanameLabel];
    }
    return self;
}

-(void)makeanameLabel
{
    self.nameLabel               = [[UILabel alloc] initWithFrame:CGRectMake(6,5,18,18)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font          = [UIFont fontWithName:@"Libian" size:14];

    [self.contentView addSubview:self.nameLabel];
    
    self.attackLable                 = [[UILabel alloc] initWithFrame:CGRectMake(3, 20, 10, 10)];
    self.attackLable.backgroundColor = [UIColor clearColor];
    self.attackLable.textAlignment   = NSTextAlignmentCenter;
    self.attackLable.font            = [UIFont boldSystemFontOfSize:10];
    [self.contentView addSubview:self.attackLable];
    
    self.healthLable                 = [[UILabel alloc] initWithFrame:CGRectMake(17, 20, 10, 10)];
    self.healthLable.backgroundColor = [UIColor clearColor];
    self.healthLable.textAlignment   = NSTextAlignmentCenter;
    self.healthLable.font            = [UIFont boldSystemFontOfSize:10];
    [self.contentView addSubview:self.healthLable];

    
}

-(void)setName:(NSString *)name
{
    if (![name isEqualToString:_name]) {
        _name               = [name copy];
        self.nameLabel.text = _name;
    }
}

-(void)setAttack:(NSString *)attack
{
    if (![attack isEqualToString:_attack]) {
        _attack               = [attack copy];
        self.attackLable.text = _attack;
    }
}

-(void)setHealth:(NSString *)health
{
    if (![health isEqualToString:_health]) {
        _health               = [health copy];
        self.healthLable.text = _health;
    }
}

-(void)setT_ag:(NSString *)t_ag
{
    _t_ag = t_ag;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
}

-(UIBezierPath *)getpath
{
    float height = 12*fabs(sqrt(3));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(3, 30)];
    [path addLineToPoint:CGPointMake(3, height)];
    [path addArcWithCenter:CGPointMake(27, height) radius:24 startAngle:M_PI endAngle:(M_PI+acos(0.5)) clockwise:YES];
    [path addArcWithCenter:CGPointMake(3, height) radius:24 startAngle:(M_PI*2-acos(0.5)) endAngle:M_PI*0 clockwise:YES];
    [path addLineToPoint:CGPointMake(27, 30)];
    [path closePath];
    
    path.lineWidth = 1.5;
    UIColor *strokeColor = [UIColor blackColor];
    [strokeColor set];
    [path stroke];
    
    return path;
}


@end
