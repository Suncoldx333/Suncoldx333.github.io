//
//  StepView.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/9.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "StepView.h"
#import <string.h>

@interface StepView ()

@property (nonatomic, readonly) UIColor *defaultBackgroundColor;
@property (nonatomic, readonly) UIColor *defaultNumberColor;
@property (nonatomic, strong)   UILabel *numberLabel;
@property(nonatomic)            CGFloat cornerRadius;
@property (nonatomic)          NSString *value;
@property(nonatomic,strong)     UIColor *whatischesscolor;
@property(nonatomic,weak)id<wheredidIpressedProtocol> delegate;

@end

@implementation StepView

+(instancetype) chessforposion:(CGPoint)position
                    sidelength:(NSInteger)side
                  cornerRadius:(NSInteger)cornerRadius
                         value:(NSString *)value
                    chesscolor:(UIColor *)chesscolor
                       withTag:(NSUInteger)tag
                      delegate:(id<wheredidIpressedProtocol>)delegate{
    StepView *tile = [[[self class] alloc] initWithFrame:CGRectMake(position.x,
                                                                    position.y,
                                                                    side,
                                                                    side)];
    tile.stepvalue        = value;
    tile.position         = position;
    tile.whatischesscolor = chesscolor;
    if ([tile.stepvalue isEqualToString:@""]) {
        tile.backgroundColor = [UIColor blueColor];
    }else
    {
        tile.backgroundColor = [UIColor blueColor];
    }
    tile.numberLabel.textColor = [UIColor blueColor];
    tile.layer.cornerRadius    = cornerRadius ;
    tile.value                 = value;
    [tile setChessMove2];
    tile.tag      = tag;
    tile.delegate = delegate;
    return tile;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               5,
                                                               20,
                                                               20)];
    label.textAlignment      = NSTextAlignmentCenter;
    label.minimumScaleFactor = 0.1;
    [self addSubview:label];
    self.numberLabel = label;
    return self;
}

- (void)setStepvalue:(NSString *)stepvalue{
    _stepvalue            = stepvalue;
    self.numberLabel.text = stepvalue;
    self.value            = stepvalue;
}
- (void)setPosition:(CGPoint)position{
    _position = position;
}
- (UIColor *)defaultBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)defaultNumberColor {
    return [UIColor blackColor];
}

-(void)setChessMove2
{
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touched34)];
    tapgesture.delegate = self;
    [self addGestureRecognizer:tapgesture];
}

-(void)touched34
{
    NSArray *path_Turn           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_Turn         = [path_Turn objectAtIndex:0];
    NSString *filename_Turn      = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
    NSMutableDictionary *turnDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Turn];
    
    [turnDic setObject:@"NO" forKey:@"turn"];
    [turnDic writeToFile:filename_Turn atomically:NO];
    
    [self.delegate wheredidIpressed:CGPointMake(self.frame.origin.x, self.frame.origin.y) withTag:self.tag];
    return;
}

@end
