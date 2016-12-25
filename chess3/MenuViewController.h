//
//  MenuViewController.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/14.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"
#import "GameCenterHelper.h"
#import <GameKit/GameKit.h>


@interface MenuViewController : UIViewController<DrawerControllerChild,DrawerControllerPresenting>
{
    uint32_t ourRandom;
    CGFloat Random;
    BOOL receiveRandom;
    NSString *otherPlayerID;
    BOOL isPlayer1;
}
@property(nonatomic,weak) DrawerViewController *drawer;

@end
