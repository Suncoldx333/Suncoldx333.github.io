//
//  ChessPlayViewController.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/6.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "ChessPlayViewController.h"
#import "GameboardView.h"
#import "chessView.h"
#import "MoveMode.h"
#import "GameCenterHelper.h"
#import "AppDelegate.h"


@interface ChessPlayViewController ()<gamemodepotocol,HowChessGoProtocol>

@property (nonatomic, strong)   GameboardView *gameboard;
@property (nonatomic)              NSUInteger dimension;
@property (nonatomic,strong)         MoveMode *mode;
@property (nonatomic,strong)         UIButton *openbutton;
@property (nonatomic,strong) GameCenterHelper *helper;
@property (nonatomic,strong)          GKMatch *the_match;
@property (nonatomic)                    BOOL isFirsrOne;
@property (nonatomic,strong)          UILabel *label;
@property (nonatomic)                 CGFloat startCount;
@property (nonatomic,strong)         NSString *turnState;

@end

@implementation ChessPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.helper               = [GameCenterHelper sharedInstance];
    [self.helper findMatchWithMinPlayers:2 maxPlayers:2 ViewController:self delegate:self];
    Random          = arc4random()%100;
    self.isFirsrOne = NO;
    [self makeMatckbutton];

    self.startCount = 0;

}

#pragma mark -GameBoardView
-(void)setgame
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.dimension            = 4;
    CGFloat padding           = (self.dimension > 5) ? 3.0 : 6.0;
    CGFloat cellWidth         = floorf((230 - padding*(self.dimension+1))/((float)self.dimension));
    if (cellWidth < 30) {
        cellWidth = 30;
    }
    GameboardView *board = [GameboardView gameboardWithDimension:4
                                               cellWidth:cellWidth
                                             cellPadding:padding
                                            cornerRadius:15
                                                 backgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"board"]]
                                         foregroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chess-1"]]
                                                        delegate:self];
                            
    CGRect gameboardframe   = board.frame;
    gameboardframe.origin.y = 0.5*(self.view.bounds.size.height - board.frame.size.height);
    gameboardframe.origin.x = 0.5*(self.view.bounds.size.width - board.bounds.size.width);
    board.frame             = gameboardframe;
    
    board.layer.borderWidth = 1.5f;
    board.layer.borderColor = [[UIColor blackColor]CGColor];
    
    [self.view addSubview:board];
    
    self.gameboard = board;
    
    [self ShowTrunLabel];

    MoveMode *mode = [MoveMode gameModelWithDimension:4 delegate:self];
    [mode insertChessAtInitLoacationPathWithValue:YES];
    self.mode = mode;
    self.startCount ++;
}

#pragma mark -FindEnemyButton
-(void)makeMatckbutton
{
    self.openbutton       = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openbutton.frame = CGRectMake(10.0f, 20.0f, 44.0f, 44.0f);
    [self.openbutton setImage:[UIImage imageNamed:@"find"] forState:UIControlStateNormal];
    [self.openbutton addTarget:self
                        action:@selector(openDrawer)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.openbutton];
}

-(void)openDrawer
{
    self.helper = [GameCenterHelper sharedInstance];
    [self.helper findMatchWithMinPlayers:2 maxPlayers:2 ViewController:self delegate:self];
}

#pragma mark - TrunLabel
-(void)ShowTrunLabel
{
    self.label                 = [[UILabel alloc]initWithFrame:CGRectMake(97.5, 40, 150, 30)];
    self.label.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2 - 185);
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textColor       = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.layer.borderWidth = 1.5f;
    self.label.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:self.label];
}

#pragma mark -ProtocolMethod
-(void)insertChessAtIndex:(CGPoint)path withValue:(NSString *)value withattack:(NSString *)attack withhealth:(NSString *)health withcolor:(NSString *)color withTag:(NSInteger)t_ag
{
    [self.gameboard insertChessAtIndexPath:path withValue:value withattack:attack withhealth:health withColor:color withTag:t_ag];
}

-(void)sendStepInfo:(NSMutableArray *)Info
{
    [self sendStepMes:Info];
}


#pragma mark -GameCenterProtocol
-(void)matchStartedwithmatch:(GKMatch *)m_atch
{
    self.the_match = m_atch;
    [self sendRandomNumber];
    [self sendEnemyInfo];
}

