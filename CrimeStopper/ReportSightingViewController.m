//
//  ReportSightingViewController.m
//  CrimeStopper 
//
//  Created by Yogesh Suthar on 30/06/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ReportSightingViewController.h"
@import CoreLocation;
#import "AFNetworking.h"
#import "Reachability.h"
#import "HomePageVC.h"
#import "UserProfileVC.h"
#import "LoginVC.h"
#import "SVProgressHUD.h"

@interface ReportSightingViewController () <UITextFieldDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIActionSheet *sightingPicker, *datePickerSheet, *imagePickerSheet;
    UIDatePicker *datePicker;
    NSDate *datePickerSelectedDate;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *originalLatitude, *originalLongitude, *selectedLatitude, *selectedLongitude, *originalDate, *originalTime, *selectedDate, *selectedTime, *samaritan_points;
    NSMutableString *address;
    NSDateFormatter *dateFormat, *timeFormat;
    UIActivityIndicatorView *activityIndicator;
    UIToolbar *bgToolBar;
    BOOL isLocationEnabled;
    UITextField *activeTextField;
    UIView *timeBackgroundView;
    NSData *imageData1;
    NSData *imageData2;
    NSData *imageData3;
    
}
#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation ReportSightingViewController

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
    
    [_viewLocationGuide setHidden:YES];
    [_viewTransparent setHidden:YES];
    //Initialize CLLocationManager
    _locationManager = [[CLLocationManager alloc] init];
    
    // Initialize CLGeocoder
    geocoder = [[CLGeocoder alloc] init];
    
    _locationManager.delegate = self; // Set delegate
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set accuracy
    
    [_locationManager startUpdatingLocation]; // start updating for current location
    //get current location
    NSString *latitude=[NSString stringWithFormat:@"%f", _locationManager.location.coordinate.latitude];
   
    //NSLog(@"current location : %@",latitude);
    
    if([latitude isEqualToString:@"0.000000"])
    {
        [_viewLocationGuide setHidden:NO];
        [_viewTransparent setHidden:NO];
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        CLLocationCoordinate2D coord = {.latitude = -32.028801, .longitude = 135.0016983};
        MKCoordinateSpan span = {.latitudeDelta = 0.5, .longitudeDelta = 0.5};
        MKCoordinateRegion region = {coord, span};
        [_mapView setRegion:region];
        
        _lblAddress.text = @"5601 SA Australia";
        
        originalLatitude = [NSString stringWithFormat:@"%f", 32.028801];
        originalLongitude = [NSString stringWithFormat:@"%f", 135.0016983];
        selectedLatitude = originalLatitude;
        selectedLongitude = originalLongitude;
    } else {
        address = [[NSMutableString alloc] initWithString:@""];
        CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
        
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
                
                _lblAddress.text = address;
                
                CLLocationCoordinate2D coord = {.latitude =  _locationManager.location.coordinate.latitude, .longitude =  _locationManager.location.coordinate.longitude};
                MKCoordinateSpan span = {.latitudeDelta =  0.005, .longitudeDelta =  0.005};
                MKCoordinateRegion region = {coord, span};
                
                [self.mapView setRegion:region animated:YES];
                
                originalLatitude = [NSString stringWithFormat:@"%f", _locationManager.location.coordinate.latitude];
                originalLongitude = [NSString stringWithFormat:@"%f", _locationManager.location.coordinate.longitude];
                selectedLatitude = originalLatitude;
                selectedLongitude = originalLongitude;
            } else {
                CLLocationCoordinate2D coord = {.latitude = -32.028801, .longitude = 135.0016983};
                MKCoordinateSpan span = {.latitudeDelta = 0.5, .longitudeDelta = 0.5};
                MKCoordinateRegion region = {coord, span};
                [_mapView setRegion:region];
                
                _lblAddress.text = @"5601 SA Australia";
                
                originalLatitude = [NSString stringWithFormat:@"%f", 32.028801];
                originalLongitude = [NSString stringWithFormat:@"%f", 135.0016983];
                selectedLatitude = originalLatitude;
                selectedLongitude = originalLongitude;
            }
        }];
    }

    
    // set contentSize of scrollview here
    [self.scrollView setContentSize:CGSizeMake(0, 700)];
    
    [self createGalleryFolder];
    
    // initialize dateFormat & timeFormat
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    ////NSLog(@"%@", [DeviceInfo platformNiceString]);
    
    // Add UIToolBar to view with alpha 0.7 for transparency
    bgToolBar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolBar.barStyle = UIBarStyleBlack;
    bgToolBar.alpha = 0.7;
    bgToolBar.translucent = YES;
    
    // initialize activityIndicator and add it to UIToolBar.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [bgToolBar addSubview:activityIndicator];
    
    // set current date & time in textbox here
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"E,MMMM dd,yyyy, HH:mm aaa"];
    
    self.txtDateTime.text = [format stringFromDate:date];
    
    // set selected date & time
    selectedDate = [dateFormat stringFromDate:date];
    selectedTime = [timeFormat stringFromDate:date];
    
    // Check If this page opened from UpdatesVC or not,
    if ([self.sighting isEqualToString:@""] || self.sighting == NULL) {
        //NSLog(@"direct");
    } else {
        self.txtSighting.text = self.sighting;
        self.txtRegistrationNo.text = self.regNo;
        self.txtMake.text = self.make;
        self.txtModel.text = self.model;
    }
    
    // setLocationEnabled as NO
    isLocationEnabled = NO;
    
    [self.txtRegistrationNo setInputAccessoryView:self.toolBar];
    [self.txtMake setInputAccessoryView:self.toolBar];
    [self.txtModel setInputAccessoryView:self.toolBar];
    [self.txtColor setInputAccessoryView:self.toolBar];
    [self.txtComments setInputAccessoryView:self.toolBar];
    
    [self deleteAllimageFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnLocation_click:(id)sender
{
    [_viewLocationGuide setHidden:YES];
    [_viewTransparent setHidden:YES];
}
- (IBAction)backButtonClicked:(id)sender {
    [self deleteAllimageFiles];
   // [self.navigationController popViewControllerAnimated:YES];
    HomePageVC *vc = [[HomePageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnSendClicked:(id)sender {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [DeviceInfo errorInConnection];
        return;
    }
    
    // Check Type of Sighting
    if ([DeviceInfo trimString:self.txtSighting.text].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Select type of Sighting" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // Check Date & time
    if ([DeviceInfo trimString:self.txtDateTime.text].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Select Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // get the count of files in gallery folder
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    //NSLog(@"%@", docPaths);
    //NSLog(@"%@", docPaths);
    NSString *dataPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    NSArray *filelist= [fm contentsOfDirectoryAtPath:dataPath error:nil];
    ////NSLog(@"%lu", (unsigned long)filelist.count);
    int filesCount = (int)[filelist count];
    
    // Atleast 1 textfield should be filled
    if ([DeviceInfo trimString:self.txtRegistrationNo.text].length == 0 && [DeviceInfo trimString:self.txtMake.text].length == 0 && [DeviceInfo trimString:self.txtModel.text].length == 0  && [DeviceInfo trimString:self.txtColor.text].length == 0 && [DeviceInfo trimString:self.txtComments.text].length == 0 && filesCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter atleast 1 value." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // get current date & time
    NSDate *currentDate = [NSDate date];
    
    // set original date & time
    originalDate = [dateFormat stringFromDate:currentDate];
    originalTime = [timeFormat stringFromDate:currentDate];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
//    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
//    
//    if (UserID == NULL) {
//        UserID = @"0";
//        pin = @"0000";
//    }
//    
//    NSDictionary *parameters = @{@"userId" : UserID,
//                                 @"pin" : pin,
//                                 @"originalLatitude": originalLatitude,
//                                 @"originalLongitude" : originalLongitude,
//                                 @"selectedLatitude" : selectedLatitude,
//                                 @"selectedLongitude" : selectedLongitude,
//                                 @"location" : address,
//                                 @"originalDate" : originalDate,
//                                 @"originalTime" : originalTime,
//                                 @"selectedDate" : selectedDate,
//                                 @"selectedTime" : selectedTime,
//                                 @"sightingType" : self.txtSighting.text,
//                                 @"vehicleMake" : self.txtMake.text,
//                                 @"vehicleModel" : self.txtModel.text,
//                                 @"vehicleColour" : self.txtColor.text,
//                                 @"noPhotos" : [NSString stringWithFormat:@"%d", filesCount],
//                                 @"registrationNumber" : self.txtRegistrationNo.text,
//                                 @"comments" : self.txtComments.text,
//                                 @"os" : OS_VERSION,
//                                 @"make" : MAKE,
//                                 @"model" : [DeviceInfo platformNiceString]};
//    
//    //NSLog(@"%@", parameters);
//    
//    // Start Animating activityIndicator
//    [activityIndicator startAnimating];
//    
//    // add bgToolbar to view
//    [self.view.superview insertSubview:bgToolBar aboveSubview:self.view];
//    
//    NSString *url = [NSString stringWithFormat:@"%@reportSighting.php", SERVERNAME];
//    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i < filesCount; i++) {
//            NSString *imgName = [NSString stringWithFormat:@"image%d", (int)(i + 1)];
//            NSData *imgData = [[NSData alloc] initWithContentsOfFile:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", filelist[i]]]];
//            [formData appendPartWithFileData:imgData name:imgName fileName:filelist[i] mimeType:@"image/png"];
//        }
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //NSLog(@"%@", responseObject);
//        
//        // Stop Animating activityIndicator
//        [activityIndicator stopAnimating];
//        
//        NSDictionary *json = (NSDictionary *)responseObject;
//        
//        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
//            
//            if (UserID == NULL || [UserID isEqualToString:@"0"]) {// this is for guest user
//                NSArray *VCS = self.navigationController.viewControllers;
//                for (int i = 0 ; i < VCS.count; i++) {
//                    if ([VCS[i] isKindOfClass:[HomePageVC class]]) {
//                     //   [self.navigationController popToViewController:VCS[i] animated:YES];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thank you for your sighting. Sign in and earn Good Samaritan points" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Sign in", nil];
//                        alert.tag = 10;
//                        [alert show];
//                        return;
//                    }
//                }
//                
//              
//            }
//            
//            NSDictionary *response = (NSDictionary *)[json objectForKey:@"response"][0];
//            samaritan_points = [response objectForKey:@"samaritan_points"];
//            [self addSuccessView];
//        } else {// this is for registered user
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//        [DeviceInfo errorInConnection];
//        [activityIndicator stopAnimating];
//        [bgToolBar removeFromSuperview];
//    }];
    
    
    /*    NSDictionary *parameters = @{@"userId" : UserID,
     //                                 @"pin" : pin,
     //                                 @"originalLatitude": originalLatitude,
     //                                 @"originalLongitude" : originalLongitude,
     //                                 @"selectedLatitude" : selectedLatitude,
     //                                 @"selectedLongitude" : selectedLongitude,
     //                                 @"location" : address,
     //                                 @"originalDate" : originalDate,
     //                                 @"originalTime" : originalTime,
     //                                 @"selectedDate" : selectedDate,
     //                                 @"selectedTime" : selectedTime,
     //                                 @"sightingType" : self.txtSighting.text,
     //                                 @"vehicleMake" : self.txtMake.text,
     //                                 @"vehicleModel" : self.txtModel.text,
     //                                 @"vehicleColour" : self.txtColor.text,
     //                                 @"noPhotos" : [NSString stringWithFormat:@"%d", filesCount],
     //                                 @"registrationNumber" : self.txtRegistrationNo.text,
     //                                 @"comments" : self.txtComments.text,
     //                                 @"os" : OS_VERSION,
     //                                 @"make" : MAKE,
     //                                 @"model" : [DeviceInfo platformNiceString]};
     */

    
    
    //sending data with multiple image to server in ios8
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSString *url = [NSString stringWithFormat:@"%@reportSighting.php", SERVERNAME];
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldPin"];
    NSString *regno = [_txtRegistrationNo.text uppercaseString];
    NSLog(@"reg no : %@",regno);

    
    NSArray *keys = [[NSArray alloc]initWithObjects:@"userId", @"pin" ,@"originalLatitude",@"originalLongitude",@"selectedLatitude",@"selectedLongitude",@"location",@"originalDate",@"originalTime",@"selectedDate",@"selectedTime",@"sightingType",@"vehicleMake",@"vehicleModel",@"vehicleColour",@"noPhotos",@"registrationNumber",@"comments",@"os",@"make",@"model", nil];
    
    NSArray *values =[[NSArray alloc]initWithObjects:UserID,pin,originalLatitude,originalLongitude ,selectedLatitude,selectedLongitude,address,originalDate,originalTime,selectedDate,selectedTime,self.txtSighting.text,self.txtMake.text,self.txtModel.text,self.txtColor.text,[NSString stringWithFormat:@"%d", filesCount],regno,self.txtComments.text,OS_VERSION,MAKE,[DeviceInfo platformNiceString], nil];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSURL *baseUrl = [NSURL URLWithString:url];
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setURL:baseUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *tempPostData = [NSMutableData data];
    [tempPostData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    for(int i=0;i<keys.count;i++){
        NSString *str = values[i];
        NSString *key =keys[i];
        NSLog(@"Key Value pair: %@-%@",key,str);
        [tempPostData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [tempPostData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        // [tempPostData appendData:[@"\r\n--%@\r\n",boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [tempPostData appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    //semd multiple images to server
    for (int i = 0; i < filesCount; i++) {
        
        [tempPostData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (i == 0)
        {
            [tempPostData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image1\"; filename=\"%@\"\r\n", filelist[0]] dataUsingEncoding:NSUTF8StringEncoding]];
            [tempPostData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [tempPostData appendData:imageData1];
            [tempPostData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        else if (i == 1)
        {
            [tempPostData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image2\"; filename=\"%@\"\r\n", filelist[1]] dataUsingEncoding:NSUTF8StringEncoding]];
             [tempPostData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [tempPostData appendData:imageData2];
            [tempPostData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [tempPostData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image3\"; filename=\"%@\"\r\n", filelist[2]] dataUsingEncoding:NSUTF8StringEncoding]];
             [tempPostData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [tempPostData appendData:imageData3];
            [tempPostData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //        [tempPostData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //        [tempPostData appendData:imgData];
        
    }

    
    
    
    [tempPostData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:tempPostData];
    _receivedData = [NSMutableData dataWithCapacity: 0];
    
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( theConnection )
    {
        
        NSLog(@"request uploading successful");
        
        
    }
    else
    {
        _receivedData = nil;
        NSLog(@"theConnection is NULL");
    }
    
    
    //[picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark nsurlconnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    [_receivedData setLength:0];
    NSLog(@"responsse : %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [_receivedData appendData:data];
    NSLog(@"receive data : %@",_receivedData);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data",[self.receivedData length]);
    // NSString *strr = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"data is: %@",self.receivedData);
    
    //NSDictionary *dict = [[NSDictionary alloc] initwithd]
    
    
    // convert to JSON
    
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: _receivedData options:NSJSONReadingMutableContainers error:&e];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableLeaves error:nil];
    //  NSLog(@"data -- %@",[dict objectForKey:@"data"]);
    NSLog(@"data -- %@",jsonDictionary);
    
    NSString *EntityID = [jsonDictionary valueForKey:@"status"];
    //NSLog(@"message %@",EntityID);
     NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if ([EntityID isEqualToString:@"success"])
    {
         //store image in device
                    if (UserID == NULL || [UserID isEqualToString:@"0"]) {// this is for guest user
                        NSArray *VCS = self.navigationController.viewControllers;
                        for (int i = 0 ; i < VCS.count; i++) {
                            if ([VCS[i] isKindOfClass:[HomePageVC class]]) {
                             //   [self.navigationController popToViewController:VCS[i] animated:YES];
                                [_viewTransparent setHidden:NO];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thank you for your sighting. Sign in and earn Good Samaritan points" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Sign in", nil];
                                alert.tag = 10;
                                [alert show];
                                [SVProgressHUD dismiss];
                                return;
                            }
                        }
        
        
                    }
        
                    NSDictionary *response = (NSDictionary *)[jsonDictionary objectForKey:@"response"][0];
                    samaritan_points = [response objectForKey:@"samaritan_points"];
                    [self addSuccessView];
                    [SVProgressHUD dismiss];
                } else {// this is for registered user
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[jsonDictionary objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [SVProgressHUD dismiss];
                }
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    /*if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Error" message:@"Location service is not enabled.\nGo to \"Settings->Privacy->LocationServices\"\nto enable location services." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
    isLocationEnabled = NO;
    
    //NSLog(@"didFailWithError: %@", error);
    CLLocationCoordinate2D coord = {.latitude = -32.028801, .longitude = 135.0016983};
    MKCoordinateSpan span = {.latitudeDelta = 0.5, .longitudeDelta = 0.5};
    MKCoordinateRegion region = {coord, span};
    [_mapView setRegion:region];
            
    _lblAddress.text = @"5601 SA Australia";
    
    originalLatitude = [NSString stringWithFormat:@"%f", 32.028801];
    originalLongitude = [NSString stringWithFormat:@"%f", 135.0016983];
    selectedLatitude = originalLatitude;
    selectedLongitude = originalLongitude;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            isLocationEnabled = YES;

            address = [[NSMutableString alloc] init];
            
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

            //NSLog(@"%@", originalLatitude);
            
            //if ([originalLatitude isEqualToString:@""] || originalLatitude == NULL) {
                
                CLLocationCoordinate2D coord = {.latitude =  currentLocation.coordinate.latitude, .longitude =  currentLocation.coordinate.longitude};
                MKCoordinateSpan span = {.latitudeDelta =  0.005, .longitudeDelta =  0.005};
                MKCoordinateRegion region = {coord, span};
                
                [self.mapView setRegion:region animated:YES];
                // set original coordinates
                originalLatitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
                originalLongitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
                selectedLatitude = originalLatitude;
                selectedLongitude = originalLongitude;
            //}
            
            _lblAddress.text = address;
            
        } else {
            //NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    // set selected coordinates
    selectedLatitude = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude];
    selectedLongitude = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude];
    
    if (originalLatitude == nil || originalLatitude == NULL) {
        originalLatitude = selectedLatitude;
        originalLongitude = selectedLongitude;
        address = [[NSMutableString alloc] initWithString:@""];
    }
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            address = [[NSMutableString alloc] init];
            
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
            
            if (isLocationEnabled == YES) {
                _lblAddress.text = address;
            }
            
            _lblAddress.text = address;
            
        } else {
            //NSLog(@"%@", error.debugDescription);
        }
    } ];

}

#pragma mark - UITextField delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    activeTextField=textField;
    
    if (textField == self.txtSighting) {
        sightingPicker = [[UIActionSheet alloc] initWithTitle:@"Type of Sighting" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Theft", @"Serious Vandalism", @"Suspicious Activity", /*@"Other",*/ nil];
        sightingPicker.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [sightingPicker showInView:self.view];
        return NO;
    } else if (textField == self.txtDateTime) {
        // Open DatePicker when age textfield is clicked
//        datePickerSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//        
//        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
//        datePicker.backgroundColor = [UIColor whiteColor];
//        datePicker.maximumDate = [NSDate date];
//        
//        // Open selected date when date is previously selected
//        if (datePickerSelectedDate) {
//            [datePicker setDate:datePickerSelectedDate];
//        }
//        
//        //format datePicker mode.
//        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//        
//        // Create toolbar kind of view using UIView for placing Done and cancel button
//        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        toolbarPicker.backgroundColor = [UIColor whiteColor];
//        [toolbarPicker sizeToFit];
//        
//        // create Done button for selecting date from picker
//        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 44)];
//        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
//        [bbitem setTitleColor:bbitem.tintColor forState:UIControlStateNormal];
//        [bbitem addTarget:self action:@selector(dateDoneClicked) forControlEvents:UIControlEventTouchUpInside];
//        
//        // create Cancel button for dismissing datepicker
//        UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
//        [bbitem1 setTitle:@"Cancel" forState:UIControlStateNormal];
//        [bbitem1 setTitleColor:bbitem1.tintColor forState:UIControlStateNormal];
//        [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
//        
//        // add subviews
//        [toolbarPicker addSubview:bbitem];
//        [toolbarPicker addSubview:bbitem1];
//        [datePickerSheet addSubview:toolbarPicker];
//        [datePickerSheet addSubview:toolbarPicker];
//        [datePickerSheet addSubview:datePicker];
//        [datePickerSheet showInView:self.view];
//        [datePickerSheet setBounds:CGRectMake(0,0,320, 464)];
        
        NSDate *date;
        date = [NSDate date];
        
        
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.maximumDate = [NSDate date];
      
        
        
        
        //formate datepicker
        NSDateFormatter  *displayFormatter = [[NSDateFormatter alloc] init];
        [displayFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [displayFormatter setDateFormat:@"MM/dd/yyyy"];
        
        // Create toolbar kind of view using UIView for placing Done and cancel button
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        pickerToolbar.tintColor = [UIColor whiteColor];
        [pickerToolbar sizeToFit];
        
        
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DOBChanged:)];
        
        [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor blackColor],
                                         NSForegroundColorAttributeName,
                                         nil] forState:UIControlStateNormal];
        
        NSArray *itemArray = [[NSArray alloc] initWithObjects: doneBtn, nil];
        
        [pickerToolbar setItems:itemArray animated:YES];
        
        //set backgound view of date picker
        if(IsIphone5)
            timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, 320, 246)];
        else
            timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, 320, 246)];

        [timeBackgroundView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
        
        [timeBackgroundView addSubview:pickerToolbar];
        [timeBackgroundView addSubview:datePicker];
        
        [self.view addSubview:timeBackgroundView];
        return NO;
    } else if(textField == self.txtRegistrationNo) {
        _txtRegistrationNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        if ([DeviceInfo isIphone5]) {
            [self.scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
        }
    } else if(textField == self.txtMake) {
        if ([DeviceInfo isIphone5]) {
            [self.scrollView setContentOffset:CGPointMake(0, 68) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 170) animated:YES];
        }
    } else if(textField == self.txtModel || textField == self.txtColor) {
        if ([DeviceInfo isIphone5]) {
            [self.scrollView setContentOffset:CGPointMake(0, 116) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 208) animated:YES];
        }
    } else if (textField == self.txtComments) {
        if ([DeviceInfo isIphone5]) {
            [self.scrollView setContentOffset:CGPointMake(0, 154) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 248) animated:YES];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtRegistrationNo) {
        [self.txtMake becomeFirstResponder];
    } else if(textField == self.txtMake) {
        [self.txtModel becomeFirstResponder];
    }  else if(textField == self.txtModel) {
        [self.txtColor becomeFirstResponder];
    } else if (textField == self.txtColor) {
        [self.txtComments becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, -20) animated:YES];
        return YES;
    }
    return NO;
}

#pragma mark - UIImagePicker Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // comprese image
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    // save image locally
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    
    // For image 1
    NSString *savedImagePath1 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"1.png"]];
    BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath1];
    if (!fileExists1) {
        imageData1 = UIImageJPEGRepresentation(chosenImage, compression);
        
        while ([imageData1 length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData1 = UIImageJPEGRepresentation(chosenImage, compression);
        }

      imageData1 = UIImagePNGRepresentation(chosenImage);
        [imageData1 writeToFile:savedImagePath1 atomically:NO];
        
        [self loadImages];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    // For image 2
    NSString *savedImagePath2 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"2.png"]];
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath2];
    if (!fileExists2) {
        imageData2 = UIImageJPEGRepresentation(chosenImage, compression);
        
        while ([imageData2 length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData2 = UIImageJPEGRepresentation(chosenImage, compression);
        }

        
       imageData2 = UIImagePNGRepresentation(chosenImage);
        [imageData2 writeToFile:savedImagePath2 atomically:NO];
        
        [self loadImages];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    // For image 3
    NSString *savedImagePath3 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"3.png"]];
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath3];
    if (!fileExists3) {
        imageData3 = UIImageJPEGRepresentation(chosenImage, compression);
        
        while ([imageData3 length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData3 = UIImageJPEGRepresentation(chosenImage, compression);
        }

        imageData3 = UIImagePNGRepresentation(chosenImage);
        [imageData3 writeToFile:savedImagePath3 atomically:NO];
        
        [self loadImages];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheet done/cancel buttons

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == sightingPicker) {
        if (buttonIndex == 3) {
            // return when cancel is clicked
            return;
        }
        NSString *title = [sightingPicker buttonTitleAtIndex:buttonIndex];
        self.txtSighting.text = title;
    } else if (actionSheet == imagePickerSheet) {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        } else if (buttonIndex == 1) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}

