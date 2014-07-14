//
//  QuestionViewController.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 5/19/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//


/*
 Chức năng test cần thêm các bổ sung nữa để trở nên hoàn hảo:
 
 + Người dùng được phép chọn số lượng question.
 
 + Thông báo chưa thể làm test được do số lượng từ mà hệ thống xác định bạn chưa biết quá ít, để bổ sung thêm các từ bạn chưa biết, bạn có thể tiếp tục sử dụng chức năng Free reading và tra cứu nghĩa những từ xuất hiện trong câu mà bạn ko biết nghĩa.
 
 + Sau khi làm test xong, hiển thị kết quả, có thể cho người dùng các lựa chọn như: Xem lại kết quả từng câu/từng câu sai người dùng đã chọn (khi đó Objective Test cần thêm 1 thuộc tính là đáp án đã chọn), Quay lại trang Test ban đầu.
 
 */


#import "QuestionViewController.h"
#import "Test.h"
#import "SSCheckBoxView.h"
#import "Toast+UIView.h"

#import "CodeColor.h"
#import "Constants.h"
#import "MFSideMenu.h"

//random function
#include <stdlib.h>

#define HEIGHT_BAR 64
@interface QuestionViewController () {
    
    UITextView *textViewQuestion;
    
    SSCheckBoxView *checkBoxA;
    SSCheckBoxView *checkBoxB;
    SSCheckBoxView *checkBoxC;
    SSCheckBoxView *checkBoxD;
    
    int pendingQuestion;
    UILabel *labelNumberQuestion;
    UIButton *menuButton;
    
    UISwipeGestureRecognizer *leftGesture;
    UISwipeGestureRecognizer *rightGesture;
    
    BOOL resultQuestion;
    int resultTest;
}

@end

@implementation QuestionViewController

@synthesize arrayQuestion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                self.view.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arrayTestsUpdated:) name:@"haki.englishnow.test" object:nil];
        
    }
    return self;
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Doing Test";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;

    
//    [self setupMenuBarButtonItems];
    
    [self addViewLabels];
    
    [self addViewQuestionAndAnwer];
    
    [self addSwipeGesture];
    [self addButtonMenu];
    [self addShutdownButton];
    
    resultQuestion = 0;
    resultTest = 0;
    
}

- (void)addButtonMenu {
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(10.0f, 15.0f, 40.0f, 50.0f);
    [menuButton setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu2.png"]];
    imageView.frame = CGRectMake(0.0f, 20.0f, 25.0f, 25.0f);
    
    [menuButton addSubview:imageView];
//    [menuButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
}

- (void)addShutdownButton {
    UIButton *shutdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shutdownButton.frame = CGRectMake(320 - 10 -40, 15.0f, 40.0f, 50.0f);
    [shutdownButton setBackgroundColor:[UIColor clearColor]];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shutdown.png"]];
    imageView.frame = CGRectMake(15.0f, 20.0f, 25.0f, 25.0f);
    [shutdownButton addSubview:imageView];
    
//    [shutdownButton setImage:[UIImage imageNamed:@"shutdown.png"] forState:UIControlStateNormal];
    [shutdownButton addTarget:self action:@selector(displayResult) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutdownButton];
}

- (void)addViewLabels {
    
    UIImageView *preView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.png"]];
    preView.frame = CGRectMake(0, HEIGHT_BAR, 320, 24);
//    [self.view addSubview:preView];
    
    labelNumberQuestion = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 40)];
    labelNumberQuestion.textAlignment = NSTextAlignmentCenter;
    labelNumberQuestion.font = [UIFont fontWithName:fontTitle size:25];
    labelNumberQuestion.textColor = [UIColor grayColor];
    [self.view addSubview:labelNumberQuestion];
    
    UILabel *labelQuestion = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 300, 30)];
    labelQuestion.text = @"Question: Choose the correct answer!";
    labelQuestion.textColor = [UIColor grayColor];
    labelQuestion.font = [UIFont fontWithName:@"HoeflerText-Regular" size:15];
    [self.view addSubview:labelQuestion];
    
    UILabel *labelAnswer = [[UILabel alloc] initWithFrame:CGRectMake(10, 310, 300, 30)];
    labelAnswer.text = @"Answer:";
    labelAnswer.textColor = [UIColor grayColor];
    labelAnswer.font = [UIFont fontWithName:@"HoeflerText-Regular" size:15];
    [self.view addSubview:labelAnswer];
    
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(20, 345, 280, 1)];
    imageLine.image = [UIImage imageNamed:@"36.png"];
    [self.view addSubview:imageLine];
    
}


