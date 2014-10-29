//
//  FileNewReportViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 05/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "FileNewReportViewController.h"
#import "UserProfileVC.h"
#import "AFNetworking.h"
#import "ShareNewReportViewController.h"
#import "Reachability.h"
#import "UIColor+Extra.h"
#import "SVProgressHUD.h"

@interface FileNewReportViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *originalLatitude, *originalLongitude, *selectedLatitude, *selectedLongitude, *originalDate, *originalTime, *selectedDate, *selectedTime, *samaritan_points;
    NSMutableString *address;
    UIActionSheet *sheet, *imagePickerSheet, *sightingPicker, *datePickerSheet;
    UIDatePicker *datePicker;
    NSMutableArray *vehicleID, *vehicleMake, *vehicleModel, *vehicleType, *vehicleRegistrationNumber;
    NSInteger selectedNumber;
    NSDate *datePickerSelectedDate;
    NSDateFormatter *dateFormat, *timeFormat;
    UIToolbar *bgToolBar, *bgToolBar1;
    UIActivityIndicatorView *activityIndicator;
    UIView *timeBackgroundView;
    BOOL isLocationEnabled;
    NSData *imageData1,*imageData2,*imageData3;
}
#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FileNewReportViewController

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
    
    // set background color or btnLetsGo
    self.btnLetsGo.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
    
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
   
    ////NSLog(@"current location : %@",latitude);
    
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
    
    // initialize dateFormat & timeFormat
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    [self createFileNewReportFolder];
    
    // Add UIToolBar to view with alpha 0.7 for transparency
    bgToolBar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolBar.barStyle = UIBarStyleBlack;
    bgToolBar.alpha = 0.7;
    bgToolBar.translucent = YES;
    
    // Add UIToolBar to view with alpha 0.7 for transparency
    bgToolBar1 = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolBar1.barStyle = UIBarStyleBlack;
    bgToolBar1.alpha = 0.7;
    bgToolBar1.translucent = YES;
    
    // initialize activityIndicator and add it to UIToolBar.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [bgToolBar addSubview:activityIndicator];
    
    //add tap gesture for lblVehicleName
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectVehicles:)];
    [self.lblVehicleName addGestureRecognizer:tapGesture];
    
    NSArray *vehicles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"vehicles"];
    if (vehicles.count == 0) {
        self.vwNoVehicle.hidden = NO;
        self.vwFileReport.hidden = YES;
        
        self.navItem.rightBarButtonItem = nil;
        
    } else {
        self.vwNoVehicle.hidden = YES;
        self.vwFileReport.hidden = NO;
        
        // Initialize all NSMutableArray
        vehicleID = [[NSMutableArray alloc] init];
        vehicleMake = [[NSMutableArray alloc] init];
        vehicleModel = [[NSMutableArray alloc] init];
        vehicleType = [[NSMutableArray alloc] init];
        vehicleRegistrationNumber = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < vehicles.count; i++) {
            NSDictionary *vehicleDic = vehicles[i];
            [vehicleID addObject:[vehicleDic objectForKey:@"vehicle_id"]];
            [vehicleMake addObject:[vehicleDic objectForKey:@"vehicle_make"]];
            [vehicleModel addObject:[vehicleDic objectForKey:@"vehicle_model"]];
            [vehicleType addObject:[vehicleDic objectForKey:@"vehicle_type"]];
            [vehicleRegistrationNumber addObject:[vehicleDic objectForKey:@"registration_serial_no"]];
        }
        
        // set selectedNumber as 0 for initial value
        selectedNumber = 0;
        
        //Set initial value
        self.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@", vehicleMake[0], vehicleModel[0]];
        self.lblRegistrationNumber.text = [NSString stringWithFormat:@"Registration Number : %@", vehicleRegistrationNumber[0]];
        
        // set Image here
        if ([vehicleType[0] isEqualToString:@"Bicycle"]) {
            self.imgVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
            self.lblRegistrationNumber.text = [NSString stringWithFormat:@"Serial Number : %@", vehicleRegistrationNumber[0]];
        } else if ([vehicleType[0] isEqualToString:@"Car"]) {
            self.imgVehicle.image = [UIImage imageNamed:@"ic_car.png"];
        } else if ([vehicleType[0] isEqualToString:@"Motorcycle"]) {
            self.imgVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
        } else {
            self.imgVehicle.image = [UIImage imageNamed:@"ic_other.png"];
        }
        
        // set current date & time in textbox here
        NSDate *date = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"E,MMMM dd,yyyy, HH:mm aaa"];
        
        self.txtDateTime.text = [format stringFromDate:date];
        
        // set selected date & time
        selectedDate = [dateFormat stringFromDate:date];
        selectedTime = [timeFormat stringFromDate:date];
    }
    
    // setLocationEnabled as NO
    isLocationEnabled = NO;
    
    [self deleteAllimageFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    //[self deleteAllimageFiles];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openProfile:(id)sender {
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    ////NSLog(@"didFailWithError: %@", error);
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
            ////NSLog(@"%@", error.debugDescription);
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
            ////NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

-(void)createFileNewReportFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/fileNewReport"];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
}

