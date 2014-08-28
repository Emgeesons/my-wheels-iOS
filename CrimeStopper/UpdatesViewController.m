//
//  UpdatesViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 11/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "UpdatesViewController.h"
#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UIColor+Extra.h"
#import "CustomImageView.h"
#import "ReportSummaryViewController.h"
#import "LoginVC.h"
#import "UserProfileVC.h"
#import "LoginVC.h"
#import "Reachability.h"

@import QuickLook;
@import CoreLocation;

#define MIN_HEIGHT 10.0f


@interface UpdatesViewController () <UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, UIAlertViewDelegate> {
    NSMutableArray *type, *comments, *first_name, *location, *make, *model, *photo1, *photo2, *photo3, *registration_serial_no, *report_id, *report_type, *selected_date, *selected_time, *vehicle_id, *vehicle_type;
    NSMutableArray *selectedImage;
    NSInteger report, sighting;
    BOOL loadMore;
    UIActivityIndicatorView *activityIndicator, *navActivityIndicator;
    
    NSMutableArray *vehicleHeader, *makeHeader, *modelHeader, *typeSightingHeader, *regNoHeader, *dateHeader, *timeHeader, *locationHeader, *commentHeader, *photo1Header, *photo2Header, *photo3Header, *vehicleID, *reportIDHeader, *insurance_company_numberHeader;
    
    NSMutableArray *commentsMy, *first_nameMy, *locationMy, *makeMy, *modelMy, *photo1My, *photo2My, *photo3My, *registration_serial_noMy, *report_idMy, *report_typeMy, *selected_dateMy, *selected_timeMy, *vehicle_idMy, *vehicle_typeMy, *recovered_dateMy, *recovered_locationMy, *recovered_timeMy;
    
    UIToolbar *bgToolBar;
    
    UIActionSheet *sheet;
    
    NSString *status;
    
    //NSArray for sending details to ReportSummary Screen
    NSArray *detailsArray;
    
    CLLocationManager *locationManager;
    CLPlacemark *placemark;
    float latitude,longitude;
    NSMutableString *address;
}
@property (weak, nonatomic) IBOutlet UIView *viewOthers;
@property (weak, nonatomic) IBOutlet UIView *viewMyUpdates;
@property (weak, nonatomic) IBOutlet UIView *viewGuestUser;
@property (weak, nonatomic) IBOutlet UIView *viewTableMyUpdates;
@property (weak, nonatomic) IBOutlet UIView *viewVehicleReported;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewVehicleReported;

- (IBAction)segmentedClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOthers;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMyUpdates;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLoginClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnVehicleRecovered;
- (IBAction)btnVehicleRecoveredClicked:(id)sender;

@end

