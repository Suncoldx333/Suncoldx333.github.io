//
//  DrawerViewController.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/14.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "DrawerViewController.h"
#import "ICSDropShadowView.h"


static const CGFloat kICSDrawerControllerDrawerDepth = 260.0f;
static const CGFloat kICSDrawerControllerLeftViewInitialOffset = -60.0f;
static const NSTimeInterval kICSDrawerControllerAnimationDuration = 0.5;
static const CGFloat kICSDrawerControllerOpeningAnimationSpringDamping = 0.7f;
static const CGFloat kICSDrawerControllerOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat kICSDrawerControllerClosingAnimationSpringDamping = 1.0f;
static const CGFloat kICSDrawerControllerClosingAnimationSpringInitialVelocity = 0.5f;


typedef NS_ENUM(NSUInteger,DrawerControllerState)
{
    DrawerControllerStateClosed = 0,
    DrawerControllerStateOpen,
    DrawerControllerStateOpening,
    DrawerControllerStateClosing
};

@interface DrawerViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,assign)DrawerControllerState *drawerState;
@property(nonatomic,strong,readwrite)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *leftViewController;
@property(nonatomic,strong,readwrite)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *centerViewController;
@property(nonatomic,strong,readwrite)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *chooseViewController;
@property(nonatomic,strong,readwrite)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *playViewController;
@property(nonatomic,strong)                  UIView *leftView;
@property(nonatomic,strong)                  UIView *centerView;
@property(nonatomic,strong)                  UIView *chooseView;
@property(nonatomic,strong)                  UIView *playView;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, assign) CGPoint panGestureStartLocation;


@end

@implementation DrawerViewController

-(id)initWithLeftViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) leftViewController
           CenterViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) centerViewController
           ChooseViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) chooseViewController
             PlayViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) playViewController
{
    self = [super init];
    if (self) {
        _leftViewController   = leftViewController;
        _centerViewController = centerViewController;
        _chooseViewController = chooseViewController;
        _playViewController   = playViewController;
        
        if ([_leftViewController respondsToSelector:@selector(setDrawer:)]) {
            _leftViewController.drawer = self;
        }
        if ([_centerViewController respondsToSelector:@selector(setDrawer:)]) {
            _centerViewController.drawer = self;
        }
        if ([_chooseViewController respondsToSelector:@selector(setDrawer:)]) {
            _chooseViewController.drawer = self;
        }
        if ([_playViewController respondsToSelector:@selector(setDrawer:)]) {
            _playViewController.drawer = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftView   =[[UIView alloc] init];
    self.centerView = [[ICSDropShadowView alloc] initWithFrame:self.view.bounds];
    self.chooseView = [[UIView alloc] init];
    self.playView   = [[UIView alloc] init];
    

    [self addCenterViewController];
    [self.view addSubview:self.centerView];
}


-(void)addCenterViewController
{
    
    [self addChildViewController:self.centerViewController];
    self.centerViewController.view.frame = self.view.bounds;
    [self.centerView addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];
}

- (void)setupGestureRecognizers
{
    NSParameterAssert(self.centerView);
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
    
    [self.centerView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)addClosingGestureRecognizers
{
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.panGestureRecognizer);
    
    [self.centerView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)removeClosingGestureRecognizers
{
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.panGestureRecognizer);
    
    [self.centerView removeGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark Tap to close the drawer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self close];
    }
}

#pragma mark Pan to open/close the drawer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    if (self.drawerState == DrawerControllerStateClosed && velocity.x > 0.0f) {
        return YES;
    }
    else if (self.drawerState == DrawerControllerStateClosed && velocity.x < 0.0f) {
        return YES;
    }
    
    return NO;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    
    UIGestureRecognizerState state = panGestureRecognizer.state;
    CGPoint location = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
            self.panGestureStartLocation = location;
            if (self.drawerState == DrawerControllerStateClosed) {
                [self willOpen];
            }
            else {
                [self willClose];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.drawerState == DrawerControllerStateOpening) {
                delta = location.x - self.panGestureStartLocation.x;
            }
            else if (self.drawerState == DrawerControllerStateClosing) {
                delta = kICSDrawerControllerDrawerDepth - (self.panGestureStartLocation.x - location.x);
            }
            
            CGRect l = self.leftView.frame;
            CGRect c = self.centerView.frame;
            if (delta > kICSDrawerControllerDrawerDepth) {
                l.origin.x = 0.0f;
                c.origin.x = kICSDrawerControllerDrawerDepth;
            }
            else if (delta < 0.0f) {
                l.origin.x = kICSDrawerControllerLeftViewInitialOffset;
                c.origin.x = 0.0f;
            }
            else {
                // While the centerView can move up to kICSDrawerControllerDrawerDepth points, to achieve a parallax effect
                // the leftView has move no more than kICSDrawerControllerLeftViewInitialOffset points
                l.origin.x = kICSDrawerControllerLeftViewInitialOffset
                - (delta * kICSDrawerControllerLeftViewInitialOffset) / kICSDrawerControllerDrawerDepth;
                
                c.origin.x = delta;
            }
            
            self.leftView.frame = l;
            self.centerView.frame = c;
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            
            if (self.drawerState == DrawerControllerStateOpening) {
                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation == kICSDrawerControllerDrawerDepth) {
                    // Open the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didOpen];
                }
                else if (centerViewLocation > self.view.bounds.size.width / 3
                         && velocity.x > 0.0f) {
                    // Animate the drawer opening
                    [self animateOpening];
                }
                else {
                    // Animate the drawer closing, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didOpen];
                    [self willClose];
                    [self animateClosing];
                }
                
            } else if (self.drawerState == DrawerControllerStateClosing) {
                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation == 0.0f) {
                    // Close the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didClose];
                }
                else if (centerViewLocation < (2 * self.view.bounds.size.width) / 3
                         && velocity.x < 0.0f) {
                    // Animate the drawer closing
                    [self animateClosing];
                }
                else {
                    // Animate the drawer opening, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didClose];
                    
                    // Here we save the current position for the leftView since
                    // we want the opening animation to start from the current position
                    // and not the one that is set in 'willOpen'
                    CGRect l = self.leftView.frame;
                    [self willOpen];
                    self.leftView.frame = l;
                    
                    [self animateOpening];
                }
            }
            break;
            
        default:
            break;
    }
}


