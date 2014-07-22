

//
//  HomePageVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 10/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "HomePageVC.h"
#import "AppDelegate.h"
#import "NavigationHomeVC.h"
#import "PPRevealSideViewController.h"
#import "AboutUsVC.h"
#import "UserProfileVC.h"
#import "LoginVC.h"
#import "SelectVehicleCell.h"
#import "ImParkingHereVC.h"
#import "FindVehicleVC.h"

#import "AFNetworking.h"
#import "FileNewReportViewController.h"
#import "UpdatesViewController.h"
#import "ReportSightingViewController.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HomePageVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation HomePageVC
@synthesize btnNav;
@synthesize viewNewReport,viewReport,viewUpdates,viewAboutUs;
@synthesize intblue;

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
    self.library = [[ALAssetsLibrary alloc] init];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"user id:%@",appdelegate.strUserID);
    [_voewMakeModel setHidden:YES];
    [_viewCoach setHidden:YES];
    [_tblMakeModel setSeparatorInset:UIEdgeInsetsZero];
    _arrVehicles = [[NSDictionary alloc]init];
    _arrVehicles = [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
    NSLog(@"vehivle count : :%d",[_arrVehicles count]);
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"arr vehicles : %@",_arrVehicles);
    int countVehicle = [_arrVehicles count];
    [_btnFindVehicle setEnabled:NO];
    [_imgTick setHidden:YES];

   if( appdelegate.intReg == 1)
   {
       timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(callDisclaimer:) userInfo:nil repeats:NO];
       appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
       self.navigationController.navigationBarHidden = YES;

   }
    
    if(countVehicle == 1)
    {
        NSString *str = [[_arrVehicles valueForKey:@"vehicle_make"] objectAtIndex:0];
        NSString *str1 = [[_arrVehicles valueForKey:@"vehicle_model"] objectAtIndex:0];
        NSString *str4 = [str stringByAppendingString:@" "];
        NSString *str2 = [str4 stringByAppendingString:str1];
        NSString  *strVehicleId = [[_arrVehicles valueForKey:@"vehicle_id"] objectAtIndex:0];
        [_btnHeading setTitle:str2 forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:strVehicleId forKey:@"CurrentVehicleID"];
        [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:@"CurrentVehicleName"];
        [_voewMakeModel setHidden:YES];
    }
    
    
    NSString *strCurrentVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    NSString *strCurrentVehicleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleName"];
    NSLog(@"strcurrent : %@",strCurrentVehicleID);
    NSLog(@"strCurretn Vehicle name :%@",strCurrentVehicleName);
    if([_arrVehicles count] > 0)
    {
      if(strCurrentVehicleID == nil || strCurrentVehicleID == (id)[NSNull null])
      {
        NSString *str = [[_arrVehicles valueForKey:@"vehicle_make"] objectAtIndex:0];
        NSString *str1 = [[_arrVehicles valueForKey:@"vehicle_model"] objectAtIndex:0];
        NSString *str4 = [str stringByAppendingString:@" "];
        NSString *str2 = [str4 stringByAppendingString:str1];
        NSString  *strVehicleId = [[_arrVehicles valueForKey:@"vehicle_id"] objectAtIndex:0];
        [_btnHeading setTitle:str2 forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:strVehicleId forKey:@"CurrentVehicleID"];
        [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:@"CurrentVehicleName"];
        [_voewMakeModel setHidden:YES];
      }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"CurrentVehicleID"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CurrentVehicleName"];
        [_btnHeading setTitle:@"" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
   // [self CurrentLocationIdentifier];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
  NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"longitude"];
    
    
    
    NSLog(@"vehicles : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"]);
    
 
    //parkVehicle
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"];
   
    NSLog(@"arr : %@",arr);
    NSLog(@"arr counbt :%d",[arr count]);
    if(arr == nil || arr == (id)[NSNull null])
    {
    
    }
    else
    {
    for(int i=0;i<[arr count];i++)
    {
        NSString *strvid = [[arr objectAtIndex:i]valueForKey:@"VehivleID"];
        NSLog(@"strvid : %@",strvid);
        if(strvid == strCurrentVehicleID && strvid != nil)
        {
            [_btnMParking setBackgroundColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] ];
             [_btnMParking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_imgTick setHidden:NO];
            intblue = 1;
            [_btnFindVehicle setEnabled:YES];
        }
        else
        {
             [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setTitleColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [_imgTick setHidden:YES];
            [_btnFindVehicle setEnabled:NO];
        }
    }
    }
   

   NSString *strVehicleName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleName"];
    [_btnHeading setTitle:strVehicleName forState:UIControlStateNormal];
    
   
    NSLog(@"%@",latitude);
    NSLog(@"%@",longitude);

    self.navigationController.navigationBarHidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.ViewMain addGestureRecognizer:tap];
    
     NSString *photoURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
    if(photoURL == nil || photoURL == (id)[NSNull null] || [photoURL isEqualToString:@""])
    {
    
    }
    else
    {
    NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    NSLog(@"file name : %@",filename);
    
    NSString *str = @"My_Wheels_";
    NSString *strFileName = [str stringByAppendingString:filename];
    NSLog(@"strfilename : %@",strFileName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:strFileName];
    
    if(imageData == nil)
    {
       
        [self downloadImageWithURL:[NSURL URLWithString:photoURL] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                _imgProfilepic.image = image;
            }
        }];

        
        // Store the data
        
    }
    else
    {  UIImage *contactImage = [UIImage imageWithData:imageData];
        _imgProfilepic.image = contactImage;
    }
    
    }
   
    
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   
                                   NSString *photoURL1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
                                   NSArray *parts = [photoURL1 componentsSeparatedByString:@"/"];
                                   NSString *filename = [parts objectAtIndex:[parts count]-1];
                                   NSLog(@"file name : %@",filename);
                                   
                                   NSString *str = @"My_Wheels_";
                                   NSString *strFileName = [str stringByAppendingString:filename];
                                   NSLog(@"strfilename : %@",strFileName);
                                   
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                   
                                   [defaults setObject:data forKey:strFileName];
                                   [defaults synchronize];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