@implementation UpdatesViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self createDownloadFolder];
    
    self.navBarHeightConstraint.constant = 55;
    [self.navBar setNeedsUpdateConstraints];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    latitude = locationManager.location.coordinate.latitude;
    longitude = locationManager.location.coordinate.longitude;
    
    alertViewGuestUser = [[UIAlertView alloc] initWithTitle:nil message:@"Please log in to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign in", nil];
    alertViewVehicleRecovered = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    NSLog(@"latitude==> %f", latitude);
    address = [[NSMutableString alloc] initWithString:@""];
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",latitude];
    if([lat isEqualToString:@"0.000000"])
    {
        [_viewLocation setHidden:NO];
        [_viewTransparent setHidden:NO];
    }
    // get location
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:clLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            if (placemark.subThoroughfare != NULL) {
                [address appendFormat:@"%@ ", placemark.subThoroughfare];
            }
            
            if (placemark.thoroughfare != NULL) {
                [address appendFormat:@"%@ ", placemark.thoroughfare];
            }
            
            if (placemark.postalCode != NULL) {
                [address appendFormat:@"%@ ", placemark.postalCode];
            }
            
            if (placemark.locality != NULL) {
                [address appendFormat:@"%@ ", placemark.locality];
            }
            
            if (placemark.administrativeArea != NULL) {
                [address appendFormat:@"%@ ", placemark.administrativeArea];
            }
            
            if (placemark.country != NULL) {
                [address appendFormat:@"%@", placemark.country];
            }
        }
    }];
    
    // set background color of btnLetsGo
    self.btnLetsGo.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
    
    [_viewLocation setHidden:YES];
    [_viewTransparent setHidden:YES];
    // initialize all NSMutableArray here
    type = [[NSMutableArray alloc] init];
    comments = [[NSMutableArray alloc] init];
    first_name = [[NSMutableArray alloc] init];
    location = [[NSMutableArray alloc] init];
    make = [[NSMutableArray alloc] init];
    model = [[NSMutableArray alloc] init];
    photo1 = [[NSMutableArray alloc] init];
    photo2 = [[NSMutableArray alloc] init];
    photo3 = [[NSMutableArray alloc] init];
    registration_serial_no = [[NSMutableArray alloc] init];
    report_id = [[NSMutableArray alloc] init];
    report_type = [[NSMutableArray alloc] init];
    selected_date = [[NSMutableArray alloc] init];
    selected_time = [[NSMutableArray alloc] init];
    vehicle_id = [[NSMutableArray alloc] init];
    vehicle_type = [[NSMutableArray alloc] init];
    
    // initialize all MyUpdates Header Part NSMutableArray
    vehicleHeader = [[NSMutableArray alloc] init];
    makeHeader = [[NSMutableArray alloc] init];
    modelHeader = [[NSMutableArray alloc] init];
    typeSightingHeader = [[NSMutableArray alloc] init];
    regNoHeader = [[NSMutableArray alloc] init];
    dateHeader = [[NSMutableArray alloc] init];
    timeHeader = [[NSMutableArray alloc] init];
    locationHeader = [[NSMutableArray alloc] init];
    commentHeader = [[NSMutableArray alloc] init];
    photo1Header = [[NSMutableArray alloc] init];
    photo2Header = [[NSMutableArray alloc] init];
    photo3Header = [[NSMutableArray alloc] init];
    vehicleID = [[NSMutableArray alloc] init];
    reportIDHeader = [[NSMutableArray alloc] init];
    insurance_company_numberHeader = [[NSMutableArray alloc] init];
    
    // initialize all MyUpdates Rows Part NSMutableArray
    commentsMy = [[NSMutableArray alloc] init];
    first_nameMy = [[NSMutableArray alloc] init];
    locationMy = [[NSMutableArray alloc] init];
    makeMy = [[NSMutableArray alloc] init];
    modelMy = [[NSMutableArray alloc] init];
    photo1My = [[NSMutableArray alloc] init];
    photo2My = [[NSMutableArray alloc] init];
    photo3My = [[NSMutableArray alloc] init];
    registration_serial_noMy = [[NSMutableArray alloc] init];
    report_idMy = [[NSMutableArray alloc] init];
    report_typeMy = [[NSMutableArray alloc] init];
    selected_dateMy = [[NSMutableArray alloc] init];
    selected_timeMy = [[NSMutableArray alloc] init];
    vehicle_idMy = [[NSMutableArray alloc] init];
    vehicle_typeMy = [[NSMutableArray alloc] init];
    recovered_dateMy = [[NSMutableArray alloc] init];
    recovered_locationMy = [[NSMutableArray alloc] init];
    recovered_timeMy = [[NSMutableArray alloc] init];
    
    //[self.btnVehicleRecovered setBackgroundColor:[UIColor colorWithHexString:@"#00B268"]];
    [self.btnVehicleRecovered setBackgroundColor:[UIColor colorWithHexString:@"#0067AD"]];
    
    // Add UIToolBar to view with alpha 0.7 for transparency
    bgToolBar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolBar.barStyle = UIBarStyleBlack;
    bgToolBar.alpha = 0.7;
    bgToolBar.translucent = YES;

    
    // Hide My updates view at load time
    self.viewOthers.hidden = NO;
    self.viewMyUpdates.hidden = YES;
    
    // Check user is guest OR not
    // If user is guest change btnLogin's Title to login
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    // initialize report, sighting as 0 at start
    report = 0;
    sighting = 0;
    
    // initialize activityIndicator and add it to view.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    
    // initialize activityIndicator and add it to navigationBar.
    navActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    navActivityIndicator.frame = CGRectMake(0, 0, 40, 40);
    navActivityIndicator.center = self.view.center;
    [bgToolBar addSubview:navActivityIndicator];
    
    //set loadMore as Yes at start
    loadMore = YES;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [DeviceInfo errorInConnection];
        [activityIndicator stopAnimating];
    } else {
        [self loadOtherUpdates];
        [self loadMyUpdates];
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    self.tableViewOthers.backgroundColor = self.view.backgroundColor;
    
    for (int i=0; i<[self.segmentedControl.subviews count]; i++)
    {
        if ([[self.segmentedControl.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithHexString:@"#0067AD"];
            [[self.segmentedControl.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            [[self.segmentedControl.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnLocation_click:(id)sender
{
    [_viewLocation setHidden:YES];
    [_viewTransparent setHidden:YES];
}
- (IBAction)segmentedClicked:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        NSLog(@"Other");
        self.viewOthers.hidden = NO;
        self.viewMyUpdates.hidden = YES;
       
    }
    else
    {
        NSLog(@"my");
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            self.viewTableMyUpdates.hidden = YES;
            return;
        }
        
        // Check user is guest OR not
        // If user is guest show login view else tableview
        NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        if(UserID == nil || UserID == (id)[NSNull null])
        {
//            self.viewTableMyUpdates.hidden = YES;
//            self.viewGuestUser.hidden = NO;
            
//            LoginVC *vc = [[LoginVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            [alertViewGuestUser show];
            [self.segmentedControl setSelectedSegmentIndex:0];
        }
        else
        {
            self.viewOthers.hidden = YES;
            self.viewMyUpdates.hidden = NO;
            
            // Check vehicles are added or not
            // If not added show Let's Go view
            NSArray *vehicles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"vehicles"];
            if (vehicles.count == 0) {
                self.viewTableMyUpdates.hidden = YES;
                self.viewGuestUser.hidden = NO;
                self.viewVehicleReported.hidden = YES;
            } else {
                // check vehicle is recovered or not
                // if yes show vehicle reported view
                // else show tableview
                if ([status isEqualToString:@"recovered"]) {
                    self.viewGuestUser.hidden = YES;
                    self.viewTableMyUpdates.hidden = YES;
                    self.viewVehicleReported.hidden = NO;
                    
                    [self addSubviewsToScrollView];
                    
                } else {
                    self.viewGuestUser.hidden = YES;
                    self.viewTableMyUpdates.hidden = NO;
                    self.viewVehicleReported.hidden = YES;
                }
            }
        }
    }
    
    for (int i=0; i<[self.segmentedControl.subviews count]; i++)
    {
        if ([[self.segmentedControl.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithHexString:@"#0067AD"];
            [[self.segmentedControl.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            [[self.segmentedControl.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
}

-(void)loadOtherUpdates {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    
    if (UserID == NULL) {
        UserID = @"0";
        pin = @"0000";
    }
    
    NSDictionary *parameters = @{@"userId" : UserID,
                                 @"pin" : pin,
                                 @"os" : OS_VERSION,
                                 @"make" : MAKE,
                                 @"model" : [DeviceInfo platformNiceString],
                                 @"countReports" : [NSString stringWithFormat:@"%ld",(long)report],
                                 @"countSightings" : [NSString stringWithFormat:@"%ld",(long)sighting],
                                 @"latitude" : [NSString stringWithFormat:@"%f", latitude],
                                 @"longitude" : [NSString stringWithFormat:@"%f", longitude]};
    
    NSLog(@"parameters : %@", parameters);
    
    NSString *url = [NSString stringWithFormat:@"%@otherUpdates.php", SERVERNAME];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"other : %@", responseObject);
        
        // Stop Animating activityIndicator
        [activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *reportData = (NSArray *)[json objectForKey:@"reports"];
            //NSLog(@"%d", reportData.count);
            for (int i = 0; i < reportData.count; i++) {
                [type addObject:@"report"];
                [comments addObject:reportData[i][@"comments"]];
                [first_name addObject:reportData[i][@"first_name"]];
                [report_id addObject:reportData[i][@"report_id"]];
                [vehicle_type addObject:reportData[i][@"vehicle_type"]];
                [vehicle_id addObject:reportData[i][@"vehicle_id"]];
                [make addObject:reportData[i][@"make"]];
                [model addObject:reportData[i][@"model"]];
                [registration_serial_no addObject:reportData[i][@"registration_serial_no"]];
                [location addObject:reportData[i][@"location"]];
                [selected_date addObject:reportData[i][@"selected_date"]];
                [selected_time addObject:reportData[i][@"selected_time"]];
                [report_type addObject:reportData[i][@"report_type"]];
                [photo1 addObject:reportData[i][@"photo1"]];
                [photo2 addObject:reportData[i][@"photo2"]];
                [photo3 addObject:reportData[i][@"photo3"]];
                
                report++;
            }
            
            NSArray *sightingData = (NSArray *)[json objectForKey:@"sightings"];
            //NSLog(@"%d", sightingData.count);
            for (int i = 0; i < sightingData.count; i++) {
                [type addObject:@"sighting"];
                [comments addObject:sightingData[i][@"comments"]];
                [first_name addObject:sightingData[i][@"first_name"]];
                [report_id addObject:sightingData[i][@"sightings_id"]];
                [vehicle_type addObject:@""];
                [vehicle_id addObject:@""];
                [make addObject:sightingData[i][@"vehicle_make"]];
                [model addObject:sightingData[i][@"vehicle_model"]];
                [registration_serial_no addObject:sightingData[i][@"registration_number"]];
                [location addObject:sightingData[i][@"location"]];
                [selected_date addObject:sightingData[i][@"selected_date"]];
                [selected_time addObject:sightingData[i][@"selected_time"]];
                [report_type addObject:sightingData[i][@"sighting_type"]];
                [photo1 addObject:sightingData[i][@"photo1"]];
                [photo2 addObject:sightingData[i][@"photo2"]];
                [photo3 addObject:sightingData[i][@"photo3"]];
                
                sighting++;
            }
            
            if (report > 0 || sighting > 0) {
                loadMore = YES;
                [self.tableViewOthers reloadData];
            } else {
                UILabel *hurrayWalaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewOthers.frame.size.height/2, 320, 20)];
                hurrayWalaLabel.text = @"Hooray! No Vehicles Reported.";
                hurrayWalaLabel.textAlignment = NSTextAlignmentCenter;
                [self.viewOthers addSubview:hurrayWalaLabel];
            }
            
            
        } else {
            loadMore = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [DeviceInfo errorInConnection];
        [activityIndicator stopAnimating];
    }];
}

-(void)loadMyUpdates {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    
    if (UserID == NULL) {
        UserID = @"0";
        pin = @"0000";
    }
    
    NSDictionary *parameters = @{@"userId" : UserID,
                                 @"pin" : pin,
                                 @"os" : OS_VERSION,
                                 @"make" : MAKE,
                                 @"model" : [DeviceInfo platformNiceString],
                                 @"latitude" : [NSString stringWithFormat:@"%f", latitude],
                                 @"longitude" : [NSString stringWithFormat:@"%f", longitude]};
    
    //NSLog(@"%@", parameters);
    
    NSString *url = [NSString stringWithFormat:@"%@myUpdates.php", SERVERNAME];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"my updates : %@", responseObject);
        
        // Stop Animating activityIndicator
        [activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *reportData = (NSArray *)[json objectForKey:@"response"];
            //NSLog(@"%d", reportData.count);
            
            // Set detailsArray value here
            detailsArray = reportData;
            
            for (int i = 0; i < reportData.count; i++) {
                [commentHeader addObject:reportData[i][@"comments"]];
                [reportIDHeader addObject:reportData[i][@"report_id"]];
                [typeSightingHeader addObject:reportData[i][@"report_type"]];
                [vehicleHeader addObject:reportData[i][@"vehicle_type"]];
                [vehicleID addObject:reportData[i][@"vehicle_id"]];
                [makeHeader addObject:reportData[i][@"make"]];
                [modelHeader addObject:reportData[i][@"model"]];
                [regNoHeader addObject:reportData[i][@"registration_serial_no"]];
                [locationHeader addObject:reportData[i][@"location"]];
                [dateHeader addObject:reportData[i][@"selected_date"]];
                [timeHeader addObject:reportData[i][@"selected_time"]];
                [photo1Header addObject:reportData[i][@"photo1"]];
                [photo2Header addObject:reportData[i][@"photo2"]];
                [photo3Header addObject:reportData[i][@"photo3"]];
                [insurance_company_numberHeader addObject:reportData[i][@"insurance_company_number"]];
                [recovered_dateMy addObject:reportData[i][@"recovered_date"]];
                [recovered_locationMy addObject:reportData[i][@"recovered_location"]];
                [recovered_timeMy addObject:reportData[i][@"recovered_time"]];
                
                status = reportData[i][@"status"];
                
                if ([status isEqualToString:@"reported"]) {
                    self.viewTableMyUpdates.hidden = NO;
                    self.viewVehicleReported.hidden = YES;
                } else {
                    self.viewTableMyUpdates.hidden = YES;
                    self.viewVehicleReported.hidden = NO;
                }
            }
            
            NSArray *sightingData = (NSArray *)[json objectForKey:@"sightings"];
            //NSLog(@"%d", sightingData.count);
            for (int i = 0; i < sightingData.count; i++) {
                [commentsMy addObject:sightingData[i][@"comments"]];
                [first_nameMy addObject:sightingData[i][@"first_name"]];
                [report_idMy addObject:sightingData[i][@"sightings_id"]];
                [vehicle_typeMy addObject:@""];
                [vehicle_idMy addObject:@""];
                //[makeMy addObject:sightingData[i][@"vehicle_make"]];
                //[modelMy addObject:sightingData[i][@"vehicle_model"]];
                //[registration_serial_noMy addObject:sightingData[i][@"registration_number"]];
                [locationMy addObject:sightingData[i][@"location"]];
                [selected_dateMy addObject:sightingData[i][@"selected_date"]];
                [selected_timeMy addObject:sightingData[i][@"selected_time"]];
                [report_typeMy addObject:sightingData[i][@"sighting_type"]];
                [photo1My addObject:sightingData[i][@"photo1"]];
                [photo2My addObject:sightingData[i][@"photo2"]];
                [photo3My addObject:sightingData[i][@"photo3"]];
            }
            //loadMore = YES;
            [self.tableViewMyUpdates reloadData];
            
            if (reportData.count == 0) {
                self.btnVehicleRecovered.hidden = YES;
                
                UILabel *titleWalaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewTableMyUpdates.frame.size.height/2 - 20, 320, 20)];
                titleWalaLabel.textAlignment = NSTextAlignmentCenter;
                titleWalaLabel.text = @"No Vehicles Reported";
                [self.viewTableMyUpdates addSubview:titleWalaLabel];
                
                UILabel *descriptionWalaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewTableMyUpdates.frame.size.height/2, 320, 20)];
                descriptionWalaLabel.textAlignment = titleWalaLabel.textAlignment;
                descriptionWalaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
                descriptionWalaLabel.text = @"Your reported vehicle updates will be displayed here";
                [self.viewTableMyUpdates addSubview:descriptionWalaLabel];
            }
            
        } else {
            //loadMore = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        //[DeviceInfo errorInConnection];
        [activityIndicator stopAnimating];
    }];
}

#pragma mark - UITableView Delegate/DataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableViewOthers) {
        return type.count;
    } else if(tableView == self.tableViewMyUpdates) {
        //NSLog(@"vehicle_idMy ==> %lu", (unsigned long)vehicle_idMy.count);
        if (vehicle_idMy.count == 0) {
            return 1;
        }
        return vehicle_idMy.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableViewOthers) {
        return 1;
    } else if(tableView == self.tableViewMyUpdates) {
        return vehicleID.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.tableViewOthers.backgroundColor;
    }
    if (tableView == self.tableViewOthers) {
        [cell.contentView addSubview:[self plotViewWithIndexNumber:indexPath.row andType:@"view"]];
    } else if (tableView == self.tableViewMyUpdates) {
        // code for my updates
        if (vehicle_idMy.count == 0) {
            // create Stay tuned view here
            UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
            viewBG.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
            
            // Add Stay Tuned label here
            UILabel *lblStayTuned = [[UILabel alloc] initWithFrame:CGRectMake(0, (viewBG.frame.size.height/2) - 30, 320, 20)];
            lblStayTuned.text = @"Stay Tuned!";
            lblStayTuned.textAlignment = NSTextAlignmentCenter;
            lblStayTuned.textColor = [UIColor colorWithHexString:@"#0067AD"];
            lblStayTuned.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            [viewBG addSubview:lblStayTuned];
            
            // Add General text label here
            UILabel *lblUpdate = [[UILabel alloc] initWithFrame:CGRectMake(0, lblStayTuned.frame.origin.y + lblStayTuned.frame.size.height + 5, 320, 20)];
            lblUpdate.text = @"Updates on this report will appear here";
            lblUpdate.textAlignment = NSTextAlignmentCenter;
            lblUpdate.textColor = [UIColor grayColor];
            lblUpdate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            [viewBG addSubview:lblUpdate];
            
            [cell.contentView addSubview:viewBG];
        } else {
            [cell.contentView addSubview:[self plotMyUpdatesViewWithIndexNumber:indexPath.row andType:@"view"]];
        }
    }
    
    return cell;
}

