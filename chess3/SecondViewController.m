//
//  SecondViewController.m
//  chess3
//
//  Created by WangZhaoyun on 15/12/13.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import "SecondViewController.h"
#import "chooseAttackAndHealth.h"
#import "ChessCollectionView.h"
#import "ChessCollectionViewLayout.h"



@interface SecondViewController ()<WhichIsSelecitedProtocol>

@property(nonatomic,strong)             UIButton *button;
@property(nonatomic,strong)          UITextField *textfield;
@property(nonatomic,strong)             UIButton *button2;
@property(nonatomic,strong)             UIButton *button3;
@property(nonatomic,strong)chooseAttackAndHealth *choose;
@property(nonatomic,strong)  NSMutableDictionary *chessDic;
@property(nonatomic,strong)             UIButton *openButton;
@property(nonatomic,strong)  ChessCollectionView *chessCollectionView;
@property(nonatomic,strong)               UIView *CardView;
@property(nonatomic)                        BOOL Ready;
@property(nonatomic,strong)     GameCenterHelper *helper;
@property(nonatomic,strong)             UIButton *DecideButton;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Ready = YES;
    [self makeCardView];
    [self makeOpenButton];
    [self chessLocation];
    [self ChooseAttackAndHealth];
    [self decideAttakAndHealth];
    
}

#pragma mark -OpenButton
-(void)makeOpenButton
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.openButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openButton.frame     = CGRectMake(10.0f, 20.0f, 44.0f, 44.0f);
    [self.openButton setImage:[UIImage imageNamed:@"find"] forState:UIControlStateNormal];
    [self.openButton addTarget:self
                        action:@selector(openDrawer)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.openButton];
}

-(void)openDrawer
{
    self.Ready = YES;
    [self PostMes];
    if (self.Ready == YES) {
        [self.drawer open];
    }
}


#pragma mark -CardView
-(void)makeCardView
{
    self.CardView                   = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.f -135, 250, 150, 200)];
    self.CardView.backgroundColor   = [UIColor whiteColor];
    self.CardView.layer.borderWidth = 1.5f;
    self.CardView.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:self.CardView];
}

#pragma mark -DecideButton
-(void)decideAttakAndHealth
{
    self.button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+60, 325, 50, 50)];
    [self.button2 setImage:[UIImage imageNamed:@"YesSir"] forState:UIControlStateNormal];
    [self.view addSubview:self.button2];
    [self.button2 addTarget:self
                     action:@selector(Decide)
           forControlEvents:UIControlEventTouchUpInside];
}

-(void)Decide
{
    if ([self.chessCollectionView IsCHessChoose]) {
    self.Info = [self.choose decideAttackAndHealth];
    if (self.Info) {
    [self.chessCollectionView GetAttack:[self.Info substringWithRange:NSMakeRange(0, 1)] AndHealth:[self.Info substringWithRange:NSMakeRange(2, 1)]];
      }
    }
}

#pragma mark -CollectionView
-(void)chessLocation
{
    ChessCollectionViewLayout *layout          = [[ChessCollectionViewLayout alloc]init];
    self.chessCollectionView                   = [ChessCollectionView initWithFrame:CGRectMake(0, 100, 270, 120) collectionViewLayout:layout delegate:self];
    self.chessCollectionView.center            = CGPointMake(self.view.bounds.size.width/2, 150);
    self.chessCollectionView.layer.borderWidth = 1.5f;
    self.chessCollectionView.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:self.chessCollectionView];
}

#pragma mark -PickerView
-(void)ChooseAttackAndHealth
{
    self.choose        = [[chooseAttackAndHealth alloc]initWithFrame:CGRectMake(0, 580, 170, 40)];
    self.choose.center = CGPointMake(self.view.bounds.size.width/2 - 65, 430);
    [self.view addSubview:self.choose];
}

#pragma mark - PostChessInfo