- (void)addViewQuestionAndAnwer{
    
    //    labelQuestion.font = [UIFont fontWithName:@"EuphemiaUCAS" size:15];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 300, 170)];
    background.image = [UIImage imageNamed:@"15_2.png"];
    [self.view addSubview:background];
    
    textViewQuestion = [[UITextView alloc] initWithFrame:CGRectMake(10, 130, 300, 150)];
    textViewQuestion.editable = NO;
    [textViewQuestion setBackgroundColor:[UIColor clearColor]];
    textViewQuestion.font = [UIFont fontWithName:fontLabel size:18];
    textViewQuestion.textColor = [UIColor brownColor];
    
    [self.view addSubview:textViewQuestion];
    
    
    checkBoxA = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(20, 350, 140, 40)
                                                style:kSSCheckBoxViewStyleGreen
                                              checked:NO];
    
    checkBoxB = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(180, 350, 140, 40)
                                                style:kSSCheckBoxViewStyleGreen
                                              checked:NO];
    
    
    checkBoxC = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(20, 420, 140, 40)
                                                style:kSSCheckBoxViewStyleGreen
                                              checked:NO];
    
    
    checkBoxD = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(180, 420, 140, 40)
                                                style:kSSCheckBoxViewStyleGreen
                                              checked:NO];
    
    [checkBoxA setStateChangedTarget:self
                            selector:@selector(checkBoxViewChangedState:)];
    [checkBoxB setStateChangedTarget:self
                            selector:@selector(checkBoxViewChangedState:)];
    [checkBoxC setStateChangedTarget:self
                            selector:@selector(checkBoxViewChangedState:)];
    [checkBoxD setStateChangedTarget:self
                            selector:@selector(checkBoxViewChangedState:)];
    
    [checkBoxA.textLabel setTextColor:[CodeColor colorFromHexString:buttonColor]];
    [checkBoxB.textLabel setTextColor:[CodeColor colorFromHexString:buttonColor]];
    [checkBoxC.textLabel setTextColor:[CodeColor colorFromHexString:buttonColor]];
    [checkBoxD.textLabel setTextColor:[CodeColor colorFromHexString:buttonColor]];

    
    [self.view addSubview:checkBoxA];
    [self.view addSubview:checkBoxB];
    [self.view addSubview:checkBoxC];
    [self.view addSubview:checkBoxD];
    
    
    
}


- (void)arrayTestsUpdated: (NSNotification *)notif {
    
    if (notif) {
        
        arrayQuestion = [notif object];
        
        pendingQuestion = -1;
        
        [self nextQuestion];
        
    }
    
}

- (void)setupMenuBarButtonItems {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"3_2.png"] forBarMetrics:UIBarMetricsDefault];
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(0.0f, 0.0f, 30.0f, 44.0f);
    //    [button setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(previousQuestion) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *barButtonItemLeft = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousQuestion)];
    self.navigationItem.leftBarButtonItem = barButtonItemLeft;
    
    UIBarButtonItem *barButtonItemRight = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextQuestion)];
    self.navigationItem.rightBarButtonItem = barButtonItemRight;
    
    
}

- (void)addSwipeGesture {
    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextQuestion)];
    [leftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftGesture];
    
    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousQuestion)];
    [rightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightGesture];
}

