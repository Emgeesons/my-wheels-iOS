//
//  FindVehicleVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 08/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface FindVehicleVC : UIViewController<CLLocationManagerDelegate,MKAnnotation>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,retain) IBOutlet UILabel *lblParking;
@property (nonatomic,retain) IBOutlet UIButton *btnLocated;

-(IBAction)btnLocated_click:(id)sender;
-(IBAction)btnBack_click:(id)sender;
@end
