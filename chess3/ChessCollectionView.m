//
//  ChessCollectionView.m
//  chess3
//
//  Created by WangZhaoyun on 16/1/17.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import "ChessCollectionView.h"
#import "ChessCollectionViewCell.h"
#import "ChessCollectionViewLayout.h"

@interface ChessCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>;

@property(nonatomic,strong)        NSMutableArray *nameArray;
@property(nonatomic,strong)   NSMutableDictionary *chessDic;
@property(nonatomic,weak)id<WhichIsSelecitedProtocol>d_elegate;
@property(nonatomic,strong)UICollectionViewLayout *l_ayout;
@property (nonatomic)                      CGRect f_rame;
@property(nonatomic,strong)   NSMutableDictionary *AHDic;
@property (nonatomic,strong)             NSString *name_choose;
@property (nonatomic,strong)             NSString *attack_choose;
@property (nonatomic,strong)             NSString *health_choose;
@property (nonatomic)                        BOOL DidChoose;
@property (nonatomic,strong)             NSString *filename;
@property (nonatomic,strong)             NSString *t_ag;
@property (nonatomic,strong)       NSMutableArray *last_Info;

@end

@implementation ChessCollectionView

+(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout delegate:(id<WhichIsSelecitedProtocol>)delegate2
{
    ChessCollectionView *collectionView = [[[self class] alloc]initWithFrame:frame collectionViewLayout:layout];
    
    collectionView.f_rame          = frame;
    collectionView.l_ayout         = layout;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.delegate   = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.d_elegate  = delegate2;
    
    [collectionView initNameArray];
    
    return collectionView;
}

-(void)initNameArray
{
    self.last_Info = [[NSMutableArray alloc]init];
    [self.last_Info addObject:@"last_name"];
    [self.last_Info addObject:@"last_attack"];
    [self.last_Info addObject:@"last_health"];
    //用于将从plist文件获取的棋子信息排序
    self.DidChoose = NO;
    
    self.nameArray              = [[NSMutableArray alloc]init];
    NSMutableArray *Info_array  = [[NSMutableArray alloc]init];
    NSMutableArray *name_array  = [[NSMutableArray alloc]init];
    NSMutableArray *name_array2 = [[NSMutableArray alloc]init];
    NSMutableArray *num_array   = [[NSMutableArray alloc]init];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    self.filename  = [path stringByAppendingPathComponent:@"chess3.plist"];
    self.chessDic  = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filename];
        
    for (id key in self.chessDic) {
        if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"R"]) {
            NSMutableDictionary *chessInfo = [[NSMutableDictionary alloc]init];
            chessInfo = [self.chessDic objectForKey:key];
            [Info_array addObject:chessInfo];
        }
    }

    for (NSUInteger i = 0; i < Info_array.count; i++) {
        NSMutableDictionary *chess = Info_array[i];
        for (id key in chess) {
            if ([key isEqualToString:@"name"]) {
                NSString *name = [chess objectForKey:key];
                [name_array addObject:name];
            }
        }
    }
    
    
    for (id key in name_array) {
        NSString *num = [key substringWithRange:NSMakeRange(1, 2)];
        [num_array addObject:num];
    }
    [num_array sortUsingSelector:@selector(compare:)];

    for (id key in num_array) {
        for (id key2 in name_array) {
            NSString *name = [key2 substringWithRange:NSMakeRange(1, 2)];
            if ([name isEqualToString:key]) {
                [name_array2 addObject:key2];
            }
        }
    }

    for (id key in name_array2) {
        NSString *name = key;
        for (id key2 in Info_array) {
            for (id key3 in key2) {
                if ([key3 isEqualToString:@"name"]) {
                    NSString *name2 = [key2 objectForKey:key3];
                    if ([name2 isEqualToString:name]) {
                        [self.nameArray addObject:key2];
                    }
                }
            }
        }
    }

}

#pragma mark - CollectionViewDelegate&Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nameArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"yooooo";
    [collectionView registerClass:[ChessCollectionViewCell class] forCellWithReuseIdentifier:identifi];
    ChessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifi forIndexPath:indexPath];
    NSMutableDictionary *dic = self.nameArray[indexPath.row];
    for (id key in dic) {
        if ([key isEqualToString:@"name"]) {
            cell.nameLabel.text = [[dic objectForKey:key] substringWithRange:NSMakeRange(0, 1)];
        }
        if ([key isEqualToString:@"attack"]) {
            cell.attackLable.text = [dic objectForKey:key];
        }
        if ([key isEqualToString:@"health"]) {
            cell.healthLable.text = [dic objectForKey:key];
        }
        NSString *t_ag = [dic objectForKey:@"name"];
        cell.t_ag = t_ag;
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *array_AH     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path_AH     = [array_AH objectAtIndex:0];
    NSString *filename_AH = [path_AH stringByAppendingPathComponent:@"AttackAndHealth.plist"];
    self.AHDic            = [[NSMutableDictionary alloc]initWithContentsOfFile:filename_AH];
    
    ChessCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.name_choose         = cell.nameLabel.text;
    self.attack_choose       = cell.attackLable.text;
    self.health_choose       = cell.healthLable.text;
    self.t_ag = cell.t_ag;
    
    if (![self.t_ag isEqualToString:self.last_Info[0]]) {
        if (![self.last_Info[0] isEqualToString:@"last_name"]) {
            if (![self.last_Info[1] isEqualToString:@"0"]) {
                NSMutableArray *health = [[NSMutableArray alloc]init];
                health = [self.AHDic[self.last_Info[1]] mutableCopy];
                [health removeObject:@([self.last_Info[2] integerValue])];
                [self.AHDic setObject:health forKey:self.last_Info[1]];
                [self.AHDic writeToFile:filename_AH atomically:YES];
                [self.d_elegate SelecteNewChess];
            }
        }

    }

        [self.last_Info replaceObjectAtIndex:0 withObject:self.t_ag];
        [self.last_Info replaceObjectAtIndex:1 withObject:self.attack_choose];
        [self.last_Info replaceObjectAtIndex:2 withObject:self.health_choose];
    
    
    if ([self.attack_choose isEqualToString:@"0"]&&[self.health_choose isEqualToString:@"0"]) {
        [self.d_elegate SelecteNewChess];
    }else
    {
        [self.AHDic writeToFile:filename_AH atomically:YES];
        [self.d_elegate SelectedWithName:self.name_choose Attack:self.attack_choose Health:self.health_choose];
        
    }
    self.DidChoose = YES;
    
    [self.d_elegate ShowCardWithName:self.t_ag];
}

-(void)GetAttack:(NSString *)attack AndHealth:(NSString *)health
{
    self.attack_choose = attack;
    self.health_choose = health;
    if (self.t_ag) {
        for (id key in self.chessDic) {
            if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"R"]) {
                NSMutableDictionary *Dic = [[NSMutableDictionary alloc]init];
                Dic = [self.chessDic objectForKey:key];
                for (id key2 in Dic) {
                    if ([key2 isEqualToString:@"name"]) {
                        if ([[Dic objectForKey:key2] isEqualToString:self.t_ag]) {
                            [Dic setObject:attack forKey:@"attack"];
                            [Dic setObject:health forKey:@"health"];
                            break;
                        }
                    }
                }
                
            }
        }
        
    }
    self.DidChoose = NO;
    [self.chessDic writeToFile:self.filename atomically:YES];
    [self reloadData];

}

-(BOOL)IsCHessChoose
{
    return self.DidChoose;
}

@end