-(id)plotViewWithIndexNumber:(NSInteger)indexPath andType:(NSString *)typeView {
    
    // Add 1 background view as container
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    viewBG.backgroundColor = [UIColor whiteColor];
    
    /************************************* Top view Starts ***********************************/
    
    // View for top
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewBG.frame.size.width, 30)];
    viewTop.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    // add UILabel for Name of user
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 290, 30)];
    NSString *strName; //[NSString stringWithFormat:@"%@ lost her vehicle", first_name[indexPath]];
    
    if ([type[indexPath] isEqualToString:@"report"]) {
        /*if ([report_type[indexPath] isEqualToString:@"Theft"]) {
            strName = [NSString stringWithFormat:@"%@ lost their vehicle", first_name[indexPath]];
        } else if ([report_type[indexPath] isEqualToString:@"Serious Vandalism"]) {
            strName = [NSString stringWithFormat:@"%@ reported a %@", first_name[indexPath], report_type[indexPath]];
        } else if ([report_type[indexPath] isEqualToString:@"Stolen /Abandoned Vehicle?"]) {
            strName = [NSString stringWithFormat:@"%@ reported a Stolen /Abandoned Vehicle", first_name[indexPath]];
        } else {
            strName = [NSString stringWithFormat:@"%@ reported a %@", first_name[indexPath], report_type[indexPath]];
        }*/
        strName = [NSString stringWithFormat:@"%@ reported their vehicle", first_name[indexPath]];
    } else {
        if ([report_type[indexPath] isEqualToString:@"Theft"] || [report_type[indexPath] isEqualToString:@"Serious Vandalism"] || [report_type[indexPath] isEqualToString:@"Suspicious Activity"]) {
            strName = [NSString stringWithFormat:@"%@ spotted a %@", first_name[indexPath], report_type[indexPath]];
        } else {
            strName = [NSString stringWithFormat:@"%@ spotted a Suspicious Activity", first_name[indexPath]];
        }
    }
    //NSLog(@"%@", strName);
    // Attribute string for User name and activity
    //NSLog(@"%@ : %@", type[indexPath], first_name[indexPath]);
    NSMutableAttributedString *attrStringName = [[NSMutableAttributedString alloc] initWithString:strName];
    [attrStringName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f] range:NSMakeRange(0, strName.length)];
    [attrStringName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#0067AD"] range:NSMakeRange(0, [first_name[indexPath] length])];
    lblName.attributedText = attrStringName;
    [viewTop addSubview:lblName];
    [viewBG addSubview:viewTop];
    
    /************************************* Top view Ends ***********************************/
    
    /************************************* Bottom view Starts ***********************************/
    
    // Add Bottom view for other information
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, viewTop.frame.origin.y + viewTop.frame.size.height, 300, 50)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    // string to check vehicle is cycle or something else
    NSString *vehicleType = @"Registration number:";
    
    // ImageView for vehicle_type
    UIImageView *ivVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 15)];
    // set Image here
    if ([vehicle_type[indexPath] isEqualToString:@"Bicycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
        vehicleType = @"Serial number:";
    } else if ([vehicle_type[indexPath] isEqualToString:@"Car"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicle_type[indexPath] isEqualToString:@"Motorcycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        ivVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    [viewBottom addSubview:ivVehicle];
    
    // Add Vehicle's make & model here
    UILabel *lblMakeModel = [[UILabel alloc] initWithFrame:CGRectMake(ivVehicle.frame.origin.x + ivVehicle.frame.size.width + 5, ivVehicle.frame.origin.x, 180, MIN_HEIGHT)];
    lblMakeModel.numberOfLines = 0;
    lblMakeModel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    lblMakeModel.text = [NSString stringWithFormat:@"%@ %@", make[indexPath], model[indexPath]];
    lblMakeModel.textColor = [UIColor colorWithHexString:@"#0067AD"];
    CGSize constraint = CGSizeMake(lblMakeModel.frame.size.width, 20000.0f);
    
    CGRect textRect = [lblMakeModel.text boundingRectWithSize:constraint
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:@{NSFontAttributeName:lblMakeModel.font}
                                                      context:nil];
    
    [lblMakeModel setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMakeModel setAdjustsFontSizeToFitWidth:NO];
    [lblMakeModel setFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y, lblMakeModel.frame.size.width, MAX(textRect.size.height, MIN_HEIGHT))];
    [viewBottom addSubview:lblMakeModel];
    
    // Add Type of report here.
    UILabel *lblTypeReport = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x + lblMakeModel.frame.size.width + 5, lblMakeModel.frame.origin.y, 75, 30)];
    lblTypeReport.numberOfLines = 2;
    lblTypeReport.textAlignment = NSTextAlignmentRight;
    lblTypeReport.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblTypeReport.text = [NSString stringWithFormat:@"%@", report_type[indexPath]];
    lblTypeReport.textColor = [UIColor colorWithHexString:@"#FF444C"];
    [viewBottom addSubview:lblTypeReport];
    
    // Add Registration number here
    UILabel *lblRegistration = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y + lblMakeModel.frame.size.height, 268, 20)];
    lblRegistration.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblRegistration.text = [NSString stringWithFormat:@"%@ %@",vehicleType, registration_serial_no[indexPath]];
    [viewBottom addSubview:lblRegistration];
    
    // Add horizontal line here
    UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblRegistration.frame.origin.y + lblRegistration.frame.size.height + 5, lblRegistration.frame.size.width, 1)];
    ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewBottom addSubview:ivHR];
    
    // Add Date here
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, ivHR.frame.origin.y + ivHR.frame.size.height + 10, 160, 20)];
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [dtFormat dateFromString:selected_date[indexPath]];
    [dtFormat setDateFormat:@"E, MMMM dd, yyyy"];
    lblDate.text = [dtFormat stringFromDate:dt];
    
    [viewBottom addSubview:lblDate];
    
    // Add Time here
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x + lblDate.frame.size.width, lblDate.frame.origin.y, 100, lblDate.frame.size.height)];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.font = lblDate.font;
    
    [dtFormat setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dtFormat dateFromString:selected_time[indexPath]];
    [dtFormat setDateFormat:@"HH:mm"];
    lblTime.text = [dtFormat stringFromDate:time];
    
    [viewBottom addSubview:lblTime];
    
    // Add Location icon here
    UIImageView *ivLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblDate.frame.origin.y + lblDate.frame.size.height + 5, 7, 10)];
    ivLocationIcon.image = [UIImage imageNamed:@"ic_location.png"];
    [viewBottom addSubview:ivLocationIcon];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(ivLocationIcon.frame.origin.x + ivLocationIcon.frame.size.width + 5, ivLocationIcon.frame.origin.y - 4, 240, 20)];
    lblLocation.font = lblDate.font;
    lblLocation.numberOfLines = 0;
    lblLocation.text = location[indexPath];
    
    CGSize constraintLocation = CGSizeMake(lblLocation.frame.size.width, 20000.0f);
    
    CGRect textRectLocation = [lblLocation.text boundingRectWithSize:constraintLocation
                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName:lblLocation.font}
                                                             context:nil];
    
    [lblLocation setLineBreakMode:NSLineBreakByWordWrapping];
    [lblLocation setAdjustsFontSizeToFitWidth:NO];
    [lblLocation setFrame:CGRectMake(lblLocation.frame.origin.x, lblLocation.frame.origin.y, lblLocation.frame.size.width, MAX(textRectLocation.size.height, MIN_HEIGHT))];
    
    [viewBottom addSubview:lblLocation];
    
    // Add HR if comment OR image is present
    NSString *strComment = comments[indexPath];
    NSString *strImage1 = photo1[indexPath];
    
    if (strComment.length > 0 || strImage1.length > 0) {
        // Add HR here
        // Add horizontal line here
        UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLocation.frame.origin.y + lblLocation.frame.size.height + 10, 300, 1)];
        ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [viewBottom addSubview:ivHR];
        
        CGFloat top = ivHR.frame.origin.y + ivHR.frame.size.height;
        
        if (strComment.length > 0) {
            // Add Comment here
            UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, top + 10, 280, 20)];
            lblComment.font = lblDate.font;
            lblComment.numberOfLines = 0;
            lblComment.text = strComment;
            
            CGSize constraintComment = CGSizeMake(lblComment.frame.size.width, 20000.0f);
            
            CGRect textRectComment = [lblComment.text boundingRectWithSize:constraintComment
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:lblComment.font}
                                                                   context:nil];
            
            [lblComment setLineBreakMode:NSLineBreakByWordWrapping];
            [lblComment setAdjustsFontSizeToFitWidth:NO];
            [lblComment setFrame:CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, lblComment.frame.size.width, MAX(textRectComment.size.height, MIN_HEIGHT))];
            
            top = top + textRectComment.size.height + 10;
            
            [viewBottom addSubview:lblComment];
        }
        
        if (strImage1.length > 0) {
            CustomImageView *ivImage1 = [[CustomImageView alloc] initWithFrame:CGRectMake(10, top + 10, 60, 60)];
            [ivImage1 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
            ivImage1.layer.cornerRadius = 30;
            ivImage1.clipsToBounds = YES;
            ivImage1.userInteractionEnabled = YES;
            ivImage1.imageFileURL = strImage1;
            [ivImage1 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strImage1] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
            [viewBottom addSubview:ivImage1];
            
            CustomImageView *ivImage2 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage1.frame.origin.x + ivImage1.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage2.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage2.clipsToBounds = ivImage1.clipsToBounds;
            
            if ([photo2[indexPath] length] > 0) {
                [ivImage2 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                
                ivImage2.userInteractionEnabled = YES;
                ivImage2.imageFileURL = photo2[indexPath];
                [ivImage2 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:photo2[indexPath]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                
                [viewBottom addSubview:ivImage2];
            }
            
            CustomImageView *ivImage3 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage2.frame.origin.x + ivImage2.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage3.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage3.clipsToBounds = ivImage1.clipsToBounds;
            
            if ([photo3[indexPath] length] > 0) {
                [ivImage3 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                ivImage3.userInteractionEnabled = YES;
                ivImage3.imageFileURL = photo3[indexPath];
                [ivImage3 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:photo3[indexPath]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                
                [viewBottom addSubview:ivImage3];
            }
        }
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [viewBottom.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    CGRect frame = viewBottom.frame;
    frame.size.height = wd+ht;
    viewBottom.frame = frame;
    
    [viewBG addSubview:viewBottom];
    
    UIView *vBG = [viewBG.subviews lastObject];
    NSInteger wd2 = vBG.frame.origin.y;
    NSInteger ht2 = vBG.frame.size.height;
    
    sizeOfContent = wd2 + ht2 + 10;
    CGRect frameBG = viewBG.frame;
    frameBG.size.height = wd2+ht2 + 10;
    viewBG.frame = frameBG;
    
    if ([typeView isEqualToString:@"height"]) {
        return [NSString stringWithFormat:@"%f", sizeOfContent];
    } else if ([typeView isEqualToString:@"view"]) {
        return viewBG;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewOthers) {
        CGFloat height = [[self plotViewWithIndexNumber:indexPath.row andType:@"height"] floatValue];
        return height + 10;
    } else if (tableView == self.tableViewMyUpdates) {
        if (vehicle_idMy.count == 0) {
            // create Stay tuned view here
            return 300;
        } else {
            CGFloat height = [[self plotMyUpdatesViewWithIndexNumber:indexPath.row andType:@"height"] floatValue];
            return height + 10;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableViewMyUpdates) {
        return 40;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableViewOthers) {
        return 0;
    } else {
        CGFloat height = [[self plotHeaderViewWithType:@"height" withIndex:section] floatValue];
        return height;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView == self.tableViewOthers) {
        return nil;
    } else {
        return [self plotHeaderViewWithType:@"view" withIndex:section];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewOthers) {
        if ([type[indexPath.row] isEqualToString:@"report"]) {
            DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
            detailsVC.firstNameHeader = first_name[indexPath.row];
            detailsVC.vehicleHeader = vehicle_type[indexPath.row];
            detailsVC.makeHeader = make[indexPath.row];
            detailsVC.modelHeader = model[indexPath.row];
            detailsVC.typeSightingHeader = report_type[indexPath.row];
            detailsVC.regNoHeader = registration_serial_no[indexPath.row];
            detailsVC.dateHeader = selected_date[indexPath.row];
            detailsVC.timeHeader = selected_time[indexPath.row];
            detailsVC.locationHeader = location[indexPath.row];
            detailsVC.commentHeader = comments[indexPath.row];
            detailsVC.photo1Header = photo1[indexPath.row];
            detailsVC.photo2Header = photo2[indexPath.row];
            detailsVC.photo3Header = photo3[indexPath.row];
            detailsVC.vehicleID = vehicle_id[indexPath.row];
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
    } else {
        // code for my updates
    }
    
}

#pragma mark - ScrollView Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance)
    {
        if (!self.viewOthers.hidden) {
            if (loadMore) {
                loadMore = NO;
                [self loadOtherUpdates];
            }
        } else {
            // code for my updates
        }
        
    }
}

-(void)createDownloadFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/download"];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
}


-(void)openImage:(CustomImageView *)imageView {
    
    [self deleteAllimageFiles];
    
    selectedImage = [[NSMutableArray alloc] init];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.currentPreviewItemIndex = 0;
    
    NSURL *URL = [NSURL URLWithString:imageView.imageFileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSString *fileName = [URL lastPathComponent];
    [selectedImage addObject:fileName];
    
    // save image here
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"/download"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, fileName];
    
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        [data writeToFile:filePath atomically:YES];
        NSLog(@"saved");
        [self presentViewController:previewController animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"file downloading error : %@", [error localizedDescription]);
    }];
    [downloadRequest start];
    
}

#pragma mark - QLPreviewControllerDataSource Methods
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return [selectedImage count];
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *fileURL = nil;
    NSString *fileName = [selectedImage objectAtIndex:index];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"/download"];
    NSString *previewFileFullPath = [path stringByAppendingPathComponent:fileName];
    fileURL = [NSURL fileURLWithPath:previewFileFullPath];
    return fileURL;
}

-(void)deleteAllimageFiles {
    // Delete all user's body picks from gallery folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:@"download/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

- (IBAction)btnLoginClicked:(id)sender {
    NSString *btnTitle = self.btnLogin.currentTitle;
    
    if ([btnTitle isEqualToString:@"Let's Go"]) {
        // open profile page
        UserProfileVC *vc = [[UserProfileVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // open login page
        LoginVC *vc = [[LoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark Header View For MyUpdates TableView

-(id)plotHeaderViewWithType:(NSString *)typeView withIndex:(NSInteger)indexPath {
    
    //Add TapGesture to open ReportSummary Screen
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openReportSummary:)];
    
    // Add 1 background view as container
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    viewBG.backgroundColor = [UIColor whiteColor];
    [viewBG addGestureRecognizer:tap];
    
    // Add Bottom view for other information
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    // string to check vehicle is cycle or something else
    NSString *vehicleType = @"Registration number:";
    
    // ImageView for vehicle_type
    UIImageView *ivVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 15)];
    // set Image here
    if ([vehicleHeader[indexPath] isEqualToString:@"Bicycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
        vehicleType = @"Serial number:";
    } else if ([vehicleHeader[indexPath] isEqualToString:@"Car"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicleHeader[indexPath] isEqualToString:@"Motorcycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        ivVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    [viewBottom addSubview:ivVehicle];
    
    // Add Vehicle's make & model here
    UILabel *lblMakeModel = [[UILabel alloc] initWithFrame:CGRectMake(ivVehicle.frame.origin.x + ivVehicle.frame.size.width + 5, ivVehicle.frame.origin.x, 180, MIN_HEIGHT)];
    lblMakeModel.numberOfLines = 0;
    lblMakeModel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    lblMakeModel.text = [NSString stringWithFormat:@"%@ %@", makeHeader[indexPath], modelHeader[indexPath]];
    lblMakeModel.textColor = [UIColor colorWithHexString:@"#0067AD"];
    CGSize constraint = CGSizeMake(lblMakeModel.frame.size.width, 20000.0f);
    
    CGRect textRect = [lblMakeModel.text boundingRectWithSize:constraint
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:@{NSFontAttributeName:lblMakeModel.font}
                                                      context:nil];
    
    [lblMakeModel setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMakeModel setAdjustsFontSizeToFitWidth:NO];
    [lblMakeModel setFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y, lblMakeModel.frame.size.width, MAX(textRect.size.height, MIN_HEIGHT))];
    [viewBottom addSubview:lblMakeModel];
    
    // Add Type of report here.
    UILabel *lblTypeReport = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x + lblMakeModel.frame.size.width + 5, lblMakeModel.frame.origin.y, 75, 30)];
    lblTypeReport.numberOfLines = 2;
    lblTypeReport.textAlignment = NSTextAlignmentRight;
    lblTypeReport.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblTypeReport.text = [NSString stringWithFormat:@"%@", typeSightingHeader[indexPath]];
    lblTypeReport.textColor = [UIColor colorWithHexString:@"#FF444C"];
    [viewBottom addSubview:lblTypeReport];
    
    // Add Registration number here
    UILabel *lblRegistration = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y + lblMakeModel.frame.size.height, 268, 20)];
    lblRegistration.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblRegistration.text = [NSString stringWithFormat:@"%@ %@",vehicleType, regNoHeader[indexPath]];
    [viewBottom addSubview:lblRegistration];
    
    // Add horizontal line here
    UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblRegistration.frame.origin.y + lblRegistration.frame.size.height + 5, lblRegistration.frame.size.width, 1)];
    ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewBottom addSubview:ivHR];
    
    // Add Date here
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, ivHR.frame.origin.y + ivHR.frame.size.height + 10, 160, 20)];
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [dtFormat dateFromString:dateHeader[indexPath]];
    [dtFormat setDateFormat:@"E, MMMM dd, yyyy"];
    lblDate.text = [dtFormat stringFromDate:dt];
    
    [viewBottom addSubview:lblDate];
    
    // Add Time here
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x + lblDate.frame.size.width, lblDate.frame.origin.y, 100, lblDate.frame.size.height)];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.font = lblDate.font;
    
    [dtFormat setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dtFormat dateFromString:timeHeader[indexPath]];
    [dtFormat setDateFormat:@"HH:mm"];
    lblTime.text = [dtFormat stringFromDate:time];
    
    [viewBottom addSubview:lblTime];
    
    // Add Location icon here
    UIImageView *ivLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblDate.frame.origin.y + lblDate.frame.size.height + 5, 7, 10)];
    ivLocationIcon.image = [UIImage imageNamed:@"ic_location.png"];
    [viewBottom addSubview:ivLocationIcon];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(ivLocationIcon.frame.origin.x + ivLocationIcon.frame.size.width + 5, ivLocationIcon.frame.origin.y - 4, 240, 20)];
    lblLocation.font = lblDate.font;
    lblLocation.numberOfLines = 0;
    lblLocation.text = locationHeader[indexPath];
    
    CGSize constraintLocation = CGSizeMake(lblLocation.frame.size.width, 20000.0f);
    
    CGRect textRectLocation = [lblLocation.text boundingRectWithSize:constraintLocation
                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName:lblLocation.font}
                                                             context:nil];
    
    [lblLocation setLineBreakMode:NSLineBreakByWordWrapping];
    [lblLocation setAdjustsFontSizeToFitWidth:NO];
    [lblLocation setFrame:CGRectMake(lblLocation.frame.origin.x, lblLocation.frame.origin.y, lblLocation.frame.size.width, MAX(textRectLocation.size.height, MIN_HEIGHT))];
    
    [viewBottom addSubview:lblLocation];
    
    // Add HR if comment OR image is present
    NSString *strComment = commentHeader[indexPath];
    NSString *strImage1 = photo1Header[indexPath];
    
    if (strComment.length > 0 || strImage1.length > 0) {
        // Add HR here
        // Add horizontal line here
        UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLocation.frame.origin.y + lblLocation.frame.size.height + 10, 300, 1)];
        ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [viewBottom addSubview:ivHR];
        
        CGFloat top = ivHR.frame.origin.y + ivHR.frame.size.height;
        
        if (strComment.length > 0) {
            // Add Comment here
            UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, top + 10, 280, 20)];
            lblComment.font = lblDate.font;
            lblComment.numberOfLines = 0;
            lblComment.text = strComment;
            
            CGSize constraintComment = CGSizeMake(lblComment.frame.size.width, 20000.0f);
            
            CGRect textRectComment = [lblComment.text boundingRectWithSize:constraintComment
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:lblComment.font}
                                                                   context:nil];
            
            [lblComment setLineBreakMode:NSLineBreakByWordWrapping];
            [lblComment setAdjustsFontSizeToFitWidth:NO];
            [lblComment setFrame:CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, lblComment.frame.size.width, MAX(textRectComment.size.height, MIN_HEIGHT))];
            
            top = top + textRectComment.size.height + 10;
            
            [viewBottom addSubview:lblComment];
        }
        
        if (strImage1.length > 0) {
            
            CustomImageView *ivImage1 = [[CustomImageView alloc] initWithFrame:CGRectMake(10, top + 10, 60, 60)];
            [ivImage1 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
            ivImage1.layer.cornerRadius = 30;
            ivImage1.clipsToBounds = YES;
            ivImage1.userInteractionEnabled = YES;
            ivImage1.imageFileURL = strImage1;
            [ivImage1 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strImage1] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
            [viewBottom addSubview:ivImage1];
            
            CustomImageView *ivImage2 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage1.frame.origin.x + ivImage1.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage2.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage2.clipsToBounds = ivImage1.clipsToBounds;
            if ([photo2Header[indexPath] length] > 0) {
                [ivImage2 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                ivImage2.userInteractionEnabled = YES;
                ivImage2.imageFileURL = photo2Header[indexPath];
                [ivImage2 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:photo2Header[indexPath]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                [viewBottom addSubview:ivImage2];
            }
            
            CustomImageView *ivImage3 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage2.frame.origin.x + ivImage2.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage3.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage3.clipsToBounds = ivImage1.clipsToBounds;
            if ([photo3Header[indexPath] length] > 0) {
                [ivImage3 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                ivImage3.userInteractionEnabled = YES;
                ivImage3.imageFileURL = photo3Header[indexPath];
                [ivImage3 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:photo3Header[indexPath]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                [viewBottom addSubview:ivImage3];
            }
        }
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [viewBottom.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    CGRect frame = viewBottom.frame;
    frame.size.height = wd+ht;
    viewBottom.frame = frame;
    
    [viewBG addSubview:viewBottom];
    
    UIView *vBG = [viewBG.subviews lastObject];
    NSInteger wd2 = vBG.frame.origin.y;
    NSInteger ht2 = vBG.frame.size.height;
    
    sizeOfContent = wd2 + ht2 + 10;
    CGRect frameBG = viewBG.frame;
    frameBG.size.height = wd2+ht2 + 10;
    viewBG.frame = frameBG;
    
    if ([typeView isEqualToString:@"height"]) {
        return [NSString stringWithFormat:@"%f", sizeOfContent];
    } else if ([typeView isEqualToString:@"view"]) {
        return viewBG;
    }
    
    return nil;
}

#pragma mark - RowsView For MyUpdates TableView

-(id)plotMyUpdatesViewWithIndexNumber:(NSInteger)indexPath andType:(NSString *)typeView {
    
    // Add 1 background view as container
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    viewBG.backgroundColor = [UIColor whiteColor];
    
    /************************************* Top view Starts ***********************************/
    
    // View for top
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewBG.frame.size.width, 30)];
    viewTop.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    // add UILabel for Name of user
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 190, 30)];
    NSString *strName = [NSString stringWithFormat:@"%@ spotted your %@", first_nameMy[indexPath], vehicleHeader[0]];
    
    // Attribute string for User anme and activity
    NSMutableAttributedString *attrStringName = [[NSMutableAttributedString alloc] initWithString:strName];
    [attrStringName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f] range:NSMakeRange(0, strName.length)];
    [attrStringName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#0067AD"] range:NSMakeRange(0, [first_nameMy[indexPath] length])];
    lblName.attributedText = attrStringName;
    [viewTop addSubview:lblName];
    
    // Add Type of report here.
    UILabel *lblTypeReport = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x + lblName.frame.size.width + 5, lblName.frame.origin.y, 75, 30)];
    lblTypeReport.numberOfLines = 2;
    lblTypeReport.textAlignment = NSTextAlignmentRight;
    lblTypeReport.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblTypeReport.text = [NSString stringWithFormat:@"%@", report_typeMy[indexPath]];
    lblTypeReport.textColor = [UIColor colorWithHexString:@"#FF444C"];
    [viewTop addSubview:lblTypeReport];
    
    [viewBG addSubview:viewTop];
    
    /************************************* Top view Ends ***********************************/
    
    /************************************* Bottom view Starts ***********************************/
    
    // Add Bottom view for other information
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, viewTop.frame.origin.y + viewTop.frame.size.height, 300, 50)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    /*// ImageView for vehicle_type
    UIImageView *ivVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 15)];
    // set Image here
    if ([vehicleHeader[0] isEqualToString:@"Bicycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
    } else if ([vehicleHeader[0] isEqualToString:@"Car"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicleHeader[0] isEqualToString:@"Motorcycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        ivVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    [viewBottom addSubview:ivVehicle];
    
    // Add Vehicle's make & model here
    UILabel *lblMakeModel = [[UILabel alloc] initWithFrame:CGRectMake(ivVehicle.frame.origin.x + ivVehicle.frame.size.width + 5, ivVehicle.frame.origin.x, 180, MIN_HEIGHT)];
    lblMakeModel.numberOfLines = 0;
    lblMakeModel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    //lblMakeModel.text = [NSString stringWithFormat:@"%@ %@", makeMy[indexPath], modelMy[indexPath]];
    lblMakeModel.textColor = [UIColor colorWithHexString:@"#0067AD"];
    CGSize constraint = CGSizeMake(lblMakeModel.frame.size.width, 20000.0f);
    
    CGRect textRect = [lblMakeModel.text boundingRectWithSize:constraint
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:@{NSFontAttributeName:lblMakeModel.font}
                                                      context:nil];
    
    [lblMakeModel setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMakeModel setAdjustsFontSizeToFitWidth:NO];
    [lblMakeModel setFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y, lblMakeModel.frame.size.width, MAX(textRect.size.height, MIN_HEIGHT))];
    [viewBottom addSubview:lblMakeModel];
    
    // Add Registration number here
    UILabel *lblRegistration = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y + lblMakeModel.frame.size.height, 268, 20)];
    lblRegistration.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    //lblRegistration.text = [NSString stringWithFormat:@"Registration number: %@", registration_serial_noMy[indexPath]];
    [viewBottom addSubview:lblRegistration];
    
    // Add horizontal line here
    UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblRegistration.frame.origin.y + lblRegistration.frame.size.height + 5, lblRegistration.frame.size.width, 1)];
    ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewBottom addSubview:ivHR];*/
    
    // Add Date here
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 160, 20)];
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [dtFormat dateFromString:selected_dateMy[indexPath]];
    [dtFormat setDateFormat:@"E, MMMM dd, yyyy"];
    lblDate.text = [dtFormat stringFromDate:dt];
    
    [viewBottom addSubview:lblDate];
    
    // Add Time here
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x + lblDate.frame.size.width + 15, lblDate.frame.origin.y, 100, lblDate.frame.size.height)];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.font = lblDate.font;
    
    [dtFormat setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dtFormat dateFromString:selected_timeMy[indexPath]];
    [dtFormat setDateFormat:@"HH:mm"];
    lblTime.text = [dtFormat stringFromDate:time];
    
    [viewBottom addSubview:lblTime];
    
    // Add Location icon here
    UIImageView *ivLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x, lblDate.frame.origin.y + lblDate.frame.size.height + 5, 7, 10)];
    ivLocationIcon.image = [UIImage imageNamed:@"ic_location.png"];
    [viewBottom addSubview:ivLocationIcon];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(ivLocationIcon.frame.origin.x + ivLocationIcon.frame.size.width + 5, ivLocationIcon.frame.origin.y - 4, 240, 20)];
    lblLocation.font = lblDate.font;
    lblLocation.numberOfLines = 0;
    lblLocation.text = locationMy[indexPath];
    
    CGSize constraintLocation = CGSizeMake(lblLocation.frame.size.width, 20000.0f);
    
    CGRect textRectLocation = [lblLocation.text boundingRectWithSize:constraintLocation
                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName:lblLocation.font}
                                                             context:nil];
    
    [lblLocation setLineBreakMode:NSLineBreakByWordWrapping];
    [lblLocation setAdjustsFontSizeToFitWidth:NO];
    [lblLocation setFrame:CGRectMake(lblLocation.frame.origin.x, lblLocation.frame.origin.y, lblLocation.frame.size.width, MAX(textRectLocation.size.height, MIN_HEIGHT))];
    
    [viewBottom addSubview:lblLocation];
    
    // Add HR if comment OR image is present
    NSString *strComment = commentsMy[indexPath];
    NSString *strImage1 = photo1My[indexPath];
    
    if (strComment.length > 0 || strImage1.length > 0) {
        // Add HR here
        // Add horizontal line here
        UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLocation.frame.origin.y + lblLocation.frame.size.height + 10, 300, 1)];
        ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [viewBottom addSubview:ivHR];
        
        CGFloat top = ivHR.frame.origin.y + ivHR.frame.size.height;
        
        if (strComment.length > 0) {
            // Add Comment here
            UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, top + 10, 280, 20)];
            lblComment.font = lblDate.font;
            lblComment.numberOfLines = 0;
            lblComment.text = strComment;
            
            CGSize constraintComment = CGSizeMake(lblComment.frame.size.width, 20000.0f);
            
            CGRect textRectComment = [lblComment.text boundingRectWithSize:constraintComment
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:lblComment.font}
                                                                   context:nil];
            
            [lblComment setLineBreakMode:NSLineBreakByWordWrapping];
            [lblComment setAdjustsFontSizeToFitWidth:NO];
            [lblComment setFrame:CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, lblComment.frame.size.width, MAX(textRectComment.size.height, MIN_HEIGHT))];
            
            top = top + textRectComment.size.height + 10;
            
            [viewBottom addSubview:lblComment];
        }
        
        if (strImage1.length > 0) {
            CustomImageView *ivImage1 = [[CustomImageView alloc] initWithFrame:CGRectMake(10, top + 10, 60, 60)];
            [ivImage1 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
            ivImage1.layer.cornerRadius = 30;
            ivImage1.clipsToBounds = YES;
            ivImage1.userInteractionEnabled = YES;
            ivImage1.imageFileURL = strImage1;
            [ivImage1 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strImage1] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
            [viewBottom addSubview:ivImage1];
            
            CustomImageView *ivImage2 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage1.frame.origin.x + ivImage1.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage2.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage2.clipsToBounds = ivImage1.clipsToBounds;
            
            if ([photo2My[indexPath] length] > 0) {
                [ivImage2 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                
                ivImage2.userInteractionEnabled = YES;
                ivImage2.imageFileURL = photo2My[indexPath];
                [ivImage2 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:photo2My[indexPath]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                
                [viewBottom addSubview:ivImage2];
            }
            
            CustomImageView *ivImage3 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage2.frame.origin.x + ivImage2.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage3.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage3.clipsToBounds = ivImage1.clipsToBounds;
            
            if ([photo3My[indexPath] length] > 0) {
                [ivImage3 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                ivImage3.userInteractionEnabled = YES;
                ivImage3.imageFileURL = photo3My[indexPath];
                [ivImage3 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:photo3My[indexPath]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                
                [viewBottom addSubview:ivImage3];
            }
        }
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [viewBottom.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    CGRect frame = viewBottom.frame;
    frame.size.height = wd+ht;
    viewBottom.frame = frame;
    
    [viewBG addSubview:viewBottom];
    
    UIView *vBG = [viewBG.subviews lastObject];
    NSInteger wd2 = vBG.frame.origin.y;
    NSInteger ht2 = vBG.frame.size.height;
    
    sizeOfContent = wd2 + ht2 + 10;
    CGRect frameBG = viewBG.frame;
    frameBG.size.height = wd2+ht2 + 10;
    viewBG.frame = frameBG;
    
    if ([typeView isEqualToString:@"height"]) {
        return [NSString stringWithFormat:@"%f", sizeOfContent];
    } else if ([typeView isEqualToString:@"view"]) {
        return viewBG;
    }
    
    return nil;
}

- (IBAction)btnVehicleRecoveredClicked:(id)sender {
    [alertViewVehicleRecovered show];
}

-(void)addSubviewsToScrollView {
    [self.scrollViewVehicleReported addSubview:[self plotHeaderViewWithType:@"view" withIndex:0]];
    
    UIView *lLastSC = [self.scrollViewVehicleReported.subviews lastObject];
    NSInteger wdSC = lLastSC.frame.origin.y;
    NSInteger htSC = lLastSC.frame.size.height;
    
    // Create BackgroundView as Container
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, wdSC + htSC + 20, 320, 280)];
    viewBG.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [viewBG sizeToFit];
    
    // Add Done button here
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.titleLabel.textColor = [UIColor whiteColor];
    btnDone.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
    btnDone.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [btnDone addTarget:self action:@selector(btnDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnDone];
    
    // Add Image of success here
    UIImageView *ivSuccess = [[UIImageView alloc] initWithFrame:CGRectMake(125, btnDone.frame.origin.y + btnDone.frame.size.height + 5, 90, 90)];
    [ivSuccess setImage:[UIImage imageNamed:@"target_symbol.png"]];
    [viewBG addSubview:ivSuccess];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dtStr = [dtFormat dateFromString:recovered_dateMy[0]];
    
    // Add Date Time label here
    UILabel *lblDtTm = [[UILabel alloc] initWithFrame:CGRectMake(0, ivSuccess.frame.origin.y + ivSuccess.frame.size.height + 5, 320, 20)];
    [dtFormat setDateFormat:@"E, MMMM dd, yyyy"];
    lblDtTm.textAlignment = NSTextAlignmentCenter;
    lblDtTm.text = [dtFormat stringFromDate:dtStr];
    [viewBG addSubview:lblDtTm];
    
    [dtFormat setDateFormat:@"HH:mm:ss"];
    NSDate *tmStr = [dtFormat dateFromString:recovered_timeMy[0]];
    
    // Add Time here
    UILabel *lblTm = [[UILabel alloc] initWithFrame:CGRectMake(0, lblDtTm.frame.origin.y + lblDtTm.frame.size.height, 320, 20)];
    [dtFormat setDateFormat:@"HH:mm"];
    lblTm.textAlignment = NSTextAlignmentCenter;
    lblTm.text = [dtFormat stringFromDate:tmStr];
    [viewBG addSubview:lblTm];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(0, lblTm.frame.origin.y + lblTm.frame.size.height, 320, 20)];
    lblLocation.textAlignment = NSTextAlignmentCenter;
    lblLocation.text = [dtFormat stringFromDate:recovered_locationMy[0]];
    [viewBG addSubview:lblLocation];
    
    // Add Police Button here
    UIButton *btnPolice = [[UIButton alloc] initWithFrame:CGRectMake(20, lblLocation.frame.origin.y + lblLocation.frame.size.height + 15, 135, 40)];
    [btnPolice setTitle:@"Call Police" forState:UIControlStateNormal];
    btnPolice.titleLabel.textColor = btnDone.titleLabel.textColor;
    btnPolice.backgroundColor = btnDone.backgroundColor;
    btnPolice.titleLabel.font = btnDone.titleLabel.font;
    [btnPolice addTarget:self action:@selector(btnCallPoliceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnPolice];
    
    // Add Insurer Button here
    UIButton *btnInsurer = [[UIButton alloc] initWithFrame:CGRectMake(btnPolice.frame.origin.x + btnPolice.frame.size.width + 10, btnPolice.frame.origin.y, btnPolice.frame.size.width, btnPolice.frame.size.height)];
    [btnInsurer setTitle:@"Call Insurer" forState:UIControlStateNormal];
    btnInsurer.titleLabel.textColor = btnDone.titleLabel.textColor;
    btnInsurer.backgroundColor = btnDone.backgroundColor;
    btnInsurer.titleLabel.font = btnDone.titleLabel.font;
    [btnInsurer addTarget:self action:@selector(btnCallInsurerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnInsurer];
    
    [self.scrollViewVehicleReported addSubview:viewBG];
    
    float sizeOfContent = 0;
    UIView *lLast1 = [self.scrollViewVehicleReported.subviews lastObject];
    NSInteger wd1 = lLast1.frame.origin.y;
    NSInteger ht1 = lLast1.frame.size.height;
    
    sizeOfContent = wd1+ht1;
    
    self.scrollViewVehicleReported.contentSize = CGSizeMake(self.scrollViewVehicleReported.frame.size.width, sizeOfContent);
}

-(void)btnDoneClicked:(UIButton *)sender {
    // open home page
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
    
    [self backButtonClicked:nil];
}

-(void)btnCallPoliceClicked:(UIButton *)sender {
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"131444"]];
    [[UIApplication sharedApplication] openURL:telURL];
}

-(void)btnCallInsurerClicked:(UIButton *)sender {
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", insurance_company_numberHeader[0]]];
    [[UIApplication sharedApplication] openURL:telURL];
}

#pragma mark - UITagGestureRecognizer methods

-(void)openReportSummary:(UITapGestureRecognizer *)recognizer {
    // open Report Summary screen
    ReportSummaryViewController *reportVC = [[ReportSummaryViewController alloc] init];
    reportVC.detailsArray = detailsArray;
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertViewGuestUser) {
        if (buttonIndex == 1) {
            LoginVC *vc = [[LoginVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (alertView == alertViewVehicleRecovered) {
        if (buttonIndex == 1) {
            // Start Animating activityIndicator
            [navActivityIndicator startAnimating];
            
            // add bgToolbar to view
            [self.view.superview insertSubview:bgToolBar aboveSubview:self.view];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
            NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
            
            NSDate *date = [NSDate date];
            
            NSDateFormatter *dtFormat = [NSDateFormatter new];
            [dtFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *dtString = [dtFormat stringFromDate:date];
            [dtFormat setDateFormat:@"HH:mm"];
            NSString *tmString = [dtFormat stringFromDate:date];
            
            NSDictionary *parameters = @{@"userId" : UserID,
                                         @"pin" : pin,
                                         @"reportId" : reportIDHeader[0],
                                         @"vehicleId" : vehicleID[0],
                                         @"date" : dtString,
                                         @"time" : tmString,
                                         @"location" : address,
                                         @"latitude" : [NSString stringWithFormat:@"%f", latitude],
                                         @"longitude" : [NSString stringWithFormat:@"%f", longitude]};
            
            NSLog(@"Vehicle Recovered:%@", parameters);
            
            NSString *url = [NSString stringWithFormat:@"%@vehicleRecovered.php", SERVERNAME];
            [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                
                // Stop Animating activityIndicator
                [navActivityIndicator stopAnimating];
                [bgToolBar removeFromSuperview];
                
                NSDictionary *json = (NSDictionary *)responseObject;
                
                if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    [self.scrollViewVehicleReported addSubview:[self plotHeaderViewWithType:@"view" withIndex:0]];
                    
                    UIView *lLastSC = [self.scrollViewVehicleReported.subviews lastObject];
                    NSInteger wdSC = lLastSC.frame.origin.y;
                    NSInteger htSC = lLastSC.frame.size.height;
                    
                    // Create BackgroundView as Container
                    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, wdSC + htSC + 20, 320, 280)];
                    viewBG.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                    [viewBG sizeToFit];
                    
                    // Add Done button here
                    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
                    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
                    btnDone.titleLabel.textColor = [UIColor whiteColor];
                    btnDone.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
                    btnDone.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                    [btnDone addTarget:self action:@selector(btnDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [viewBG addSubview:btnDone];
                    
                    // Add Image of success here
                    UIImageView *ivSuccess = [[UIImageView alloc] initWithFrame:CGRectMake(125, btnDone.frame.origin.y + btnDone.frame.size.height + 5, 90, 90)];
                    [ivSuccess setImage:[UIImage imageNamed:@"target_symbol.png"]];
                    [viewBG addSubview:ivSuccess];
                    
                    // Add Date Time label here
                    UILabel *lblDtTm = [[UILabel alloc] initWithFrame:CGRectMake(0, ivSuccess.frame.origin.y + ivSuccess.frame.size.height + 5, 320, 30)];
                    [dtFormat setDateFormat:@"E, MMMM dd, yyyy"];
                    lblDtTm.textAlignment = NSTextAlignmentCenter;
                    lblDtTm.text = [dtFormat stringFromDate:date];
                    [viewBG addSubview:lblDtTm];
                    
                    // Add Time here
                    UILabel *lblTm = [[UILabel alloc] initWithFrame:CGRectMake(0, lblDtTm.frame.origin.y + lblDtTm.frame.size.height, 320, 20)];
                    [dtFormat setDateFormat:@"HH:mm"];
                    lblTm.textAlignment = NSTextAlignmentCenter;
                    lblTm.text = tmString;
                    [viewBG addSubview:lblTm];
                    
                    // Add Location here
                    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(0, lblTm.frame.origin.y + lblTm.frame.size.height, 320, 20)];
                    lblLocation.textAlignment = NSTextAlignmentCenter;
                    lblLocation.text = address;
                    [viewBG addSubview:lblLocation];
                    
                    // Add Police Button here
                    UIButton *btnPolice = [[UIButton alloc] initWithFrame:CGRectMake(20, lblLocation.frame.origin.y + lblLocation.frame.size.height + 15, 135, 40)];
                    [btnPolice setTitle:@"Call Police" forState:UIControlStateNormal];
                    btnPolice.titleLabel.textColor = btnDone.titleLabel.textColor;
                    btnPolice.backgroundColor = btnDone.backgroundColor;
                    btnPolice.titleLabel.font = btnDone.titleLabel.font;
                    [btnPolice addTarget:self action:@selector(btnCallPoliceClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [viewBG addSubview:btnPolice];
                    
                    // Add Insurer Button here
                    UIButton *btnInsurer = [[UIButton alloc] initWithFrame:CGRectMake(btnPolice.frame.origin.x + btnPolice.frame.size.width + 10, btnPolice.frame.origin.y, btnPolice.frame.size.width, btnPolice.frame.size.height)];
                    [btnInsurer setTitle:@"Call Insurer" forState:UIControlStateNormal];
                    btnInsurer.titleLabel.textColor = btnDone.titleLabel.textColor;
                    btnInsurer.backgroundColor = btnDone.backgroundColor;
                    btnInsurer.titleLabel.font = btnDone.titleLabel.font;
                    [btnInsurer addTarget:self action:@selector(btnCallInsurerClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [viewBG addSubview:btnInsurer];
                    
                    [self.scrollViewVehicleReported addSubview:viewBG];
                    
                    float sizeOfContent = 0;
                    UIView *lLast1 = [self.scrollViewVehicleReported.subviews lastObject];
                    NSInteger wd1 = lLast1.frame.origin.y;
                    NSInteger ht1 = lLast1.frame.size.height;
                    
                    sizeOfContent = wd1+ht1;
                    
                    self.scrollViewVehicleReported.contentSize = CGSizeMake(self.scrollViewVehicleReported.frame.size.width, sizeOfContent);
                    
                    // hide
                    
                    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        self.viewVehicleReported.alpha = 1;
                        self.viewTableMyUpdates.alpha = 0;
                        
                        self.viewTableMyUpdates.hidden = YES;
                        self.viewVehicleReported.hidden = NO;
                    } completion:nil];
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                [DeviceInfo errorInConnection];
                
                // Stop Animating activityIndicator
                [navActivityIndicator stopAnimating];
                [bgToolBar removeFromSuperview];
                
            }];
        }
    }
}

@end