-(void)open
{
    [self willOpen];
    [self animateOpening];
}

-(void)willOpen
{
    self.drawerState = DrawerControllerStateOpening;
    
    CGRect rect = self.view.bounds;
    rect.origin.x = -60;
    self.leftView.frame = rect;
    
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = self.leftView.bounds;
    [self.leftView addSubview:self.leftViewController.view];
    
    [self.view insertSubview:self.leftView belowSubview:self.centerView];
}

-(void)didOpen
{
    [self.leftViewController didMoveToParentViewController:self];
    
    self.drawerState = DrawerControllerStateOpen;
}

-(void)animateOpening
{
    CGRect leftViewFinalFrame = self.view.bounds;
    CGRect centerViewFinalFrame = self.view.bounds;
    centerViewFinalFrame.origin.x = 260;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.centerView.frame = centerViewFinalFrame;
                         self.leftView.frame =leftViewFinalFrame;
                     }
                     completion:^(BOOL finished)
     {
         [self didOpen];
     }];
}

- (void)close
{
    
    [self willClose];
    
    [self animateClosing];
}

- (void)willClose
{
    
    [self.leftViewController willMoveToParentViewController:nil];
    
    self.drawerState = DrawerControllerStateClosing;
    
}

- (void)didClose
{
    
    [self.leftViewController.view removeFromSuperview];
    [self.leftViewController removeFromParentViewController];
    
    [self.leftView removeFromSuperview];
    
    //[self removeClosingGestureRecognizers];
    
    self.drawerState = DrawerControllerStateClosed;
    
}

- (void)animateClosing
{

    
    CGRect leftViewFinalFrame = self.leftView.frame;
    leftViewFinalFrame.origin.x = -60;
    CGRect centerViewFinalFrame = self.view.bounds;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.centerView.frame = centerViewFinalFrame;
                         self.leftView.frame = leftViewFinalFrame;
                         
//                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [self didClose];
                     }];
}


- (void)replaceCenterViewControllerWithViewController:(UIViewController<DrawerControllerChild, DrawerControllerPresenting> *)viewController
{
    [self willClose];
    
    CGRect f = self.centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [self.centerViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration: 0.5 / 2
                     animations:^{
                         self.centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         // The center view controller is now out of sight
                         
                         // Remove the current center view controller from the container
                         if ([self.centerViewController respondsToSelector:@selector(setDrawer:)]) {
                             self.centerViewController.drawer = nil;
                         }
                         [self.centerViewController.view removeFromSuperview];
                         [self.centerViewController removeFromParentViewController];
                         
                         // Set the new center view controller
                         self.centerViewController = viewController;
                         if ([self.centerViewController respondsToSelector:@selector(setDrawer:)]) {
                             self.centerViewController.drawer = self;
                         }
                         
                         // Add the new center view controller to the container
                         [self addCenterViewController];
                         
                         // Finally, close the drawer
                         [self animateClosing];
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
