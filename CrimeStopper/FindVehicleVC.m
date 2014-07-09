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

@interface FindVehicleVC ()

@end

@implementation FindVehicleVC
#define METERS_PER_MILE 1609.344
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
    // Do any additional setup after loading the view from its nib.
    // [self CurrentLocationIdentifier];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    [ self.map.delegate self];

    NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    float currlat = [latitude floatValue];
    float currlongt = [longitude floatValue];
    CLLocationCoordinate2D loc ;
    loc.latitude = currlat;
    loc.longitude = currlongt;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.map setRegion:region animated:YES];
    //
     NSString *strCurrentVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"parkVehicle"];
    
    NSLog(@"arr : %@",arr);
    NSLog(@"arr counbt :%d",[arr count]);
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
        
    }
}

@end
