//
//  SettingViewController.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/23/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "SettingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "CodeColor.h"
#import "Constants.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[CodeColor colorFromHexString:codeColor]];
    [self setupMenuBarButtonItems];
    self.navigationItem.title = @"Setting";

    [self addButtonLogout];
    
    [self setupMenuBarButtonItems];

    
}

- (void)addButtonLogout {
    
    UIButton *fbLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fbLogout.layer.cornerRadius = 8;
    
    fbLogout.frame = CGRectMake(80, 300, 160, 40);
    fbLogout.backgroundColor = [CodeColor colorFromHexString:buttonColor];
    [fbLogout setTitle:@"Logout" forState:UIControlStateNormal];
    [fbLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fbLogout setTintColor:[UIColor whiteColor]];
    
    [fbLogout addTarget:self action:@selector(fbLogoutMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fbLogout];
}


- (void)fbLogoutMethod:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            // Retrieve the app delegate
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
            [appDelegate sessionStateChanged:session state:status error:error];
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
