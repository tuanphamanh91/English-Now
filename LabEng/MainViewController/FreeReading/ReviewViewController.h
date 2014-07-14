//
//  ReviewViewController.h
//  English Now
//
//  Created by Tuan Pham Anh on 7/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tappedWordObjects;

@end
