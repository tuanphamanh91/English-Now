//
//  ReadingViewController.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/6/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "ReadingViewController.h"
#import "CodeColor.h"
#import "Constants.h"
#import "TextViewSencence.h"
#import "DictionaryView.h"
#import "MFSideMenu.h"
#import "Toast+UIView.h"
#import "ProcessAPI.h"
#import "TappedWordObject.h"
#import "ReviewViewController.h"


@interface ReadingViewController () {
    UIScrollView *scrollView;
    CGRect screenSize;
    
    DictionaryView *dictionaryView;
    TextView *translateView;
    NSMutableArray *arraySentences;
    NSMutableArray *arraySentenceObjects;
    
    UIButton *menuButton;
    UILabel *labelTip;
    
    NSMutableArray *wordsTapped;
}

@end

@implementation ReadingViewController


#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnSentenceToday:) name:notificationNameTodaySentences object:nil];
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)returnSentenceToday: (NSNotification *)notif {
    if (notif) {
        
        arraySentenceObjects = [notif object];
        [self parseArray:arraySentenceObjects];
        
        [self addScrollView];
        
        [self.view hideToastActivity];
        [self addDictionaryView];
        
        [self addTranslateView];
        [self addButtonTranslate];
    }
}


- (void)parseArray: (NSMutableArray *)array {
    
    arraySentences = [[NSMutableArray alloc] init];
    
    for (SentenceObject *sobj in array) {
        [arraySentences addObject:sobj.text];
    }
    
    if (arraySentences.count == 0) {
        [arraySentences addObjectsFromArray:[NSArray arrayWithObjects:@"There is no such thing, at this stage of the world’s history in America, as an independent press. You know it and I know it. There is not one of you who dare write your honest opinions, and if you did, you know beforehand that it would never appear in print. I am paid weekly for keeping my honest opinions out of the paper I am connected with. Others of you are paid similar salaries for similar things, and any of you who would be foolish as to write honest opinions would be out on the streets looking for another job. If I allowed my honest opinions to appear in one issue of my papers, before twenty-four hours my occupation would be gone. The business of the journalist is to destroy the truth, to lie outright, to pervert, to vilify, to fawn at the feet of Mammon, and to sell his country and his race for his daily bread. You know it and I know it, and what folly is this toasting an independent press? We are the jumping jacks, they pull the strings and we dance. Our talents, our possibilities and our lives are all the property of other men. We are intellectual prostitutes.", @"The students have taken no notice of these instructions.", @"I thought you guys had a big party tonight.", @"People who count their chickens before they are hatched act very wisely because chickens run about so absurdly that it's impossible to count them accurately.", @"Everything is theoretically impossible until it's done.", @"What we've already achieved gives us hope for what we can and must achieve tomorrow.", @"That's the true genius of America; that America can change. Our Union can be perfected. What we've already achieved gives us hope for what we can and must achieve tomorrow.", @"The students have taken no notice of these instructions.", @"No one of us can cut himself off from the body of the community to which he belongs.", @"If you are a member of a primitive community and you wish to produce, say, food, there are two things that you must do.", nil]];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    
}


- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    [self.navigationController.navigationBar setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    [self.view makeToastActivity];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = YES;
    
    screenSize = [UIScreen mainScreen].bounds;
    
    wordsTapped = [[NSMutableArray alloc] init];
    
}

#pragma mark - Add UI
- (void)addButtonMenu {
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(10.0f, 36.0f, 25.0f, 25.0f);
    [menuButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    menuButton.hidden = YES;
    [self.view addSubview:menuButton];
}

- (void)addButtonTranslate {
    UIButton *btnTranslate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTranslate.frame = CGRectMake(screenSize.size.width/2 - 40, screenSize.size.height - 100, 80.0f, 80.0f);
    btnTranslate.backgroundColor = [UIColor orangeColor];
    [btnTranslate addTarget:self action:@selector(showTranslateSentence) forControlEvents:UIControlEventTouchUpInside];
    //    [menuButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    //    [menuButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    menuButton.hidden = YES;
    [self.view addSubview:btnTranslate];
}


- (void)addScrollView {
    
    scrollView = [[UIScrollView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    scrollView.contentSize = CGSizeMake(320*(arraySentences.count +1), screenSize.size.height - 64);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:240 green:230 blue:140 alpha:1];
    //    scrollView.backgroundColor = [CodeColor colorFromHexString:@"EEF0E4"];
    
    scrollView.delegate = self;
    
    [scrollView setShowsHorizontalScrollIndicator:YES];
    [scrollView setShowsVerticalScrollIndicator:NO];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuButton)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTapGesture];
    
    [self.view addSubview:scrollView];
    
    [self addTip];
    [self addTextView];
    [self addButtonMenu];
    
}


- (void)addTip {
    
    labelTip = [[UILabel alloc] init];
    labelTip.frame = CGRectMake(0, 45, screenSize.size.width, 20);
    labelTip.text = @"Tips: Double tap here to show or hide menu button.";
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.font = [UIFont fontWithName:fontLabel size:13];
    labelTip.textColor = [UIColor grayColor];
    
    [scrollView addSubview:labelTip];
}

- (void)addTextView {
    
    for (int i = 0; i < arraySentences.count; i++) {
        
        TextViewSencence *textView = [[TextViewSencence alloc] initWithFrame:CGRectMake(i*screenSize.size.width + 10, 85, screenSize.size.width - 10*2, screenSize.size.height - 180)];
        [textView.myTextView setText:[arraySentences objectAtIndex:i]];
        textView.delegate = self;
        [scrollView addSubview:textView];
        
    }
    
    // add tong ket hoac lam lai
    //congratulations. You have completed the sentences today
    
    [self addEndScreen];
    
}

- (void)addEndScreen {
    
    UILabel *labelCongrat = [[UILabel alloc] init];
    labelCongrat.frame = CGRectMake(arraySentences.count*screenSize.size.width + 20, 50, screenSize.size.width - 20*2, 40);
    labelCongrat.text = @"Congratulations!";
    labelCongrat.textAlignment = NSTextAlignmentCenter;
    labelCongrat.font = [UIFont fontWithName:fontTitle size:30];
    labelCongrat.textColor = [CodeColor colorFromHexString:buttonColor];
    
    [scrollView addSubview:labelCongrat];
    
    UILabel *labelComplete = [[UILabel alloc] init];
    labelComplete.frame = CGRectMake(arraySentences.count*screenSize.size.width + 5, 90, screenSize.size.width - 5*2, 20);
    labelComplete.text = @"You have completed the sentences today.";
    labelComplete.textAlignment = NSTextAlignmentCenter;
    labelComplete.font = [UIFont fontWithName:fontTitle size:16];
    labelComplete.textColor = [CodeColor colorFromHexString:buttonColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(arraySentences.count*screenSize.size.width + 10, 115, screenSize.size.width - 10*2, 1)];
    lineView.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [scrollView addSubview:lineView];
    
    [scrollView addSubview:labelComplete];
    
    UIButton *learnAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    learnAgain.layer.cornerRadius = 8;
    
    learnAgain.frame = CGRectMake(arraySentences.count*screenSize.size.width + 20, 220, screenSize.size.width - 20*2, 50);
    learnAgain.backgroundColor = [CodeColor colorFromHexString:codeColor];
    [learnAgain setTitle:@"Read Again" forState:UIControlStateNormal];
    learnAgain.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [learnAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [learnAgain setTintColor:[UIColor whiteColor]];
    
    [learnAgain addTarget:self action:@selector(learnAgain) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:learnAgain];
    
    
    UIButton *finishReading = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finishReading.layer.cornerRadius = 8;
    
    finishReading.frame = CGRectMake(arraySentences.count*screenSize.size.width + 20, 340, screenSize.size.width - 20*2, 50);
    finishReading.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [finishReading setTitle:@"Finish Reading" forState:UIControlStateNormal];
    finishReading.titleLabel.font = [UIFont fontWithName:fontTitle size:20];
    [finishReading setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishReading setTintColor:[UIColor whiteColor]];
    
    [finishReading addTarget:self action:@selector(finishReading) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:finishReading];
}

- (void)addDictionaryView {
    
    dictionaryView = [[DictionaryView alloc] initWithFrame:CGRectMake(0, -10, 320, 0)];
    dictionaryView.hidden = NO;
    [self.view addSubview:dictionaryView];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewOfDictionary)];
    [self.view addGestureRecognizer:tapView];
    
}

