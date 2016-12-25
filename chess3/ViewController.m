//
//  ViewController.m
//  chess3
//
//  Created by WangZhaoyun on 15/12/12.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ChessPlayViewController.h"
#import "JLAnimatedImagesView.h"
#import "GameCenterHelper.h"
#import "AppDelegate.h"

@interface ViewController ()<JLAnimatedImagesViewDelegate>

@property(nonatomic,strong)            UIButton *playButton;
@property(nonatomic,strong)            UIButton *openbutton;
@property(nonatomic,strong)             UILabel *labbel;
@property(nonatomic,strong)JLAnimatedImagesView *AnimatingImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setgame];
    [self plistInit];
}


-(void)setgame
{
    
    self.AnimatingImageView                 = [JLAnimatedImagesView initWithFrame:self.view.bounds delegate:self];
    self.AnimatingImageView.backgroundColor = [UIColor whiteColor];
    [self.AnimatingImageView startAnimating:1];
    [self.view addSubview:self.AnimatingImageView];
    
    
    self.openbutton       = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openbutton.frame = CGRectMake(10.0f, 20.0f, 44.0f, 44.0f);
    [self.openbutton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [self.openbutton addTarget:self
                        action:@selector(openDrawer)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.openbutton];
    
    self.view.backgroundColor = [UIColor grayColor];

}

-(void)reloadAnimating
{
    [self.AnimatingImageView reloadData];
}

-(void)openDrawer
{
    [self.AnimatingImageView stopAnimating];
    [self.drawer open];
}

-(void)plistInit
{
    NSString *path_mainbundle     = [[NSBundle mainBundle] pathForResource:@"chess" ofType:@"plist"];
    NSMutableDictionary *chessdic = [[NSMutableDictionary alloc]initWithContentsOfFile:path_mainbundle];
    
    NSArray *path      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist    = [path objectAtIndex:0];
    NSString *filename = [plist stringByAppendingPathComponent:@"chess3.plist"];
    [chessdic writeToFile:filename atomically:YES];
    NSString *path_mainbundle_AH = [[NSBundle mainBundle] pathForResource:@"AttackHealth" ofType:@"plist"];
    NSMutableDictionary *AHDic   = [[NSMutableDictionary alloc]initWithContentsOfFile:path_mainbundle_AH];
    
    NSArray *path_AH      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_AH    = [path_AH objectAtIndex:0];
    NSString *filename_AH = [plist_AH stringByAppendingPathComponent:@"AttackAndHealth.plist"];
    [AHDic writeToFile:filename_AH atomically:YES];
    
    NSString *path_mainbundle_Turn = [[NSBundle mainBundle] pathForResource:@"Turn" ofType:@"plist"];
    NSMutableDictionary *TurnDic   = [[NSMutableDictionary alloc]initWithContentsOfFile:path_mainbundle_Turn];
    
    NSArray *path_Turn      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_Turn    = [path_Turn objectAtIndex:0];
    NSString *filename_Turn = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
    [TurnDic writeToFile:filename_Turn atomically:YES];
    
    NSString *path_mainbundle_Score = [[NSBundle mainBundle] pathForResource:@"Score" ofType:@"plist"];
    NSMutableDictionary *ScoreDic   = [[NSMutableDictionary alloc]initWithContentsOfFile:path_mainbundle_Score];
    
    NSArray *path_Score      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_Score    = [path_Score objectAtIndex:0];
    NSString *filename_Score = [plist_Score stringByAppendingPathComponent:@"Score.plist"];
    NSMutableDictionary *Score = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Score];
    if (Score.count == 0) {
        [ScoreDic writeToFile:filename_Score atomically:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)drawerControllerWillOpen:(DrawerViewController *)drawerController{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(DrawerViewController *)drawerController{
    self.view.userInteractionEnabled = YES;
}

#pragma mark -AMprotocol
-(NSInteger)animatedImagesNumberOfImages:(JLAnimatedImagesView *)animatedImagesView
{
    return 2;
}

-(UIImage *)animatedImagesView:(JLAnimatedImagesView *)animatedImagesView imageAtImdex:(NSInteger)index
{
    UIImage *image ;
    if (index == 0) {
        image = [UIImage imageNamed:@"load1"];
    }else
    {
        image = [UIImage imageNamed:@"load2"];
    }
    return image;
}

@end
