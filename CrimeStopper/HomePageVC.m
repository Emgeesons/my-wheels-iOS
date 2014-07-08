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
#import "ReportSightingViewController.h"
#import "FileNewReportViewController.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HomePageVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation HomePageVC
@synthesize btnNav;
@synthesize viewNewReport,viewReport,viewUpdates,viewAboutUs;

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
    
    NSString *photoURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
    NSLog(@"vehicles : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"]);
    
    // Create the Album:
    NSString *albumName = @"My Wheels";
    [self.library addAssetsGroupAlbumWithName:albumName
                                  resultBlock:^(ALAssetsGroup *group) {
                                      NSLog(@"added album:%@", albumName);
                                  }
                                 failureBlock:^(NSError *error) {
                                     NSLog(@"error adding album");
                                 }];
    
       
    
    NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    NSLog(@"file name : %@",filename);
    
   
    
    if(photoURL == nil || photoURL == (id)[NSNull null])
    {
        _imgProfilepic.image = [UIImage imageNamed:@"default_profile_home.png"];
    }
    else
    {
        if(filename == nil || filename == (id)[NSNull null])
        {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
            _imgProfilepic.image = [UIImage imageWithData:imageData];
        }
        else
        {
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
//            
//            UIImage *image1 = [UIImage imageWithData:imageData];
//            _imgProfilepic.image = image1;
//            
//            __block ALAssetsGroup* groupToAddTo;
//            [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum
//                                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//                                            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
//                                                NSLog(@"found album %@", albumName);
//                                                groupToAddTo = group;
//                                            }
//                                        }
//                                      failureBlock:^(NSError* error) {
//                                          NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
//                                      }];
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:filename];
//            NSData *imageData = [NSData dataWithContentsOfMappedFile:savedImagePath];
//            _imgProfilepic.image = [UIImage imageWithData:imageData];
            
//            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
//            void (^assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
//                NSLog(@"hi");
//                if(group != nil) {
//                    [assetGroups addObject:group];
//                    
//                    NSLog(@"Number of assets in group: %d",[group numberOfAssets]);
//                }
//            };
//            
//            assetGroups = [[NSMutableArray alloc] init];
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
//            
//            [library enumerateGroupsWithTypes:groupTypes
//                                   usingBlock:assetGroupEnumerator
//                                 failureBlock:^(NSError *error) {NSLog(@"A problem occurred");
//            }];
//            
//            NSLog(@"Asset groups: %@", assetGroups);
//            [library release];
//            [assetGroups release];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
            _imgProfilepic.image = [UIImage imageWithData:imageData];
        
        }
        }
    NSLog(@"%@",latitude);
    NSLog(@"%@",longitude);
    

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark button click event
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

- (IBAction)openReportSighting:(id)sender {
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
@end
