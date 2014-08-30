//
//  ReportSubmittedViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 07/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ReportSubmittedViewController.h"
#import "AFNetworking.h"
#import "ReportSummaryViewController.h"
#import "HomePageVC.h"
#import "UIColor+Extra.h"
@import CoreLocation;
#import "Reachability.h"

@interface ReportSubmittedViewController () {
    CLLocationManager *locationManager;
    float latitude,longitude;
}
- (IBAction)reportSummaryClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)btnBackClicked:(id)sender;

@end

@implementation ReportSubmittedViewController

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
    
    // set navigationBar height to 55
    CGRect frame = self.navBar.frame;
    frame.size.height = 55;
    frame.origin.y = 0;
    self.navBar.frame = frame;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    latitude = locationManager.location.coordinate.latitude;
    longitude = locationManager.location.coordinate.longitude;
    
    // set background color or btnReportSummary
    self.btnReportSummary.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reportSummaryClicked:(id)sender {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [DeviceInfo errorInConnection];
        return;
    }
    
    // open report summary
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    
    NSDictionary *parameters = @{@"userId" : UserID,
                                 @"pin" : pin,
                                 @"os" : OS_VERSION,
                                 @"make" : MAKE,
                                 @"model" : [DeviceInfo platformNiceString],
                                 @"vehicleId" : self.vehicleID,
                                 @"latitude" : [NSString stringWithFormat:@"%f", latitude],
                                 @"longitude" : [NSString stringWithFormat:@"%f", longitude]};
    
    //NSLog(@"%@", parameters);
    
    NSString *url = [NSString stringWithFormat:@"%@reportSummary.php", SERVERNAME];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Details ==> %@", responseObject);
        
        // Stop Animating activityIndicator
        //[activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *reportData = (NSArray *)[json objectForKey:@"response"];
            ////NSLog(@"%d", reportData.count);
            
            // Set detailsArray value here
            NSArray *detailsArray = reportData;
            
            // open Report Summary screen
            ReportSummaryViewController *reportVC = [[ReportSummaryViewController alloc] init];
            reportVC.detailsArray = detailsArray;
            [self.navigationController pushViewController:reportVC animated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [DeviceInfo errorInConnection];
    }];
}
- (IBAction)btnBackClicked:(id)sender {
    NSArray *VCS = self.navigationController.viewControllers;
    for (int i = 0 ; i < VCS.count; i++) {
        if ([VCS[i] isKindOfClass:[HomePageVC class]]) {
            [self.navigationController popToViewController:VCS[i] animated:YES];
            return;
        }
    }
}
@end
