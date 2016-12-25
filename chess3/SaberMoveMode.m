//
//  SaberMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/2/28.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "SaberMoveMode.h"

@interface SaberMoveMode()

@property(nonatomic)                   CGPoint position;
@property(nonatomic)                NSUInteger chess_tag;
@property(nonatomic,strong)NSMutableDictionary *chess;
@property(nonatomic,strong)           NSString *chesscolor;

@end

@implementation SaberMoveMode

+(instancetype)SaberCameFrom:(CGPoint)initLocation
                     withTag:(NSUInteger)tag
                   withColor:(NSString *)color
{
    SaberMoveMode *saber = [SaberMoveMode new];
    saber.position       = initLocation;
    saber.chess_tag      = tag;
    saber.chesscolor     = color;
    return saber;
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

-(NSMutableArray *)HowSaberGo:(CGPoint)positon
{
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    
    NSString *step_up    = [self GetPositionInString:CGPointMake(positon.x, positon.y - 30)];
    NSString *step_down  = [self GetPositionInString:CGPointMake(positon.x, positon.y + 30)];
    NSString *step_left  = [self GetPositionInString:CGPointMake(positon.x - 30, positon.y)];
    NSString *step_right = [self GetPositionInString:CGPointMake(positon.x + 30, positon.y)];
    NSMutableArray *step = [[NSMutableArray alloc]init];
    NSArray *total       = @[@"090370",@"120370",@"150370",@"090340",@"120340",@"150340",@"090310",@"120310",@"150310"];
    NSArray *choosen     = @[step_up,step_down,step_left,step_right];
    
    for (NSString *step1 in choosen) {
        for (NSString *step2 in total) {
            if ([step1 isEqualToString:step2]) {
                [step addObject:step1];
            }
        }
    }
    
    NSMutableArray *enemy  = [[NSMutableArray alloc]init];
    NSMutableArray *friend = [[NSMutableArray alloc]init];

    for (id location in step) {
        for (id key in self.chess) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess                      = [self.chess objectForKey:key];
            if ([[chess objectForKey:@"location"] isEqualToString:location]) {
                if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"]) {
                    [enemy addObject:location];
                }else
                {
                    [friend addObject:location];
                }
            }
        }
    }

    for (NSUInteger i = 0; i < enemy.count; i++) {
        [step removeObject:enemy[i]];
    }
    for (NSUInteger i = 0; i < friend.count; i++) {
        [step removeObject:friend[i]];
    }
    
    [step addObject:@"enemy:"];
    for (NSUInteger i = 0; i < enemy.count; i++) {
        [step addObject:enemy[i]];
    }
    
    NSString *RedSaber   = [self GetPositionInString:positon];
    NSString *BlackSaber = [[self.chess objectForKey:@"BedSaber"] objectForKey:@"location"];
    if ([[RedSaber substringWithRange:NSMakeRange(0, 3)] isEqualToString:[BlackSaber substringWithRange:NSMakeRange(0, 3)]]) {
        
        CGFloat red_y         = [[RedSaber substringWithRange:NSMakeRange(3, 3)] floatValue];
        CGFloat black_y       = [[BlackSaber substringWithRange:NSMakeRange(3, 3)] floatValue];
        NSMutableArray *inter = [[NSMutableArray alloc]init];
        CGFloat count         = 0.f;
        
        for (id key in self.chess) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess = [self.chess objectForKey:key];
            if ([[[chess objectForKey:@"location"] substringWithRange:NSMakeRange(0, 3)] isEqualToString:[step_up substringWithRange:NSMakeRange(0, 3)]]) {
                [inter addObject:[chess objectForKey:@"location"]];
            }
        }
        
        for (NSInteger i = 0; i < inter.count; i++) {
            CGFloat inter_f = [[inter[i] substringWithRange:NSMakeRange(3, 3)]floatValue];
            if (inter_f > black_y &&inter_f < red_y ) {
                count++;
            }
        }
        
        if (count == 0) {
            [step addObject:BlackSaber];
        }
    }
    
    
    return step;
    
}

@end
