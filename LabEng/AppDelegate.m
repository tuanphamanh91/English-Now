//
//  AppDelegate.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/5/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "AppDelegate.h"
#import "SideMenuViewController.h"
#import "MainViewController.h"
#import "MFSideMenu.h"
#import "ProcessAPI.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize loginView;
@synthesize leftSideMenuController, navMainController, navProgressController, navSettingController, navTestController, navFreeReadingController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // status bar
    [self createViewControllers];
    [self createUserDefault];

    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navMainController
                                                    leftMenuViewController:leftSideMenuController
                                                    rightMenuViewController:nil];
    
    self.window.rootViewController = container;
    

    [self.window makeKeyAndVisible];
    
    [[ProcessAPI sharedInstance] getTodayWords];

    [self createViewLogin];
    //fb
    // Whenever a person opens the app, check for a cached session
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        
        loginView.hidden = NO;
    }
    
    return YES;
}

- (void)createUserDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger numberWordsDaily = [defaults integerForKey:userDefaultNumberWords];
    if (!numberWordsDaily) {
        [defaults setInteger:10 forKey:userDefaultNumberWords];
    }
    
    NSMutableArray *arrayCacheWords = (NSMutableArray *)[defaults arrayForKey:userDefaultCacheWords];
    if (!arrayCacheWords) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [defaults setObject:arr forKey:userDefaultCacheWords];
    }
    
    [defaults synchronize];

}

- (void)createViewControllers {
    
    mainViewController = [[MainViewController alloc] init];
    navMainController = [[UINavigationController alloc] initWithRootViewController:mainViewController];

    freeViewController = [[FreeReadingViewController alloc] init];
    navFreeReadingController = [[UINavigationController alloc] initWithRootViewController:freeViewController];
    
    progressViewController = [[ProgressViewController alloc] init];
    navProgressController = [[UINavigationController alloc] initWithRootViewController:progressViewController];
    
    testViewController = [[TestViewController alloc] init];
    navTestController = [[UINavigationController alloc] initWithRootViewController:testViewController];
    
    settingViewController = [[SettingViewController alloc] init];
    navSettingController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    leftSideMenuController = [[SideMenuViewController alloc] init];
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}


// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    [loginView setHidden:NO];
    
    // Confirm logout message
    //    [self showMessage:@"You're now logged out" withTitle:@""];
}


// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    [loginView setHidden:YES];
    
    // Welcome message
    //    [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}





- (void) createViewLogin {
    loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.window addSubview:loginView];
    loginView.hidden = YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application NS_AVAILABLE_IOS(4_0) {
    
//    NSLog(@"background");
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application NS_AVAILABLE_IOS(4_0) {
//    NSLog(@"foreground");
    
//    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
//    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *sToday = [DateFormatter stringFromDate:[NSDate date]];
//    
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *recent = [defaults objectForKey:@"recent"];
//    
//    if (![sToday isEqualToString:recent]) {
//        
//        [databaseManager getNumberWordsToday];
//        [navFreeReadingController popToRootViewControllerAnimated:NO];
//    }
}


@end
