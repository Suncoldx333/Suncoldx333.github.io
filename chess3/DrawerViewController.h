//
//  DrawerViewController.h
//  chess3
//
//  Created by WangZhaoyun on 16/1/14.
//  Copyright © 2016年 WangZhaoyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawerControllerChild;
@protocol DrawerControllerPresenting;


@interface DrawerViewController : UIViewController

@property (nonatomic,strong,readonly)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *centerViewController;
@property (nonatomic,strong,readonly)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *leftViewController;
@property (nonatomic,strong,readonly)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *chooseViewController;
@property (nonatomic,strong,readonly)UIViewController<DrawerControllerChild,DrawerControllerPresenting> *playViewController;

-(id)initWithLeftViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) leftViewController
          CenterViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) centerViewController
          ChooseViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) chooseViewController
            PlayViewController:(UIViewController<DrawerControllerChild,DrawerControllerPresenting> *) playViewController;


-(void)open;
-(void)close;
-(void)replaceCenterViewControllerWithViewController:(UIViewController<DrawerControllerChild, DrawerControllerPresenting> *)viewController;


@end

@protocol DrawerControllerChild <NSObject>

@property(nonatomic,weak)DrawerViewController *drawer;

@end

@protocol DrawerControllerPresenting <NSObject>

@optional

- (void)drawerControllerWillOpen:(DrawerViewController *)drawerController;
- (void)drawerControllerDidOpen:(DrawerViewController *)drawerController;
- (void)drawerControllerWillClose:(DrawerViewController *)drawerController;
- (void)drawerControllerDidClose:(DrawerViewController *)drawerController;


@end