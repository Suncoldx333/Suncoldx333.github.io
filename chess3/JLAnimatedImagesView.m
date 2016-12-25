//
//  JLAnimatedImagesView.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/12.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//


#import "JLAnimatedImagesView.h"

#define noImageDisplayingIndex 1
#define imageSwappingAnimationDuration 2.0f
#define imageViewsborderOffset 50

@interface JLAnimatedImagesView()<JLAnimatedImagesViewDelegate>
{
    JLAnimatedType animatedType;
    BOOL animating;
    NSUInteger totalImages;
    NSUInteger currentlyDisplayingImageViewIndex;
    NSUInteger currentlyDisplayingImageIndex;
}

@property (nonatomic, strong) NSArray *imageViews;
@property (nonatomic, strong) NSTimer *imageSwappingTimer;




- (void)_init;

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber;

@end

@implementation JLAnimatedImagesView


+(instancetype)initWithFrame:(CGRect)frame
                    delegate:(id<JLAnimatedImagesViewDelegate>)delegate
{
    JLAnimatedImagesView *AnimatedImagesView = [[[self class] alloc] initWithFrame:frame];
    AnimatedImagesView.delegate = delegate;
    [AnimatedImagesView _init];
    return AnimatedImagesView;
}



-(void)_init
{
    NSMutableArray *imageViews = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-imageViewsborderOffset * 3.3, -imageViewsborderOffset, self.bounds.size.width, self.bounds.size.height )];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-imageViewsborderOffset * 3.3, -imageViewsborderOffset, self.bounds.size.width + (imageViewsborderOffset * 2), self.bounds.size.height + (imageViewsborderOffset * 2))];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = NO;
        [self addSubview:imageView];
        
        [imageViews addObject:imageView];
    }
    
    self.imageViews = [imageViews copy];
    
    currentlyDisplayingImageIndex = noImageDisplayingIndex;
}

-(void)startAnimating:(JLAnimatedType)type
{
    if (!animating) {
        animating = YES;
        animatedType = type;
        [self.imageSwappingTimer fire];
    }
}

- (void)bringNextImage
{
    UIImageView *imageViewToHide = [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    currentlyDisplayingImageViewIndex = currentlyDisplayingImageViewIndex == 0 ? 1 : 0;
    UIImageView *imageViewToShow = [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    totalImages = 2;
    NSUInteger nextImageToShowIndex = currentlyDisplayingImageIndex;
    
    do {
        nextImageToShowIndex = [[self class] randomIntBetweenNumber:0 andNumber:totalImages - 1];
    } while (nextImageToShowIndex == currentlyDisplayingImageIndex);
    
    currentlyDisplayingImageIndex = nextImageToShowIndex;
    
    imageViewToShow.image = [self.delegate animatedImagesView:self imageAtImdex:nextImageToShowIndex];
    
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    
    if (animatedType == JLAnimatedType_Translation) {
        [UIView animateWithDuration:self.timePerImage + imageSwappingAnimationDuration + kMovementAndTransitionTimeOffset delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
            NSInteger randomTranslationValueX = imageViewsborderOffset * 3.5 - [[self class] randomIntBetweenNumber:0 andNumber:imageViewsborderOffset];
            NSInteger randomTranslationValueY = 0;
            
            CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
            
            CGFloat randomScaleTransformValue = [[self class] randomIntBetweenNumber:115 andNumber:120]/100;
            
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
            
            imageViewToShow.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
            
        } completion:nil];
        
        
        [UIView animateWithDuration:imageSwappingAnimationDuration delay:kMovementAndTransitionTimeOffset options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
            imageViewToShow.alpha = 1;
            imageViewToHide.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                imageViewToHide.transform = CGAffineTransformIdentity;
            }
        }];
    }
    else if (animatedType == JLAnimatedType_Largen) {
        [UIView animateWithDuration:self.timePerImage + imageSwappingAnimationDuration + kMovementAndTransitionTimeOffset
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                         animations:^
         {
             NSInteger randomTranslationValueX = [[self class] randomIntBetweenNumber:0 andNumber:imageViewsborderOffset] - imageViewsborderOffset;
             NSInteger randomTranslationValueY = [[self class] randomIntBetweenNumber:0 andNumber:imageViewsborderOffset] - imageViewsborderOffset;
             
             CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
             
             CGFloat randomScaleTransformValue = [[self class] randomIntBetweenNumber:115 andNumber:120] / 100.0f;
             
             CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
             
             imageViewToShow.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
         }
                         completion:NULL];
        
        [UIView animateWithDuration:imageSwappingAnimationDuration
                              delay:kMovementAndTransitionTimeOffset
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                         animations:^
         {
             imageViewToShow.alpha = 1.0;
             imageViewToHide.alpha = 0.0;
         }
                         completion:^(BOOL finished)
         {
             if (finished)
             {
                 imageViewToHide.transform = CGAffineTransformIdentity;
             }
         }];
    }
    
}

-(void)reloadData
{
    totalImages = [self.delegate animatedImagesNumberOfImages:self];
    
    [self.imageSwappingTimer fire];
}


-(void)stopAnimating
{
    if (animating) {
        [_imageSwappingTimer invalidate];
        _imageSwappingTimer = nil;
        
        [UIView animateWithDuration:imageSwappingAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            for (UIImageView *imageView in self.imageViews) {
                imageView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            currentlyDisplayingImageIndex = noImageDisplayingIndex;
            animating = NO;
        }];
    }
}


-(NSTimeInterval)timePerImage
{
    if (_timePerImage == 0) {
        return JLAnimatedImagesViewDefaultTimePerImage;
    }
    return _timePerImage;
}

-(void)setDelegate:(id<JLAnimatedImagesViewDelegate>)delegate
{
    if (delegate != _delegate) {
        _delegate = delegate;
        totalImages = [_delegate animatedImagesNumberOfImages:self];
    }
}

-(NSTimer *)imageSwappingTimer
{
    if (!_imageSwappingTimer) {
        _imageSwappingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timePerImage target:self selector:@selector(bringNextImage) userInfo:nil repeats:YES];
    }
    return _imageSwappingTimer;
}

+(NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    
    return i;
}

#pragma mark - Memory Management

-(void)dealloc
{
    [_imageSwappingTimer invalidate];
}



@end











