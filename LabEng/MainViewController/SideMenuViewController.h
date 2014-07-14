//
//  SideMenuViewController.h
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayMenus;
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) UINavigationController *navMainController;
@property (nonatomic, strong) UINavigationController *navFreeReadingController;
@property (nonatomic, strong) UINavigationController *navTestController;
@property (nonatomic, strong) UINavigationController *navSettingController;
@property (nonatomic, strong) UINavigationController *navProgressController;


@property (nonatomic, strong) UIImage *imageProfile;
@property (nonatomic, strong) NSString *username;

- (void)selectRow: (NSIndexPath *)indexPath;
@end
