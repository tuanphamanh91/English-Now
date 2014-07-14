//
//  FreeReadingViewController.h
//  LabEng
//
//  Created by Tuan Pham Anh on 6/6/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeReadingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableVocabulary;

@end