-(void)matchEnded
{
    [self chessPlayScore];
    
    NSArray *path_Score      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_Score    = [path_Score objectAtIndex:0];
    NSString *filename_Score = [plist_Score stringByAppendingPathComponent:@"Score.plist"];
    NSMutableDictionary *Score = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Score];
    
    int64_t score = [[Score objectForKey:@"Score"] longLongValue];
    double complement_5 = score * 20;
    double complement_10 = score * 10;
    double complement_100 = score;
    double complement_1000 = score / 10;

    [self.helper reportScore:score forIdentify:@"grp.gretleader"];
    
    if (score <= 5) {
        [self.helper reportAchievment:@"grp.chesswarrior.05" withPercentageComplete:complement_5];
    }else if (score > 5 &&score <= 10)
    {
        [self.helper reportAchievment:@"grp.chesswarrior.10" withPercentageComplete:complement_10];
    }else if (score > 11 && score <= 100)
    {
        [self.helper reportAchievment:@"grp.chesswarrior.100" withPercentageComplete:complement_100];
    }else
    {
        [self.helper reportAchievment:@"grp.chesswarrior.1000" withPercentageComplete:complement_1000];

    }
    
    [self.helper submitAllSavedScores];
}

-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{

    NSError *error;
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    Dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSString *type;
    id info;
    
    for (id key in Dic) {
        if ([key isEqualToString:@"Chess-Type"]) {
            type = [Dic objectForKey:key];
        }else
        {
            info = [Dic objectForKey:key];
        }
    }
    
    if ([type isEqualToString:@"Random"])
    {
        CGFloat random_enemy = [info floatValue];
        if (Random > random_enemy) {
            self.turnState = @"己方回合";
            self.isFirsrOne = YES;
        }else if (Random < random_enemy)
        {
            self.turnState = @"对方回合";
            self.isFirsrOne = NO;
        }else
        {
            ourRandom = arc4random()%100;
            [self sendRandomNumber];
        }
        
        
        NSArray *path_Turn           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plist_Turn         = [path_Turn objectAtIndex:0];
        NSString *filename_Turn      = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
        NSMutableDictionary *turnDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Turn];
        if (self.isFirsrOne == YES) {
            [turnDic setObject:@"YES" forKey:@"turn"];
        }else
        {
            [turnDic setObject:@"NO" forKey:@"turn"];
        }
        [turnDic writeToFile:filename_Turn atomically:NO];
    }
    else if ([type isEqualToString:@"EnemyInfo"])
    {
        
        if (self.startCount > 0) {
            [self refrashPlist];
        }
        
        NSArray *paths                = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plist               = [paths objectAtIndex:0];
        NSString *filename            = [plist stringByAppendingPathComponent:@"chess3.plist"];
        NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
        
        NSMutableDictionary *enemy_chess_copy = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *enemy_chess      = [[NSMutableDictionary alloc]init];

        for (id key in info) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess                      = [info objectForKey:key];
            [enemy_chess_copy setObject:chess forKey:key];
        }
        
        for (id key in enemy_chess_copy) {
            NSMutableString *dickey    = [NSMutableString stringWithString:key];
            NSMutableDictionary *chess = [enemy_chess_copy objectForKey:key];
            [dickey replaceCharactersInRange:NSMakeRange(0, 1) withString:@"B"];
            
            [enemy_chess setObject:chess forKey:dickey];
            
        }
        
        for (id key in enemy_chess) {
            NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
            chess                      = [enemy_chess objectForKey:key];
            [chessDic setObject:chess forKey:key];
        }
        [chessDic writeToFile:filename atomically:NO];
        [self setgame];
        self.label.text = self.turnState;
    }
    else if ([type isEqualToString:@"Step"])
    {
        [self.gameboard playBlack:info];
        NSString *result = [self IsGameEnd];

        if ([result isEqualToString:@"GoOn"]) {
            NSArray *path_Turn           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *plist_Turn         = [path_Turn objectAtIndex:0];
            NSString *filename_Turn      = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
            NSMutableDictionary *turnDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Turn];
            [turnDic setObject:@"YES" forKey:@"turn"];
            [turnDic writeToFile:filename_Turn atomically:NO];
            self.label.text = @"己方回合";
            self.label.font = [UIFont fontWithName:@"Libina" size:20];
        }else if ([result isEqualToString:@"BlackWinner"])
        {
            self.label.text = @"Victory!";
            self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
            self.label.textColor = [UIColor redColor];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Victory!" message:@"请点击左上角重新寻找对手" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
            [self matchEnded];
            
        }else if ([result isEqualToString:@"RedWinner"])
        {
            self.label.text = @"甘拜下风";
            self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
            self.label.textColor = [UIColor redColor];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"甘拜下风" message:@"请点击左上角重新寻找对手" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
            [self matchEnded];
            
        }else if ([result isEqualToString:@"AllDead"])
        {
            self.label.text = @"势均力敌";
            self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
            self.label.textColor = [UIColor redColor];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"势均力敌" message:@"请点击左上角重新寻找对手" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            [self matchEnded];

        }
        
    }

    
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)sendEnemyInfo
{
    NSArray *array                = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path                = [array objectAtIndex:0];
    NSString *filename            = [path stringByAppendingPathComponent:@"BlackChess.plist"];
    NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];

    
    NSError *error;
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    
    [Dic setValue:@"EnemyInfo" forKey:@"Chess-Type"];
    [Dic setValue:chessDic forKey:@"Chess-Info"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:Dic options:NSJSONWritingPrettyPrinted error:&error];
    
    [self sendData:data];
}

