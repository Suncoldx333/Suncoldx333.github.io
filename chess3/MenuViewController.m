//
//  MenuViewController.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/14.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "MenuViewController.h"
#import "SecondViewController.h"
#import "ChessPlayViewController.h"
#import "ViewController.h"

static NSString * const CellReuseId = @"reusecell";


@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)            UITableView *tableView;
@property(nonatomic,strong)                NSArray *tableArray;
@property(nonatomic,strong)   SecondViewController *second;
@property(nonatomic,strong)ChessPlayViewController *play;
@property(nonatomic,strong)         ViewController *center;
@property (nonatomic,strong)      GameCenterHelper *helper;
@property (nonatomic,strong)               GKMatch *the_match;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableArray           = @[@"兵法概要",@"排兵布阵",@"驰骋沙场",@"辉煌战绩"];
    self.helper               = [GameCenterHelper sharedInstance];
    self.second               = [[SecondViewController alloc] init];
    self.play                 = [[ChessPlayViewController alloc] init];
    self.center               = [[ViewController alloc]init];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -TableViewProtocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseId];
    cell.textLabel.text   = self.tableArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([cell_text isEqualToString:@"兵法概要"]) {
        [self.drawer replaceCenterViewControllerWithViewController:self.center];
    }
    if ([cell_text isEqualToString:@"驰骋沙场"]) {
        NSArray *path_Turn           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plist_Turn         = [path_Turn objectAtIndex:0];
        NSString *filename_Turn      = [plist_Turn stringByAppendingPathComponent:@"Turn.plist"];
        NSMutableDictionary *turnDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_Turn];
        for (id key in turnDic) {
            NSString *turn = [turnDic objectForKey:key];
            if ([turn isEqualToString:@"YES"]) {
                [self.drawer replaceCenterViewControllerWithViewController:self.play];
            }
        }

    }
    if([cell_text isEqualToString:@"排兵布阵"])
    {
    [self.drawer replaceCenterViewControllerWithViewController:self.second];
    }
    if([cell_text isEqualToString:@"辉煌战绩"])
    {
        [self.helper showGameCenterin:self];
//        [self.drawer replaceCenterViewControllerWithViewController:self.second];
    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView            = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.center     = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2+20);
        _tableView.delegate   = self;
        _tableView.dataSource =self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseId];
    }
    return _tableView;
}


@end
