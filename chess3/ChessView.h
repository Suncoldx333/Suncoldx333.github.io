//
//  ChessView.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol chessViewProtocol <NSObject>

-(void)WhereCanChessGo123:(CGPoint)position withMessage:(NSArray *)message;
-(BOOL)IsAnyStepHere;
-(BOOL)IsStillTheChess:(NSUInteger)tag;
-(void)RemoveAllStep;

@end

@interface ChessView : UIView

@property (nonatomic) NSString *tileValue;
@property (nonatomic) NSString *attackValue;
@property (nonatomic) NSString *healthValue;

@property(nonatomic) CGPoint position;

+ (instancetype)ChessForPosition:(CGPoint)position//位置
                      sideLength:(CGFloat)side
                    cornerRadius:(CGFloat)cornerRadius
                           value:(NSString *)value
                          attack:(NSString *)attack
                          health:(NSString *)health
                      ChessColor:(NSString *)chesscolor
                         withTag:(NSInteger)tag
                        delegate:(id<chessViewProtocol>)delegate;

@end