- (void) dismissKeyboard
{
    // add self
    [self.voewMakeModel setHidden:YES];
    [self.ViewMain setBackgroundColor:[UIColor clearColor]];
    [self.ViewMain setAlpha:0.9];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if(photoURL == nil || photoURL == (id)[NSNull null] || [photoURL isEqualToString:@""])
//    {
//        _imgProfilepic .image = [UIImage imageNamed:@"default_profile_2.png"];
//    }
//    else
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
//            //  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
//            
//            //                    UIImage *image = [UIImage imageWithData:imageData];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^(void) {
//                
//                //  _imgUserProfilepic.image = image;
//                NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
//                NSString *filename = [parts objectAtIndex:[parts count]-1];
//                NSLog(@"file name : %@",filename);
//                
//                NSString *str = @"My_Wheels_";
//                NSString *strFileName = [str stringByAppendingString:filename];
//                NSLog(@"strfilename : %@",strFileName);
//                
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSData *imageData = [defaults dataForKey:strFileName];
//                
//                if(imageData == nil)
//                {
//                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    _imgProfilepic.image = image;
//                    
//                    // Store the data
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    
//                    [defaults setObject:imageData forKey:strFileName];
//                    [defaults synchronize];
//                }
//                else
//                {  UIImage *contactImage = [UIImage imageWithData:imageData];
//                    _imgProfilepic.image = contactImage;
//                }
//                
//            });
//        });
//    }

      if(IsIphone5)
    {
        //scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
       // self.scrollview.contentSize = CGSizeMake(320, 800);
        _map.frame = CGRectMake(0,20, 320, 270);
        _btnParking.frame = CGRectMake(1, 210, 150, 60);
        _btnVehicles.frame = CGRectMake(152, 210, 150, 60);
        viewReport.frame = CGRectMake(0, 230, 320, 60);
        viewNewReport.frame = CGRectMake(0, 290, 320, 60);
        viewUpdates.frame = CGRectMake(0, 350, 320, 60);
        viewUpdates.frame = CGRectMake(0, 410, 320, 60);
    
    }
    else
    {
        _map.frame = CGRectMake(0,70, 320, 270);
        _btnParking.frame = CGRectMake(1, 120, 150, 55);
        _btnVehicles.frame = CGRectMake(152, 120, 150, 55);
        viewReport.frame = CGRectMake(0, 230, 320, 55);
        viewNewReport.frame = CGRectMake(0, 290, 320, 55);
        viewUpdates.frame = CGRectMake(0, 350, 320, 55);
        viewUpdates.frame = CGRectMake(0, 410, 320, 55);
//        scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
        
//        self.scrollview.contentSize = CGSizeMake(320, 700);
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark selectore method
- (IBAction)tapDetected:(UIGestureRecognizer *)sender {
//    [_viewCoach setHidden:YES];
    CGRect theFrame = _viewCoach.frame;
    theFrame.origin = CGPointMake(_viewCoach.frame.origin.x, 0);
    _viewCoach.frame = theFrame;
    theFrame.origin = CGPointMake(0,-1000);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _viewCoach.frame = theFrame;
    [UIView commitAnimations];
    
    
}
-(void)swipe:(UISwipeGestureRecognizer *)swipeGes{
    if(swipeGes.direction == UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:.5 animations:^{
            //set frame of bottom view to top of screen (show 100%)
            _viewCoach.frame =CGRectMake(0, 0, 320, _viewCoach.frame.size.height);
        }];
    }
    else if (swipeGes.direction == UISwipeGestureRecognizerDirectionDown){
        [UIView animateWithDuration:.5 animations:^{
            //set frame of bottom view to bottom of screen (show 60%)
            _viewCoach.frame =CGRectMake(0, 300, 320, _viewCoach.frame.size.height);
        }];
    }
}
-(void)callDisclaimer:(NSTimer *)theTimer
{
    [_viewCoach setHidden:NO];
    CGRect theFrame = _viewCoach.frame;
    theFrame.origin = CGPointMake(_viewCoach.frame.origin.x, -1000);
   _viewCoach.frame = theFrame;
    theFrame.origin = CGPointMake(0,0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
   _viewCoach.frame = theFrame;
    [UIView commitAnimations];
   
    
//    [UIView animateWithDuration:30.0 animations:^{
//        _viewCoach.frame = CGRectMake(_viewCoach.frame.origin.x, -210, _viewCoach.frame.size.width, _viewCoach.frame.size.height);
//    } completion:^(BOOL finished) {
//        [_viewCoach removeFromSuperview];
//    }];
     [self.view addSubview:_viewCoach];
    
    appdelegate.intReg = 0;
    
}
#pragma mark button click event
- (IBAction)openFileNewReport:(id)sender {
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSLog(@"str : %@",UserID);
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        LoginVC *vc = [[LoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        FileNewReportViewController *vc = [[FileNewReportViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(IBAction)btnCancel_clck:(id)sender
{
    [self.voewMakeModel setHidden:YES];
    [self.ViewMain setBackgroundColor:[UIColor clearColor]];
    [self.ViewMain setAlpha:0.9];
}
-(IBAction)btnNav_click:(id)sender
{
    NavigationHomeVC *obj = [[NavigationHomeVC alloc] initWithNibName:@"NavigationHomeVC" bundle:[NSBundle mainBundle]];
    [self.revealSideViewController pushViewController:obj onDirection:PPRevealSideDirectionLeft withOffset:50 animated:YES];

}
-(IBAction)btnAboutUs_Click:(id)sender
{
    AboutUsVC *vc = [[AboutUsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnProfile_click:(id)sender
{
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSLog(@"str : %@",UserID);
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        LoginVC *vc = [[LoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UserProfileVC *vc = [[UserProfileVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
-(IBAction)btnHeading_click:(id)sender
{
    if([_arrVehicles count] > 1)
    {
//        self.ViewMain.backgroundColor = [UIColor blackColor];
//        self.ViewMain.alpha = 0.5;
        
        self.ViewMain.userInteractionEnabled = NO ;
        [self.ViewMain setBackgroundColor:[UIColor grayColor]];
           self.ViewMain.alpha = 0.5;
        [self.voewMakeModel setHidden:NO];


    }
    
}
//dfbdjshf

-(IBAction)btnMParking_click:(id)sender
{
   if(intblue == 1)
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Cancel parking"
                                                               message:@"Please confirm your vehicle is not parked here."
                                                              delegate:self
                                                    cancelButtonTitle:@"Yes"
                                                     otherButtonTitles:@"No", nil];
        intblue = 0;
        CheckAlert.tag =1;
           [CheckAlert show];
   }
    else
    {
        ImParkingHereVC *vc = [[ImParkingHereVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
   }
    
    
}
-(IBAction)btnFindVehicle_click:(id)sender
{
    FindVehicleVC *vc = [[FindVehicleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnGo_Click:(id)sender
{
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)openUpdates:(id)sender {
    UpdatesViewController *updatesVC = [[UpdatesViewController alloc] init];
    [self.navigationController pushViewController:updatesVC animated:YES];
}
-(IBAction)btnReportSighting_click:(id)sender
{
    ReportSightingViewController *vc = [[ReportSightingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark get current location
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //------
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            // NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
            // CountryArea = NULL;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}
#pragma mark table view delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrVehicles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SelectVehicleCell";
    SelectVehicleCell *cell = (SelectVehicleCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectVehicleCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *str = [[_arrVehicles valueForKey:@"vehicle_make"] objectAtIndex:indexPath.row];
    NSString *str1 = [[_arrVehicles valueForKey:@"vehicle_model"] objectAtIndex:indexPath.row];
    NSString *str4 = [str stringByAppendingString:@" "];
    NSString *str2 = [str4 stringByAppendingString:str1];
    cell.lblMakeModel.text = str2;
    cell.lblRegistrationNumber.text = [[_arrVehicles valueForKey:@"registration_serial_no"] objectAtIndex:indexPath.row];
    NSString *vehivleType = [[_arrVehicles valueForKey:@"vehicle_type"] objectAtIndex:indexPath.row];
   
    
    if([vehivleType isEqualToString:@"Car"])
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_car.png"]];
    }
    else if ([vehivleType isEqualToString:@"Bicycle"])
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_cycle.png"]];
    }
    else if ([vehivleType isEqualToString:@"Motor Cycle"])
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_bike.png"]];
    }
    else
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
    }
    
    //    cell.lblExercise.text = [ExerciseArray objectAtIndex:[indexPath row]];
    //    cell.lblDuration.text = [NSString stringWithFormat:@"%@",[DurationArray objectAtIndex:[indexPath row]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *vehivleType = [[_arrVehicles valueForKey:@"vehicle_type"] objectAtIndex:indexPath.row];
    appdelegate.strVehicleType = vehivleType;
    
    NSString *str = [[_arrVehicles valueForKey:@"vehicle_make"] objectAtIndex:indexPath.row];
    NSString *str1 = [[_arrVehicles valueForKey:@"vehicle_model"] objectAtIndex:indexPath.row];
    NSString *str4 = [str stringByAppendingString:@" "];
    NSString *str2 = [str4 stringByAppendingString:str1];
     NSString  *strVehicleId = [[_arrVehicles valueForKey:@"vehicle_id"] objectAtIndex:indexPath.row];
    [_btnHeading setTitle:str2 forState:UIControlStateNormal];
     [[NSUserDefaults standardUserDefaults] setValue:strVehicleId forKey:@"CurrentVehicleID"];
    [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:@"CurrentVehicleName"];
    [_voewMakeModel setHidden:YES];
    [self.voewMakeModel setHidden:YES];
    [self.ViewMain setBackgroundColor:[UIColor clearColor]];
    [self.ViewMain setAlpha:0.9];
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"];
    
    NSLog(@"arr : %@",arr);
    NSLog(@"arr counbt :%d",[arr count]);
    if(arr == nil || arr == (id)[NSNull null])
    {
        
    }
    else
    {
        for(int i=0;i<[arr count];i++)
        {
            NSString *strvid = [[arr objectAtIndex:i]valueForKey:@"VehivleID"];
            NSLog(@"strvid : %@",strvid);
            if(strvid == strVehicleId && strvid != nil)
            {
                [_btnMParking setBackgroundColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] ];
                [_btnMParking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_imgTick setHidden:NO];
                [_btnFindVehicle setEnabled:YES];
                intblue =1;
                return;
            }
            else
            {
                [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
                [_btnMParking setTitleColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] forState:UIControlStateNormal];
                [_btnFindVehicle setEnabled:NO];
                [_imgTick setHidden:YES];
            }
        }
    }
   
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
           // NSLog(@"vehicle : %@",appDelegate.arrMutvehiclePark);
            NSString *strCurrentVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
            
            NSMutableArray  *arr = [[NSMutableArray alloc]init];
            arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"];
            
            NSLog(@"arr : %@",arr);
            NSLog(@"current vehicle id : %@",strCurrentVehicleID);
            for(int i=0;i< [arr count];i++)
            {
                NSString *veh = [[arr objectAtIndex:i] valueForKey:@"VehivleID"];
                NSLog(@"veh : %@",veh);
                if(veh == strCurrentVehicleID)
                {
                    [arr removeObjectAtIndex:i];
                }
                
            }
            
            NSLog(@"arr : %@",arr);
            
            [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setTitleColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [_imgTick setHidden:YES];
            
        }
        else
        {
            
        }
    }
}
@end
