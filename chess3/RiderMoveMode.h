//
//  RiderMoveMode.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RiderMoveMode : NSObject

+(instancetype)RiderCameFrom:(CGPoint)initLocation
                     withTag:(NSUInteger)tag
                   withColor:(NSString *)color;
-(NSMutableArray *)HowRiderGo:(CGPoint)positon;

@end
