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
    UIToolbar *bgToolBar;
    UIActivityIndicatorView *activityIndicator;
    
    BOOL isLocationEnabled;
}
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
    
    // set background color or btnLetsGo
    self.btnLetsGo.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
    
    [_viewLocationGuide setHidden:YES];
    //Initialize CLLocationManager
    _locationManager = [[CLLocationManager alloc] init];
    
    // Initialize CLGeocoder
    geocoder = [[CLGeocoder alloc] init];
    
    _locationManager.delegate = self; // Set delegate
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set accuracy
    
    [_locationManager startUpdatingLocation]; // start updating for current location
    //get current location
    NSString *latitude=[NSString stringWithFormat:@"%f", _locationManager.location.coordinate.latitude];
   
    NSLog(@"current location : %@",latitude);
    
    if([latitude isEqualToString:@"0.000000"])
    {
        [_viewLocationGuide setHidden:NO];
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
            }
        }];
    }

    // set contentSize of scrollview here
    [self.scrollView setContentSize:CGSizeMake(0, 470)];
    
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
        } else if ([vehicleType[0] isEqualToString:@"Car"]) {
            self.imgVehicle.image = [UIImage imageNamed:@"ic_car.png"];
        } else if ([vehicleType[0] isEqualToString:@"Motor Cycle"]) {
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
    
    NSLog(@"didFailWithError: %@", error);
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
    /*CLLocation *currentLocation = newLocation;
    
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
            NSLog(@"%@", error.debugDescription);
        }
    } ];*/
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
            NSLog(@"%@", error.debugDescription);
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
    // Open DatePicker when age textfield is clicked
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
    [sheet setBounds:CGRectMake( 0, 0, 320, 450)];
}

