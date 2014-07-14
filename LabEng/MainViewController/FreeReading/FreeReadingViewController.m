//
//  FreeReadingViewController.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/6/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "FreeReadingViewController.h"
#import "CodeColor.h"
#import "Constants.h"
#import "MFSideMenu.h"
#import "ReadingViewController.h"
#import "WordObject.h"
#import "CustomCell.h"
#import "MeanWordView.h"
#import "ProcessAPI.h"
#import "WordObject.h"

@interface FreeReadingViewController () {
    
    MeanWordView *meanWordView;
    UIView *blackView;
    
    NSMutableArray *arrayWordsToday;
    NSMutableArray *arrayWordsData;

}

@end

@implementation FreeReadingViewController

@synthesize tableVocabulary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifDataWordsToday:) name:notificationNameTodayWords object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Free Reading";
    [self.view setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    [self setupMenuBarButtonItems];
    [self addVocabularyView];

    [self addFreeReadingView];
    
    [self addMeanWordView];

}



- (void)addViewStartButton {
    
    UIButton *startTestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startTestButton.layer.cornerRadius = 8;
    
    startTestButton.frame = CGRectMake(20, 400, 280, 40);
    startTestButton.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [startTestButton setTitle:@"Start Free Reading" forState:UIControlStateNormal];
    startTestButton.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [startTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startTestButton setTintColor:[UIColor whiteColor]];
    
    [startTestButton addTarget:self action:@selector(startReading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startTestButton];
}


- (void)addMeanWordView {
    blackView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    blackView.hidden = YES;
    [self.view addSubview:blackView];
    
    meanWordView = [[MeanWordView alloc] initWithFrame:CGRectMake(10, 80, 300, 320)];
    [self.view addSubview:meanWordView];
    meanWordView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMeanWordView)];
    [blackView addGestureRecognizer:tapGesture];
}

- (void)showMeanWordView {
    blackView.hidden = NO;
    meanWordView.hidden = NO;
}

- (void)hideMeanWordView {
    blackView.hidden = YES;
    meanWordView.hidden = YES;
}



- (void)addVocabularyView {
    
    UIView *vocabularyList = [[UIView alloc] initWithFrame:CGRectMake(10, 64, 300, 235)];
    vocabularyList.backgroundColor = [UIColor whiteColor];
    vocabularyList.layer.cornerRadius = 8;
    
    UILabel *labelVocabulary = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    labelVocabulary.textColor = [UIColor orangeColor];
    labelVocabulary.font = [UIFont fontWithName:fontTitle size:20];
    labelVocabulary.text = @"Vocabulary Today";
    labelVocabulary.textAlignment = NSTextAlignmentCenter;
    [vocabularyList addSubview:labelVocabulary];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 32, 280, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [vocabularyList addSubview:lineView];
    
    UILabel *labelWord = [[UILabel alloc] initWithFrame:CGRectMake(12, 35, 60, 25)];
    labelWord.textColor = [UIColor grayColor];
    labelWord.font = [UIFont fontWithName:fontTitle size:15];
    labelWord.text = @"Word";
    labelWord.textAlignment = NSTextAlignmentCenter;
    [vocabularyList addSubview:labelWord];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    labelWord.attributedText = [[NSAttributedString alloc] initWithString:labelWord.text
                                                             attributes:underlineAttribute];
    
    UILabel *labelRank = [[UILabel alloc] initWithFrame:CGRectMake(180, 35, 100, 25)];
    labelRank.textColor = [UIColor grayColor];
    labelRank.font = [UIFont fontWithName:fontTitle size:15];
    labelRank.text = @"Popular Rank";
    labelRank.textAlignment = NSTextAlignmentCenter;
    [vocabularyList addSubview:labelRank];
    
    labelRank.attributedText = [[NSAttributedString alloc] initWithString:labelRank.text
                                                               attributes:underlineAttribute];
    
    tableVocabulary = [[UITableView alloc] initWithFrame:CGRectMake(10, 60, 260, 170)];
    tableVocabulary.dataSource = self;
    tableVocabulary.delegate = self;
    tableVocabulary.backgroundColor = [UIColor clearColor];
    
    [vocabularyList addSubview:tableVocabulary];
    
    
    [self.view addSubview:vocabularyList];
    
}