-(void)sendRandomNumber
{
    
    NSString *randomnumber   = [NSString stringWithFormat:@"%f",Random];
    NSError *error;
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    
    [Dic setValue:@"Random" forKey:@"Chess-Type"];
    [Dic setValue:randomnumber forKey:@"Chess-Info"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:Dic options:NSJSONWritingPrettyPrinted error:&error];
    
    [self sendData:data];
}

-(void)sendStepMes:(NSMutableArray *)message
{
    NSString *result = [self IsGameEnd];
    if ([result isEqualToString:@"BlackWinner"])
    {
        self.label.text = @"Victory!";
        self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
        self.label.textColor = [UIColor redColor];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Victory!" message:@"请点击左上角重新寻找对手" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        [self matchEnded];
        
    }else if ([result isEqualToString:@"RedWinner"])
    {
        self.label.text = @"甘拜下风";
        self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
        self.label.textColor = [UIColor redColor];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"甘拜下风" message:@"请点击左上角重新寻找对手" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        [self matchEnded];
        
    }else if ([result isEqualToString:@"AllDead"])
    {
        self.label.text = @"势均力敌";
        self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
        self.label.textColor = [UIColor redColor];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"势均力敌" message:@"请点击左上角重新寻找对手" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        [self matchEnded];
        
    }else if ([result isEqualToString:@"GoOn"])
    {
        self.label.text = @"对方回合";
        self.label.font = [UIFont fontWithName:@"Libina.ttc" size:20];
    }
    NSError *error;
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
    
    [Dic setValue:@"Step" forKey:@"Chess-Type"];
    [Dic setValue:message forKey:@"Chess-Info"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:Dic options:NSJSONWritingPrettyPrinted error:&error];
    
    [self sendData:data];

}

-(void)sendData:(NSData *)data
{
    NSError* sendError ;
    
    GKMatch *tth_match =  self.the_match;
    
    BOOL success1      = [tth_match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&sendError];
    if (!success1) {
        [self matchEnded];
    }
}

-(NSString *)IsGameEnd
{
    NSString *GameResult;
    
    NSArray *paths                = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist               = [paths objectAtIndex:0];
    NSString *filename            = [plist stringByAppendingPathComponent:@"chess3.plist"];
    NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    NSDictionary *chess = [chessDic copy];
    NSArray *key_array = [chess allKeys];
    
    if ([key_array indexOfObject:@"BedSaber"] != NSNotFound && [key_array indexOfObject:@"RedSaber"] != NSNotFound ) {
        GameResult = @"GoOn";
    }else if ([key_array indexOfObject:@"BedSaber"] != NSNotFound && [key_array indexOfObject:@"RedSaber"] == NSNotFound)
    {
        GameResult = @"RedWinner";
    }else if ([key_array indexOfObject:@"BedSaber"] == NSNotFound && [key_array indexOfObject:@"RedSaber"] != NSNotFound)
    {
        GameResult = @"BlackWinner";
    }else if ([key_array indexOfObject:@"BedSaber"] == NSNotFound && [key_array indexOfObject:@"RedSaber"] == NSNotFound)
    {
        GameResult = @"AllDead";
    }
    return GameResult;
}

-(void)refrashPlist
{
    NSArray *paths                = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist               = [paths objectAtIndex:0];
    NSString *filename            = [plist stringByAppendingPathComponent:@"chess3.plist"];
    NSMutableDictionary *chessDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    
    [chessDic removeAllObjects];
    
    NSString *filename_copy            = [plist stringByAppendingPathComponent:@"chess3_copy.plist"];
    NSMutableDictionary *chessDic_copy = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_copy];
    
    for (id key in chessDic_copy) {
        NSMutableDictionary *chess = [chessDic_copy objectForKey:key];
        [chessDic setObject:chess forKey:key];
    }
    
    [chessDic writeToFile:filename atomically:NO];

}

-(void)chessPlayScore
{
    NSArray *path_Score      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plist_Score    = [path_Score objectAtIndex:0];
    NSString *filename_Score = [plist_Score stringByAppendingPathComponent:@"Score.plist"];
    NSMutableDictionary *Score = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Score];
    
    NSUInteger score = [[Score objectForKey:@"Score"] integerValue];
    if ([self.label.text isEqualToString:@"Victory!"]) {
        score++;
    }
    NSString *score_store = [NSString stringWithFormat:@"%lu",(unsigned long)score];
    [Score setObject:score_store forKey:@"Score"];
    [Score writeToFile:filename_Score atomically:NO];
}

@end
