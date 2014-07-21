//
//  FindVehicleVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 08/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "FindVehicleVC.h"
#import "HomePageVC.h"
#import <MapKit/MapKit.h>
#import "MyLocation.h"
#import "MyAnnotation.h"
#import "HomePageVC.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "DirectionMapVC.h"

@interface FindVehicleVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation FindVehicleVC
#define METERS_PER_MILE 1609.344
int progressAsInt;

NSInteger flag;
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
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    [ self.map.delegate self];
    
    [_viewLocated setHidden:YES];
   
  
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    [_txtComment setInputAccessoryView:self.toolbar];
    _btnPost.layer.borderWidth=0.5f;
    _btnPost.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _btnSkip.layer.borderWidth=0.5f;
    _btnSkip.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    /// zoom map
    NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    float currlat = [latitude floatValue];
    float currlongt = [longitude floatValue];
    CLLocationCoordinate2D loc ;
    loc.latitude = currlat;
    loc.longitude = currlongt;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.map setRegion:region animated:YES];
    //sow current location and parked location on map
     NSString *strCurrentVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"];
    
    NSLog(@"arr : %@",arr);
   
    if(arr == nil || arr == (id)[NSNull null])
    {
        
    }
    else
    {
        for(int i=0;i<=[arr count]-1;i++)
        {
            NSString *strvid = [[arr objectAtIndex:i]valueForKey:@"VehivleID"];
            NSLog(@"strvid : %@",strvid);
            if(strvid == strCurrentVehicleID && strvid != nil)
            {
                _lblParking.text = [[arr objectAtIndex:i]valueForKey:@"Comment"];
                NSString *parkLatitude = [[arr objectAtIndex:i]valueForKey:@"parkingLatitude"];
                NSString *parkLongitude = [[arr objectAtIndex:i]valueForKey:@"prkingLongitude"];
              
                
                float lat = [parkLatitude floatValue];
                float longt = [parkLongitude floatValue];
                NSLog(@"plat : %f",lat);
                NSLog(@"plong : %f",longt);
                
                CLLocation *userLoc = _map.userLocation.location;
                CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
                NSLog(@"user latitude = %f",userCoordinate.latitude);
                NSLog(@"user longitude = %f",userCoordinate.longitude);
               
                NSMutableArray* annotations=[[NSMutableArray alloc] init];
                
                CLLocationCoordinate2D theCoordinate1;
                theCoordinate1.latitude =lat;
                theCoordinate1.longitude = longt;
                
                MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
                
                myAnnotation1.coordinate=theCoordinate1;
                myAnnotation1.title=@"vehicle";
//                myAnnotation1.subtitle=@"";
                 [myAnnotation1.image setImage: [UIImage imageNamed:@"vehicle_parked.png"]];
             
                
                [_map addAnnotation:myAnnotation1];
                [annotations addObject:myAnnotation1];
                
                NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
                NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
                float currlat = [latitude floatValue];
                float currlongt = [longitude floatValue];
                CLLocationCoordinate2D theCoordinate2;
                theCoordinate2.latitude =currlat;
                theCoordinate2.longitude = currlongt;
                MyAnnotation* myAnnotation2=[[MyAnnotation alloc] init];
                
                myAnnotation2.coordinate=theCoordinate2;
                   [myAnnotation2.image setImage: [UIImage imageNamed:@"current_location.png"]];

            }
            else
            {
                
            }
        }
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.map setRegion:region animated:YES];
    
    
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    HomePageVC *vc = [[HomePageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnLocated_click:(id)sender
{
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSLog(@"str : %@",UserID);
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        HomePageVC *vc = [[HomePageVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        self.map.userInteractionEnabled = NO ;
        [self.map setAlpha:0.9f];
        [_btnLocated setAlpha:0.9f];
        _btnLocated.userInteractionEnabled = NO;
        [_viewHeading setAlpha:0.8f];
        _viewHeading.userInteractionEnabled = NO;
        
        [_viewLocated setHidden:NO];
    }
}
-(IBAction)btnPost_click:(id)sender
{
 if(progressAsInt == 0)
 {
     UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                         message:@"Please give feedback rating."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
     [CheckAlert show];
 }
    else
    {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Please connect to the internet to continue."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    } else {
        NSLog(@"There IS internet connection");
        
    if(_lblRating.text == nil || _lblRating.text == (id)[NSNull null])
   {
       UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                           message:@"Please give feedback rating."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
       [CheckAlert show];

   }
else
{
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        NSString *strCurrentVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    /*
     
     userId (0 if guest)
     pin
     vehicleId (0 if default)
     latitude
     longitude
     feedback
     rating
     os
     make
     model
*/
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSLog(@"str : %@",UserID);
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        [param setValue:@"0" forKey:@"userId"];
    }
    else
    {
        [param setValue:UserID forKey:@"userId"];
    }
    [param setValue:strCurrentVehicleID forKey:@"vehicleId"];
    [param setValue:pin forKey:@"pin"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    [param setValue:_txtComment.text forKey:@"feedback"];
   
    [param setValue:_lblRating.text forKey:@"rating"];
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/parkingFeedback.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
        NSLog(@"data : %@",jsonDictionary);
        
        NSString *EntityID = [jsonDictionary valueForKey:@"status"];
        NSLog(@"message %@",EntityID);
        if ([EntityID isEqualToString:@"failure"])
        {
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                message:@"Something went wrong. Please Try Again."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [CheckAlert show];
        }
        else
        {
            NSLog(@"vehicle : %@",appDelegate.arrMutvehiclePark);
           
            
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

           
            HomePageVC *vc = [[HomePageVC alloc]init];
            vc.intblue = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    }
    }
}
-(IBAction)btnSkip_click:(id)sender
{
     NSString *strCurrentVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    NSMutableArray  *arr = [[NSMutableArray alloc]init];
    arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"] mutableCopy];
    
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
    HomePageVC *vc = [[HomePageVC alloc]init];
    vc.intblue = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnMinimize_Click:(id)sender {
    [activeTextField resignFirstResponder];
}
- (IBAction)btnNext_Click:(id)sender
{
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
- (IBAction)btnPreviuse_Click:(id)sender
{
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
-(IBAction)btnDirection_click:(id)sender
{
    DirectionMapVC *vc = [[DirectionMapVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark slider change
-(IBAction) sliderChanged:(id) sender{
	
    progressAsInt =(int)(_slide.value + 0.5f);
	NSString *newText =[[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_lblRating.text = newText;
	
}
#pragma mark textfield delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    activeTextField = textView;
    int y;
    y=150;
    

NSLog(@"y = %d",y);
[UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:_scroll];
    rc.origin.x = 0 ;
    rc.origin.y = y ;
    CGPoint pt=rc.origin;
    [self.scroll setContentOffset:pt animated:YES];
}completion:nil];
}

-(void)textViewDidEndEditing:(UITextView *)textField
{
       int y=0;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
}

@end
