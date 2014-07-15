//
//  NavigationHomeVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 17/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "NavigationHomeVC.h"
#import "TableViewCell.h"
#import "EmergencyNoVC.h"
#import "PPRevealSideViewController.h"
#import "FeedBackVC.h"
#import "HomePageVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"

@interface NavigationHomeVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation NavigationHomeVC
@synthesize arrImage,arrList;

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
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    arrList = [[NSMutableArray alloc] initWithObjects:@"Home",@"Emergency Number",@"Feedback",@"Share App",@"Rate us",@"Logout", nil];
    
    arrImage=[[NSMutableArray alloc]initWithObjects:@"ic_nav_home.png",@"ic_nav_emergency_numbers.png",@"ic_nav_feedback",@"ic_nav_share_app.png",@"ic_nav_rate_us.png",@"ic_nav_logout.png", nil];
    
        self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Methods...
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblList.text = [arrList objectAtIndex:[indexPath row]];
    [cell.imgList setImage:[UIImage imageNamed:[arrImage objectAtIndex:[indexPath row]]]];
    
    if(indexPath.row == 1)
    {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,140, 320, 1)];
        [lbl setBackgroundColor:[UIColor whiteColor]];
        [_tblNavigation addSubview:lbl];
        
    }
    else if (indexPath.row == 4)
    {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,351, 320, 1)];
        [lbl setBackgroundColor:[UIColor whiteColor]];
        [_tblNavigation addSubview:lbl];
    }
    else
    {
    
    }
    // [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
  //  [cell.imgList setImage:[UIImage imageNamed:[arrImage objectAtIndex:[indexPath row]]]];
   
     
   // cell.lblDuration.text = [NSString stringWithFormat:@"%@",[DurationArray objectAtIndex:[indexPath row]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        HomePageVC *obj = [[HomePageVC alloc] initWithNibName:@"HomePageVC" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
        [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
        [self.revealSideViewController popViewControllerAnimated:YES];

    }
    else if (indexPath.row == 1)
    {
        EmergencyNoVC *obj = [[EmergencyNoVC alloc] initWithNibName:@"EmergencyNoVC" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
        [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
        [self.revealSideViewController popViewControllerAnimated:YES];

    }
    else if (indexPath.row == 2)
    {
        NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        NSLog(@"str : %@",UserID);
        if(UserID == nil || UserID == (id)[NSNull null])
        {
            LoginVC *obj = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
            [self.revealSideViewController popViewControllerAnimated:YES];

            
        }
        else
        {
            FeedBackVC *obj = [[FeedBackVC alloc] initWithNibName:@"FeedBackVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
    }
    else if (indexPath.row == 3)
    {
        
    }
    else if (indexPath.row == 4)
    {
    
    }
    else if (indexPath.row == 5)
    {        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dob"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emergencyContact"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emergency_contact_number"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fb_id"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fb_token"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first_name"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_name"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"license_no"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"license_photo_url"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile_number"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"modified_at"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"photo_url"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"postcode"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile_completed"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"samaritan_points"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"security_question"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"suburb"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
        //parkVehicle
                 [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"parkVehicle"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vehicles"];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        appdelegate.strUserID = @"";
        LoginVC *obj = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
        [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
        [self.revealSideViewController popViewControllerAnimated:YES];
        
    }
    else
    {
    
    }
    
    
}

@end