- (IBAction)selectVehicles:(id)sender {
    
    if (vehicleModel.count == 1) {
        return;
    }
    
    // add bgToolbar to view
    [self.view.superview insertSubview:bgToolBar1 aboveSubview:self.view];
    
    CGRect frame1 = self.viewselectVehicle.frame;
    frame1.origin.x = 30;
    frame1.origin.y = 95;
    self.viewselectVehicle.frame = frame1;
    [bgToolBar1 addSubview:self.viewselectVehicle];
    
    /*// Open DatePicker when age textfield is clicked
    sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Create toolbar kind of view using UIView for placing Done and cancel button
    UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbarPicker.backgroundColor = [UIColor whiteColor];
    [toolbarPicker sizeToFit];
    
    // create Cancel button for dismissing datepicker
    UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 60, 44)];
    [bbitem1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [bbitem1 setTitleColor:bbitem1.tintColor forState:UIControlStateNormal];
    [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbarPicker addSubview:bbitem1];
    [sheet addSubview:toolbarPicker];
    
    [sheet addSubview:_tableView];
    [sheet showInView:self.view];
    [sheet setBounds:CGRectMake( 0, 0, 320, 450)];*/
}

#pragma mark - UIActionSheet done/cancel buttons
-(IBAction)btnGot_click:(id)sender
{
    [_viewLocationGuide setHidden:YES];
    [_viewTransparent setHidden:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == sightingPicker) {
        if (buttonIndex == 2) {
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

- (IBAction)addImages:(id)sender {
    imagePickerSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    imagePickerSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [imagePickerSheet showInView:self.view];
}

- (IBAction)sendClicked:(id)sender {
    // code for web service call
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [DeviceInfo errorInConnection];
        return;
    }
    
    // Check Type of Sighting
    if ([DeviceInfo trimString:self.txtSighting.text].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Select type of Report" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // get the count of files in gallery folder
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"/fileNewReport"];
    NSArray *filelist= [fm contentsOfDirectoryAtPath:dataPath error:nil];
    ////NSLog(@"%lu", (unsigned long)filelist.count);
    int filesCount = (int)[filelist count];
    
    // get current date & time
    NSDate *currentDate = [NSDate date];
    
    // set original date & time
    originalDate = [dateFormat stringFromDate:currentDate];
    originalTime = [timeFormat stringFromDate:currentDate];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
//    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
//    
//    NSDictionary *parameters = @{@"userId" : UserID,
//                                 @"vehicleId" : vehicleID[selectedNumber],
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
//                                 @"reportType" : self.txtSighting.text,
//                                 @"noPhotos" : [NSString stringWithFormat:@"%d", filesCount],
//                                 @"comments" : self.txtComments.text,
//                                 @"os" : OS_VERSION,
//                                 @"make" : MAKE,
//                                 @"model" : [DeviceInfo platformNiceString]};
//    
//    ////NSLog(@"%@", parameters);
//    
//    // Start Animating activityIndicator
//    [activityIndicator startAnimating];
//    
//    // add bgToolbar to view
//    [self.view.superview insertSubview:bgToolBar aboveSubview:self.view];
//    
//    NSString *url = [NSString stringWithFormat:@"%@fileNewReport.php", SERVERNAME];
//    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        for (int i = 0; i < filesCount; i++) {
//            NSString *imgName = [NSString stringWithFormat:@"image%d", (int)(i + 1)];
//            NSData *imgData = [[NSData alloc] initWithContentsOfFile:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", filelist[i]]]];
//            [formData appendPartWithFileData:imgData name:imgName fileName:filelist[i] mimeType:@"image/png"];
//        }
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        ////NSLog(@"%@", responseObject);
//        
//        // Stop Animating activityIndicator
//        [activityIndicator stopAnimating];
//        
//        NSDictionary *json = (NSDictionary *)responseObject;
//        ////NSLog(@"%@", json);
//        
//        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
//            NSDictionary *response = (NSDictionary *)[json objectForKey:@"response"][0];
//            NSString *photo1 = [response objectForKey:@"photo1"];
//            //NSString *photo2 = [response objectForKey:@"photo2"];
//            //NSString *photo3 = [response objectForKey:@"photo3"];
//            
//            ShareNewReportViewController *vc = [[ShareNewReportViewController alloc] init];
//            vc.photo1 = photo1;
//            vc.vehicleId = vehicleID[selectedNumber];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        ////NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//        [DeviceInfo errorInConnection];
//        [activityIndicator stopAnimating];
//        [bgToolBar removeFromSuperview];
//    }];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSString *url = [NSString stringWithFormat:@"%@fileNewReport.php", SERVERNAME];
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldPin"];
  //  NSDictionary *parameters = @{@"userId" : UserID,
                                 //                                 @"vehicleId" : vehicleID[selectedNumber],
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
                                 //                                 @"reportType" : self.txtSighting.text,
                                 //                                 @"noPhotos" : [NSString stringWithFormat:@"%d", filesCount],
                                 //                                 @"comments" : self.txtComments.text,
                                 //                                 @"os" : OS_VERSION,
                                 //                                 @"make" : MAKE,
                                 //                                 @"model" : [DeviceInfo platformNiceString]};
    
    NSArray *keys = [[NSArray alloc]initWithObjects:@"userId",@"vehicleId",@"pin", @"originalLatitude",@"originalLongitude",@"selectedLatitude",@"selectedLongitude",@"location",@"originalDate",@"originalTime",@"selectedDate",@"selectedTime",@"reportType",@"noPhotos",@"comments",@"os", @"make",@"model", nil];
    
    NSArray *values =[[NSArray alloc]initWithObjects:UserID,vehicleID[selectedNumber],pin,originalLatitude,originalLongitude,selectedLatitude,selectedLongitude,address,originalDate,originalTime,selectedDate,selectedTime,self.txtSighting.text,[NSString stringWithFormat:@"%d", filesCount],self.txtComments.text,OS_VERSION,MAKE, [DeviceInfo platformNiceString], nil];
    
    
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
   
    if ([EntityID isEqualToString:@"success"])
    {
        NSDictionary *response = (NSDictionary *)[jsonDictionary objectForKey:@"response"][0];
                    NSString *photo1 = [response objectForKey:@"photo1"];
//                    NSString *photo2 = [response objectForKey:@"photo2"];
//                    NSString *photo3 = [response objectForKey:@"photo3"];
        
                    ShareNewReportViewController *vc = [[ShareNewReportViewController alloc] init];
                    vc.photo1 = photo1;
                    vc.vehicleId = vehicleID[selectedNumber];
                    [self.navigationController pushViewController:vc animated:YES];
        [SVProgressHUD dismiss];
        
    }
    else
    {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[jsonDictionary objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
        [SVProgressHUD dismiss];
    }
   
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    }
}



#pragma mark - UITableView Delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vehicleMake.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIButton *tmp = [[UIButton alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", vehicleMake[indexPath.row], vehicleModel[indexPath.row]];
    cell.textLabel.textColor = tmp.tintColor;
    cell.textLabel.font = [UIFont systemFontOfSize:22.0];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Registration Number : %@", vehicleRegistrationNumber[indexPath.row]];
    
    // set Image here
    if ([vehicleType[indexPath.row] isEqualToString:@"Bicycle"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_cycle.png"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Serial Number : %@", vehicleRegistrationNumber[indexPath.row]];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Car"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Motorcycle"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"ic_other.png"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change the values in view with selected vehicle.
    self.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@", vehicleMake[indexPath.row], vehicleModel[indexPath.row]];
    self.lblRegistrationNumber.text = [NSString stringWithFormat:@"Registration Number : %@", vehicleRegistrationNumber[indexPath.row]];
    
    // set Image here
    if ([vehicleType[indexPath.row] isEqualToString:@"Bicycle"]) {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
        self.lblRegistrationNumber.text = [NSString stringWithFormat:@"Serial Number : %@", vehicleRegistrationNumber[indexPath.row]];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Car"]) {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Motorcycle"]) {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    
    // Set selectedNumber as indexPath.row
    selectedNumber = indexPath.row;
    
    [self cancelClicked];
    [self btnCancelClicked:nil];
}

#pragma mark - UIImagePicker Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // comprese image
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    // save image locally
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/fileNewReport"];
    
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

-(void)loadImages {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/fileNewReport"];
    
    // For image 1
    NSString *savedImagePath1 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"1.png"]];
    BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath1];
    if (fileExists1) {
        // unhide image1
        self.image1.hidden = NO;
        self.image1.image = [UIImage imageWithContentsOfFile:savedImagePath1];
    }
    
    // For image 2
    NSString *savedImagePath2 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"2.png"]];
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath2];
    if (fileExists2) {
        // unhide image2
        self.image2.hidden = NO;
        self.image2.image = [UIImage imageWithContentsOfFile:savedImagePath2];
    }
    
    // For image 3
    NSString *savedImagePath3 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"3.png"]];
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath3];
    if (fileExists3) {
        // unhide image3
        self.image3.hidden = NO;
        self.image3.image = [UIImage imageWithContentsOfFile:savedImagePath3];
        
        // hide add image button
        self.btnAddImage.hidden = YES;
    }
}