- (void)addTranslateView {
    
    translateView = [[TextView alloc] initWithFrame:CGRectMake(30, 100, 260, 200)];
    translateView.hidden = YES;
    translateView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:translateView];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTranslateView)];
    [translateView addGestureRecognizer:tapView];
    
}


#pragma mark - Action


- (void)textView:(TextViewSencence *)textView tappedAtWord:(NSString *)wordTapped {
    
    if ([wordTapped isEqualToString:@""])    {
        [self hideViewOfDictionary];
    }
    else {
        
        wordTapped = [wordTapped lowercaseString];
        [self showDictionaryView];
        [dictionaryView.textViewMean setText:[[ProcessAPI sharedInstance] searchDictionary:wordTapped]];
        [dictionaryView.textViewMean scrollRangeToVisible:NSMakeRange(0, 0)];
        
        [[ProcessAPI sharedInstance] wordTapped:wordTapped];
        [wordsTapped addObject:wordTapped];
    }
}


- (void)showTranslateSentence {
    
    if (translateView.hidden == NO) {
        translateView.hidden = YES;
        
    } else {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);

        if (page < arraySentenceObjects.count) {
            SentenceObject *sobj = [arraySentenceObjects objectAtIndex:page];
            if (![sobj.translateText isEqualToString:@""]) {
                [translateView setText: sobj.translateText];
            } else {
                [translateView setText: @"Please wait... Translate by google!"];
                
            }
        }
        
        translateView.hidden = NO;
    }
    
}
- (void)hideTranslateView {
    translateView.hidden = YES;
    [translateView setText:@""];
}

