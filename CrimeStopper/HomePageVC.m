

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
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "FileNewReportViewController.h"
#import "UpdatesViewController.h"
#import "ReportSightingViewController.h"
#import "UAPush.h"

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
    
    //get pushnotification counter
  
    // change status bar color
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     [_viewUpdate setBackgroundColor: [UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1]];
    [self.viewTrasparent setHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    self.library = [[ALAssetsLibrary alloc] init];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar  setBarTintColor:[UIColor whiteColor]];
    
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
     _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_viewLocationGuide setHidden:YES];
    
    //set status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
    // set find my vehicle button enavle no
    [_btnFindVehicle setEnabled:NO];
    
    
    
    
    //set image as round
    _imgProfilepic.layer.cornerRadius = 15;
    _imgProfilepic.clipsToBounds = YES;
    _lblPush.layer.cornerRadius = 11.5;
    _lblPush.clipsToBounds = YES;
    
    //intcountpushnotification set here
    if(appdelegate.intCountPushNotification > 0)
    {
        [_lblPush setHidden:NO];
        NSString *str = [NSString stringWithFormat:@"%d",appdelegate.intCountPushNotification];
        [_lblPush setText:str];
    }
    else
    {
        [_lblPush setHidden:YES];
    }
    
   if( appdelegate.intReg == 1)
   {
       timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(callDisclaimer:) userInfo:nil repeats:NO];
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
      if(strCurrentVehicleID == nil || strCurrentVehicleID == (id)[NSNull null] || [strCurrentVehicleID isEqualToString:@"0"])
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
    
    /// implementing map
    
    [ self.map.delegate self];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
  NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"longitude"];
    
    /// zoom map
    
    float currlat = [latitude floatValue];
    float currlongt = [longitude floatValue];
    CLLocationCoordinate2D loc ;
    loc.latitude = currlat;
    loc.longitude = currlongt;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    region.center.latitude = currlat;
    region.center.longitude = currlongt;
    
    [self.map setRegion:region animated:YES];
    
    NSLog(@"vehicles : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"]);
    NSLog(@"latitude : %@",latitude);
    
    if([latitude isEqualToString:@"0.000000"])
    {
        [_viewLocationGuide setHidden:NO];
    }
    
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
        [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
        NSString *strvid = [[arr objectAtIndex:i]valueForKey:@"VehivleID"];
        NSLog(@"strvid : %@",strvid);
        if([strCurrentVehicleID isEqualToString:@"0"] || strCurrentVehicleID == nil || strCurrentVehicleID == (id)[NSNull null] )
        {
        
        }
        else
        {
        if(strvid == strCurrentVehicleID && strvid != nil)
        {
            [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1] ];
            [_btnMParking setAlpha:1.0f];
             [_btnMParking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_imgTick setHidden:NO];
             _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
           // appdelegate.intMparking = 1;
            [_btnFindVehicle setEnabled:YES];
        }
        else
        {
            [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
             [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setTitleColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [_btnMParking setAlpha:0.9f];
            [_imgTick setHidden:YES];
             _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_btnFindVehicle setEnabled:NO];
           // appdelegate.intMparking = 2;
        }
        }
    }
    }
   //for m parking color change
    NSLog(@"mparking  :%d",appdelegate.intMparking);
           if(appdelegate.intMparking == 2)
        {
            [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setTitleColor:[UIColor colorWithRed:14.0/255.0f green:122.0/255.0f blue:254.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [_btnMParking setAlpha:0.9f];
            [_imgTick setHidden:YES];
             _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_btnFindVehicle setEnabled:NO];
        }
        else if(appdelegate.intMparking == 1)
        {
            [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1] ];
            [_btnMParking setAlpha:1.0f];
            [_btnMParking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_imgTick setHidden:NO];
             _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_btnFindVehicle setEnabled:YES];
            
           
        }
    else
    {
    
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
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    UA_LINFO(@"Received remote notification: %@", userInfo);
//    appdelegate.intCountPushNotification ++ ;
//    NSLog(@"int : %d",appdelegate.intCountPushNotification);
//    //  [[NSUserDefaults standardUserDefaults]setObject:_intCountPushNotification forKey:@"CountPushNoti"];
//    
//    NSLog(@"I camhe here ");
//    // Fire the handlers for both regular and rich push
//    [[UAPush shared] handleNotification:userInfo applicationState:application.applicationState];
//    // [UAInboxPushHandler handleNotification:userInfo];
//}

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
    [_viewTrasparent setHidden:YES];
    [self.ViewMain setBackgroundColor:[UIColor clearColor]];
    [self.ViewMain setAlpha:0.9];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return self.navigationController.navigationBar.barStyle = ui;
//}

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
        _map.frame = CGRectMake(0,55, 320, 270);
        _btnParking.frame = CGRectMake(1, 220, 150, 60);
        _btnVehicles.frame = CGRectMake(152, 220, 150, 60);
        viewReport.frame = CGRectMake(0, 230, 320, 60);
        viewNewReport.frame = CGRectMake(0, 290, 320, 60);
        viewUpdates.frame = CGRectMake(0, 350, 320, 60);
        viewUpdates.frame = CGRectMake(0, 410, 320, 60);
    
    }
    else
    {
        _map.frame = CGRectMake(0,55, 320, 220);
        _btnMParking.frame = CGRectMake(1, 183, 158, 50);
        _btnFindVehicle.frame = CGRectMake(160, 183, 158, 50);
        viewReport.frame = CGRectMake(0, 230, 320, 55);
        viewNewReport.frame = CGRectMake(0, 290, 320, 55);
        viewUpdates.frame = CGRectMake(0, 350, 320, 55);
        viewUpdates.frame = CGRectMake(0, 410, 320, 55);
        _imgReportSighting.frame = CGRectMake(11, 10, 30, 30);
        _imgFileNewReport.frame = CGRectMake(11, 10, 33, 35);
        _imgAboutUs.frame = CGRectMake(11, 12, 33, 35);
        _imgUpdates.frame = CGRectMake(11, 20, 33, 35);
        _lblGray1.frame = CGRectMake(0, 55, 320, 1);
        _lblGray2.frame = CGRectMake(0, 53, 320, 1);
        _lblmainText.frame = CGRectMake(56, 5, 245, 30);
        _lblSubText.frame = CGRectMake(56, 30, 257, 21);
//        scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
        
//        self.scrollview.contentSize = CGSizeMake(320, 700);
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
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
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotation = nil;
    NSString *defaultPinID = @"myPin";
    pinAnnotation = (MKPinAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinAnnotation == nil )
        pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    
    pinAnnotation.image = [UIImage imageNamed:@"marker_postoffice.png"];
    pinAnnotation.annotation = annotation;
    pinAnnotation.canShowCallout = YES;
    if([[annotation title] isEqualToString:@"vehicle"])
    {
        
        pinAnnotation.image = [UIImage imageNamed:@"vehicle_parked.png"];
        pinAnnotation.annotation = annotation;
        pinAnnotation.canShowCallout = YES;
        
        
    }
    else
    {
        
        pinAnnotation.image = [UIImage imageNamed:@"current_location.png"];
        pinAnnotation.canShowCallout = YES;
        
    }
    return pinAnnotation;
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"in zoom ");
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    region.center.latitude = loc.latitude;
    region.center.longitude = loc.longitude;
    [self.map setRegion:region animated:YES];
    
    
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
        [UIView animateWithDuration:.25 animations:^{
            //set frame of bottom view to top of screen (show 100%)
            _viewCoach.frame =CGRectMake(0, 0, 320, _viewCoach.frame.size.height);
        }];
    }
    else if (swipeGes.direction == UISwipeGestureRecognizerDirectionDown){
        [UIView animateWithDuration:.25 animations:^{
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
-(IBAction)btnLocation_click:(id)sender
{
    [_viewLocationGuide setHidden:YES];
}
- (IBAction)openFileNewReport:(id)sender {
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSLog(@"str : %@",UserID);
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
                                                            message:@"Please log in to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign in", nil];
        CheckAlert.tag =10;
        [CheckAlert show];    }
    else
    {
        FileNewReportViewController *vc = [[FileNewReportViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(IBAction)btnCancel_clck:(id)sender
{
    [self.voewMakeModel setHidden:YES];
    [_viewTrasparent setHidden:YES];
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
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
                                                            message:@"Please log in to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign in", nil];
        CheckAlert.tag =10;
        [CheckAlert show];
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
        self.ViewMain.userInteractionEnabled = NO ;
       
        [self.viewTrasparent setHidden:NO];
        
        [self.voewMakeModel setHidden:NO];
    }
    
}
-(IBAction)btnMParking_click:(id)sender
{
   if(appdelegate.intMparking == 1)
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Cancel parking"
                                                               message:@"Please confirm your vehicle is not parked here."
                                                              delegate:self
                                                    cancelButtonTitle:@"Yes"
                                                     otherButtonTitles:@"No", nil];
        appdelegate.intMparking = 2;
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
    appdelegate.intCountPushNotification = 0;
    UpdatesViewController *updatesVC = [[UpdatesViewController alloc] init];
    [self.navigationController pushViewController:updatesVC animated:YES];
}
-(IBAction)btnReportSighting_click:(id)sender
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
        ReportSightingViewController *vc = [[ReportSightingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark get current location
//-(void)CurrentLocationIdentifier
//{
//    //---- For getting current gps location
//    locationManager = [CLLocationManager new];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//    //------
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    currentLocation = [locations objectAtIndex:0];
//    [locationManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (!(error))
//         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//            // NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//             NSLog(@"%@",CountryArea);
//         }
//         else
//         {
//             NSLog(@"Geocode failed with error %@", error);
//             NSLog(@"\nCurrent Location Not Detected\n");
//             //return;
//            // CountryArea = NULL;
//         }
//         /*---- For more results
//          placemark.region);
//          placemark.country);
//          placemark.locality);
//          placemark.name);
//          placemark.ocean);
//          placemark.postalCode);
//          placemark.subLocality);
//          placemark.location);
//          ------*/
//     }];
//}
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
        [cell.lblSerialNo setText:@"Registration No"];
    }
    else if ([vehivleType isEqualToString:@"Bicycle"])
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_cycle.png"]];
        [cell.lblSerialNo setText:@"Serial No"];
    }
    else if ([vehivleType isEqualToString:@"Motorcycle"])
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_bike.png"]];
        [cell.lblSerialNo setText:@"Registration No"];
    }
    else
    {
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
        [cell.lblSerialNo setText:@"Registration No"];
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
    [_viewTrasparent setHidden:YES];
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
        [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
        for(int i=0;i<[arr count];i++)
        {
            NSString *strvid = [[arr objectAtIndex:i]valueForKey:@"VehivleID"];
            NSLog(@"strvid : %@",strvid);
            if(strvid == strVehicleId && strvid != nil)
            {
                [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
                [_btnMParking setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1] ];
                [_btnMParking setAlpha:1.0f];
                [_btnMParking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_imgTick setHidden:NO];
                _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_btnFindVehicle setEnabled:YES];
                appdelegate.intMparking =1;
                return;
            }
            else
            {
                [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
                [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
                [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
                [_btnMParking setTitleColor:[UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1] forState:UIControlStateNormal];
                [_btnMParking setAlpha:0.9f];
                [_btnFindVehicle setEnabled:NO];
                appdelegate.intMparking = 2;
                [_imgTick setHidden:YES];
                 _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
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
            arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"]mutableCopy];
            
            NSLog(@"arr : %@",arr);
            NSLog(@"current vehicle id : %@",strCurrentVehicleID);
            for(int i=0;i< [arr count];i++)
            {
                NSString *veh = [[arr objectAtIndex:i] valueForKey:@"VehivleID"];
                NSLog(@"veh : %@",veh);
                if([veh isEqualToString:strCurrentVehicleID])
                {
                    if([arr count] == 1)
                    {
                        [arr removeObjectAtIndex:0];
                    }
                    else
                    {
                        [arr removeObjectAtIndex:i];
                    }
                    
                    
                    
                }
                
            }
            [[NSUserDefaults standardUserDefaults] setValue:arr forKey:@"parkVehicle"];
            NSLog(@"arr : %@",arr);
            appdelegate.intMparking = 2;
            [_btnFindVehicle setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setBackgroundColor:[UIColor lightTextColor]];
            [_btnMParking setTitleColor:[UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1] forState:UIControlStateNormal];
            [_imgTick setHidden:YES];
             _btnMParking.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_btnFindVehicle setEnabled:NO];
            
        }
        else
        {
            appdelegate.intMparking = 1;
        }
    }
    if(alertView.tag == 10)
    {
        if(buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else
        {
            LoginVC *vc = [[LoginVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}
@end