-(void)PostMes
{
    NSArray *array                    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path                    = [array objectAtIndex:0];
    NSString *filename                = [path stringByAppendingPathComponent:@"chess3.plist"];
    NSMutableDictionary *chessDic     = [[NSMutableDictionary alloc]init];
    chessDic                          = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSMutableDictionary *chessDic_new = [[NSMutableDictionary alloc]init];
    
    for (id key in chessDic) {
        NSMutableDictionary *chess = [[NSMutableDictionary alloc]init];
        chess = [chessDic objectForKey:key];
        for (id key2 in chess) {
            if ([key2 isEqualToString:@"attack"]) {
                NSString *info = [chess objectForKey:key2];
                if ([info isEqualToString: @"0"]) {
                    self.Ready = NO;
                    break;
                }
            }
        }
    }
    
    if (!self.Ready) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"还有人没上车" message:@"请检查棋子信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action    = [UIAlertAction actionWithTitle:@"检查检查" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    }else
    {
        NSString *filename_copy            = [path stringByAppendingPathComponent:@"chess3_copy.plist"];
        NSMutableDictionary *chessDic_copy = [chessDic mutableCopy];
        [chessDic_copy writeToFile:filename_copy atomically:NO];
        
        for (id key in chessDic) {
            NSMutableDictionary *chess         = [[NSMutableDictionary alloc]init];
            NSMutableDictionary *chess_forcopy = [[NSMutableDictionary alloc]init];

            chess = [chessDic objectForKey:key];
            for (id key2 in chess) {
                if ([key2 isEqualToString: @"name"]) {
                    NSString *name = [[chess objectForKey:key2] substringWithRange:NSMakeRange(0, 1)];
                    NSString *num = [[chess objectForKey:key2] substringWithRange:NSMakeRange(1, 2)];
                    if ([name isEqualToString:@"兵"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"卒"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                    if ([name isEqualToString:@"相"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"象"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                    if ([name isEqualToString:@"仕"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"士"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                    if ([name isEqualToString:@"帅"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"将"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                    if ([name isEqualToString:@"炮"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"炮"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                    if ([name isEqualToString:@"車"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"車"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                    if ([name isEqualToString:@"马"]) {
                        NSMutableString *new_name = [NSMutableString stringWithString:@"馬"];
                        [new_name appendString:num];
                        [chess_forcopy setValue:new_name forKey:key2];
                    }
                }
                
                if ([key2 isEqualToString:@"location"]) {
                    NSString *location = [chess objectForKey:key2];
                    int x                         = 240 - [[location substringWithRange:NSMakeRange(0, 3)] intValue];
                    int y                         = 470 - [[location substringWithRange:NSMakeRange(3, 3)] intValue];
                    NSString *x_str               = [NSString stringWithFormat:@"%i",x];
                    NSString *y_str               = [NSString stringWithFormat:@"%i",y];
                    NSMutableString *location_new = [[NSMutableString alloc] init];

                        if (x >= 100) {
                            [location_new appendString:x_str];
                        }
                        else if (x <100&&x >10)
                        {
                            [location_new appendString:@"0"];
                            [location_new appendString:x_str];
                        }else if (x <10)
                        {
                            [location_new appendString:@"0"];
                            [location_new appendString:@"0"];
                            [location_new appendString:x_str];
                        }
                        
                        if (y >= 100) {
                            [location_new appendString:y_str];
                        }
                        else if (y <100&&y >10)
                        {
                            [location_new appendString:@"0"];
                            [location_new appendString:y_str];
                        }else if (y <10)
                        {
                            [location_new appendString:@"0"];
                            [location_new appendString:@"0"];
                            [location_new appendString:y_str];
                        }
                    [chess_forcopy setValue:location_new forKey:key2];
                }
                
                if ([key2 isEqualToString:@"attack"]) {
                    NSString *attack = [chess objectForKey:key2];
                    [chess_forcopy setValue:attack forKey:key2];
                }
                
                if ([key2 isEqualToString:@"health"]) {
                    NSString *health = [chess objectForKey:key2];
                    [chess_forcopy setValue:health forKey:key2];
                }
                
            }
            chess = [chess_forcopy copy];
            [chessDic_new setObject:chess_forcopy forKey:key];
        }
        
        
        NSString *black_filename  = [path stringByAppendingPathComponent:@"BlackChess.plist"];
        [chessDic_new writeToFile:black_filename atomically:YES];
        
        NSArray *path_Turn           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plist_Turn         = [path_Turn objectAtIndex:0];
        NSString *filename_Turn      = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
        NSMutableDictionary *turnDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Turn];
        
        [turnDic setObject:@"YES" forKey:@"turn"];
        [turnDic writeToFile:filename_Turn atomically:NO];

    }
    

}

#pragma mark -ProtocolMethod
-(void)SelecteNewChess
{
    [self.choose removeSelecte];
}

-(void)SelectedWithName:(NSString *)name Attack:(NSString *)attack Health:(NSString *)health
{
    [self.choose refrashWithAttack:attack AndHealth:health];
}

-(void)ShowCardWithName:(NSString *)name
{
    NSString *real_name = [name substringWithRange:NSMakeRange(0, 1)];
    if ([real_name isEqualToString:@"車"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_berserker"]];
    }
    if ([real_name isEqualToString:@"马"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_rider"]];
    }
    if ([real_name isEqualToString:@"相"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_caster"]];
    }
    if ([real_name isEqualToString:@"仕"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_assassin"]];
    }
    if ([real_name isEqualToString:@"帅"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_saber"]];
    }
    if ([real_name isEqualToString:@"炮"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_archer"]];
    }
    if ([real_name isEqualToString:@"兵"]) {
        self.CardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chess_lancer"]];
    }
}


@end