- (void)addDataForQuestion: (Test *)theTest {
    
//    NSString *question = [self questionFromSentence:theTest.sentence correctAnswer:theTest.correctAnswer];
    
    [textViewQuestion setText:theTest.sentence];
    
    int r = arc4random() % 4;
    
    switch (r) {
        case 0:
            [checkBoxA setText:theTest.correctAnswer];
            [checkBoxB setText:theTest.wrongAnswer1];
            [checkBoxC setText:theTest.wrongAnswer2];
            [checkBoxD setText:theTest.wrongAnswer3];
            break;
            
        case 1:
            [checkBoxA setText:theTest.wrongAnswer1];
            [checkBoxB setText:theTest.correctAnswer];
            [checkBoxC setText:theTest.wrongAnswer2];
            [checkBoxD setText:theTest.wrongAnswer3];
            break;
            
        case 2:
            [checkBoxA setText:theTest.wrongAnswer2];
            [checkBoxB setText:theTest.wrongAnswer1];
            [checkBoxC setText:theTest.correctAnswer];
            [checkBoxD setText:theTest.wrongAnswer3];
            break;
            
        case 3:
            [checkBoxA setText:theTest.wrongAnswer3];
            [checkBoxB setText:theTest.wrongAnswer1];
            [checkBoxC setText:theTest.wrongAnswer2];
            [checkBoxD setText:theTest.correctAnswer];
            break;
            
        default:
            break;
    }
    
}


