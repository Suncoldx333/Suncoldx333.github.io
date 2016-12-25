//
//  ChessPlayViewController.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/6.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"
#import <GameKit/GameKit.h>
#import "GameCenterHelper.h"



@interface ChessPlayViewController : UIViewController<DrawerControllerChild,DrawerControllerPresenting,GameCnterHelperProtocol,GKMatchDelegate,GKMatchmakerViewControllerDelegate,GameCnterHelperProtocol>
{
    uint32_t ourRandom;
    CGFloat Random;
    BOOL receiveRandom;
    NSString *otherPlayerID;
    BOOL isPlayer1;
}

@property (nonatomic,weak) DrawerViewController *drawer;

-(void)setgame;

@end
