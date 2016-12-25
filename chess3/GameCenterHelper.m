//
//  GameCenterHelper.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/27.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "GameCenterHelper.h"
#import "ViewController.h"

@implementation GameCenterHelper

@synthesize gameCenterAvailable;
@synthesize presentViewController;
@synthesize thematch;
@synthesize delegate;
@synthesize playerDict;
@synthesize pendingInvite;
@synthesize pendingPlayersToInvite;


+(GameCenterHelper *)sharedInstance
{
    GameCenterHelper *sharedHelper = [[GameCenterHelper alloc]init];
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer =@"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init]))
    {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&!userAuthenticated)
    {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = YES;
        
        __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        if ([localPlayer respondsToSelector:@selector(registerListener:)]) {
            [localPlayer registerListener:self];
        }else
        {
            [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptInvite,NSArray *playersToInvite)
            {
                self.pendingInvite = acceptInvite;
                self.pendingPlayersToInvite = playersToInvite;
                [self findMatchWithInvite];
            };
        }
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
    {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = NO;
        __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        if ([localPlayer respondsToSelector:@selector(unregisterListener:)]) {
            
            [localPlayer unregisterListener:self];
        }
    }
    
}


#pragma mark User functions

- (void)authenticateLocalUser {
    

    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
     {
         
         if (error == nil) {
             //成功处理
             NSLog(@"成功");
             NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
             NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
             //                NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
             NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
             NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
         }else {
             //错误处理
             NSLog(@"失败  %@",error);
         }
     }
     ];
}


-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers ViewController:(UIViewController *)viewController delegate:(id<GameCnterHelperProtocol>)theDelegate
{
    if (!gameCenterAvailable) {
        return;
    }
    matchStarted = NO;
    self.thematch = nil;
    self.presentViewController = viewController;
    delegate = theDelegate;
    
        [presentViewController dismissViewControllerAnimated:NO completion:nil];
        
        GKMatchRequest *request = [[GKMatchRequest alloc]init];
        request.minPlayers = minPlayers;
        request.maxPlayers = maxPlayers;
    
        GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc]initWithMatchRequest:request];
        mmvc.hosted = NO;
        mmvc.matchmakerDelegate =self;
     
        [presentViewController presentViewController:mmvc animated:YES completion:nil];
        
        self.pendingInvite = nil;
        self.pendingPlayersToInvite = nil;
    
}


- (void)findMatchWithInvite {
    
    if (!gameCenterAvailable) return;
    
    matchStarted = NO;
    self.thematch = nil;
    GKMatchmakerViewController * mmvc = [[GKMatchmakerViewController alloc] initWithInvite:pendingInvite];
    
    mmvc.matchmakerDelegate = self;
    
    self.pendingInvite = nil;
    self.pendingPlayersToInvite = nil;
    [presentViewController presentViewController:mmvc animated:YES completion:nil];
    
}

#pragma  mark -gkmatchmakerVCdelegate


-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [presentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [presentViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match:%@",error.localizedDescription);
}



-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [presentViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.thematch = match;
    NSLog(@"%lu",(unsigned long)match.players.count);

    match.delegate =self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"have find match");
        [self lookupPlayers];
    }
}


#pragma mark -gkmatchdelegate
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player
{
    if (thematch != match) {
        return;
    }
    NSString *ID = player.playerID;
    [delegate match:match didReceiveData:data fromPlayer:ID];

}


-(void)match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state
{
    if (thematch != match) {
        return;
    }
    switch (state) {
        case GKPlayerStateConnected:
            NSLog(@"connected");
            if (!matchStarted && match.expectedPlayerCount == 0) {
                NSLog(@"Ready");
                [self lookupPlayers];
            }
            break;
            
        case GKPlayerStateDisconnected:
            NSLog(@"Disconnected");
            matchStarted = NO;
            [delegate matchEnded];
            
        default:
            break;
    }
}

-(BOOL)match:(GKMatch *)match shouldReinviteDisconnectedPlayer:(GKPlayer *)player
{
    return YES;
}

-(void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
    if (thematch != match) {
        return;
    }
    
    NSLog(@"Error");
    matchStarted = NO;
    [delegate matchEnded];
}

-(void)lookupPlayers
{
    NSLog(@"looking up %lu players ...",(unsigned long)thematch.players.count);
    [GKPlayer loadPlayersForIdentifiers:thematch.playerIDs withCompletionHandler:^(NSArray *players,NSError *error)
     {
         if (error != nil) {
             NSLog(@"Error retrieving player info :%@",error.localizedDescription);
             matchStarted = NO;
             [delegate matchEnded];
         }else
         {
             self.playerDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
             for (GKPlayer *player in players) {
                 NSLog(@"found player :%@",player.alias);
                 [playerDict setObject:player forKey:player.playerID];
             }
             matchStarted = YES;
             [delegate matchStartedwithmatch:self.thematch];
         }
     }];
}




#pragma mark -GKgamecenterVC



-(void)showGameCenterin:(UIViewController *)viewController
{
    self.presentViewController = viewController;
    GKGameCenterViewController *gameview = [[GKGameCenterViewController alloc]init];
    if (gameview != nil) {
        gameview.gameCenterDelegate = self;
        [gameview setLeaderboardIdentifier:@"grp.greatleader"];
        [gameview setLeaderboardTimeScope:GKLeaderboardTimeScopeAllTime];
        [presentViewController presentViewController:gameview animated:YES completion:nil];
        
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [presentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportScore: (int64_t) score forIdentify: (NSString*) identify{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:identify];
    
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            [self storeScoreForLater:saveSocreData];
        }else{
            NSLog(@"提交成功");
        }
    }];
}

- (void)storeScoreForLater:(NSData *)scoreData{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}

- (void)submitAllSavedScores{
    NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedScores"];
    
    for(NSData *scoreData in savedScoreArray){
        GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if(error != nil){
                NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
                //未能提交得分，需要保存下来后继续提交
                [self storeScoreForLater:saveSocreData];
            }else{
                NSLog(@"提交成功");
                
                
            }
        }];
    }
}

- (void)reportAchievment:(NSString *)identifier withPercentageComplete:(double)percentComplete{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    
    [achievement setPercentComplete:percentComplete];
    
    [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSLog(@"error:%@", [error localizedDescription]);
        }else{
            NSLog(@"提交成就成功");
        }
    }];
}

#pragma mark GKInviteEventListener
-(void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite
{
    NSLog(@"invite received");
    pendingInvite = invite;
    [self findMatchWithInvite];
}

-(void)player:(GKPlayer *)player didRequestMatchWithOtherPlayers:(NSArray<GKPlayer *> *)playersToInvite
{
    GKMatchRequest *request = [[GKMatchRequest alloc]init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    request.recipients = playersToInvite;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc]initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    [presentViewController presentViewController:mmvc animated:YES completion:nil];
    
}

@end