- (void)addFreeReadingView {
    
    UIView *freeReadingView = [[UIView alloc] initWithFrame:CGRectMake(10, 305, 300, 160)];
    freeReadingView.backgroundColor = [UIColor whiteColor];
    freeReadingView.layer.cornerRadius = 8;
    
    UILabel *labelFree = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    
    labelFree.textColor = [UIColor orangeColor];
    labelFree.font = [UIFont fontWithName:fontTitle size:20];
    labelFree.text = @"How To Learn";
    labelFree.textAlignment = NSTextAlignmentCenter;
    [freeReadingView addSubview:labelFree];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, 280, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [freeReadingView addSubview:lineView];
    
    
    UILabel *vocabularyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 280, 50)];
    vocabularyLabel.textColor = [UIColor grayColor];
    vocabularyLabel.font = [UIFont fontWithName:fontLabel size:13];
    vocabularyLabel.text = @"You will read the sentences that are displayed. You also can touch a word to view it's meaning.";
    vocabularyLabel.numberOfLines = 0;
    vocabularyLabel.textAlignment = NSTextAlignmentCenter;
    [freeReadingView addSubview:vocabularyLabel];
    
    
    UIButton *startTestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startTestButton.layer.cornerRadius = 8;
    
    startTestButton.frame = CGRectMake(10, 100, 280, 50);
    startTestButton.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [startTestButton setTitle:@"Start Free Reading" forState:UIControlStateNormal];
    startTestButton.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [startTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startTestButton setTintColor:[UIColor whiteColor]];
    
    [startTestButton addTarget:self action:@selector(startReading) forControlEvents:UIControlEventTouchUpInside];
    
    [freeReadingView addSubview:startTestButton];
   
    
    [self.view addSubview:freeReadingView];
    
}

#pragma mark - Action

- (void)startReading {
    ReadingViewController *reading = [[ReadingViewController alloc] init];
    [self.navigationController pushViewController:reading animated:YES];
    
    [[ProcessAPI sharedInstance] getSentencesContainWordInArray:arrayWordsToday];
}

- (void)notifDataWordsToday: (NSNotification *)notif {
    if (notif) {
        arrayWordsData = [notif object];
        if (arrayWordsData.count == 0) {
            return;
        }
        NSInteger number = [self numberWordsDaily];
        if (number < arrayWordsData.count) {
            NSArray *arr = [arrayWordsData subarrayWithRange:NSMakeRange(0, number)];
            arrayWordsToday = [NSMutableArray arrayWithArray:arr];
        } else {
            NSArray *arr = [arrayWordsData subarrayWithRange:NSMakeRange(0, arrayWordsData.count)];
            arrayWordsToday = [NSMutableArray arrayWithArray:arr];

        }
        [arrayWordsData removeObjectsInArray:arrayWordsToday];
        [self.tableVocabulary reloadData];
    }
}

- (NSInteger )numberWordsDaily {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberWordsDaily = [defaults integerForKey:userDefaultNumberWords];
    return numberWordsDaily;
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
    return arrayWordsToday.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    WordObject *word = [arrayWordsToday objectAtIndex:indexPath.row];
    
    NSString *capitalisedText = [word.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                              withString:[[word.text substringToIndex:1] capitalizedString]];
    cell.textLabel.text = capitalisedText;
    cell.textLabel.font = [UIFont fontWithName:fontTitle size:20];
    cell.textLabel.textColor = [CodeColor colorFromHexString:codeColor];
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.labelRank setText:[NSString stringWithFormat:@"%ld", (long)word.rank]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WordObject *word = [arrayWordsToday objectAtIndex:indexPath.row];
    NSString *capitalisedText = [word.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                   withString:[[word.text substringToIndex:1] capitalizedString]];
    meanWordView.labelWord.text = capitalisedText;
    meanWordView.textViewMean.text = [[ProcessAPI sharedInstance] searchDictionary:word.text];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordObject *word = [arrayWordsToday objectAtIndex:indexPath.row];
    
    [[ProcessAPI sharedInstance] deleteWord:word.text];
    [arrayWordsToday removeObjectAtIndex:indexPath.row];
    NSArray *a = [NSArray arrayWithObject:indexPath];
    [tableVocabulary deleteRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationFade];

    if (arrayWordsData.count > 0) {
        [arrayWordsToday addObject:[arrayWordsData objectAtIndex:0]];
        [arrayWordsData removeObjectAtIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:arrayWordsToday.count - 1 inSection:0];
        NSArray *b = [NSArray arrayWithObject:index];
        [tableVocabulary insertRowsAtIndexPaths:b withRowAnimation:UITableViewRowAnimationFade];
    }
    NSLog(@"Delete row done!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
