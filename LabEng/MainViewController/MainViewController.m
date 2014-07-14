//
//  MainViewController.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/5/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "CodeColor.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "ProcessAPI.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize numberLabel;

#pragma mark - Add View
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberWordsToday:) name:notificationNameNumberWords object:nil];
    }
    return self;
}

- (void)setupMenuBarButtonItems {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 30.0f, 44.0f);
    [button setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    UIFont *font = [UIFont fontWithName:fontTitleNav size:20];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, font, NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"English Now";

    [self.view setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    [self setupMenuBarButtonItems];
    
    [self addViewWorkout];
    [self addProgressView];
    
    NSInteger number = [[ProcessAPI sharedInstance] getNumberTodayWords];
    [self.numberLabel setText:[NSString stringWithFormat:@"%d", number]];
}


- (void)addProgressView {
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, 300, 215 - 5 -64)];
    progressView.backgroundColor = [UIColor whiteColor];
    progressView.layer.cornerRadius = 8;
    
    UILabel *labelWorkout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    
    labelWorkout.textColor = [UIColor orangeColor];
    labelWorkout.font = [UIFont fontWithName:fontTitle size:20];
    labelWorkout.text = @"Your Progress";
    labelWorkout.textAlignment = NSTextAlignmentCenter;
    [progressView addSubview:labelWorkout];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, 280, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [progressView addSubview:lineView];
    
    [self.view addSubview:progressView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoProgressViewController)];
    [progressView addGestureRecognizer:tapGesture];
    
}
- (void)addViewWorkout {
    
    UIView *workoutView = [[UIView alloc] initWithFrame:CGRectMake(10, 215, 300, 250)];
    workoutView.backgroundColor = [UIColor whiteColor];
    workoutView.layer.cornerRadius = 8;
    
    UILabel *labelWorkout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];

    labelWorkout.textColor = [UIColor orangeColor];
    labelWorkout.font = [UIFont fontWithName:fontTitle size:20];
    labelWorkout.text = @"Your Daily Workout";
    labelWorkout.textAlignment = NSTextAlignmentCenter;
    [workoutView addSubview:labelWorkout];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, 280, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [workoutView addSubview:lineView];
    
    UILabel *vocabularyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 280, 25)];
    vocabularyLabel.textColor = [UIColor grayColor];
    vocabularyLabel.font = [UIFont fontWithName:fontLabel size:15];
    vocabularyLabel.text = @"Number of words pending to review today:";
    vocabularyLabel.textAlignment = NSTextAlignmentCenter;
    [workoutView addSubview:vocabularyLabel];
    
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 280, 100)];
    numberLabel.textColor = [CodeColor colorFromHexString:buttonColor];
    numberLabel.font = [UIFont fontWithName:fontTitle size:100];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [workoutView addSubview:numberLabel];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.layer.cornerRadius = 8;
    startButton.frame = CGRectMake(20, workoutView.frame.size.height - 40 - 25, 260, 40);
    startButton.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [startButton setTitle:@"Start Your Workout" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton setTintColor:[UIColor whiteColor]];
    [startButton addTarget:self action:@selector(gotoFreeViewController) forControlEvents:UIControlEventTouchUpInside];
    [workoutView addSubview:startButton];
    
    [self.view addSubview:workoutView];
    
    UILabel *readyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, workoutView.frame.size.height -20 , 240, 20)];
    readyLabel.textColor = [UIColor grayColor];
    readyLabel.font = [UIFont fontWithName:fontLabel size:12];
    readyLabel.text = @"Your personal Free Reading is ready.";
    readyLabel.textAlignment = NSTextAlignmentCenter;
    [workoutView addSubview:readyLabel];
}


#pragma mark - Action

- (void)gotoProgressViewController {
        
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];    
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    SideMenuViewController *side = appdelegate.leftSideMenuController;
    [side selectRow:index];

}


- (void)gotoFreeViewController {
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    SideMenuViewController *side = appdelegate.leftSideMenuController;
    [side selectRow:index];

}

- (void)numberWordsToday: (NSNotification *)notif {
    if (notif) {
        int number = [[[notif userInfo] valueForKey:@"number"] intValue];
        numberLabel.text = [NSString stringWithFormat:@"%d", number];
    }
}


#pragma mark - Design

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
