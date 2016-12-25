//
//  RiderMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "RiderMoveMode.h"

@interface RiderMoveMode ()

@property(nonatomic)                    CGPoint initLocation;
@property(nonatomic)                 NSUInteger tag;
@property(nonatomic,strong) NSMutableDictionary *chess;
@property(nonatomic,strong)            NSString *chesscolor;

@end

@implementation RiderMoveMode

+(instancetype)RiderCameFrom:(CGPoint)initLocation
                     withTag:(NSUInteger)tag
                   withColor:(NSString *)color
{
    RiderMoveMode *riderMoveMode = [RiderMoveMode new];
    riderMoveMode.initLocation   = initLocation;
    riderMoveMode.tag            = tag;
    riderMoveMode.chesscolor     = color;
    return riderMoveMode;
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
    
    if (position.x >=0 && position.x <=240 && position.y<=370 && position.y>=100 )
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

-(NSMutableArray *)HowRiderGo:(CGPoint)positon
{
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableArray *chessposition_B = [[NSMutableArray alloc]init];
    NSMutableArray *chessposition_R = [[NSMutableArray alloc]init];
    NSMutableArray *chessposition   = [[NSMutableArray alloc]init];
    
    NSMutableArray *rider = [[NSMutableArray alloc]init];
    
    CGPoint rider1_1 = CGPointMake(self.initLocation.x+60, self.initLocation.y+30);
    CGPoint rider1_2 = CGPointMake(self.initLocation.x+60, self.initLocation.y-30);
    [rider addObject:[self GetPositionInString:rider1_1]];
    [rider addObject:[self GetPositionInString:rider1_2]];
    CGPoint rider1_break = CGPointMake(self.initLocation.x+30, self.initLocation.y);
    
    CGPoint rider2_1 = CGPointMake(self.initLocation.x+30, self.initLocation.y+60);
    CGPoint rider2_2 = CGPointMake(self.initLocation.x-30, self.initLocation.y+60);
    [rider addObject:[self GetPositionInString:rider2_1]];
    [rider addObject:[self GetPositionInString:rider2_2]];
    CGPoint rider2_break = CGPointMake(self.initLocation.x, self.initLocation.y+30);
    
    CGPoint rider3_1 = CGPointMake(self.initLocation.x-60, self.initLocation.y+30);
    CGPoint rider3_2 = CGPointMake(self.initLocation.x-60, self.initLocation.y-30);
    [rider addObject:[self GetPositionInString:rider3_1]];
    [rider addObject:[self GetPositionInString:rider3_2]];
    CGPoint rider3_break = CGPointMake(self.initLocation.x-30, self.initLocation.y);
    
    CGPoint rider4_1 = CGPointMake(self.initLocation.x-30, self.initLocation.y-60);
    CGPoint rider4_2 = CGPointMake(self.initLocation.x+30, self.initLocation.y-60);
    [rider addObject:[self GetPositionInString:rider4_1]];
    [rider addObject:[self GetPositionInString:rider4_2]];
    CGPoint rider4_break = CGPointMake(self.initLocation.x, self.initLocation.y-30);
    
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
    
    
    for (NSString *string in chessposition) {
        if ([[self GetPositionInString:rider1_break] isEqualToString:string]) {
            [rider removeObject:[self GetPositionInString:rider1_1]];
            [rider removeObject:[self GetPositionInString:rider1_2]];
        }
        if ([[self GetPositionInString:rider2_break] isEqualToString:string]) {
            [rider removeObject:[self GetPositionInString:rider2_1]];
            [rider removeObject:[self GetPositionInString:rider2_2]];
        }
        if ([[self GetPositionInString:rider3_break] isEqualToString:string]) {
            [rider removeObject:[self GetPositionInString:rider3_1]];
            [rider removeObject:[self GetPositionInString:rider3_2]];
        }
        if ([[self GetPositionInString:rider4_break] isEqualToString:string]) {
            [rider removeObject:[self GetPositionInString:rider4_1]];
            [rider removeObject:[self GetPositionInString:rider4_2]];
        }
    }
    
    NSMutableArray *removechess2 = [[NSMutableArray alloc]initWithCapacity:999];
    for (NSString *string in rider) {
        if (string.length != 6) {
            [removechess2 addObject:string];
        }
    }
    if ([removechess2 count] != 0)
    {
        for (NSUInteger i = 0; i < [removechess2 count]; i++)
        {
            [rider removeObject:removechess2[i]];
        }
    }
    
    NSMutableArray *removechess = [[NSMutableArray alloc]initWithCapacity:999];
    NSMutableArray *enemychess = [[NSMutableArray alloc]initWithCapacity:999];
    if ([self.chesscolor isEqualToString:@"R"])  //如果棋子是红色的，删除所有红色的可走位置，留下黑色的可走位置
    {
        for (NSString *chessrider in rider) {
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
                [rider removeObject:removechess[i]];
            }
        }
        for (NSString *chessrider in rider) {
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
                [rider removeObject:enemychess[i]];
            }
        }
    }else
    {
        for (NSString *chessrider in rider) {
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
                [rider removeObject:removechess[i]];
            }
        }
        for (NSString *chessrider in rider) {
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
                [rider removeObject:enemychess[i]];
            }
        }
        
    }
    [rider addObject:@"enemy:"];
    for (NSString *string in enemychess) {
        [rider addObject:string];
    }
    return rider;
    
    
}

@end