#pragma mark - UIActionSheet done/cancel buttons
-(IBAction)btnGot_click:(id)sender
{
    [_viewLocationGuide setHidden:YES];
}
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
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
    [datePickerSheet dismissWithClickedButtonIndex:0 animated:YES];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Select type of report" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // get the count of files in gallery folder
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"/fileNewReport"];
    NSArray *filelist= [fm contentsOfDirectoryAtPath:dataPath error:nil];
    //NSLog(@"%lu", (unsigned long)filelist.count);
    int filesCount = (int)[filelist count];
    
    // get current date & time
    NSDate *currentDate = [NSDate date];
    
    // set original date & time
    originalDate = [dateFormat stringFromDate:currentDate];
    originalTime = [timeFormat stringFromDate:currentDate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    
    NSDictionary *parameters = @{@"userId" : UserID,
                                 @"vehicleId" : vehicleID[selectedNumber],
                                 @"pin" : pin,
                                 @"originalLatitude": originalLatitude,
                                 @"originalLongitude" : originalLongitude,
                                 @"selectedLatitude" : selectedLatitude,
                                 @"selectedLongitude" : selectedLongitude,
                                 @"location" : address,
                                 @"originalDate" : originalDate,
                                 @"originalTime" : originalTime,
                                 @"selectedDate" : selectedDate,
                                 @"selectedTime" : selectedTime,
                                 @"reportType" : self.txtSighting.text,
                                 @"noPhotos" : [NSString stringWithFormat:@"%d", filesCount],
                                 @"comments" : self.txtComments.text,
                                 @"os" : OS_VERSION,
                                 @"make" : MAKE,
                                 @"model" : [DeviceInfo platformNiceString]};
    
    NSLog(@"%@", parameters);
    
    // Start Animating activityIndicator
    [activityIndicator startAnimating];
    
    // add bgToolbar to view
    [self.view.superview insertSubview:bgToolBar aboveSubview:self.view];
    
    NSString *url = [NSString stringWithFormat:@"%@fileNewReport.php", SERVERNAME];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < filesCount; i++) {
            NSString *imgName = [NSString stringWithFormat:@"image%d", (int)(i + 1)];
            NSData *imgData = [[NSData alloc] initWithContentsOfFile:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", filelist[i]]]];
            [formData appendPartWithFileData:imgData name:imgName fileName:filelist[i] mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        // Stop Animating activityIndicator
        [activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        //NSLog(@"%@", json);
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSDictionary *response = (NSDictionary *)[json objectForKey:@"response"][0];
            NSString *photo1 = [response objectForKey:@"photo1"];
            //NSString *photo2 = [response objectForKey:@"photo2"];
            //NSString *photo3 = [response objectForKey:@"photo3"];
            
            ShareNewReportViewController *vc = [[ShareNewReportViewController alloc] init];
            vc.photo1 = photo1;
            vc.vehicleId = vehicleID[selectedNumber];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [DeviceInfo errorInConnection];
        [activityIndicator stopAnimating];
        [bgToolBar removeFromSuperview];
    }];
}

#pragma mark - UITableView Delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vehicleMake.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    UIButton *tmp = [[UIButton alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", vehicleMake[indexPath.row], vehicleModel[indexPath.row]];
    cell.textLabel.textColor = tmp.tintColor;
    cell.textLabel.font = [UIFont systemFontOfSize:22.0];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Registration Number : %@", vehicleRegistrationNumber[indexPath.row]];
    
    // set Image here
    if ([vehicleType[indexPath.row] isEqualToString:@"Bicycle"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_cycle.png"];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Car"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Motor Cycle"]) {
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
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Car"]) {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([vehicleType[indexPath.row] isEqualToString:@"Motor Cycle"]) {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        self.imgVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    
    // Set selectedNumber as indexPath.row
    selectedNumber = indexPath.row;
    
    [self cancelClicked];
}

#pragma mark - UIImagePicker Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    // save image locally
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/fileNewReport"];
    
    // For image 1
    NSString *savedImagePath1 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"1.png"]];
    BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath1];
    if (!fileExists1) {
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        [imageData writeToFile:savedImagePath1 atomically:NO];
        
        [self loadImages];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    // For image 2
    NSString *savedImagePath2 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"2.png"]];
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath2];
    if (!fileExists2) {
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        [imageData writeToFile:savedImagePath2 atomically:NO];
        
        [self loadImages];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    // For image 3
    NSString *savedImagePath3 = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"3.png"]];
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:savedImagePath3];
    if (!fileExists3) {
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        [imageData writeToFile:savedImagePath3 atomically:NO];
        
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
        sightingPicker = [[UIActionSheet alloc] initWithTitle:@"Type of report" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Theft", @"Vandalism"/*, @"Stolen /Abandoned Vehicle?"*/, nil];
        sightingPicker.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [sightingPicker showInView:self.view];
        return NO;
    } else if (textField == self.txtDateTime) {
        // Open DatePicker when age textfield is clicked
        datePickerSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        datePicker.backgroundColor = [UIColor whiteColor];
        
        // Open selected date when date is previously selected
        if (datePickerSelectedDate) {
            [datePicker setDate:datePickerSelectedDate];
        }
        
        //format datePicker mode.
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        // Create toolbar kind of view using UIView for placing Done and cancel button
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor whiteColor];
        [toolbarPicker sizeToFit];
        
        // create Done button for selecting date from picker
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem setTitleColor:bbitem.tintColor forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(dateDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // create Cancel button for dismissing datepicker
        UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        [bbitem1 setTitle:@"Cancel" forState:UIControlStateNormal];
        [bbitem1 setTitleColor:bbitem1.tintColor forState:UIControlStateNormal];
        [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // add subviews
        [toolbarPicker addSubview:bbitem];
        [toolbarPicker addSubview:bbitem1];
        [datePickerSheet addSubview:toolbarPicker];
        [datePickerSheet addSubview:toolbarPicker];
        [datePickerSheet addSubview:datePicker];
        [datePickerSheet showInView:self.view];
        [datePickerSheet setBounds:CGRectMake(0,0,320, 464)];
        return NO;
    } else if (textField == self.txtComments) {
        if ([DeviceInfo isIphone5]) {
            [self.scrollView setContentOffset:CGPointMake(0, 110) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 195) animated:YES];
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

@end
