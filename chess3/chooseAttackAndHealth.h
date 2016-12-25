//
//  chooseAttackAndHealth.h
//  chess3
//
//  Created by WangZhaoyun on 15/12/21.
//  Copyright © 2015年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface chooseAttackAndHealth : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)     NSMutableArray *AttackArray;
@property (nonatomic,strong     )NSMutableArray *HealthArray;
@property (nonatomic,strong)NSMutableDictionary *AHDic;
@property (nonatomic,strong)           NSString *filename;
@property (nonatomic,strong)            NSArray *lineField;
@property (nonatomic)id<decideAttackAndHealthProtocol>choose_delegate;

-(NSString *)decideAttackAndHealth;
-(void)refrashWithAttack:(NSString *)attack
               AndHealth:(NSString *)health;
-(void)removeSelecte;
-(void)resetPickerView;

@end