-(void)cancelClicked {
    [timeBackgroundView setHidden:YES];
}

-(void)dateDoneClicked {
    
    /*
     Function for selecting date & time from datePicker.
     */
    
    //format date
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [NSLocale currentLocale]];
    
    //set date format
    [FormatDate setDateFormat:@"E,MMMM dd,yyyy, HH:mm aaa"];
    
    self.txtDateTime.text = [FormatDate stringFromDate:[datePicker date]];
    
    // set selected date & time
    selectedDate = [dateFormat stringFromDate:[datePicker date]];
    selectedTime = [timeFormat stringFromDate:[datePicker date]];
    
    datePicker.frame=CGRectMake(0, 44, 320, 416);
    [self cancelClicked];
}

- (IBAction)addImage:(id)sender {
    imagePickerSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    imagePickerSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [imagePickerSheet showInView:self.view];
}

-(void)createGalleryFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/gallery"];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
}

-(void)loadImages {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    
    // For image 1
    NSString *savedImagePath1 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"1.png"]]; 
    BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath1];
    if (fileExists1) {
        // unhide image1
        self.imageView1.hidden = NO;
        self.imageView1.image = [UIImage imageWithContentsOfFile:savedImagePath1];
    }
    
    // For image 2
    NSString *savedImagePath2 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"2.png"]];
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath2];
    if (fileExists2) {
        // unhide image2
        self.imageView2.hidden = NO;
        self.imageView2.image = [UIImage imageWithContentsOfFile:savedImagePath2];
    }
    
    // For image 3
    NSString *savedImagePath3 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"3.png"]];
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath3];
    if (fileExists3) {
        // unhide image3
        self.imageview3.hidden = NO;
        self.imageview3.image = [UIImage imageWithContentsOfFile:savedImagePath3];
        
        // hide add image button
        self.btnAddImage.hidden = YES;
    }
}

