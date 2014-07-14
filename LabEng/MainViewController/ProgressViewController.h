//
//  ProgressViewController.h
//  LabEng
//
//  Created by Tuan Pham Anh on 6/5/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableVocabulary;

@property (nonatomic, strong) NSMutableArray *arrayWords;
@end
