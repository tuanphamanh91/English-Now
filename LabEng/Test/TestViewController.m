//
//  TestViewController.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 5/18/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//



#import "TestViewController.h"
#import "QuestionViewController.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "CodeColor.h"
#import "Constants.h"

@interface TestViewController () {
    
    UIPickerView *picker;

}

@end

@implementation TestViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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


- (void)viewWillAppear:(BOOL)animated {

    [picker selectRow:1 inComponent:0 animated:YES];
        
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationItem.title = @"Test";
    
    [self.view setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    [self setupMenuBarButtonItems];
    
    [self addViewPicker];
    [self addStartButton];
}

- (void)addViewPicker {
    
    UIView *viewPicker = [[UIView alloc] initWithFrame:CGRectMake(10, 84, 300, 250)];
    viewPicker.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelWorkout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    
    labelWorkout.textColor = [UIColor orangeColor];
    labelWorkout.font = [UIFont fontWithName:fontTitle size:20];
    labelWorkout.text = @"Number Questions";
    labelWorkout.textAlignment = NSTextAlignmentCenter;
    [viewPicker addSubview:labelWorkout];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, 280, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [viewPicker addSubview:lineView];
    
    UILabel *vocabularyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 280, 25)];
    vocabularyLabel.textColor = [UIColor grayColor];
    vocabularyLabel.font = [UIFont fontWithName:fontLabel size:15];
    vocabularyLabel.text = @"Select number of questions for Test";
    vocabularyLabel.textAlignment = NSTextAlignmentCenter;
    [viewPicker addSubview:vocabularyLabel];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 70, 280, 80)];
    picker.layer.cornerRadius = 8;
    picker.backgroundColor = [CodeColor colorFromHexString:codeColor];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    [viewPicker addSubview:picker];
    
    [self.view addSubview:viewPicker];
    

}

- (void)addStartButton {
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.layer.cornerRadius = 8;
    startButton.frame = CGRectMake(20, 380, 280, 50);
    startButton.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [startButton setTitle:@"Start Doing Test" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton setTintColor:[UIColor whiteColor]];
    [startButton addTarget:self action:@selector(startDoingTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}



#pragma mark - Picker Delegate & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 5;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 45)];
        tView.textColor = [UIColor whiteColor];
        tView.font = [UIFont fontWithName:fontTitle size:30];
        tView.text = [NSString stringWithFormat:@"%d", 10 + row*5];
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    // Fill the label text here
    
    return tView;
}

#pragma mark - Action



- (void)startDoingTest {
    
    NSInteger rowPicker = [picker selectedRowInComponent:0];
    NSInteger valuePicker = 10 + rowPicker*5;
    
    QuestionViewController *questionViewController = [[QuestionViewController alloc] init];
    [self.navigationController pushViewController:questionViewController animated:YES];

//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate.databaseManager createTestsWithNumberQuestion:valuePicker];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
