//
//  ResultTestViewController.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/10/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "ResultTestViewController.h"
#import "CodeColor.h"
#import "Constants.h"

@interface ResultTestViewController () {
    CGRect screenSize;
    
}

@end

@implementation ResultTestViewController

@synthesize resultDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    screenSize = [UIScreen mainScreen].bounds;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *labelCongrat = [[UILabel alloc] init];
    labelCongrat.frame = CGRectMake(screenSize.size.width + 20, 100, screenSize.size.width - 20*2, 40);
    labelCongrat.text = @"Congratulations!";
    labelCongrat.textAlignment = NSTextAlignmentCenter;
    labelCongrat.font = [UIFont fontWithName:fontTitle size:30];
    labelCongrat.textColor = [CodeColor colorFromHexString:buttonColor];
    
    [self.view addSubview:labelCongrat];
    
    UILabel *labelComplete = [[UILabel alloc] init];
    labelComplete.frame = CGRectMake(5, 140, screenSize.size.width - 5*2, 20);
    labelComplete.text = @"You have completed the test. Your result:";
    labelComplete.textAlignment = NSTextAlignmentCenter;
    labelComplete.font = [UIFont fontWithName:fontTitle size:16];
    labelComplete.textColor = [CodeColor colorFromHexString:buttonColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 165, screenSize.size.width - 10*2, 1)];
    lineView.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:labelComplete];
    
    UILabel *labelResult = [[UILabel alloc] init];
    labelResult.frame = CGRectMake(5, 180, screenSize.size.width - 5*2, 70);
    labelResult.text = [NSString stringWithFormat:@"%d/%d", _correct, _total];
    labelResult.textAlignment = NSTextAlignmentCenter;
    labelResult.font = [UIFont fontWithName:fontTitle size:70];
    labelResult.textColor = [CodeColor colorFromHexString:buttonColor];
    [self.view addSubview:labelResult];

    
    
    UIButton *learnAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    learnAgain.layer.cornerRadius = 8;
    
    learnAgain.frame = CGRectMake(20, 270, screenSize.size.width - 20*2, 50);
    learnAgain.backgroundColor = [CodeColor colorFromHexString:codeColor];
    [learnAgain setTitle:@"Review Again" forState:UIControlStateNormal];
    learnAgain.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [learnAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [learnAgain setTintColor:[UIColor whiteColor]];
    
    [learnAgain addTarget:self action:@selector(reviewAgain) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:learnAgain];
    
    
    UIButton *finishReading = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finishReading.layer.cornerRadius = 8;
    
    finishReading.frame = CGRectMake(20, 400, screenSize.size.width - 20*2, 50);
    finishReading.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [finishReading setTitle:@"Finish Test" forState:UIControlStateNormal];
    finishReading.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [finishReading setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishReading setTintColor:[UIColor whiteColor]];
    
    [finishReading addTarget:self action:@selector(finishTest) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:finishReading];
    
    
    
}

- (void)reviewAgain {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishTest {
    [resultDelegate endTest];

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
