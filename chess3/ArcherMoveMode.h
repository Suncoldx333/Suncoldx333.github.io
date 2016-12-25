//
//  ArcherMoveMode.h
//  chess3
//
//  Created by WangZhaoyun on 16/2/17.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ArcherMoveMode : NSObject

+(instancetype)ArcherCameFrom:(CGPoint)initLocation
                     withTag:(NSUInteger)tag
                   withColor:(NSString *)color;
-(NSMutableArray *)HowArcherGo:(CGPoint)positon;

@end
