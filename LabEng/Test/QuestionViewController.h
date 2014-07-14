//
//  QuestionViewController.h
//  EngLishNow
//
//  Created by Tuan Pham Anh on 5/19/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultTestViewController.h"

@interface QuestionViewController : UIViewController <UIAlertViewDelegate, ResultDelegate>

@property (nonatomic, strong) NSMutableArray *arrayQuestion;


@end
