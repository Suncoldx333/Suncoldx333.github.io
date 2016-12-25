//
//  SecondViewController.h
//  chess3
//
//  Created by WangZhaoyun on 15/12/13.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"
#import "GameCenterHelper.h"
#import <GameKit/GameKit.h>

@protocol decideAttackAndHealthProtocol <NSObject>

-(void)decideAttackAndHealth;

@end


@interface SecondViewController : UIViewController<DrawerControllerChild,DrawerControllerPresenting>

@property(nonatomic,strong) NSString *Info;
@property(nonatomic,weak) DrawerViewController *drawer;
-(void)SelectedWithName:(NSString *)name
                 Attack:(NSString *)attack
                 Health:(NSString *)health;

@end
