//
//  MoveMode.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/6.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol gamemodepotocol <NSObject>

-(void)insertChessAtIndex:(CGPoint)path withValue:(NSString *)value withattack:(NSString *)attack withhealth:(NSString *)health withcolor:(NSString *)color withTag:(NSInteger)t_ag;


@end


@interface MoveMode : NSObject
+ (instancetype)gameModelWithDimension:(NSUInteger)dimension
                              delegate:(id<gamemodepotocol>)delegate;

-(void)insertChessAtInitLoacationPathWithValue:(BOOL)init;
-(void)insertChess:(NSString *)value
        WithAttack:(NSString *)attack
        WithHealth:(NSString *)health
       AtIndexpath:(CGPoint)path
         withcolor:(NSString *)color
           withTag:(NSInteger)t_ag;

@end
