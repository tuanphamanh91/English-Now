//
//  ProgressViewController.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/5/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "ProgressViewController.h"
#import "MFSideMenu.h"
#import "Constants.h"
#import "CodeColor.h"
#import "CustomCell.h"
#import "WordObject.h"
#import "AppDelegate.h"
#import "MeanWordView.h"
#import "ProcessAPI.h"
@interface ProgressViewController () {
    
    MeanWordView *meanWordView;
    UIView *blackView;
}

@end

@implementation ProgressViewController
@synthesize tableVocabulary, arrayWords;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnWords:) name:notificationNameAllWords object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)returnWords: (NSNotification *)notif {
    if (notif) {
        arrayWords = [notif object];
        [self.tableVocabulary reloadData];
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [[ProcessAPI sharedInstance] getAllWords];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Progress";
    [self.view setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    [self setupMenuBarButtonItems];
    [self addTableView];
    [self addMeanWordView];

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


- (void)addTableView {
    
    
    tableVocabulary = [[UITableView alloc] initWithFrame:CGRectMake(30, 64, 260, 480 -64)];
    tableVocabulary.dataSource = self;
    tableVocabulary.delegate = self;
    tableVocabulary.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableVocabulary];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arrayWords.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    WordObject *word = [arrayWords objectAtIndex:indexPath.row];
    
    NSString *capitalisedText = [word.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                   withString:[[word.text substringToIndex:1] capitalizedString]];
    cell.textLabel.text = capitalisedText;
    cell.textLabel.font = [UIFont fontWithName:fontTitle size:20];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [word nextDay];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.labelRank.textColor = [UIColor whiteColor];

    [cell.labelRank setText:[NSString stringWithFormat:@"%ld", (long)word.rank]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WordObject *wobj = [arrayWords objectAtIndex:indexPath.row];
    NSString *capitalisedText = [wobj.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                   withString:[[wobj.text substringToIndex:1] capitalizedString]];
    meanWordView.labelWord.text = capitalisedText;
    meanWordView.textViewMean.text = [[ProcessAPI sharedInstance] searchDictionary:wobj.text];
    [self showMeanWordView];

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 1)];
//    v.backgroundColor = [CodeColor colorFromHexString:@"#CCC9C8"];
//    return v;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordObject *word = [arrayWords objectAtIndex:indexPath.row];
    
    [[ProcessAPI sharedInstance] deleteWord:word.text];
    [arrayWords removeObjectAtIndex:indexPath.row];
    NSArray *a = [NSArray arrayWithObject:indexPath];
    [tableVocabulary deleteRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationFade];
    
    NSLog(@"Delete row done!");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
