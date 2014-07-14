//
//  ResultTestViewController.h
//  LabEng
//
//  Created by Tuan Pham Anh on 6/10/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultDelegate <NSObject>

- (void)endTest;

@end

@interface ResultTestViewController : UIViewController

@property (nonatomic, assign) NSInteger correct;

@property (nonatomic, assign) NSInteger total;

@property (strong) id<ResultDelegate> resultDelegate;


@end
