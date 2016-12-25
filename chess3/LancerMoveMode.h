//
//  LancerMoveMode.h
//  chess3
//
//  Created by WangZhaoyun on 16/2/20.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LancerMoveMode : NSObject

+(instancetype)LancerCameFrom:(CGPoint)initLocation
                      withTag:(NSUInteger)tag
                    withColor:(NSString *)color;
-(NSMutableArray *)HowLancerGo:(CGPoint)positon;

@end
