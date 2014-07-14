//
//  LoginView.m
//  FbLogin
//
//  Created by Tuan Pham Anh on 3/4/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//


#import "LoginView.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"
#import "CodeColor.h"

@implementation LoginView
@synthesize loginButton = _loginButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [CodeColor colorFromHexString:codeColor];
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _loginButton.layer.cornerRadius = 8;
        _loginButton.frame = CGRectMake(80, 300, 160, 40);
        _loginButton.backgroundColor = [CodeColor colorFromHexString:buttonColor];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
        
        [_loginButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_loginButton];
        
    }
    return self;
}

- (void)buttonTouched:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
//        [FBSession openActiveSessionWithPublishPermissions:@[@"public_profile", @"email"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//            // Retrieve the app delegate
//            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//            // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//            [appDelegate sessionStateChanged:session state:status error:error];
//            
//            [self getProfileInfo];
//        }];
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [self getProfileInfo];
         }];
        
//        
//        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email"]
//                                           allowLoginUI:YES
//                                      completionHandler:
//         ^(FBSession *session, FBSessionState state, NSError *error) {
//             
//             // Retrieve the app delegate
//             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//             [appDelegate sessionStateChanged:session state:state error:error];
//             
//            [self getProfileInfo];
//             
//         }];
        
        
    }
}

- (void)getProfileInfo {
    
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            
            if (!error) {
                
                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", [user objectID]];
                
                NSURL *url = [NSURL URLWithString:userImageURL];
                
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
                
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                
                
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    UIImage  *image = responseObject;
                    NSData *pictureData = UIImagePNGRepresentation(image);
                    
                    NSString *email = [user objectForKey:@"email"];
                    NSLog(@"Email: %@", email);
                    
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:user.name forKey:@"username"];
                    [userDefault setObject:pictureData forKey:@"imageData"];
                    [userDefault setObject:email forKey:@"email"];

                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"Image error: %@", error);
                }];
                
                [requestOperation start];
                
                
            }
        }];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
