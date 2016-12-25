//
//  ArcherMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/2/17.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "ArcherMoveMode.h"

@interface ArcherMoveMode()

@property(nonatomic)                   CGPoint position;
@property(nonatomic)                NSUInteger chess_tag;
@property(nonatomic,strong)NSMutableDictionary *chess;
@property(nonatomic,strong)           NSString *chesscolor;

@end

@implementation ArcherMoveMode

+(instancetype)ArcherCameFrom:(CGPoint)initLocation
                      withTag:(NSUInteger)tag
                    withColor:(NSString *)color
{
    ArcherMoveMode *archer = [ArcherMoveMode new];
    archer.position        = initLocation;
    archer.chess_tag       = tag;
    archer.chesscolor      = color;
    return archer;
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

-(NSMutableArray *)HowArcherGo:(CGPoint)positon
{
    
    NSMutableArray *archer                = [[NSMutableArray alloc]init];
    NSMutableArray *archer_enemy          = [[NSMutableArray alloc]init];
    NSMutableArray *chess_matchlocation_x = [[NSMutableArray alloc]init];
    NSMutableArray *chess_matchlocation_y = [[NSMutableArray alloc]init];

    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    
    NSString *location_x = [[self GetPositionInString:positon] substringWithRange:NSMakeRange(0, 3)];
    NSString *location_y = [[self GetPositionInString:positon] substringWithRange:NSMakeRange(3, 3)];
    
    for (id key in self.chess) {
        NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
        chess = [self.chess objectForKey:key];
        for (id key1 in chess) {
            if ([key1 isEqualToString:@"location"]) {
                if ([[[chess objectForKey:key1] substringWithRange:NSMakeRange(0, 3)] isEqualToString:location_x])
                {
                    [chess_matchlocation_y addObject:[[chess objectForKey:key1] substringWithRange:NSMakeRange(3, 3)]];
                }else if ([[[chess objectForKey:key1] substringWithRange:NSMakeRange(3, 3)] isEqualToString:location_y])
                {
                    [chess_matchlocation_x addObject:[[chess objectForKey:key1] substringWithRange:NSMakeRange(0, 3)]];
                }
            }
        }
    }
    //Y轴方向选择可以走的位置
    NSMutableArray *big_y    = [[NSMutableArray alloc]init];
    NSMutableArray *little_y = [[NSMutableArray alloc]init];
    
    for (NSUInteger i = 0; i < chess_matchlocation_y.count; i++) {
        if ([chess_matchlocation_y[i] floatValue] > positon.y) {
            [big_y addObject:chess_matchlocation_y[i]];
        }else if([chess_matchlocation_y[i] floatValue] < positon.y)
        {
            [little_y addObject:chess_matchlocation_y[i]];
        }
    }
    
    NSMutableArray *big_x    = [[NSMutableArray alloc]init];
    NSMutableArray *little_x = [[NSMutableArray alloc]init];
    
    for (NSUInteger i = 0; i < chess_matchlocation_x.count; i++) {
        if ([chess_matchlocation_x[i] floatValue] > positon.x) {
            [big_x addObject:chess_matchlocation_x[i]];
        }else if([chess_matchlocation_x[i] floatValue] < positon.x)
        {
            [little_x addObject:chess_matchlocation_x[i]];
        }
    }

    //可以走的位置
    if (little_y.count > 0) {

    [little_y sortUsingSelector:@selector(compare:)];
    NSUInteger count = (positon.y - [little_y[little_y.count-1] floatValue])/30.f -1;
    for (NSUInteger i = 1; i <= count; i++) {
        CGFloat y                   = [little_y[little_y.count-1] floatValue] + i * 30;
        NSString *location_feasible = [self GetPositionInString:CGPointMake(positon.x, y)];
        [archer addObject:location_feasible];
        }
    }else
    {
        NSUInteger count = (positon.y - 100.f)/30.f;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat y                   = 100 + (i-1) * 30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(positon.x, y)];
            [archer addObject:location_feasible];
        }
    }
    
    if (big_y.count > 0) {
        [big_y sortUsingSelector:@selector(compare:)];
        NSUInteger count = ([big_y[0] floatValue] - positon.y)/30.f - 1;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat y                   = positon.y + i*30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(positon.x, y)];
            [archer addObject:location_feasible];
        }
    }else
    {
        NSUInteger count = (370.f - positon.y)/30.f;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat y                   = positon.y + i * 30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(positon.x, y)];
            [archer addObject:location_feasible];
        }
    }
    
    if (little_x.count > 0) {
        [little_x sortUsingSelector:@selector(compare:)];
        NSUInteger count = (positon.x - [little_x[little_x.count -1] floatValue])/30.f -1;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat x                   = [little_x[little_x.count -1]floatValue] + i*30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(x, positon.y)];
            [archer addObject:location_feasible];
        }
    }else
    {
        NSUInteger count = (positon.x - 0.f)/30.f;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat x                   = (i - 1)*30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(x, positon.y)];
            [archer addObject:location_feasible];
        }
    }

    if (big_x.count > 0) {
        [big_x sortUsingSelector:@selector(compare:)];
        NSUInteger count = ([big_x[0] floatValue] - positon.x)/30.f -1;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat x                   = positon.x + i * 30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(x, positon.y)];
            [archer addObject:location_feasible];
        }
    }
    else
    {
        NSUInteger count = (240.f - positon.x)/30.f;
        for (NSUInteger i = 1; i <= count; i++) {
            CGFloat x                   = positon.x + i * 30;
            NSString *location_feasible = [self GetPositionInString:CGPointMake(x, positon.y)];
            [archer addObject:location_feasible];
        }
    }
    //可攻击的位置
    if (big_y.count > 1) {
        CGFloat y =  [big_y[1] floatValue];
        NSString *location_attackable = [self GetPositionInString:CGPointMake(positon.x, y)];
        for (id key in self.chess) {
            NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]init];
            chessDic = [self.chess objectForKey:key];
            for (id key1 in chessDic) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessDic objectForKey:key1] isEqualToString:location_attackable]) {
                        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                            [archer_enemy addObject:location_attackable];
                        }
                    }
                }
            }
        }
    }
    
    if (little_y.count > 1) {
        CGFloat y =  [little_y[little_y.count -2] floatValue];
        NSString *location_attackable = [self GetPositionInString:CGPointMake(positon.x, y)];
        for (id key in self.chess) {
            NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]init];
            chessDic = [self.chess objectForKey:key];
            for (id key1 in chessDic) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessDic objectForKey:key1] isEqualToString:location_attackable]) {
                        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                            [archer_enemy addObject:location_attackable];
                        }
                    }
                }
            }
        }
    }
    
    if (big_x.count > 1) {
        CGFloat x =  [big_x[1] floatValue];
        NSString *location_attackable = [self GetPositionInString:CGPointMake(x, positon.y)];
        for (id key in self.chess) {
            NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]init];
            chessDic = [self.chess objectForKey:key];
            for (id key1 in chessDic) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessDic objectForKey:key1] isEqualToString:location_attackable]) {
                        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                            [archer_enemy addObject:location_attackable];
                        }
                    }
                }
            }
        }
    }
    
    if (little_x.count > 1) {
        CGFloat x =  [little_x[little_x.count -2] floatValue];
        NSString *location_attackable = [self GetPositionInString:CGPointMake(x, positon.y)];
        for (id key in self.chess) {
            NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]init];
            chessDic = [self.chess objectForKey:key];
            for (id key1 in chessDic) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessDic objectForKey:key1] isEqualToString:location_attackable]) {
                        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                            [archer_enemy addObject:location_attackable];
                        }
                    }
                }
            }
        }
    }
    
    [archer addObject:@"enemy:"];
    for (NSUInteger i = 0; i < archer_enemy.count; i++) {
        [archer addObject:archer_enemy[i]];
    }
    
    return archer;
}


@end
