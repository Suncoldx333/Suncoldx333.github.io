//
//  GameCenterHelper.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/27.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<GameKit/GameKit.h>

@protocol GameCnterHelperProtocol <NSObject>

-(void)matchStartedwithmatch:(GKMatch*)m_atch;
-(void)matchEnded;
-(void)match:(GKMatch *)match didReceiveData:(nonnull NSData *)data fromPlayer:(nonnull NSString *)playerID;
-(void)inviteReceived;

@end

@interface GameCenterHelper : NSObject<GKMatchmakerViewControllerDelegate,GKMatchDelegate,GKLocalPlayerListener,GKGameCenterControllerDelegate>

{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentViewController;
    GKMatch *thematch;
    BOOL matchStarted;
    NSMutableDictionary *playerDict;
    GKInvite *pendingInvite;
    NSArray *pendingPlayersToInvite;
}


@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController *presentViewController;
@property (retain) GKMatch *thematch;
@property (assign) id<GameCnterHelperProtocol>delegate;
@property (retain) NSMutableDictionary *playerDict;
@property (retain) GKInvite *pendingInvite;
@property (retain) NSArray *pendingPlayersToInvite;




+ (GameCenterHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers ViewController:(UIViewController *)viewController delegate:(id<GameCnterHelperProtocol>)theDelegate;
-(void)showGameCenterin:(UIViewController *)viewController;
- (void)reportScore:(int64_t)score forIdentify:(NSString *)identify;
- (void)reportAchievment:(NSString *)identifier withPercentageComplete:(double)percentComplete;
- (void)submitAllSavedScores;

@end
