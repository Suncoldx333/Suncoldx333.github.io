//
//  GameboardView.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "GameboardView.h"
#import "ChessView.h"
#import "StepView.h"
#import "BerserkerMoveMode.h"
#import "RiderMoveMode.h"
#import "CasterMoveMode.h"
#import "AssassinMoveMode.h"
#import "ArcherMoveMode.h"
#import "LancerMoveMode.h"
#import "SaberMoveMode.h"

@interface GameboardView ()<chessViewProtocol,wheredidIpressedProtocol>

@property(nonatomic,weak) id<HowChessGoProtocol> delegate;
@property (nonatomic)                NSUInteger dimension;
@property (nonatomic)                   CGFloat tileSideLength;
@property (nonatomic)                   CGFloat padding;
@property (nonatomic)                   CGFloat cornerRadius;
@property(nonatomic,strong) NSMutableDictionary *chessDic;
@property(nonatomic,strong)      NSMutableArray *chess_message;
@property(nonatomic,strong)      NSMutableArray *final_message;
@property(nonatomic,strong)      NSMutableArray *initial_message;
@property(nonatomic,strong)      NSMutableArray *post_message;
@property(nonatomic,strong)      NSMutableArray *tag_array;
@property(nonatomic,strong)      NSMutableArray *step_tag_array;
@property(nonatomic,strong)      NSMutableArray *step_tag_array2;
@property(nonatomic)                    CGFloat fight_count;
@property(nonatomic,strong)            NSString *result;
@property(nonatomic,strong)            NSString *initial_position;
@property(nonatomic,strong)            NSString *final_position;

@end

@implementation GameboardView

+(instancetype)gameboardWithDimension:(NSUInteger)dimension
                            cellWidth:(CGFloat)width
                          cellPadding:(CGFloat)padding
                         cornerRadius:(CGFloat)cornerRadius
                      backgroundColor:(UIColor *)backgroundColor
                      foregroundColor:(UIColor *)foregroundColor
                             delegate:(id<HowChessGoProtocol>)delegate
{
    GameboardView *view = [[[self class] alloc] initWithFrame:CGRectMake(0,0,270,400)];
    view.delegate     = delegate;
    view.dimension    = dimension;
    view.padding      = padding;
    view.cornerRadius = cornerRadius;
    [view setupbackgroundColor:backgroundColor foregroundcolor:foregroundColor];
    [view PlistInit];
    view.fight_count = 32.f;
    return view;
}

-(void)PlistInit
{
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chessDic      = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
}

-(void)setupbackgroundColor:(UIColor *)background foregroundcolor:(UIColor *)foreground
{
    self.backgroundColor = background;
    return;
}

- (void)insertChessAtIndexPath:(CGPoint)path
                     withValue:(NSString *)value
                    withattack:(NSString *)attack
                    withhealth:(NSString *)health
                     withColor:(NSString *)color
                       withTag:(NSInteger)t_ag;

{
        ChessView *chess =[ChessView ChessForPosition:path
                                           sideLength:30
                                         cornerRadius:self.cornerRadius
                                                value:value
                                               attack:attack
                                               health:health
                                           ChessColor:color
                                              withTag:t_ag
                                             delegate:self] ;
        [self addSubview:chess];
}


-(BOOL)IsAnyStepHere
{
    BOOL IsAnyStepHere = YES;
    if ([self.step_tag_array count] == 0) {
        IsAnyStepHere = NO;
    }
    return IsAnyStepHere;
}

-(BOOL)IsStillTheChess:(NSUInteger)tag
{
    BOOL IsStillTheChess    = NO;
    NSUInteger tag_before   = [[self.chess_message objectAtIndex:3] integerValue];
    NSNumber *number_before = [NSNumber numberWithInteger:tag_before];
    NSNumber *number        = [NSNumber numberWithInteger:tag];
    if ([number isEqualToNumber:number_before]) {
        IsStillTheChess = YES;
    }
    return IsStillTheChess;
}

-(void)RemoveAllStep
{
    for (int i = 0; i<[self.step_tag_array count]; i++) {
        NSUInteger step_tag = [self.step_tag_array[i] integerValue];
        UIView *step        = (UIView *)[self viewWithTag:step_tag];
        [step removeFromSuperview];
    }
    [self.step_tag_array removeAllObjects];
}

