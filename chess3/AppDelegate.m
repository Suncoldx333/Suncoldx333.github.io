//
//  AppDelegate.m
//  chess3
//
//  Created by WangZhaoyun on 15/12/12.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "SecondViewController.h"
#import "ChessPlayViewController.h"
#import "DrawerViewController.h"
#import "ViewController.h"
#import "GameCenterHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize currentPlayerID, gameCenterAuthenticationComplete;
@synthesize view_Controller;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MenuViewController *leftVC      = [[MenuViewController alloc] init];
    ViewController *centerVC        = [[ViewController alloc] init];
    SecondViewController *chooseVC  = [[SecondViewController alloc] init];
    ChessPlayViewController *playVC = [[ChessPlayViewController alloc] init];
    
    DrawerViewController *drawer    = [[DrawerViewController alloc] initWithLeftViewController:leftVC
                                                                          CenterViewController:centerVC
                                                                          ChooseViewController:chooseVC
                                                                            PlayViewController:playVC];
    self.window.rootViewController  = drawer;
    
    [[GameCenterHelper sharedInstance] authenticateLocalUser];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
