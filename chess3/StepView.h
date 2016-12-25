//
//  StepView.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol wheredidIpressedProtocol <NSObject>

-(void) wheredidIpressed:(CGPoint)position withTag:(NSUInteger)tag;

@end

@interface StepView : UIView

@property(nonatomic,strong) NSString *stepvalue;
@property(nonatomic) CGPoint position;

+(instancetype) chessforposion:(CGPoint)posion
                    sidelength:(NSInteger)side
                  cornerRadius:(NSInteger)cornerRadius
                         value:(NSString *)value
                    chesscolor:(UIColor *)chesscolor
                       withTag:(NSUInteger)tag
                      delegate:(id<wheredidIpressedProtocol>) delegate;

@end
