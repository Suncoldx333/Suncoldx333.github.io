//
//  BerserkerMoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "BerserkerMoveMode.h"

@interface BerserkerMoveMode ()

@property(nonatomic)                    CGPoint initLocation;
@property(nonatomic)                    CGPoint nextLocation;
@property(nonatomic,strong) NSMutableDictionary *chessDic;
@property(nonatomic)                 NSUInteger Tag;
@property(nonatomic,strong)            NSString *name;
@property(nonatomic,strong) NSMutableDictionary *chess;
@property(nonatomic,strong)            NSString *chesscolor;

@end

@implementation BerserkerMoveMode

+(instancetype)BerserkerCameFrom:(CGPoint)initLocation
                         withTag:(NSUInteger)tag
                       withColor:(NSString *)color
{
    BerserkerMoveMode *berserkermovemode = [BerserkerMoveMode new];
    berserkermovemode.Tag                = tag;
    berserkermovemode.initLocation       = initLocation;
    berserkermovemode.chesscolor         = color;
    
    return berserkermovemode;
}

-(NSMutableArray *)maopao:(NSMutableArray *)array
{
    BOOL finish =YES;
    for (int a= 1; a<=[array count]&&finish; a++) {
        finish = NO;
        for (NSUInteger b=(array.count - 1); b>=a; b--) {
            if ([[array objectAtIndex:b] floatValue] > [[array objectAtIndex:b-1] floatValue]) {
                [array exchangeObjectAtIndex:b withObjectAtIndex:b-1];
                finish =YES;
            }
        }
    }
    return array;
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

-(NSMutableArray *)HowBerserkerGo:(CGPoint)position
{
    NSMutableArray *positionInString = [[NSMutableArray alloc]init];
    NSMutableArray *x                = [[NSMutableArray alloc]init];
    NSMutableArray *y                = [[NSMutableArray alloc]init];
    NSString *init_y;
    NSString *init_x;
    NSMutableArray *little_y        = [[NSMutableArray alloc]init];
    NSMutableArray *big_y           = [[NSMutableArray alloc]init];
    NSMutableArray *little_x        = [[NSMutableArray alloc]init];
    NSMutableArray *big_x           = [[NSMutableArray alloc]init];
    NSMutableArray *little_y1       = [[NSMutableArray alloc]init];
    NSMutableArray *big_y1          = [[NSMutableArray alloc]init];
    NSMutableArray *little_x1       = [[NSMutableArray alloc]init];
    NSMutableArray *big_x1          = [[NSMutableArray alloc]init];
    NSMutableArray *chessposition_B = [[NSMutableArray alloc]init];
    NSMutableArray *chessposition_R = [[NSMutableArray alloc]init];
    
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [paths objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    self.chess         = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
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
    //遍历plist，找出各个棋子，为Dic格式
    for (id key in self.chess) {
        NSMutableDictionary *chessNameAndLocation = [self.chess objectForKey:key];
        //遍历棋子的属性，包括name和location
        for (id key in chessNameAndLocation) {
            //找出与选定棋子横坐标一致的所有棋子，绘制能够走得所有位置
            if ([key isEqualToString:@"location"]) {
                if ([[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(0, 3)] floatValue] == self.initLocation.x){
                    //y = [[NSMutableArray alloc]initWithCapacity:90];
                    [y addObject:[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(3, 3)]];
                }
                if ([[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(3, 3)] floatValue] == self.initLocation.y) {
                    [x addObject:[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(0, 3)]];
                    
                }
            }
        }
    }
    init_y = [NSString stringWithFormat:@"%f",self.initLocation.y];
    init_x = [NSString stringWithFormat:@"%f",self.initLocation.x];
    
    
    //将y比选定車大/小的放在一个数组，进行冒泡，选择想要的位置。
    for (int i =0; i<[y count]; i++) {
        
        
        if ([init_y floatValue] > [y[i] floatValue]) {
            [little_y addObject:y[i]];
            
        } else{
            if([init_y floatValue] < [y[i] floatValue]){
                [big_y addObject:y[i]];
            }
        }
    }
    
    for (int i =0; i<[x count]; i++) {
        
        
        if ([init_x floatValue] > [x[i] floatValue]) {
            [little_x addObject:x[i]];
        } else{
            if ([init_x floatValue] < [x[i] floatValue]) {
                [big_x addObject:x[i]];
            }
        }
    }
    little_x1 = [little_x copy];
    little_y1 = [little_y copy];
    big_x1    = [big_x copy];
    big_y1    = [big_y copy];
    
    if ([little_y count] == 0) {
        CGFloat i ;
        for (i = self.initLocation.y; i>=100; i= i-30) {
            NSString *j  = [NSString stringWithFormat:@"%f",i];
            int f        = [j intValue];
            NSString *j2 = [NSString stringWithFormat:@"%i",f];
            [little_y addObject:j2];
        }
    }
    if ([big_y count] == 0) {
        CGFloat i ;
        for (i = self.initLocation.y; i<=370; i= i+30) {
            NSString *j  = [NSString stringWithFormat:@"%f",i];
            int f        = [j intValue];
            NSString *j2 = [NSString stringWithFormat:@"%i",f];
            [big_y addObject:j2];
        }
    }
    if ([little_x count] == 0) {
        CGFloat i ;
        for (i = self.initLocation.x; i>=0; i= i-30) {
            NSString *j  = [NSString stringWithFormat:@"%f",i];
            int f        = [j intValue];
            NSString *j2 = [NSString stringWithFormat:@"%i",f];
            [little_x addObject:j2];
        }
    }
    if ([big_x count] == 0) {
        CGFloat i ;
        for (i = self.initLocation.x; i<=240; i= i+30) {
            NSString *j  = [NSString stringWithFormat:@"%f",i];
            int f        = [j intValue];
            NSString *j2 = [NSString stringWithFormat:@"%i",f];
            [big_x addObject:j2];
        }
    }
    
    NSUInteger tag_step = 400;
    //绘制可以走的位置
    NSMutableArray *enemy_chess = [[NSMutableArray alloc]init];
    if (little_y.count != 0)  {
        CGFloat count1;
        if ([little_y1 count] == 0) {
            count1 = ([init_y floatValue] - [[self maopao:little_y][little_y.count -1] floatValue])/30;
        }else
        {
            count1        = ([init_y floatValue] - [[self maopao:little_y][0] floatValue])/30-1;
            CGPoint enemy = CGPointMake(self.initLocation.x, [[self maopao:little_y][0] floatValue]);
            [enemy_chess addObject:[self GetPositionInString:enemy]];
        }
        for (CGFloat c=1; c<=count1; c++) {
            CGFloat f        = self.initLocation.y - c*30;
            CGPoint position = CGPointMake(self.initLocation.x, f);
            [positionInString addObject:[self GetPositionInString:position]];
            //                [self.delegate WhereCanBerserkerGo:position withTag:tag_step];
            tag_step++;
        }
    }
    
    if (big_y.count != 0) {
        CGFloat count2;
        if (big_y1.count == 0) {
            count2 = ([[self maopao:big_y][0] floatValue]-[init_y floatValue])/30;
        }
        else
        {
            count2        = ([[self maopao:big_y][big_y.count - 1] floatValue]-[init_y floatValue])/30-1;
            CGPoint enemy = CGPointMake(self.initLocation.x, [[self maopao:big_y][big_y.count - 1] floatValue]);
            [enemy_chess addObject:[self GetPositionInString:enemy]];
        }
        
        for (CGFloat c=1; c<=count2; c++) {
            CGFloat f        = self.initLocation.y + c*30;
            CGPoint position = CGPointMake(self.initLocation.x, f);
            [positionInString addObject:[self GetPositionInString:position]];
            //                [self.delegate WhereCanBerserkerGo:position withTag:tag_step];
            tag_step++;
        }
    }
    if (little_x.count != 0) {
        CGFloat count3;
        if (little_x1.count == 0) {
            count3 = ([init_x floatValue] - [[self maopao:little_x][little_x.count -1] floatValue])/30;
        }
        else{
            count3        = ([init_x floatValue] - [[self maopao:little_x][0] floatValue])/30-1;
            CGPoint enemy = CGPointMake([[self maopao:little_x][0] floatValue], self.initLocation.y);
            [enemy_chess addObject:[self GetPositionInString:enemy]];
        }
        for (CGFloat c=1; c<=count3; c++) {
            CGFloat f        = self.initLocation.x - c*30;
            CGPoint position = CGPointMake(f,self.initLocation.y);
            [positionInString addObject:[self GetPositionInString:position]];
            //                [self.delegate WhereCanBerserkerGo:position withTag:tag_step];
            tag_step++;
        }
    }
    if (big_x.count !=0)  {
        CGFloat count4;
        if (big_x1.count == 0) {
            count4 = ([[self maopao:big_x][0] floatValue] - [init_x floatValue])/30;
        }
        else{
            count4        = ([[self maopao:big_x][big_x.count -1] floatValue] - [init_x floatValue])/30-1;
            CGPoint enemy = CGPointMake([[self maopao:big_x][big_x.count -1] floatValue], self.initLocation.y);
            [enemy_chess addObject:[self GetPositionInString:enemy]];
        }
        for (CGFloat c=1; c<=count4; c++) {
            CGFloat f        = self.initLocation.x + c*30;
            CGPoint position = CGPointMake(f, self.initLocation.y);
            [positionInString addObject:[self GetPositionInString:position]];
            //                [self.delegate WhereCanBerserkerGo:position withTag:tag_step];
            tag_step++;
        }
    }
    [positionInString addObject:@"enemy:"];
    NSMutableArray *enemy_array = [[NSMutableArray alloc]init];
    if ([self.chesscolor isEqualToString:@"R"]) {
        
        for (NSString *chess in chessposition_B) {
            for (NSString *enemy in enemy_chess) {
                if ([enemy isEqualToString:chess]) {
                    [enemy_array addObject:enemy];
                }
            }
        }
    }else
    {
        
        for (NSString *chess in chessposition_R) {
            for (NSString *enemy in enemy_chess) {
                if ([enemy isEqualToString:chess]) {
                    [enemy_array addObject:enemy];
                }
            }
        }
    }
    
    for (NSString *enemy in enemy_array) {
        [positionInString addObject:enemy];
    }
    return positionInString;
}
@end