-(void)addSuccessView {
    
    // view for success
    [_viewTransparent setHidden:NO];
    [_toolBar setHidden:YES];
    [activeTextField resignFirstResponder]; 
    UIView *viewSuccess = [[UIView alloc] initWithFrame:CGRectZero];
    viewSuccess.backgroundColor = [UIColor whiteColor];
    viewSuccess.layer.cornerRadius = 5;
    viewSuccess.clipsToBounds = YES;
    viewSuccess.frame = CGRectMake(20, 600, 280, 368);
    
    // UIImageView for +50 points
    UIImageView *ivPoints = [[UIImageView alloc] init];
    ivPoints.image = [UIImage imageNamed:@"points_bg_ios.png"];
    ivPoints.frame = CGRectMake(50, 0, 180, 180);
    [viewSuccess addSubview:ivPoints];
    
    // UILabel for Good Jpb text
    UILabel *lblGood = [[UILabel alloc] init];
    lblGood.frame = CGRectMake(0, 200, 280, 25);
    lblGood.text = @"Good Job!";
    lblGood.textAlignment = NSTextAlignmentCenter;
    lblGood.textColor = [UIColor grayColor];
    lblGood.font = [UIFont fontWithName:@"HelveticaNeue" size:27];
    [viewSuccess addSubview:lblGood];
    
    //UILabel for 50 points
    UILabel *lblPoints = [[UILabel alloc] init];
    lblPoints.frame = CGRectMake(0, lblGood.frame.origin.y + lblGood.frame.size.height + 5, 280, 35);
    lblPoints.text = @"You earned yourself 50 Good\nSamaritan points!";
    lblPoints.numberOfLines = 0;
    lblPoints.textAlignment = NSTextAlignmentCenter;
    lblPoints.textColor = [UIColor grayColor];
    lblPoints.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    [viewSuccess addSubview:lblPoints];
    
    // UILabel for Total Points text
    UILabel *lblTotalPoints = [[UILabel alloc] init];
    lblTotalPoints.frame = CGRectMake(0, lblPoints.frame.origin.y + lblPoints.frame.size.height + 5, 280, 18);
    lblTotalPoints.text =  [NSString stringWithFormat:@"Total Samaritan Points: %@", samaritan_points];
    lblTotalPoints.textAlignment = NSTextAlignmentCenter;
    lblTotalPoints.textColor = [UIColor blackColor];
    lblTotalPoints.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [viewSuccess addSubview:lblTotalPoints];
    
    //UIImageView for divider
    UIImageView *ivDivider = [[UIImageView alloc] init];
    ivDivider.frame = CGRectMake(0, lblTotalPoints.frame.origin.y + lblTotalPoints.frame.size.height + 20, 280, 0.5);
    ivDivider.backgroundColor = [UIColor lightGrayColor];
    [viewSuccess addSubview:ivDivider];
    
    //UIButton for Close
    UIButton *btnClose = [[UIButton alloc] init];
    btnClose.frame = CGRectMake(0, ivDivider.frame.origin.y + ivDivider.frame.size.height + 1, 140, 60);
    [btnClose setTitle:@"Close" forState:UIControlStateNormal];
    [btnClose setTitleColor:btnClose.tintColor forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewSuccess addSubview:btnClose];
    
    //UIImageView for divider2
    UIImageView *ivDivider2 = [[UIImageView alloc] init];
    ivDivider2.frame = CGRectMake(140, ivDivider.frame.origin.y + ivDivider.frame.size.height, 0.5, 60);
    ivDivider2.backgroundColor = [UIColor lightGrayColor];
    [viewSuccess addSubview:ivDivider2];
    
    //UIButton for View Profile
    UIButton *btnProfile = [[UIButton alloc] init];
    btnProfile.frame = CGRectMake(141, ivDivider.frame.origin.y + ivDivider.frame.size.height + 1, 140, 60);
    [btnProfile setTitle:@"View Profile" forState:UIControlStateNormal];
    [btnProfile setTitleColor:btnClose.tintColor forState:UIControlStateNormal];
    [btnProfile addTarget:self action:@selector(openProfile) forControlEvents:UIControlEventTouchUpInside];
    [viewSuccess addSubview:btnProfile];
    
    [self.view.superview insertSubview:viewSuccess aboveSubview:bgToolBar];
    
    // Animate Success View
    [UIView animateWithDuration:0.7f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([DeviceInfo isIphone5]) {
            viewSuccess.frame = CGRectMake(20, 100, 280, 368);
        } else {
            viewSuccess.frame = CGRectMake(20, 55, 280, 368);
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)deleteAllimageFiles {
    // Delete all user's body picks from gallery folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:@"gallery/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

-(void)openProfile {
    // Code for open profile page
    UserProfileVC *vc = [[UserProfileVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)previousClicked:(id)sender {
    NSInteger nextTag = activeTextField.tag-1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
}

- (IBAction)nextClicked:(id)sender {
    NSInteger nextTag = activeTextField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
}

- (IBAction)doneClicked:(id)sender {
    [activeTextField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, -20) animated:YES];
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10)
    {
        [_viewTransparent setHidden:YES];
        if(buttonIndex == 0)
        {
            HomePageVC *vc = [[HomePageVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            LoginVC *vc = [[LoginVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
