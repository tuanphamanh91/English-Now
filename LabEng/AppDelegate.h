//
//  AppDelegate.h
//  LabEng
//
//  Created by Tuan Pham Anh on 6/5/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginView.h"
#import "SideMenuViewController.h"
//
#import "TestViewController.h"
#import "ProgressViewController.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "FreeReadingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

    FreeReadingViewController *freeViewController;
    TestViewController *testViewController;
    ProgressViewController *progressViewController;
    MainViewController *mainViewController;
    SettingViewController *settingViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginView *loginView;

@property (strong, nonatomic) SideMenuViewController *leftSideMenuController;

@property (strong, nonatomic) UINavigationController *navMainController;
@property (nonatomic, strong) UINavigationController *navFreeReadingController;
@property (nonatomic, strong) UINavigationController *navTestController;
@property (nonatomic, strong) UINavigationController *navSettingController;
@property (nonatomic, strong) UINavigationController *navProgressController;


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
