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
//#import "UAConfig.h"
//#import "UAPush.h"
//#import "UAirship.h"

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
    arrList = [[NSMutableArray alloc] initWithObjects:@"Home",@"Helpful Numbers",@"Feedback",@"Share App",@"Rate us",@"Logout", nil];
    
    arrImage=[[NSMutableArray alloc]initWithObjects:@"ic_nav_home1.png",@"ic_nav_emergency_numbers1.png",@"ic_nav_feedback1.png",@"ic_nav_share_app1.png",@"ic_nav_rate_us1.png",@"ic_nav_logout1.png", nil];
    
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
    //NSLog(@"index path : %d",indexPath.row);
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
        //NSLog(@"str : %@",UserID);
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
        //share app
        NSString *text = @"Check out MyWheels by Crime Stoppers South Australia. Get it from -  ";
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/au/app/mywheels-australia/id914228666?ls=1&mt=8"];
        UIImage *image = [UIImage imageNamed:@"app_icon_120x120.png"];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:nil];
        
        controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                             UIActivityTypePrint,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
                                             UIActivityTypeAirDrop];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        [controller setCompletionHandler:^(NSString *activityType, BOOL completed)
         {
             if (completed)
             {
                 UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully Shared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [objalert show];
                 objalert = nil;
             }
         }];
    }
    else if (indexPath.row == 4)
    {
        //Rate us
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/au/app/mywheels-australia/id914228666?ls=1&mt=8"]];
    }
    else if (indexPath.row == 5)
    {
        NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        if(UserID == nil || UserID == (id)[NSNull null] || [UserID isEqualToString:@""])
        {
            LoginVC *obj = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
        else
        {
         UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
         objalert.tag = 1;
        [objalert show];
        }
        
    }
    else
    {
    
    }
    
    
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            
        }
        else
        {
            
            //log out
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
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleType"];
            //parkVehicle
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"parkVehicle"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleType"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vehicles"];
           // appdelegate.intCountPushNotification = 0;
            appdelegate.intMparking = 0;
            appdelegate.Time = 0;
            
            //remove profile pic
            //       NSString *photoURL = appdelegate.strPhotoURL;
            //        //NSLog(@"phtoturl : %@",appdelegate.strPhotoURL);
            //        NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
            //        NSString *filename = [parts objectAtIndex:[parts count]-1];
            //        //NSLog(@"file name : %@",filename);
            //
            //        NSString *str = @"My_Wheels_";
            //        NSString *strFileName = [str stringByAppendingString:filename];
            //        //NSLog(@"strfilename : %@",strFileName);
            //
            //         [[NSUserDefaults standardUserDefaults] removeObjectForKey:strFileName];
            
          //  [[UAPush shared] setPushEnabled:NO];
            
            [[NSUserDefaults standardUserDefaults]synchronize ];
            appdelegate.strUserID = @"";
            LoginVC *obj = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            [self.revealSideViewController replaceCentralViewControllerWithNewControllerWithoutPopping:nav];
            [self.revealSideViewController popViewControllerAnimated:YES];

        }
    }
}

@end