//TODO: Lam cho hoan hoa hon.
- (NSString *)questionFromSentence: (NSString *)sentence correctAnswer: (NSString *)correctAnswer {
    

    NSString *question = [[NSString alloc] init];
    
    NSString *replaceNomal = [NSString stringWithFormat:@" %@ ", correctAnswer];
    
    question = [sentence stringByReplacingOccurrencesOfString:replaceNomal withString:@" _____ "];
    
    // truong hop viet hoa
    if ([sentence isEqualToString:question]) {
        
        NSString *firstCapChar = [[correctAnswer substringToIndex:1] capitalizedString];
        NSString *cappedString = [correctAnswer stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        
        NSString *replaceUpcase = [NSString stringWithFormat:@" %@ ", cappedString];
        question = [sentence stringByReplacingOccurrencesOfString:replaceUpcase withString:@" ____ "];
        
        // truong hop dung dau dong
        if ([question isEqualToString:sentence]) {
            
            NSString *replaceFirst = [NSString stringWithFormat:@"%@ ", cappedString];
            question = [sentence stringByReplacingOccurrencesOfString:replaceFirst withString:@" ____ "];
            
            //thuong hop them _s
            if ([question isEqualToString:sentence]) {
                
                NSString *stringAddS = [correctAnswer stringByAppendingString:@"s"];
                NSString *replaceNomal1 = [NSString stringWithFormat:@" %@ ", stringAddS];
                question = [sentence stringByReplacingOccurrencesOfString:replaceNomal1 withString:@" ____ "];
                
                // truong hop them _es
                if ([question isEqualToString:sentence]) {
                
                    NSString *stringAddES = [correctAnswer stringByAppendingString:@"es"];
                    NSString *replaceNomal2 = [NSString stringWithFormat:@" %@ ", stringAddES];
                    question = [sentence stringByReplacingOccurrencesOfString:replaceNomal2 withString:@" ____ "];
                    
                    // truong hop them _ed
                    if ([question isEqualToString:sentence]) {
                        
                        NSString *stringAddED = [correctAnswer stringByAppendingString:@"ed"];
                        NSString *replaceNomal3 = [NSString stringWithFormat:@" %@ ", stringAddED];
                        question = [sentence stringByReplacingOccurrencesOfString:replaceNomal3 withString:@" ____ "];
                        
                        // truong hop them _ing
                        if ([question isEqualToString:sentence]) {
                            
                            NSString *stringAddING = [correctAnswer stringByAppendingString:@"ing"];
                            NSString *replaceNomal4 = [NSString stringWithFormat:@" %@ ", stringAddING];
                            question = [sentence stringByReplacingOccurrencesOfString:replaceNomal4 withString:@" ____ "];
                            
                            if ([question isEqualToString:sentence]) {
                                
                                // truong hop dung cuoi dong dau
                                NSString *replaceNomal5 = [NSString stringWithFormat:@" %@", correctAnswer];
                                question = [sentence stringByReplacingOccurrencesOfString:replaceNomal5 withString:@" ____ "];
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    

    return question;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        // do something here...
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (buttonIndex == 0) {
        pendingQuestion++;
    }
}


- (void)nextQuestion {
    
    pendingQuestion++;
    
    if (pendingQuestion < arrayQuestion.count) {
        
        [self updateQuestion];
        
    } else {
        pendingQuestion--;

        [self displayResult];
    }
    
    [self checkEnabelButtonBar];
    
    [self resetCheckButton];
    [self resetColorCheckBox];
    
    resultQuestion = 0;
    
    NSLog(@"%d/%d", resultTest, arrayQuestion.count);
}

- (void)displayResult {
    
    ResultTestViewController *resultViewController = [[ResultTestViewController alloc] init];
    resultViewController.resultDelegate = self;
    resultViewController.correct = resultTest;
    resultViewController.total = arrayQuestion.count;
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController presentViewController:resultViewController animated:YES completion:nil];
    
}

- (void)endTest {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)previousQuestion{
    
    pendingQuestion--;
    
    
    if (pendingQuestion >= 0) {
        
        [self updateQuestion];
        
    } else {
        // hien thong bao ket qua toan bai test. Dung may cau. Sai may cau.
    }
    
    [self checkEnabelButtonBar];
    
    [self resetCheckButton];
    [self resetColorCheckBox];
    
    resultQuestion = 1;
}


- (void)updateQuestion {
    Test *theTest = [arrayQuestion objectAtIndex:pendingQuestion];
    
    [self addDataForQuestion:theTest];
    
    [labelNumberQuestion setText:[NSString stringWithFormat:@"Question %d/%lu", pendingQuestion + 1, (unsigned long)arrayQuestion.count]];
}


- (void)checkEnabelButtonBar {
    
    if (pendingQuestion == 0) {
        
        self.navigationItem.leftBarButtonItem.enabled = NO;
        rightGesture.enabled = NO;
        
    } else {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        rightGesture.enabled = YES;
        
    }
    
    
    if (pendingQuestion == arrayQuestion.count - 1) {
        
        [self.navigationItem.rightBarButtonItem setTitle:@"Result"];
        leftGesture.enabled = NO;
        
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:@"Next"];
        leftGesture.enabled = YES;

    }
}

#pragma mark - Work with SSCheckBox

- (void)resetCheckButton {
    
    checkBoxA.checked = NO;
    checkBoxB.checked = NO;
    checkBoxC.checked = NO;
    checkBoxD.checked = NO;
    
}


- (void)resetColorCheckBox {
    checkBoxA.textLabel.textColor = [UIColor brownColor];
    checkBoxB.textLabel.textColor = [UIColor brownColor];
    checkBoxC.textLabel.textColor = [UIColor brownColor];
    checkBoxD.textLabel.textColor = [UIColor brownColor];
    
}


- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    NSLog(@"checkBoxViewChangedState: %d", cbv.checked);
    
    //reset checker
    [self resetCheckButton];
    [cbv setChecked:YES];
    
    Test *currentTest = [arrayQuestion objectAtIndex:pendingQuestion];
    
    if ([[cbv getText] isEqualToString: currentTest.correctAnswer]) {
        
        // cbv la dap an dung!
        [self.view makeToast:@"Great job! You are correct!" duration:1 position:@"center"];
        
        [self resetColorCheckBox];
        cbv.textLabel.textColor = [CodeColor colorFromHexString:buttonColor];
        
        if (resultQuestion == 0) {
            resultTest++;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self nextQuestion];
        });
        
    }
    else {
        // cbv la dap an sai!
        [self.view makeToast:@"Wrong! Try again" duration:1 position:@"center"];

        [self resetColorCheckBox];
        cbv.textLabel.textColor = [UIColor redColor];
        
        resultQuestion = 1;
    }   
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
