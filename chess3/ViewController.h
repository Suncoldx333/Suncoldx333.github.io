//
//  ViewController.h
//  chess3
//
//  Created by WangZhaoyun on 15/12/12.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"
#import <GameKit/GameKit.h>
#import "GameCenterHelper.h"

@interface ViewController : UIViewController<DrawerControllerChild,DrawerControllerPresenting>

@property(nonatomic,weak)DrawerViewController *drawer;
-(void)reloadAnimating;

@end

