//
//  FileNewReportViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 05/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "FileNewReportViewController.h"
#import "UserProfileVC.h"

@interface FileNewReportViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *originalLatitude, *originalLongitude, *selectedLatitude, *selectedLongitude, *originalDate, *originalTime, *selectedDate, *selectedTime, *samaritan_points;
    NSMutableString *address;
    UIActionSheet *sheet;
    NSMutableArray *vehicleID, *vehicleMake, *vehicleModel, *vehicleType, *vehicleRegistrationNumber;
    NSInteger selectedNumber;
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
    
    //Initialize CLLocationManager
    _locationManager = [[CLLocationManager alloc] init];
    
    // Initialize CLGeocoder
    geocoder = [[CLGeocoder alloc] init];
    
    _locationManager.delegate = self; // Set delegate
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set accuracy
    
    [_locationManager startUpdatingLocation]; // start updating for current location
    
    // set contentSize of scrollview here
    [self.scrollView setContentSize:CGSizeMake(0, 450)];
    
    [self createFileNewReportFolder];
    
    NSArray *vehicles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"vehicles"];
    if (vehicles.count == 0) {
        self.vwNoVehicle.hidden = NO;
        self.vwFileReport.hidden = YES;
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
            //[vehicleName addObject:[NSString stringWithFormat:@"%@ %@", [vehicleDic objectForKey:@"vehicle_make"], [vehicleDic objectForKey:@"vehicle_model"]]];
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
    }
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
    NSLog(@"didFailWithError: %@", error);
    CLLocationCoordinate2D coord = {.latitude = 37.423617, .longitude = -122.220154};
    MKCoordinateSpan span = {.latitudeDelta = 0.005, .longitudeDelta = 0.005};
    MKCoordinateRegion region = {coord, span};
    [_mapView setRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
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
            
            if ([originalLatitude isEqualToString:@""] || originalLatitude == NULL) {
                
                CLLocationCoordinate2D coord = {.latitude =  currentLocation.coordinate.latitude, .longitude =  currentLocation.coordinate.longitude};
                MKCoordinateSpan span = {.latitudeDelta =  0.005, .longitudeDelta =  0.005};
                MKCoordinateRegion region = {coord, span};
                
                [self.mapView setRegion:region animated:YES];
                // set original coordinates
                originalLatitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
                originalLongitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
                selectedLatitude = originalLatitude;
                selectedLongitude = originalLongitude;
            }
            
            _lblAddress.text = address;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    // set selected coordinates
    selectedLatitude = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude];
    selectedLongitude = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude];
    
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

-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)addImages:(id)sender {
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

@end
