//
//  LancerMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/2/20.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "LancerMoveMode.h"

@interface LancerMoveMode ()

@property(nonatomic)                   CGPoint position;
@property(nonatomic)                NSUInteger chess_tag;
@property(nonatomic,strong)NSMutableDictionary *chess;
@property(nonatomic,strong)           NSString *chesscolor;

@end

@implementation LancerMoveMode

+(instancetype)LancerCameFrom:(CGPoint)initLocation
                      withTag:(NSUInteger)tag
                    withColor:(NSString *)color

{
    LancerMoveMode *lancer = [LancerMoveMode new];
    lancer.position        = initLocation;
    lancer.chess_tag       = tag;
    lancer.chesscolor      = color;
    return lancer;
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

-(NSMutableArray *)HowLancerGo:(CGPoint)positon
{
    NSMutableArray *Lancer        = [[NSMutableArray alloc]init];
    NSMutableArray *Lancer_enemy  = [[NSMutableArray alloc]init];
    NSMutableArray *Lancer_remove = [[NSMutableArray alloc]init];

    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    
    if (positon.y > 220.f) {
        
        NSString *step1 = [self GetPositionInString:CGPointMake(positon.x, positon.y - 30)];
        [Lancer addObject:step1];
        
        for (id key in self.chess) {
            NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]init];
            chessDic = [self.chess objectForKey:key];
            for (id key1 in chessDic) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessDic objectForKey:key1] isEqualToString:step1]) {
                        [Lancer removeObject:step1];
                        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                            [Lancer_enemy addObject:step1];
                        }
                    }
                }
            }
        }
    }else
    {
        if (positon.x > 29) {
            NSString *step_left = [self GetPositionInString:CGPointMake(positon.x - 30, positon.y)];
            [Lancer addObject:step_left];
        }
        if (positon.x < 239) {
            NSString *step_right = [self GetPositionInString:CGPointMake(positon.x + 30, positon.y)];
            [Lancer addObject:step_right];
        }
        if (positon.y > 100) {
            NSString *step_up = [self GetPositionInString:CGPointMake(positon.x, positon.y - 30)];
            [Lancer addObject:step_up];
        }
        
    }
    
    for (id location in Lancer) {
        for (id key in self.chess) {
            NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]init];
            chessDic                      = [self.chess objectForKey:key];
            for (id key1 in chessDic) {
                if ([key1 isEqualToString:@"location"]) {
                    if ([[chessDic objectForKey:key1]isEqualToString:location]) {
                        [Lancer_remove addObject:location];
                        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                            [Lancer_enemy addObject:location];
                        }
                    }
                }
            }
        }
    }
    
    for (id remove in Lancer_remove) {
        [Lancer removeObject:remove];
    }
    
    [Lancer addObject:@"enemy:"];
    for (NSUInteger i = 0; i < Lancer_enemy.count; i++) {
        [Lancer addObject:Lancer_enemy[i]];
    }
    
    return Lancer;
}

@end
