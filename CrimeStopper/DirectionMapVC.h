//
//  DirectionMapVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 11/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface DirectionMapVC : UIViewController <CLLocationManagerDelegate,MKAnnotation,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    MKMapView* mapView;
    NSArray* routes;
    BOOL isUpdatingRoutes;


}

@property (nonatomic,retain) IBOutlet MKMapView *map;


//-(void) showRouteFrom: (MKAnnotation*) f to:(MKAnnotation*) t;
@end
