//
//  SaberMoveMode.h
//  chess3
//
//  Created by WangZhaoyun on 16/2/28.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaberMoveMode : NSObject

+(instancetype)SaberCameFrom:(CGPoint)initLocation
                      withTag:(NSUInteger)tag
                    withColor:(NSString *)color;
-(NSMutableArray *)HowSaberGo:(CGPoint)positon;


@end
