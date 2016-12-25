//
//  GameboardView.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HowChessGoProtocol <NSObject>

-(NSMutableArray *) HowBerserkerGo:(CGPoint)position;
-(void)sendStepInfo:(NSMutableArray *)Info;

@end

@interface GameboardView : UIView

+ (instancetype)gameboardWithDimension:(NSUInteger)dimension
                             cellWidth:(CGFloat)width
                           cellPadding:(CGFloat)padding
                          cornerRadius:(CGFloat)cornerRadius
                       backgroundColor:(UIColor *)backgroundColor
                       foregroundColor:(UIColor *)foregroundColor
                              delegate:(id<HowChessGoProtocol>)delegate;

- (void)insertChessAtIndexPath:(CGPoint)path
                     withValue:(NSString *)value
                    withattack:(NSString *)attack
                    withhealth:(NSString *)health
                     withColor:(NSString *)color
                       withTag:(NSInteger)t_ag;

-(void)WhereCanChessGo123:(CGPoint)position withMessage:(NSArray *)message;
-(void)WhereCanChessGo:(CGPoint)position withTag:(NSUInteger)tag;
-(void) wheredidIpressed:(CGPoint)position withTag:(NSUInteger)tag;
-(BOOL)IsAnyStepHere;
-(void)RemoveAllStep;
-(BOOL)IsStillTheChess:(NSUInteger)tag;
-(void)playBlack:(NSMutableArray *)BlackInfo;
@end
