//
//  AssassinMoveMode.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AssassinMoveMode : NSObject

+(instancetype)AssassinCameFrom:(CGPoint)initLocation
                        withTag:(NSUInteger)tag
                      withColor:(NSString *)color;
-(NSMutableArray *)HowAssassinGo:(CGPoint)positon;

@end
