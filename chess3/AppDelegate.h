
//  AppDelegate.h
//  chess3
//
//  Created by WangZhaoyun on 15/12/12.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UIViewController *view_Controller;
// Gamecenter
-(void) initGameCenter;

// currentPlayerID is the value of the playerID last time we authenticated.
@property (retain,readwrite) NSString * currentPlayerID;

// isGameCenterAuthenticationComplete is set after authentication, and authenticateWithCompletionHandler's completionHandler block has been run. It is unset when the application is backgrounded.
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;

@end

