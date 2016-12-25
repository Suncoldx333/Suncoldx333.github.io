//
//  JLAnimatedImagesView.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/12.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JLAnimatedImagesViewDefaultTimePerImage 20.0f
typedef NS_ENUM(NSUInteger, JLAnimatedType) {

    JLAnimatedType_Translation = 1,
    JLAnimatedType_Largen
};
@protocol JLAnimatedImagesViewDelegate;

@interface JLAnimatedImagesView : UIView

@property (nonatomic, assign) id<JLAnimatedImagesViewDelegate>delegate;

@property (nonatomic, assign) NSTimeInterval timePerImage;
+(instancetype)initWithFrame:(CGRect)frame
                    delegate:(id<JLAnimatedImagesViewDelegate>)delegate;


- (void)startAnimating:(JLAnimatedType)type;
- (void)stopAnimating;
- (void)reloadData;

@end


@protocol JLAnimatedImagesViewDelegate <NSObject>

- (NSInteger)animatedImagesNumberOfImages:(JLAnimatedImagesView *)animatedImagesView;
- (UIImage *)animatedImagesView:(JLAnimatedImagesView *)animatedImagesView imageAtImdex:(NSInteger)index;


@end
