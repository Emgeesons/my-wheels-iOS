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

@interface ReportSubmittedViewController ()
- (IBAction)reportSummaryClicked:(id)sender;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reportSummaryClicked:(id)sender {
    
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
                                 @"vehicleId" : self.vehicleID};
    
    NSLog(@"%@", parameters);
    
    NSString *url = [NSString stringWithFormat:@"%@reportSummary.php", SERVERNAME];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Details ==> %@", responseObject);
        
        // Stop Animating activityIndicator
        //[activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *reportData = (NSArray *)[json objectForKey:@"response"];
            //NSLog(@"%d", reportData.count);
            
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
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [DeviceInfo errorInConnection];
        //[activityIndicator stopAnimating];
    }];
}
@end
