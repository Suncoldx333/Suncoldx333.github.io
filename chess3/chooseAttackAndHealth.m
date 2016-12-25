//
//  chooseAttackAndHealth.m
//  chess3
//
//  Created by WangZhaoyun on 15/12/21.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import "chooseAttackAndHealth.h"
#import <sqlite3.h>

@implementation chooseAttackAndHealth

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha           = 0.6f;
        self.delegate        = self;
        self.dataSource      = self;
        
        NSString *path_mainbundle_AH = [[NSBundle mainBundle] pathForResource:@"AttackHealth" ofType:@"plist"];
        NSMutableDictionary *AHDic   = [[NSMutableDictionary alloc]initWithContentsOfFile:path_mainbundle_AH];
        
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [array objectAtIndex:0];
        self.filename  = [path stringByAppendingPathComponent:@"AttackAndHealth.plist"];
        self.AHDic     = [[NSMutableDictionary alloc]initWithContentsOfFile:self.filename];
    
        self.AttackArray = [[NSMutableArray alloc]init];
        self.HealthArray = [[NSMutableArray alloc]init];
        //获取攻击/血量栏的数据
        NSArray *allAttacks    = [self.AHDic allKeys];
        NSArray *sortedAttacks = [allAttacks sortedArrayUsingSelector:@selector(compare:)];
        self.AttackArray       = sortedAttacks;
        
        NSString *selectedAttack = self.AttackArray[0];
        self.HealthArray         = self.AHDic[selectedAttack];

    }
    return self;
}


#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.AttackArray count];
    }else
    {
        return [self.HealthArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *attack = [NSString stringWithFormat:@"%@",self.AttackArray[row]];
        return attack;
    }else
    {
        NSString *health = [NSString stringWithFormat:@"%@",self.HealthArray[row]];
        return health;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *selectedAttack = self.AttackArray[row];
        self.HealthArray         = self.AHDic[selectedAttack];
        [self reloadComponent:1];
        [self selectRow:0 inComponent:1 animated:YES];
    }
}
#pragma mark - Sort
-(NSMutableArray *)maopao:(NSMutableArray *)array
{
    //sortedArrayUsingSelector方法没法正常排序所选Array,故添加一个冒泡算法
    //后来发现sortedUsingSelector可以，后期的代码使用了sorted
    BOOL finish =YES;
    for (int a= 1; a<=[array count]&&finish; a++) {
        finish = NO;
        for (NSUInteger b=(array.count - 1); b>=a; b--) {
            if ([[array objectAtIndex:b] floatValue] < [[array objectAtIndex:b-1] floatValue]) {
                [array exchangeObjectAtIndex:b withObjectAtIndex:b-1];
                finish =YES;
            }
        }
    }
    return array;
}
#pragma mark - CustomMethod
-(NSString *)decideAttackAndHealth
{
    //在其他方法中有对沙盒中的plist进行过修改，因此需重新生成
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    self.filename  = [path stringByAppendingPathComponent:@"AttackAndHealth.plist"];
    self.AHDic     = [[NSMutableDictionary alloc]initWithContentsOfFile:self.filename];
    
    //获取当前PickerView中的值，以x+y形式传递给Controller
    NSString *max           = @"0+0";
    NSInteger atatck        = [self selectedRowInComponent:0];
    NSString *attack_chooes = [NSString stringWithFormat:@"%@",self.AttackArray[atatck]];
    
    if (self.HealthArray.count > 0) {
        NSInteger health        = [self selectedRowInComponent:1];
        NSString *health_choose = self.HealthArray[health];
        max = [NSString stringWithFormat:@"%@+%@",attack_chooes,health_choose];
        //选取后，对应的数值被移除，在PickerView的DataSource：self.HealthArray和沙盒中的plist文件中；但仅移除health,因为attack是包含health的一个Array
        [self.HealthArray removeObject:health_choose];
        
        for (id key in self.AHDic) {
            if ([key isEqualToString:attack_chooes]) {
                [self.AHDic[attack_chooes] removeObject:health_choose];
            }
        }
        //修改plist文件后要重新写入，否则没有修改效果
        [self.AHDic writeToFile:self.filename atomically:YES];
        [self reloadAllComponents];
    }
    return max;
}

-(void)refrashWithAttack:(NSString *)attack  AndHealth:(NSString *)health
{
    //用于更新选取若干后攻击/血量后的PickerView数据。由于沙盒内的plist更新过，需重新获取
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    self.filename  = [path stringByAppendingPathComponent:@"AttackAndHealth.plist"];
    self.AHDic     = [[NSMutableDictionary alloc]initWithContentsOfFile:self.filename];
    
    NSNumber *health_number = @([health integerValue]);
    CGFloat attack_number   = [attack floatValue];
    self.HealthArray        = self.AHDic[attack];
    
    //在TableView的一个cell选中后，如果该cell内有某个棋子的攻击/血量的非零值，如1-3，
    [self.HealthArray addObject:health_number];
    [self maopao:self.HealthArray];
    
    NSInteger i = 0;
    for (i = 0; i<[self.HealthArray count]; i++) {
        if ([self.HealthArray[i] floatValue] > [health floatValue]) {
            break;
        }
    }
    
    [self selectRow:attack_number-1 inComponent:0 animated:YES];
    [self selectRow:i-1 inComponent:1 animated:YES];
    [self reloadComponent:1];
    [self.AHDic setObject:self.HealthArray forKey:attack];
    [self.AHDic writeToFile:self.filename atomically:YES];
}

-(void)removeSelecte
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    self.filename  = [path stringByAppendingPathComponent:@"AttackAndHealth.plist"];
    self.AHDic     = [[NSMutableDictionary alloc]initWithContentsOfFile:self.filename];
    
    NSArray *allAttacks    = [self.AHDic allKeys];
    NSArray *sortedAttacks = [allAttacks sortedArrayUsingSelector:@selector(compare:)];
    self.AttackArray       = sortedAttacks;
    
    NSInteger r_ow           = [self selectedRowInComponent:0];
    NSString *selectedAttack = self.AttackArray[r_ow];
    self.HealthArray         = self.AHDic[selectedAttack];
        
    [self reloadAllComponents];
    
    
    
}


-(void)resetPickerView
{
    NSString *path_mainbundle_AH = [[NSBundle mainBundle] pathForResource:@"AttackHealth" ofType:@"plist"];
    NSMutableDictionary *AHDic   = [[NSMutableDictionary alloc]initWithContentsOfFile:path_mainbundle_AH];
    [AHDic writeToFile:self.filename atomically:YES];
    self.AHDic             = [[NSMutableDictionary alloc]initWithContentsOfFile:self.filename];
    NSArray *allAttacks    = [self.AHDic allKeys];
    NSArray *sortedAttacks = [allAttacks sortedArrayUsingSelector:@selector(compare:)];
    self.AttackArray       = sortedAttacks;
    
    NSString *selectedAttack = self.AttackArray[0];
    self.HealthArray         = self.AHDic[selectedAttack];
    [self reloadAllComponents];
}

@end