- (void)learnAgain {
    
    CGPoint firstScreen = CGPointMake(0, 0);
    [scrollView setContentOffset:firstScreen animated:NO];
}

- (void)finishReading {
//    [self.navigationController popViewControllerAnimated:YES];
    ReviewViewController *reviewViewController = [[ReviewViewController alloc] init];
    reviewViewController.tappedWordObjects = [self processWithTappedWords:wordsTapped];
    
    [self.navigationController pushViewController:reviewViewController animated:YES];
    
}

- (NSMutableArray *)processWithTappedWords:(NSMutableArray *)words {
    NSMutableArray *tapWordObjects = [[NSMutableArray alloc] init];
    
    while (words.count >0) {
        NSInteger n = 1;
        for (int i = 1; i <words.count; i++) {
            if ([words[0] isEqualToString: words[i]]) {
                n++;
                [words removeObjectAtIndex:i];
                i--;
            }
        }
        
        TappedWordObject *twobj = [[TappedWordObject alloc] initWithWord:words[0] andNumberTouch:n];
        [tapWordObjects addObject:twobj];
        [words removeObjectAtIndex:0];
    }
    
    return tapWordObjects;
}

- (void)showMenuButton {
    
    [labelTip removeFromSuperview];
    if (menuButton.hidden == YES) {
        menuButton.hidden = NO;
    } else {
        menuButton.hidden = YES;
    }
    
}


- (void)showDictionaryView {
    
    [UIView animateWithDuration:0.2 animations:^{
        dictionaryView.frame = CGRectMake(0, -10, 320, 150);
        [dictionaryView.textViewMean setFrame:CGRectMake(0, 30, 320, 120)];
        [scrollView setFrame:CGRectMake(0, 70, screenSize.size.width, screenSize.size.height - 100)];
        
        
    }];
    
}

- (void)hideViewOfDictionary {
    
    [UIView animateWithDuration:0.1 animations:^{
        [dictionaryView setFrame:CGRectMake(0, -10, 320, 0)];
        [dictionaryView.textViewMean setFrame:CGRectMake(0, 0, 320, 0)];
        [scrollView setFrame:[UIScreen mainScreen].bounds];
    }];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ScrollView Delegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self hideViewOfDictionary];
    [self hideTranslateView];
    [labelTip removeFromSuperview];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)viewScroll {

//    static NSInteger previousPage = 0;
//    CGFloat pageWidth = viewScroll.frame.size.width;
//    float fractionalPage = viewScroll.contentOffset.x / pageWidth;
//    NSInteger page = lround(fractionalPage);
//    if (previousPage != page) {
//        // Page has changed, do your thing!
//        // ...
//        // Finally, update previous page
//        NSLog(@"%d", page);
//        previousPage = page;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
