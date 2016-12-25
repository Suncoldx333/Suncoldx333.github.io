//
//  ChessView.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "ChessView.h"
#import "StepView.h"
#import "GameboardView.h"
#import <UIKit/UIKit.h>
#import <string.h>

@interface ChessView ()

@property (nonatomic, readonly) UIColor *defaultBackgroundColor;
@property (nonatomic, readonly) UIColor *defaultNumberColor;
@property (nonatomic, strong)   UILabel *nameLabel;
@property (nonatomic,strong)    UILabel *attackLabel;
@property (nonatomic,strong)    UILabel *healthLabel;
@property (nonatomic,strong)   NSString *attack_value;
@property (nonatomic,strong)   NSString *health_value;
@property(nonatomic)            CGFloat cornerRadius;
@property (nonatomic)          NSString *value;
@property(nonatomic,strong)    NSString *whatischesscolor;
@property (nonatomic, weak) id<chessViewProtocol> delegate;

@end

@implementation ChessView

+ (instancetype)ChessForPosition:(CGPoint)position
                      sideLength:(CGFloat)side
                    cornerRadius:(CGFloat)cornerRadius
                           value:(NSString *)value
                          attack:(NSString *)attack
                          health:(NSString *)health
                      ChessColor:(NSString *)chesscolor
                         withTag:(NSInteger)tag
                        delegate:(id<chessViewProtocol>)delegate{
    ChessView *tile = [[[self class] alloc] initWithFrame:CGRectMake(position.x,
                                                                     position.y,
                                                                     side,
                                                                    side)];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.path = [[tile getpath] CGPath];
//    tile.layer.mask = shapelayer;
    shapelayer.borderWidth   = 2.f;
    shapelayer.strokeColor   = [[UIColor blackColor]CGColor];
    shapelayer.fillColor     = [[UIColor clearColor]CGColor];
    [tile.layer addSublayer:shapelayer];
    
    tile.delegate    = delegate;
    tile.tileValue   = value;
    tile.attackValue = attack;
    tile.healthValue = health;

    tile.position         = position;
    tile.whatischesscolor = chesscolor;
    tile.backgroundColor  = tile.defaultBackgroundColor;
    if ([chesscolor isEqualToString:@"B"]) {
        tile.nameLabel.textColor = [UIColor blackColor];
    }else
    {
        tile.nameLabel.textColor = [UIColor redColor];
    }
//    tile.layer.cornerRadius = cornerRadius ;
    tile.value        = value;
    tile.attack_value = attack;
    tile.health_value = health;
    
    tile.tag = tag;
    [tile setChessMove];
    return tile;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.nameLabel               = [[UILabel alloc] initWithFrame:CGRectMake(6,5,18,18)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.attackLabel.font        = [UIFont fontWithName:@"Libian" size:16];
    [self addSubview:self.nameLabel];
    
    self.attackLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(3, 20, 10, 10)];
    self.attackLabel.backgroundColor = [UIColor clearColor];
    self.attackLabel.textAlignment   = NSTextAlignmentCenter;
    self.attackLabel.font            = [UIFont boldSystemFontOfSize:10];
    [self addSubview:self.attackLabel];
    
    self.healthLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(17, 20, 10, 10)];
    self.healthLabel.backgroundColor = [UIColor clearColor];
    self.healthLabel.textAlignment   = NSTextAlignmentCenter;
    self.healthLabel.font            = [UIFont boldSystemFontOfSize:10];
    [self addSubview:self.healthLabel];
    
    return self;
}

-(UIBezierPath *)getpath
{
    float height       = 12*fabs(sqrt(3));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(3, 30)];
    [path addLineToPoint:CGPointMake(3, height)];
    [path addArcWithCenter:CGPointMake(27, height) radius:24 startAngle:M_PI endAngle:(M_PI+acos(0.5)) clockwise:YES];
    [path addArcWithCenter:CGPointMake(3, height) radius:24 startAngle:(M_PI*2-acos(0.5)) endAngle:M_PI*0 clockwise:YES];
    [path addLineToPoint:CGPointMake(27, 30)];
    [path closePath];
    return path;
}

- (void)setTileValue:(NSString *)tileValue {
    _tileValue          = tileValue;
    self.nameLabel.text = tileValue;
    self.value          = tileValue;
}

-(void)setAttackValue:(NSString *)attackValue
{
    _attackValue          = attackValue;
    self.attackLabel.text = attackValue;
    self.attack_value     = attackValue;
}

-(void)setHealthValue:(NSString *)healthValue
{
    _healthValue          = healthValue;
    self.healthLabel.text = healthValue;
    self.health_value     = healthValue;
}

- (void)setPosition:(CGPoint)position{
    _position  = position;
}
- (UIColor *)defaultBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)defaultNumberColor {
    return [UIColor blackColor];
}

-(void)setChessMove
{
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touched)];
    tapgesture.delegate = self;
    [self addGestureRecognizer:tapgesture];
    
}

-(void)touched
{
    
    BOOL IsAnyStepHere      = NO;
    IsAnyStepHere           = [self.delegate IsAnyStepHere];
    
    NSMutableArray *message = [[NSMutableArray alloc]init];
    NSString *value = self.value;
    [message addObject:value];
    NSString *x = [NSString stringWithFormat:@"%f",self.frame.origin.x];
    [message addObject:x];
    NSString *y = [NSString stringWithFormat:@"%f",self.frame.origin.y];
    [message addObject:y];
    NSNumber *tag = [NSNumber numberWithInteger:self.tag];
    NSNumberFormatter *tag1 = [NSNumberFormatter alloc];
    NSString *tag2 = [tag1 stringFromNumber:tag];
    [message addObject:tag2];
    NSString *color ;
    UIColor *chesscolor = self.nameLabel.textColor;
    if (chesscolor == [UIColor blackColor]) {
        color = @"B";
    }else
    {
        color =@"R";
    }
    [message addObject:color];
    NSString *attack = self.attack_value;
    [message addObject:attack];
    NSString *health = self.health_value;
    [message addObject:health];
    NSArray *path_Turn           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_Turn         = [path_Turn objectAtIndex:0];
    NSString *filename_Turn      = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
    NSMutableDictionary *turnDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Turn];
    
    NSString *turn = [turnDic objectForKey:@"turn"];
    if ([turn isEqualToString:@"YES"]) {
        if ([color isEqualToString:@"R"]) {
            if (!IsAnyStepHere) {
                [self.delegate WhereCanChessGo123:CGPointMake(self.frame.origin.x, self.frame.origin.y) withMessage:message];
            }else if([self.delegate IsStillTheChess:self.tag])
            {
                [self.delegate RemoveAllStep];
                
            }else
            {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"走错啦" message:@"请走蓝色位置" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
    }

    return;
}
@end