#pragma mark - UITextField delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtSighting) {
        sightingPicker = [[UIActionSheet alloc] initWithTitle:@"Type of report" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Theft", @"Serious Vandalism"/*, @"Stolen /Abandoned Vehicle?"*/, nil];
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

        //date picker for ios8
        NSDate *date;
        date = [NSDate date];
        
        
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.maximumDate = [NSDate date];
        
        //format datePicker mode.
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        
        
        //formate datepicker
        NSDateFormatter  *displayFormatter = [[NSDateFormatter alloc] init];
        [displayFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [displayFormatter setDateFormat:@"MM/dd/yyyy"];
        
        // Create toolbar kind of view using UIView for placing Done and cancel button
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        pickerToolbar.tintColor = [UIColor whiteColor];
        [pickerToolbar sizeToFit];
        
        
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dateDoneClicked)];
        
        [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor blackColor],
                                         NSForegroundColorAttributeName,
                                         nil] forState:UIControlStateNormal];
        
        NSArray *itemArray = [[NSArray alloc] initWithObjects: doneBtn, nil];
        
        [pickerToolbar setItems:itemArray animated:YES];
        
        //set backgound view of date picker
      //  timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, 320, 246)];
       if(IsIphone5)
            timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, 320, 246)];
        else
            timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, 320, 246)];
        [timeBackgroundView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
        
        [timeBackgroundView addSubview:pickerToolbar];
        [timeBackgroundView addSubview:datePicker];
        
        [self.view addSubview:timeBackgroundView];
        

        
        return NO;
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
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)deleteAllimageFiles {
    // Delete all user's body picks from gallery folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:@"fileNewReport/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            // it failed.
            [activityIndicator stopAnimating];
        }
    }
}

- (IBAction)btnCancelClicked:(id)sender {
    [bgToolBar1 removeFromSuperview];
}
@end
