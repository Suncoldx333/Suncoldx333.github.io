//
//  MoveMode.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/6.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "MoveMode.h"

@interface MoveMode ()

@property (nonatomic, weak) id<gamemodepotocol> delegate;
@property (nonatomic, strong)    NSMutableArray *gameState;
@property (nonatomic)                NSUInteger dimension;
@property (nonatomic, strong)    NSMutableArray *commandQueue;
@property (nonatomic, strong)           NSTimer *queueTimer;
@property (nonatomic, readwrite)      NSInteger score;
@property(nonatomic,strong) NSMutableDictionary *RedchessDic;
@property(nonatomic,strong) NSMutableDictionary *BlackchessDic;


@end

@implementation MoveMode

+ (instancetype)gameModelWithDimension:(NSUInteger)dimension
                              delegate:(id<gamemodepotocol>)delegate {
    MoveMode *model = [MoveMode new];
    model.dimension = dimension;
    model.delegate  = delegate;
    return model;
}

- (void)reset {
    self.score = 0;
    self.gameState = nil;
    [self.commandQueue removeAllObjects];
    [self.queueTimer invalidate];
    self.queueTimer = nil;
}


-(void)insertChessAtInitLoacationPathWithValue:(BOOL)init
{
    if (init) {
        NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plist    = [paths objectAtIndex:0];
        NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
        self.RedchessDic   = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
        
        for (id key in self.RedchessDic) {
            CGFloat x = 0.0;
            CGFloat y = 0.0;
            NSString *ChessColor;
            NSString *chessValue;
            NSString *ChessAttack;
            NSString *ChessHealth;
            NSInteger t_ag = 0;
            
            if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"R"]) {
                ChessColor = @"R";
            }else
            {
                ChessColor = @"B";
            }
            NSMutableDictionary *chessNameAndLocation = [self.RedchessDic objectForKey:key];
            for (id key in chessNameAndLocation) {
                
                if ([key isEqualToString:@"location"]) {
                    x    = [[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(0, 3)] floatValue];
                    y    = [[[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(3, 3)] floatValue];
                    t_ag = [[chessNameAndLocation objectForKey:key] integerValue];
                }
                if ([key isEqualToString:@"name"]) {
                    chessValue = [[chessNameAndLocation objectForKey:key] substringWithRange:NSMakeRange(0, 1)];

                }
                if ([key isEqualToString:@"attack"]) {
                    ChessAttack = [chessNameAndLocation objectForKey:key];
                }
                if ([key isEqualToString:@"health"]) {
                    ChessHealth = [chessNameAndLocation objectForKey:key];
                }
            }
            [self insertChess:chessValue WithAttack:ChessAttack WithHealth:ChessHealth AtIndexpath:CGPointMake(x, y) withcolor:ChessColor withTag:t_ag];


        }
    }
}

-(void)insertChess:(NSString *)value
        WithAttack:(NSString *)attack
        WithHealth:(NSString *)health
       AtIndexpath:(CGPoint)path
         withcolor:(NSString *)color
           withTag:(NSInteger)t_ag;
{
    [self.delegate insertChessAtIndex:path withValue:value withattack:attack withhealth:health withcolor:color withTag:t_ag];
}

@end
