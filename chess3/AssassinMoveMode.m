//
//  AssassinMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "AssassinMoveMode.h"

@interface AssassinMoveMode ()

@property(nonatomic)                   CGPoint position;
@property(nonatomic)                NSUInteger chess_tag;
@property(nonatomic,strong)NSMutableDictionary *chess;
@property(nonatomic,strong)           NSString *chesscolor;

@end

@implementation AssassinMoveMode

+(instancetype)AssassinCameFrom:(CGPoint)initLocation
                        withTag:(NSUInteger)tag
                      withColor:(NSString *)color
{
    AssassinMoveMode *assassin = [AssassinMoveMode new];
    assassin.position          = initLocation;
    assassin.chess_tag         = tag;
    assassin.chesscolor        = color;
    return assassin;
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
    
    if (position.x >=90 && position.x <=150 && position.y<=370 && position.y>=310 )
    {
        
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
    }
    return location_now;
    
}

-(NSMutableArray *)HowAssassinGo:(CGPoint)positon
{
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableArray *chessposition   = [[NSMutableArray alloc]init];
    NSMutableArray *chessposition_B = [[NSMutableArray alloc]init];
    NSMutableArray *chessposition_R = [[NSMutableArray alloc]init];
    
    NSMutableArray *assassin = [[NSMutableArray alloc]init];
    
    
    
    CGPoint assassin_1 = CGPointMake(self.position.x+30, self.position.y+30);
    [assassin addObject:[self GetPositionInString:assassin_1]];
    
    CGPoint assassin_2 = CGPointMake(self.position.x+30, self.position.y-30);
    [assassin addObject:[self GetPositionInString:assassin_2]];
    
    CGPoint assassin_3 = CGPointMake(self.position.x-30, self.position.y-30);
    [assassin addObject:[self GetPositionInString:assassin_3]];
    
    CGPoint assassin_4 = CGPointMake(self.position.x-30, self.position.y+30);
    [assassin addObject:[self GetPositionInString:assassin_4]];
    
    for (id key in self.chess) {
        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"])
        {
            NSMutableDictionary *chessNameAndLocation = [self.chess objectForKey:key];
            for (id key in chessNameAndLocation) {
                if ([key isEqualToString:@"location"]) {
                    [chessposition_B addObject:[chessNameAndLocation objectForKey:key]];
                }
            }
        }else
        {
            NSMutableDictionary *chessNameAndLocation = [self.chess objectForKey:key];
            for (id key in chessNameAndLocation) {
                if ([key isEqualToString:@"location"]) {
                    [chessposition_R addObject:[chessNameAndLocation objectForKey:key]];
                }
            }
        }
    }
    
    for (NSString *location in chessposition_R) {
        [chessposition addObject:location];
    }
    for (NSString *location in chessposition_B) {
        [chessposition addObject:location];
    }
    
    for (id key in self.chess) {
        NSMutableDictionary *chessNameAndLocation = [self.chess objectForKey:key];
        for (id key in chessNameAndLocation) {
            if ([key isEqualToString:@"location"]) {
                [chessposition addObject:[chessNameAndLocation objectForKey:key]];
            }
        }
    }
    
    
    for (id key in self.chess) {
        NSMutableDictionary *chessNameAndLocation = [self.chess objectForKey:key];
        for (id key in chessNameAndLocation) {
            if ([key isEqualToString:@"location"]) {
                [chessposition addObject:[chessNameAndLocation objectForKey:key]];
            }
        }
    }
    
    //判定可走位置是否在棋盘内
    NSMutableArray *removechess2 = [[NSMutableArray alloc]initWithCapacity:999];
    for (NSString *string in assassin) {
        if (string.length != 6) {
            [removechess2 addObject:string];
        }
    }
    if ([removechess2 count] != 0)
    {
        for (NSUInteger i = 0; i < [removechess2 count]; i++)
        {
            [assassin removeObject:removechess2[i]];
        }
    }
    //判定可走位置上是否有其他棋子
    NSMutableArray *removechess = [[NSMutableArray alloc]initWithCapacity:999];
    NSMutableArray *enemychess  = [[NSMutableArray alloc]initWithCapacity:999];
    
    if ([self.chesscolor isEqualToString:@"R"])  //如果棋子是红色的，删除所有红色的可走位置，留下黑色的可走位置
    {
        for (NSString *chessrider in assassin) {
            for (NSString *string in chessposition_R) {
                if ([chessrider isEqual:string]) {
                    [removechess addObject:chessrider];
                }
            }
        }
        if ([removechess count] != 0)
        {
            for (NSUInteger i = 0; i < [removechess count]; i++)
            {
                [assassin removeObject:removechess[i]];
            }
        }
        for (NSString *chessrider in assassin) {
            for (NSString *string in chessposition_B) {
                if ([chessrider isEqual:string]) {
                    [enemychess addObject:chessrider];
                }
            }
        }
        if ([enemychess count] != 0)
        {
            for (NSUInteger i = 0; i < [enemychess count]; i++)
            {
                [assassin removeObject:enemychess[i]];
            }
        }
    }else
    {
        for (NSString *chessrider in assassin) {
            for (NSString *string in chessposition_B) {
                if ([chessrider isEqual:string]) {
                    [removechess addObject:chessrider];
                }
            }
        }
        if ([removechess count] != 0)
        {
            for (NSUInteger i = 0; i < [removechess count]; i++)
            {
                [assassin removeObject:removechess[i]];
            }
        }
        for (NSString *chessrider in assassin) {
            for (NSString *string in chessposition_R) {
                if ([chessrider isEqual:string]) {
                    [enemychess addObject:chessrider];
                }
            }
        }
        if ([enemychess count] != 0)
        {
            for (NSUInteger i = 0; i < [enemychess count]; i++)
            {
                [assassin removeObject:enemychess[i]];
            }
        }
        
    }
    [assassin addObject:@"enemy:"];
    for (NSString *string in enemychess) {
        [assassin addObject:string];
    }
    return assassin;
    
    
}

@end
