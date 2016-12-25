//
//  CasterMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "CasterMoveMode.h"

@interface CasterMoveMode ()

@property(nonatomic)                   CGPoint position;
@property(nonatomic)                NSUInteger chess_tag;
@property(nonatomic,strong)NSMutableDictionary *chess;
@property(nonatomic,strong)           NSString *chesscolor;

@end

@implementation CasterMoveMode

+(instancetype)CasterCameFrom:(CGPoint)initLocation
                      withTag:(NSUInteger)tag
                    withColor:(NSString *)color
{
    CasterMoveMode *caster = [CasterMoveMode new];
    caster.position        = initLocation;
    caster.chess_tag       = tag;
    caster.chesscolor      = color;
    return caster;
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
    
    if (position.x >=0 && position.x <=240 && position.y<=370 && position.y>=220 )
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

-(NSMutableArray *)HowCasterGo:(CGPoint)positon
{
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableArray *chessposition   = [[NSMutableArray alloc]initWithCapacity:999];
    NSMutableArray *chessposition_B = [[NSMutableArray alloc]initWithCapacity:999];
    NSMutableArray *chessposition_R = [[NSMutableArray alloc]initWithCapacity:999];
    
    NSMutableArray *caster = [[NSMutableArray alloc]initWithCapacity:999];
    
    
    
    CGPoint caster_1 = CGPointMake(self.position.x+60, self.position.y+60);
    [caster addObject:[self GetPositionInString:caster_1]];
    CGPoint caster1_break = CGPointMake(self.position.x+30, self.position.y+30);
    
    CGPoint caster_2 = CGPointMake(self.position.x+60, self.position.y-60);
    [caster addObject:[self GetPositionInString:caster_2]];
    CGPoint caster2_break = CGPointMake(self.position.x+30, self.position.y-30);
    
    CGPoint caster_3 = CGPointMake(self.position.x-60, self.position.y-60);
    [caster addObject:[self GetPositionInString:caster_3]];
    CGPoint caster3_break = CGPointMake(self.position.x-30, self.position.y-30);
    
    CGPoint caster_4 = CGPointMake(self.position.x-60, self.position.y+60);
    [caster addObject:[self GetPositionInString:caster_4]];
    CGPoint caster4_break = CGPointMake(self.position.x-30, self.position.y+30);
    
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
    
    for (NSString *string in chessposition) {
        if ([[self GetPositionInString:caster1_break] isEqualToString:string]) {
            [caster removeObject:[self GetPositionInString:caster_1]];
        }
        if ([[self GetPositionInString:caster2_break] isEqualToString:string]) {
            [caster removeObject:[self GetPositionInString:caster_2]];
        }
        if ([[self GetPositionInString:caster3_break] isEqualToString:string]) {
            [caster removeObject:[self GetPositionInString:caster_3]];
        }
        if ([[self GetPositionInString:caster4_break] isEqualToString:string]) {
            [caster removeObject:[self GetPositionInString:caster_4]];
        }
    }
    
    NSMutableArray *removechess2 = [[NSMutableArray alloc]initWithCapacity:999];
    for (NSString *string in caster) {
        if (string.length != 6) {
            [removechess2 addObject:string];
        }
    }
    if ([removechess2 count] != 0)
    {
        for (NSUInteger i = 0; i < [removechess2 count]; i++)
        {
            [caster removeObject:removechess2[i]];
        }
    }
    
    
    NSMutableArray *removechess = [[NSMutableArray alloc]initWithCapacity:999];
    NSMutableArray *enemychess  = [[NSMutableArray alloc]initWithCapacity:999];
    
    if ([self.chesscolor isEqualToString:@"R"])  //如果棋子是红色的，删除所有红色的可走位置，留下黑色的可走位置
    {
        for (NSString *chessrider in caster) {
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
                [caster removeObject:removechess[i]];
            }
        }
        for (NSString *chessrider in caster) {
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
                [caster removeObject:enemychess[i]];
            }
        }
    }else
    {
        for (NSString *chessrider in caster) {
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
                [caster removeObject:removechess[i]];
            }
        }
        for (NSString *chessrider in caster) {
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
                [caster removeObject:enemychess[i]];
            }
        }
        
    }
    [caster addObject:@"enemy:"];
    for (NSString *string in enemychess) {
        [caster addObject:string];
    }
    return caster;
    
    
}

@end
