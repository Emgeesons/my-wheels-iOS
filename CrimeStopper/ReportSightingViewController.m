//
//  ReportSightingViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 30/06/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ReportSightingViewController.h"
@import CoreLocation;

@interface ReportSightingViewController () <UITextFieldDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    UIActionSheet *sightingPicker, *datePickerSheet;
    UIDatePicker *datePicker;
    NSDate *datePickerSelectedDate;
    //CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *originalLatitude, *originalLongitude, *selectedLatitude, *selectedLongitude, *address, *originalDate, *originalTime, *selectedDate, *selectedTime;
}
@property (nonatomic , strong) CLLocationManager *locationManager;
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
    
    //Initialize CLLocationManager
    _locationManager = [[CLLocationManager alloc] init];
    
    // Initialize CLGeocoder
    geocoder = [[CLGeocoder alloc] init];
    
    _locationManager.delegate = self; // Set delegate
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set accuracy
    
    [_locationManager startUpdatingLocation]; // start updating for current location
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    // Stop Location Manager
    //[locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];

            NSLog(@"currentLocation ==> %f", currentLocation.coordinate.latitude);
            NSLog(@"oldLocation ==> %f", oldLocation.coordinate.latitude);
            
            if ([originalLatitude isEqualToString:@""] || originalLatitude == NULL) {
                
                self.mapView.centerCoordinate = currentLocation.coordinate;
                
                CLLocationCoordinate2D coord = {.latitude =  currentLocation.coordinate.latitude, .longitude =  currentLocation.coordinate.longitude};
                MKCoordinateSpan span = {.latitudeDelta =  0.005, .longitudeDelta =  0.005};
                MKCoordinateRegion region = {coord, span};
                
                [_mapView setShowsUserLocation:YES];
                [self.mapView setRegion:region animated:YES];
                // set original coordinates
                originalLatitude = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.latitude];
                originalLongitude = [NSString stringWithFormat:@"%f", self.mapView.centerCoordinate.longitude];
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
    NSLog(@"%@", selectedLatitude);
}

#pragma mark - UITextField delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtSighting) {
        sightingPicker = [[UIActionSheet alloc] initWithTitle:@"Type of Sighting" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Theft", @"Vandalism", @"Suspicious activity", @"Other", nil];
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
    } else if(textField == self.txtMake) {
        [self.scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
    }  else if(textField == self.txtModel) {
        [self.scrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    } else if (textField == self.txtColor) {
        [self.scrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    } else if (textField == self.txtComments) {
        [self.scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
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
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return YES;
    }
    return NO;
}

#pragma mark - UIActionSheet done/cancel buttons

-(void)cancelClicked {
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
    [FormatDate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    self.txtDateTime.text = [FormatDate stringFromDate:[datePicker date]];
    
    datePicker.frame=CGRectMake(0, 44, 320, 416);
    [self cancelClicked];
}

@end
