//
//  SideMenuViewController.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "CodeColor.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FXBlurView.h"

@interface SideMenuViewController () {
    
    AppDelegate *appDelegate;
    UIView *whiteView;
    NSInteger indexSelect;
    
}
@end

@implementation SideMenuViewController

@synthesize arrayMenus, imageProfile, tableView, username;

@synthesize  navMainController, navSettingController, navTestController, navProgressController, navFreeReadingController;




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIImageView *cloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Marina-Bay-Sands-Night-Singapore-960x640.jpg"]];
    cloud.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:cloud];
    self.view.backgroundColor = [UIColor whiteColor];
    
    FXBlurView *fxView = [[FXBlurView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    fxView.blurRadius = 100;
    fxView.dynamic = NO;
    fxView.tintColor = [UIColor blackColor];
    [self.view addSubview:fxView];
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 2, 48)];
    whiteView.backgroundColor = [UIColor whiteColor];
    indexSelect = 0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 260, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.alwaysBounceVertical = NO;
    
    [self.view addSubview:self.tableView];
    //    self.tableView.backgroundColor = [CodeColor colorFromHexString:@"#eaeaea"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    navMainController = appDelegate.navMainController;
    navFreeReadingController = appDelegate.navFreeReadingController;
    navTestController = appDelegate.navTestController;
    navProgressController = appDelegate.navProgressController;
    navSettingController = appDelegate.navSettingController;
    
    arrayMenus = [NSMutableArray arrayWithObjects:navMainController, navFreeReadingController, navTestController, navProgressController, navSettingController, nil];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    self.username = [userDefaults objectForKey:@"username"];
//    NSData *imageData = [userDefaults dataForKey:@"imageData"];
//    self.imageProfile = [UIImage imageWithData:imageData];
    
    // status bar
    NSIndexPath *ind1 = [NSIndexPath indexPathForRow:4 inSection:0];
//    [self selectRow:ind1];
    
    NSIndexPath *ind2 = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self selectRow:ind2];
    [tableView selectRowAtIndexPath:ind1
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
    [tableView selectRowAtIndexPath:ind2
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
}



- (void)selectRow: (NSIndexPath *)indexPath {
    
    [tableView selectRowAtIndexPath:indexPath
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];

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
    return arrayMenus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:fontTitle size:20];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            
            cell.textLabel.text = @"Main";
            
            UIImageView *imageViewCell = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
            imageViewCell.image = [UIImage imageNamed:@"home.png"];
            cell.imageView.image = [UIImage imageNamed:@"home.png"];
//            [cell addSubview:imageViewCell];
//
//            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 30)];
//            labelName.text = self.username;

        }
            break;
        case 1:
            cell.textLabel.text = @"Free Reading";
            cell.imageView.image = [UIImage imageNamed:@"glass.png"];

            break;
        case 2:
            cell.textLabel.text = @"Test";
            cell.imageView.image = [UIImage imageNamed:@"test.png"];

            break;
        case 3:
            cell.textLabel.text = @"Progress";
            cell.imageView.image = [UIImage imageNamed:@"process.png"];

            break;
        case 4:
            cell.textLabel.text = @"Setting - Feedback";
            cell.imageView.image = [UIImage imageNamed:@"setting.png"];

            break;
        default:
            break;
    }
    
    if (indexPath.row == indexSelect) {
        [cell addSubview:whiteView];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.menuContainerViewController.centerViewController = navMainController;
            break;
            
        case 1:
            self.menuContainerViewController.centerViewController = navFreeReadingController;
            break;
            
        case 2:
            self.menuContainerViewController.centerViewController = navTestController;
            break;
            
        case 3:
            self.menuContainerViewController.centerViewController = navProgressController;
            break;
            
        case 4:
            self.menuContainerViewController.centerViewController = navSettingController;
            
            break;
        default:
            break;
    }
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    indexSelect = indexPath.row;
    [self.tableView reloadData];
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



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
