//
//  ReviewViewController.m
//  English Now
//
//  Created by Tuan Pham Anh on 7/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "ReviewViewController.h"
#import "TappedWordObject.h"
#import "CodeColor.h"
#import "Constants.h"
#import "MeanWordView.h"
#import "ProcessAPI.h"

@interface ReviewViewController () {

    UITableView *tappedWordTableView;
    MeanWordView *meanWordView;
    UIView *blackView;

}

@end

@implementation ReviewViewController
@synthesize tappedWordObjects;

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
    
    self.navigationItem.title = @"Review";
    [self.view setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    
    [self setupMenuBarButtonItems];
    
    tappedWordTableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 64, 260, 480 -64)];
    tappedWordTableView.dataSource = self;
    tappedWordTableView.delegate = self;
    tappedWordTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tappedWordTableView];
    
    [self addMeanWordView];
}

- (void)setupMenuBarButtonItems {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [self.navigationItem setRightBarButtonItem:barButtonItem];

    UIFont *font = [UIFont fontWithName:fontTitleNav size:20];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, font, NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)addMeanWordView {
    
    blackView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    [self.view addSubview:blackView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMeanWordView)];
    [blackView addGestureRecognizer:tapGesture];
    blackView.hidden = YES;
    
    meanWordView = [[MeanWordView alloc] initWithFrame:CGRectMake(10, 80, 300, 320)];
    [self.view addSubview:meanWordView];
    meanWordView.hidden = YES;
}

- (void)showMeanWordView {
    blackView.hidden = NO;
    meanWordView.hidden = NO;
}

- (void)hideMeanWordView {
    blackView.hidden = YES;
    meanWordView.hidden = YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return tappedWordObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    TappedWordObject *twobj = [tappedWordObjects objectAtIndex:indexPath.row];
    
    NSString *capitalisedText = [twobj.word stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                   withString:[[twobj.word substringToIndex:1] capitalizedString]];
    cell.textLabel.text = capitalisedText;
    cell.textLabel.font = [UIFont fontWithName:fontTitle size:20];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",twobj.numberTouch];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TappedWordObject *wobj = [tappedWordObjects objectAtIndex:indexPath.row];
    NSString *capitalisedText = [wobj.word stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                   withString:[[wobj.word substringToIndex:1] capitalizedString]];
    meanWordView.labelWord.text = capitalisedText;
    meanWordView.textViewMean.text = [[ProcessAPI sharedInstance] searchDictionary:wobj.word];
    [self showMeanWordView];
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 30;
//}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 1)];
//    v.backgroundColor = [CodeColor colorFromHexString:@"#CCC9C8"];
//    return v;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