//前期书写不规范，随便取的名字，与后面有个方法的名字类似，需注意
-(void)WhereCanChessGo123:(CGPoint)position withMessage:(NSArray *)message
{

    CGFloat x_init        = [message[1] floatValue];
    CGFloat y_init        = [message[2] floatValue];
    CGPoint position_init = CGPointMake(x_init, y_init);
    self.initial_position = [self GetPositionInString:position_init];
//    [self.initial_message addObject:[self GetPositionInString:position_init]];
    

    self.chess_message  = [[NSMutableArray alloc] initWithArray:message];
    self.step_tag_array = [[NSMutableArray alloc]init];
    self.tag_array      = [[NSMutableArray alloc]init];
    
    NSUInteger step_tag  = 400;
    NSUInteger tag       = [[message objectAtIndex:3] integerValue];
    NSNumber *number     = [NSNumber numberWithInteger:tag];
    NSString *value      = [message objectAtIndex:0];
    NSString *chesscolor = [message objectAtIndex:4];
    
    [self.tag_array addObject:number];

    if ([value isEqualToString:@"車"]) {
        BerserkerMoveMode *berserker = [BerserkerMoveMode BerserkerCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *berserker_array =  [berserker HowBerserkerGo:position];
        
        for (int i = 0; i<[berserker_array  count]; i++) {
            if (![berserker_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[berserker_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[berserker_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [berserker_array count]-1; i<=[berserker_array  count]; i--) {
            if (![berserker_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[berserker_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[berserker_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    
    if ([value isEqualToString:@"帅"]) {
        SaberMoveMode *saber = [SaberMoveMode SaberCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *saber_array =  [saber HowSaberGo:position];
        
        for (int i = 0; i<[saber_array  count]; i++) {
            if (![saber_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[saber_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[saber_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [saber_array count]-1; i<=[saber_array count]; i--) {
            if (![saber_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[saber_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[saber_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    
    if ([value isEqualToString:@"马"]) {
        RiderMoveMode *rider = [RiderMoveMode RiderCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *rider_array = [rider HowRiderGo:position];
        
        for (int i = 0; i<[rider_array  count]; i++) {
            if (![rider_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[rider_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[rider_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [rider_array count]-1; i<=[rider_array  count]; i--) {
            if (![rider_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[rider_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[rider_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    if ([value isEqualToString:@"相"]) {
        CasterMoveMode *caster = [CasterMoveMode CasterCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *caster_array = [caster HowCasterGo:position];
        
        for (int i = 0; i<[caster_array  count]; i++) {
            if (![caster_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[caster_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[caster_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [caster_array count]-1; i<=[caster_array  count]; i--) {
            if (![caster_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[caster_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[caster_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    if ([value isEqualToString:@"炮"]) {
        ArcherMoveMode *archer = [ArcherMoveMode ArcherCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *archer_array = [archer HowArcherGo:position];
        
        for (int i = 0; i<[archer_array  count]; i++) {
            if (![archer_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[archer_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[archer_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [archer_array count]-1; i<=[archer_array  count]; i--) {
            if (![archer_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[archer_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[archer_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    
    if ([value isEqualToString:@"兵"]) {
        LancerMoveMode *lancer = [LancerMoveMode LancerCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *lancer_array = [lancer HowLancerGo:position];
        
        for (int i = 0; i<[lancer_array  count]; i++) {
            if (![lancer_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[lancer_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[lancer_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [lancer_array count]-1; i<=[lancer_array  count]; i--) {
            if (![lancer_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[lancer_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[lancer_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    
    if ([value isEqualToString:@"仕"]) {
        AssassinMoveMode *assassin = [AssassinMoveMode AssassinCameFrom:position withTag:tag withColor:chesscolor];
        NSMutableArray *assassin_array = [assassin HowAssassinGo:position];
        
        for (int i = 0; i<[assassin_array  count]; i++) {
            if (![assassin_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x            = [[assassin_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y            = [[assassin_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint position_now = CGPointMake(x, y);
                [self WhereCanChessGo:position_now withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
        for (NSUInteger i = [assassin_array count]-1; i<=[assassin_array  count]; i--) {
            if (![assassin_array[i] isEqualToString:@"enemy:"]) {
                CGFloat x              = [[assassin_array[i] substringWithRange:NSMakeRange(0, 3)] floatValue];
                CGFloat y              = [[assassin_array[i] substringWithRange:NSMakeRange(3, 3)] floatValue];
                CGPoint enemy_position = CGPointMake(x, y);
                [self WhereCanEnemyGo:enemy_position withTag:step_tag];
                step_tag++;
            }
            else
            {
                break;
            }
        }
        
    }
    
}

-(void)WhereCanEnemyGo:(CGPoint)position withTag:(NSUInteger)tag

{
    
    NSNumber *number = [NSNumber numberWithInteger:tag];
    [self.step_tag_array addObject:number];
    StepView *step = [StepView chessforposion:position
                                   sidelength:30
                                 cornerRadius:15
                                        value:@""
                                   chesscolor:[UIColor blueColor]
                                      withTag:tag
                                     delegate:self];
    step.alpha = 0.5;
    [self addSubview:step];
    [UIView animateWithDuration:0.18
                          delay:0.05
                        options:0
                     animations:^{step.layer.affineTransform = CGAffineTransformMakeScale(1.1, 1.1);}
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.08 animations:^{
                             step.layer.affineTransform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                         }];
                     }];
}

-(void)WhereCanChessGo:(CGPoint)position withTag:(NSUInteger)tag

{
    
    NSNumber *number = [NSNumber numberWithInteger:tag];
    [self.step_tag_array addObject:number];
    StepView *step = [StepView chessforposion:position
                                   sidelength:30
                                 cornerRadius:15
                                        value:@"X"
                                   chesscolor:[UIColor blueColor]
                                      withTag:tag
                                     delegate:self];
    [self addSubview:step];
    [UIView animateWithDuration:0.18
                          delay:0.05
                        options:0
                     animations:^{step.layer.affineTransform = CGAffineTransformMakeScale(1.1, 1.1);}
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.08 animations:^{
                             step.layer.affineTransform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                         }];
                     }];
}

-(NSString *)GetPositionInString:(CGPoint)position
{
    CGFloat x             = position.x;
    CGFloat y             = position.y;
    NSString *x_string    = [NSString stringWithFormat:@"%f",x];
    NSString *y_string    = [NSString stringWithFormat:@"%f",y];
    int x_now             = [x_string intValue];
    int y_now             = [y_string intValue];
    NSString *x_nowstring = [NSString stringWithFormat:@"%i",x_now];
    NSString *y_nowstring = [NSString stringWithFormat:@"%i",y_now];
    
    NSMutableString *location_now = [NSMutableString stringWithCapacity:999];
    
    
    
    if (x_now >= 100) {
        [location_now appendString:x_nowstring];
    }
    else if (x_now <100&&x_now >10)
    {
        [location_now appendString:@"0"];
        [location_now appendString:x_nowstring];
    }else if (x_now <10)
    {
        [location_now appendString:@"0"];
        [location_now appendString:@"0"];
        [location_now appendString:x_nowstring];
    }
    
    if (y_now >= 100) {
        [location_now appendString:y_nowstring];
    }
    else if (y_now <100&&y_now >10)
    {
        [location_now appendString:@"0"];
        [location_now appendString:y_nowstring];
    }else if (y_now <10)
    {
        [location_now appendString:@"0"];
        [location_now appendString:@"0"];
        [location_now appendString:y_nowstring];
    }
    
    return location_now;
    
}

-(void)wheredidIpressed:(CGPoint)position withTag:(NSUInteger)tag
{
    self.final_position         = [self GetPositionInString:position];
    NSMutableArray *fightResult = [[NSMutableArray alloc]init];
    
    NSArray *paths                = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist               = [paths objectAtIndex:0];
    NSString *filename            = [plist stringByAppendingPathComponent:@"chess3.plist"];
    NSMutableDictionary *chessDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    //删除所有的View;

    NSUInteger chess_tag = [self.tag_array[0] integerValue];
    UIView *asd          =(UIView *)[self viewWithTag:chess_tag];
    [self.step_tag_array removeObject:[NSNumber numberWithInteger:tag]];
    
    UIView *chosen = (UIView *)[self viewWithTag:tag];
    [chosen removeFromSuperview];
    
    for (int i = 0; i<[self.step_tag_array count]; i++) {
        NSUInteger step_tag = [self.step_tag_array[i] integerValue];
        UIView *step        = (UIView *)[self viewWithTag:step_tag];
        [step removeFromSuperview];
    }
    [asd removeFromSuperview];
    [self.step_tag_array removeAllObjects];
    
    NSUInteger count = 0;
    NSString *position_enemy;
    for (UIView *subview in self.subviews) {
        NSString *position_pressed = [self GetPositionInString:position];
        CGPoint position_enenmy1   = CGPointMake(subview.frame.origin.x, subview.frame.origin.y);
        NSString *position_enemy2  = [self GetPositionInString:position_enenmy1];
        if ([position_enemy2 isEqualToString:position_pressed]) {
            position_enemy              = position_enemy2;
            NSMutableArray *red_chess   = [[NSMutableArray alloc]init];
            NSMutableArray *black_chess = [[NSMutableArray alloc]init];
            
            [red_chess addObject:[self.chess_message objectAtIndex:0]];
            [red_chess addObject:[self.chess_message objectAtIndex:5]];
            [red_chess addObject:[self.chess_message objectAtIndex:6]];
            
            for (id key in chessDic) {
                NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
                chess = [chessDic objectForKey:key];
                for (id key2 in chess) {
                    if ([key2 isEqualToString:@"location"]) {
                        if ([position_enemy2 isEqualToString:[chess objectForKey:key2]]) {
                            [black_chess addObject:[chess objectForKey:@"name"]];
                            [black_chess addObject:[chess objectForKey:@"attack"]];
                            [black_chess addObject:[chess objectForKey:@"health"]];
                            break;
                        }
                    }
                }
            }
            
            fightResult = [self FightBetweenRed:red_chess andBlack:black_chess];
            [subview removeFromSuperview];
            count++;
        }
    }
    //统计发生“战斗”的次数
    //获取之前点击的棋子的信息
    NSString *value_reborn      =[self.chess_message objectAtIndex:0];
    NSString *chesscolor_reborn = [self.chess_message objectAtIndex:4];
    NSUInteger tag_reborn       = [[self.chess_message objectAtIndex:3] integerValue];
    NSString *attack_reborn     = [self.chess_message objectAtIndex:5];
    NSString *health_reborn     = [self.chess_message objectAtIndex:6];
    
    if (fightResult.count != 0) {

    if ([[fightResult objectAtIndex:2] isEqualToString:@"0"]) {
        if ([[fightResult objectAtIndex:5] isEqualToString:@"0"]) {
            //双方都阵亡
            NSString *red_location = [self GetPositionInString:CGPointMake([self.chess_message[1] floatValue], [self.chess_message[2] floatValue])];
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:red_location];
            [array addObject:[self GetPositionInString:position]];
            [array addObject:@"0"];
            [array addObject:@"0"];
            [array addObject:@"0"];
            [array addObject:@"0"];
            [self RefrashPlist:array];
            
            self.initial_message = [[NSMutableArray alloc]init];
            self.final_message   = [[NSMutableArray alloc]init];
            
            self.result = @"AD";
            // AD means All Dead
            
        }else
        {
            NSInteger t_ag = [[self GetPositionInString:position] integerValue];
            //红色棋子GG，需更新黑色棋子的血量，考虑重绘
            ChessView *chessview = [ChessView ChessForPosition:position sideLength:30 cornerRadius:15 value:[[fightResult objectAtIndex:3] substringWithRange:NSMakeRange(0, 1)] attack:[fightResult objectAtIndex:4] health:[fightResult objectAtIndex:5] ChessColor:@"B" withTag:t_ag delegate:self];
            [self addSubview:chessview];
            
            NSString *red_location = [self GetPositionInString:CGPointMake([self.chess_message[1] floatValue], [self.chess_message[2] floatValue])];
            NSMutableArray *array  = [[NSMutableArray alloc]init];
            [array addObject:red_location];
            [array addObject:[self GetPositionInString:position]];
            [array addObject:@"0"];
            [array addObject:@"0"];
            [array addObject:[fightResult objectAtIndex:4]];
            [array addObject:[fightResult objectAtIndex:5]];

            [self RefrashPlist:array];
            
            self.initial_message = [[NSMutableArray alloc]init];
            self.final_message = [[NSMutableArray alloc]init];
            
            [self.final_message addObject:[[fightResult objectAtIndex:3] substringWithRange:NSMakeRange(0, 1)]];
            [self.final_message addObject:[fightResult objectAtIndex:4]];
            [self.final_message addObject:[fightResult objectAtIndex:5]];
            [self.final_message addObject:[self GetPositionInString:position]];
            
            self.result = @"BW";
            //means black win
        }
    }else
    {
        if ([[fightResult objectAtIndex:5] isEqualToString:@"0"]) {
            //黑色棋子GG
            NSInteger t_ag       = [[self GetPositionInString:position] integerValue];
            ChessView *chessview = [ChessView ChessForPosition:position sideLength:30 cornerRadius:15 value:[fightResult objectAtIndex:0] attack:[fightResult objectAtIndex:1] health:[fightResult objectAtIndex:2] ChessColor:@"R" withTag:t_ag delegate:self];
            [self addSubview:chessview];
            
            NSString *red_location = [self GetPositionInString:CGPointMake([self.chess_message[1] floatValue], [self.chess_message[2] floatValue])];
            NSMutableArray *array  = [[NSMutableArray alloc]init];
            
            [array addObject:[self GetPositionInString:position]];
            [array addObject:red_location];
            [array addObject:[fightResult objectAtIndex:1]];
            [array addObject:[fightResult objectAtIndex:2]];
            [array addObject:@"0"];
            [array addObject:@"0"];
            
            [self RefrashPlist:array];
            
            self.initial_message = [[NSMutableArray alloc]init];
            self.final_message = [[NSMutableArray alloc]init];
            
            [self.initial_message addObject:[fightResult objectAtIndex:0]];
            [self.initial_message addObject:[fightResult objectAtIndex:1]];
            [self.initial_message addObject:[fightResult objectAtIndex:2]];
            [self.initial_message addObject:[self GetPositionInString:position]];
            
            self.result = @"RW";

        }else
        {
            //双方都存活
            NSString *red_location = [self GetPositionInString:CGPointMake([self.chess_message[1] floatValue], [self.chess_message[2] floatValue])];
            
            CGPoint red_new_position = CGPointMake([self.chess_message[1] floatValue], [self.chess_message[2] floatValue]);
            NSInteger t_ag1 = [red_location integerValue];
            ChessView *chessview1 = [ChessView ChessForPosition:red_new_position sideLength:30 cornerRadius:15 value:[[fightResult objectAtIndex:0] substringWithRange:NSMakeRange(0, 1)] attack:[fightResult objectAtIndex:1] health:[fightResult objectAtIndex:2] ChessColor:@"R" withTag:t_ag1 delegate:self];
            [self addSubview:chessview1];
            
            NSInteger t_ag2 = [[self GetPositionInString:position] integerValue];
            ChessView *chessview2 = [ChessView ChessForPosition:position sideLength:30 cornerRadius:15 value:[[fightResult objectAtIndex:3] substringWithRange:NSMakeRange(0, 1)] attack:[fightResult objectAtIndex:4] health:[fightResult objectAtIndex:5] ChessColor:@"B" withTag:t_ag2 delegate:self];
            [self addSubview:chessview2];
            

            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:red_location];
            [array addObject:[self GetPositionInString:position]];
            [array addObject:[fightResult objectAtIndex:1]];
            [array addObject:[fightResult objectAtIndex:2]];
            [array addObject:[fightResult objectAtIndex:4]];
            [array addObject:[fightResult objectAtIndex:5]];
            
            [self RefrashPlist:array];
            
            self.initial_message = [[NSMutableArray alloc]init];
            self.final_message = [[NSMutableArray alloc]init];
            
            [self.initial_message addObject:[[fightResult objectAtIndex:0] substringWithRange:NSMakeRange(0, 1)]];
            [self.initial_message addObject:[fightResult objectAtIndex:1]];
            [self.initial_message addObject:[fightResult objectAtIndex:2]];
            [self.initial_message addObject:[self GetPositionInString:red_new_position]];
            
            [self.final_message addObject:[[fightResult objectAtIndex:3] substringWithRange:NSMakeRange(0, 1)]];
            [self.final_message addObject:[fightResult objectAtIndex:4]];
            [self.final_message addObject:[fightResult objectAtIndex:5]];
            [self.final_message addObject:[self GetPositionInString:position]];
            
            self.result = @"TIE";
        }
    }
    }else
    {
            ChessView *chessview = [ChessView ChessForPosition:position sideLength:30 cornerRadius:15 value:value_reborn attack:attack_reborn health:health_reborn ChessColor:chesscolor_reborn withTag:tag_reborn delegate:self];
            [self addSubview:chessview];
        
            NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *plist            = [paths objectAtIndex:0];
            NSString *filename         = [plist stringByAppendingPathComponent:@"chess3.plist"];
            NSMutableDictionary *chess = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
        
            for (id key in chess) {
                NSMutableDictionary *chessNameAndLocation = [chess objectForKey:key];
                for (id key in chessNameAndLocation) {
                    if ([key isEqualToString:@"location"])
                    {
                        if ([[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(0, 3)] floatValue] == [self.chess_message[1] floatValue]
                            &&
                            [[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(3, 3)] floatValue] == [self.chess_message[2] floatValue])
                        {
                            //                NSMutableString *whereischessnow = [NSMutableString stringWithCapacity:999];
                            //传递进来的是Float，带小数点，要去掉小数点，x与y组成一个表示坐标的string
                            [chessNameAndLocation setObject:[self GetPositionInString:position] forKey:@"location"];//修改移动后的棋子的信息
                            break;
                        }
                    }
                    
                }
            }
            [chess writeToFile:filename atomically:YES];
        
        
        self.initial_message = [[NSMutableArray alloc]init];
        self.final_message   = [[NSMutableArray alloc]init];
        
        [self.final_message addObject:value_reborn];
        [self.final_message addObject:attack_reborn];
        [self.final_message addObject:health_reborn];
        [self.final_message addObject:[self GetPositionInString:position]];
        
        self.result = @"NOTHING";
    }
    

    [self postchessmes];
    [self.delegate sendStepInfo:self.post_message];

    return;
}

-(void)RefrashPlist:(NSMutableArray *)location
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist            = [paths objectAtIndex:0];
    NSString *filename         = [plist stringByAppendingPathComponent:@"chess3.plist"];
    NSMutableDictionary *chess = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    NSMutableArray *enemy_chess = [[NSMutableArray alloc]init];
    
    for (id key in chess) {
        NSMutableDictionary *chessNameAndLocation = [chess objectForKey:key];
        for (id key1 in chessNameAndLocation) {
            if ([key1 isEqualToString:@"location"]) {
                if ([location[2] isEqualToString:@"0"]&&[location[4] isEqualToString:@"0"]) {
                    for (NSUInteger i = 0; i < 2; i++) {
                        if ([[chessNameAndLocation objectForKey:key1] isEqualToString:location[i]]) {
                            [enemy_chess addObject:key];
                        }
                    }
                }else if ([location[2] isEqualToString:@"0"])
                {
                    if ([[chessNameAndLocation objectForKey:key1] isEqualToString:location[0]]) {
                        [enemy_chess addObject:key];

                    }
                }else if ([location[4] isEqualToString:@"0"])
                {
                    if ([[chessNameAndLocation objectForKey:key1] isEqualToString:location[0]]) {
                        [enemy_chess addObject:key];

                    }
                }
            }
        }
    }
    for (NSUInteger i = 0; i < enemy_chess.count; i++) {
        [chess removeObjectForKey:enemy_chess[i]];
    }

    
    if (chess.count == self.fight_count) {
        NSMutableDictionary *new_chess  = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *new_chess1 = [[NSMutableDictionary alloc]init];
        NSString *new_key;
        NSString *new_key1;

        for (id key in chess) {
            NSMutableDictionary *chessNameAndLocation = [chess objectForKey:key];
            for (id key1 in chessNameAndLocation) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessNameAndLocation objectForKey:key1] isEqualToString:location[0]]) {
                        new_chess = [chessNameAndLocation mutableCopy];
                        [new_chess setObject:location[2] forKey:@"attack"];
                        [new_chess setObject:location[3] forKey:@"health"];
                        new_key = key;
                    }else if ([[chessNameAndLocation objectForKey:key1] isEqualToString:location[1]])
                    {
                        new_chess1 = [chessNameAndLocation mutableCopy];
                        [new_chess1 setObject:location[4] forKey:@"attack"];
                        [new_chess1 setObject:location[5] forKey:@"health"];
                        new_key1 = key;
                    }
                }
            }
        }
        
        [chess setObject:new_chess forKey:new_key];
        [chess setObject:new_chess1 forKey:new_key1];
        
    }else
    {
        if (chess.count == (self.fight_count -1)) {
                NSMutableDictionary *new_chess = [[NSMutableDictionary alloc]init];
                NSString *new_key;
                
                for (id key in chess) {
                    NSMutableDictionary *chessNameAndLocation = [chess objectForKey:key];
                    for (id key1 in chessNameAndLocation) {
                        if ([key1 isEqualToString:@"location"]) {
                            if ([[chessNameAndLocation objectForKey:key1] isEqualToString:location[1]]) {
                                new_chess = [chessNameAndLocation mutableCopy];
                                new_key = key;
                                if ([location[2] isEqualToString:@"0"]) {
                                    [new_chess setObject:location[4] forKey:@"attack"];
                                    [new_chess setObject:location[5] forKey:@"health"];
                                }else
                                {
                                [new_chess setObject:location[2] forKey:@"attack"];
                                [new_chess setObject:location[3] forKey:@"health"];
                                }
                            }
                            
                        }
                    }
                }
            if ([location[2] isEqualToString:@"0"]) {
                [new_chess setObject:location[1] forKey:@"location"];
            }else
            {
                [new_chess setObject:location[0] forKey:@"location"];
            }
                [chess setObject:new_chess forKey:new_key];
            self.fight_count = self.fight_count -1.f;
        }
    }
    
    [chess writeToFile:filename atomically:YES];
}

-(NSMutableArray *)FightBetweenRed:(NSMutableArray *)RedChess andBlack:(NSMutableArray *)BlackChess
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSInteger red_attack   = [[RedChess objectAtIndex:1] integerValue];
    NSInteger red_health   = [[RedChess objectAtIndex:2] integerValue];
    NSInteger black_attack = [[BlackChess objectAtIndex:1] integerValue];
    NSInteger black_health = [[BlackChess objectAtIndex:2] integerValue];
    
    NSString *new_red_health;
    NSString *new_black_health;

    
    if (red_attack >= black_health) {
        if (red_health > black_attack) {
            new_red_health = [NSString stringWithFormat:@"%li",(long)red_health - black_attack];
            new_black_health = @"0";
        }else
        {
            new_red_health = @"0";
            new_black_health = @"0";
        }
    }else
    {
        if (red_health > black_attack)
        {
            new_red_health   = [NSString stringWithFormat:@"%li",(long)red_health - black_attack];
            new_black_health = [NSString stringWithFormat:@"%li",(long)black_health - red_attack];
        }else
        {
            new_red_health   = @"0";
            new_black_health = [NSString stringWithFormat:@"%li",(long)black_health - red_attack];
        }
    }
    
    [result addObject:[RedChess objectAtIndex:0]];
    [result addObject:[NSString stringWithFormat:@"%li",(long)red_attack]];
    [result addObject:new_red_health];
    [result addObject:[BlackChess objectAtIndex:0]];
    [result addObject:[NSString stringWithFormat:@"%li",(long)black_attack]];
    [result addObject:new_black_health];
    
    
    return result;
}

-(void)postchessmes
{
    self.post_message = [[NSMutableArray alloc]init];
    [self.post_message addObject:self.initial_position];
    [self.post_message addObject:self.final_position];
    [self.post_message addObject:self.result];
    [self.post_message addObject:self.initial_message];
    [self.post_message addObject:self.final_message];
}

-(void)playBlack:(NSMutableArray *)BlackInfo
{
    //1）先根据收到的Info移除对面棋子
    //2）根据Info中的RESULT重绘棋子；
    //3) 更新plist
    [self PlistInit];
    NSString *result                = BlackInfo[2];
    NSString *location_init         = BlackInfo[0];
    NSString *location_final        = BlackInfo[1];
    NSString *location_init_change  = [self changeXandY:location_init];
    NSString *location_final_change = [self changeXandY:location_final];
    NSMutableArray *initial         = BlackInfo[3];
    NSMutableArray *final           = BlackInfo[4];
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist                 = [paths objectAtIndex:0];
    NSString *filename              = [plist stringByAppendingPathComponent:@"chess3.plist"];
    
    
    NSUInteger t_aag1 = [location_init_change integerValue];
    UIView *delete1 =(UIView *)[self viewWithTag:t_aag1];
    if (delete1) {
        [delete1 removeFromSuperview];
    }
    
    NSUInteger t_aag2 = [location_final_change integerValue];
    UIView *delete2   = (UIView *)[self viewWithTag:t_aag2];
    if (delete2) {
        [delete2 removeFromSuperview];
    }
    
    if ([result isEqualToString:@"AD"]) {
        NSMutableArray *remove_key = [[NSMutableArray alloc]init];
        for (id key in self.chessDic) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess = [self.chessDic objectForKey:key];
            if ([[chess objectForKey:@"location"] isEqualToString:location_init_change] || [[chess objectForKey:@"location"] isEqualToString:location_final_change]) {
                [remove_key addObject:key];
            }
        }
        for (NSUInteger i = 0; i < remove_key.count; i++) {
            [self.chessDic removeObjectForKey:remove_key[i]];
        }
        [self.chessDic writeToFile:filename atomically:NO];
    }else if ([result isEqualToString:@"BW"])
    {
        CGFloat x               = [[location_final_change substringWithRange:NSMakeRange(0, 3)] floatValue];
        CGFloat y               = [[location_final_change substringWithRange:NSMakeRange(3, 3)] floatValue];
        CGPoint path            = CGPointMake(x, y);
        NSString *value_black_a = final[0];
        NSString *value_black   = [self ChangChessName:value_black_a];
        NSString *attack_black  = final[1];
        NSString *health_black  = final[2];
        NSUInteger t_ag = [location_final_change integerValue];
        
        [self insertChessAtIndexPath:path withValue:value_black withattack:attack_black withhealth:health_black withColor:@"R" withTag:t_ag];
        
        NSMutableArray *remove_key         = [[NSMutableArray alloc]init];
        NSMutableDictionary *replace_chess = [[NSMutableDictionary alloc]init];
        NSString *replace_key;
        
        for (id key in self.chessDic) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess                      = [self.chessDic objectForKey:key];
            if ([[chess objectForKey:@"location"]isEqualToString:location_init_change]) {
                [remove_key addObject:key];
            }else if ([[chess objectForKey:@"location"]isEqualToString:location_final_change])
            {
                replace_key   = key;
                replace_chess = [chess mutableCopy];
                [replace_chess setObject:attack_black forKey:@"attack"];
                [replace_chess setObject:health_black forKey:@"health"];
            }
        }
        for (NSUInteger i = 0; i < remove_key.count; i++) {
            [self.chessDic removeObjectForKey:remove_key[i]];
        }
        [self.chessDic setObject:replace_chess forKey:replace_key];
        [self.chessDic writeToFile:filename atomically:NO];
    }else if ([result isEqualToString:@"RW"])
    {
        CGFloat x             = [[location_final_change substringWithRange:NSMakeRange(0, 3)] floatValue];
        CGFloat y             = [[location_final_change substringWithRange:NSMakeRange(3, 3)] floatValue];
        CGPoint path          = CGPointMake(x, y);
        NSString *value_red_A = initial[0];
        NSString *value_red   = [self ChangChessName:value_red_A];
        NSString *attack_red  = initial[1];
        NSString *health_red  = initial[2];
        NSUInteger t_ag = [location_final_change integerValue];
        
        [self insertChessAtIndexPath:path withValue:value_red withattack:attack_red withhealth:health_red withColor:@"B" withTag:t_ag];
        
        NSMutableArray *remove_key = [[NSMutableArray alloc]init];
        NSMutableDictionary *replace_chess = [[NSMutableDictionary alloc]init];
        NSString *replace_key;
        
        for (id key in self.chessDic) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess                      = [self.chessDic objectForKey:key];
            if ([[chess objectForKey:@"location"]isEqualToString:location_final_change]) {
                [remove_key addObject:key];
            }else if ([[chess objectForKey:@"location"]isEqualToString:location_init_change])
            {
                replace_key   = key;
                replace_chess = [chess mutableCopy];
                [replace_chess setObject:attack_red forKey:@"attack"];
                [replace_chess setObject:health_red forKey:@"health"];
                [replace_chess setValue:location_final_change forKey:@"location"];
            }
        }
        for (NSUInteger i = 0; i < remove_key.count; i++) {
            [self.chessDic removeObjectForKey:remove_key[i]];
        }
        [self.chessDic setObject:replace_chess forKey:replace_key];
        [self.chessDic writeToFile:filename atomically:NO];

    }else if ([result isEqualToString:@"TIE"])
    {
        CGFloat x_black         = [[location_final_change substringWithRange:NSMakeRange(0, 3)] floatValue];
        CGFloat y_black         = [[location_final_change substringWithRange:NSMakeRange(3, 3)] floatValue];
        CGPoint path_black      = CGPointMake(x_black, y_black);
        NSString *value_black_A = final[0];
        NSString *value_black   = [self ChangChessName:value_black_A];
        NSString *attack_black  = final[1];
        NSString *health_black  = final[2];
        NSUInteger t_ag_black   = [location_final_change integerValue];
        
        [self insertChessAtIndexPath:path_black withValue:value_black withattack:attack_black withhealth:health_black withColor:@"R" withTag:t_ag_black];
        
        CGFloat x_red         = [[location_init_change substringWithRange:NSMakeRange(0, 3)] floatValue];
        CGFloat y_red         = [[location_init_change substringWithRange:NSMakeRange(3, 3)] floatValue];
        CGPoint path_red      = CGPointMake(x_red, y_red);
        NSString *value_red_a = initial[0];
        NSString *value_red   = [self ChangChessName:value_red_a];
        NSString *attack_red  = initial[1];
        NSString *health_red  = initial[2];
        NSUInteger t_ag_red   = [location_init_change integerValue];
        
        [self insertChessAtIndexPath:path_red withValue:value_red withattack:attack_red withhealth:health_red withColor:@"B" withTag:t_ag_red];
        
        NSString *replace_key1;
        NSString *replace_key2;
        NSMutableDictionary *replace_chess1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *replace_chess2 = [[NSMutableDictionary alloc]init];
        
        for (id key in self.chessDic) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess = [self.chessDic objectForKey:key];
            if ([[chess objectForKey:@"location"] isEqualToString:location_init_change]) {
                replace_key1   = key;
                replace_chess1 = [chess mutableCopy];
                [replace_chess1 setObject:attack_red forKey:@"attack"];
                [replace_chess1 setObject:health_red forKey:@"health"];
            }else if ([[chess objectForKey:@"location"] isEqualToString:location_final_change])
            {
                replace_key2   = key;
                replace_chess2 = [chess mutableCopy];
                [replace_chess2 setObject:attack_black forKey:@"attack"];
                [replace_chess2 setObject:health_black forKey:@"health"];
            }
        }
        [self.chessDic setObject:replace_chess1 forKey:replace_key1];
        [self.chessDic setObject:replace_chess2 forKey:replace_key2];
        [self.chessDic writeToFile:filename atomically:NO];
    }else if ([result isEqualToString:@"NOTHING"])
    {
        CGFloat x               = [[location_final_change substringWithRange:NSMakeRange(0, 3)] floatValue];
        CGFloat y               = [[location_final_change substringWithRange:NSMakeRange(3, 3)] floatValue];
        CGPoint path            = CGPointMake(x, y);
        NSString *value_black_A = final[0];
        NSString *value_black   = [self ChangChessName:value_black_A];
        NSString *attack_black  = final[1];
        NSString *health_black  = final[2];
        NSUInteger t_ag = [location_final_change integerValue];
        
        [self insertChessAtIndexPath:path withValue:value_black withattack:attack_black withhealth:health_black withColor:@"B" withTag:t_ag];
        
        
        NSString *replace_key;
        NSMutableDictionary *replace_chess = [[NSMutableDictionary alloc]init];
        
        for (id key in self.chessDic) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess = [self.chessDic objectForKey:key];
            if ([[chess objectForKey:@"location"] isEqualToString:location_init_change]) {
                replace_key   = key;
                replace_chess = [chess mutableCopy];
                [replace_chess setObject:location_final_change forKey:@"location"];
            }
        }
        [self.chessDic setObject:replace_chess forKey:replace_key];
        [self.chessDic writeToFile:filename atomically:NO];
    }

}

-(NSMutableString *)changeXandY:(NSString *)string
{
    int x                         = 240 - [[string substringWithRange:NSMakeRange(0, 3)] intValue];
    int y                         = 470 - [[string substringWithRange:NSMakeRange(3, 3)] intValue];
    NSString *x_str               = [NSString stringWithFormat:@"%i",x];
    NSString *y_str               = [NSString stringWithFormat:@"%i",y];
    NSMutableString *location_new = [[NSMutableString alloc] init];
    
    if (x >= 100) {
        [location_new appendString:x_str];
    }
    else if (x <100&&x >10)
    {
        [location_new appendString:@"0"];
        [location_new appendString:x_str];
    }else if (x <10)
    {
        [location_new appendString:@"0"];
        [location_new appendString:@"0"];
        [location_new appendString:x_str];
    }
    
    if (y >= 100) {
        [location_new appendString:y_str];
    }
    else if (y <100&&y >10)
    {
        [location_new appendString:@"0"];
        [location_new appendString:y_str];
    }else if (y <10)
    {
        [location_new appendString:@"0"];
        [location_new appendString:@"0"];
        [location_new appendString:y_str];
    }

    return location_new;
}

-(NSString *)ChangChessName:(NSString *)name
{
    NSString *chang_name;
    if ([name isEqualToString:@"帅"]) {
        chang_name = @"将";
    }
    if ([name isEqualToString:@"兵"]) {
        chang_name = @"卒";
    }
    if ([name isEqualToString:@"马"]) {
        chang_name = @"馬";
    }
    if ([name isEqualToString:@"相"]) {
        chang_name = @"象";
    }
    if ([name isEqualToString:@"仕"]) {
        chang_name = @"士";
    }
    if ([name isEqualToString:@"将"]) {
        chang_name = @"帅";
    }
    if ([name isEqualToString:@"卒"]) {
        chang_name = @"兵";
    }
    if ([name isEqualToString:@"馬"]) {
        chang_name = @"马";
    }
    if ([name isEqualToString:@"象"]) {
        chang_name = @"相";
    }
    if ([name isEqualToString:@"士"]) {
        chang_name = @"仕";
    }
    if ([name isEqualToString:@"炮"]) {
        chang_name = @"炮";
    }
    if ([name isEqualToString:@"車"]) {
        chang_name = @"車";
    }
    return chang_name;
}

@end
