//
//  DirectionMapVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 11/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "DirectionMapVC.h"
#import <MapKit/MapKit.h>
#import "FindVehicleVC.h"

@interface DirectionMapVC ()
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
-(void) centerMap;
@end

@implementation DirectionMapVC

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
- (id) initWithFrame:(CGRect) frame
{
    //self = [super initWithFrame:frame];
    if (self != nil)
    {
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mapView.showsUserLocation = NO;
        [mapView setDelegate:self];
        [self.view addSubview:mapView];
    }
    return self;
}
- (NSMutableArray *)decodePolyLine: (NSMutableString *)encoded
{
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        //printf("[%f,", [latitude doubleValue]);
        //printf("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    return array;
}

//-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
//{
//    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
//    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
//    
//    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
//    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
//    //NSLog(@"api url: %@", apiUrl);
//    NSError* error = nil;
//    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];
//    NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
//    return [self decodePolyLine:[encodedPoints mutableCopy]];
//}
//
//-(void) centerMap
//{
//    MKCoordinateRegion region;
//    CLLocationDegrees maxLat = -90.0;
//    CLLocationDegrees maxLon = -180.0;
//    CLLocationDegrees minLat = 90.0;
//    CLLocationDegrees minLon = 180.0;
//    for(int idx = 0; idx < routes.count; idx++)
//    {
//        CLLocation* currentLocation = [routes objectAtIndex:idx];
//        if(currentLocation.coordinate.latitude > maxLat)
//            maxLat = currentLocation.coordinate.latitude;
//        if(currentLocation.coordinate.latitude < minLat)
//            minLat = currentLocation.coordinate.latitude;
//        if(currentLocation.coordinate.longitude > maxLon)
//            maxLon = currentLocation.coordinate.longitude;
//        if(currentLocation.coordinate.longitude < minLon)
//            minLon = currentLocation.coordinate.longitude;
//    }
//    region.center.latitude     = (maxLat + minLat) / 2.0;
//    region.center.longitude    = (maxLon + minLon) / 2.0;
//    region.span.latitudeDelta = 0.01;
//    region.span.longitudeDelta = 0.01;
//    
//    region.span.latitudeDelta  = ((maxLat - minLat)<0.0)?100.0:(maxLat - minLat);
//    region.span.longitudeDelta = ((maxLon - minLon)<0.0)?100.0:(maxLon - minLon);
//    [mapView setRegion:region animated:YES];
//}
//
//-(void) showRouteFrom: (MKAnnotation*) f to:(MKAnnotation*) t
//{
//    if(routes)
//    {
//        [mapView removeAnnotations:[mapView annotations]];
//    }
//    
//    [mapView addAnnotation:f];
//    [mapView addAnnotation:t];
//    
//    routes = [self calculateRoutesFrom:f.coordinate to:t.coordinate];
//    NSInteger numberOfSteps = routes.count;
//    
//    CLLocationCoordinate2D coordinates[numberOfSteps];
//    for (NSInteger index = 0; index < numberOfSteps; index++)
//    {
//        CLLocation *location = [routes objectAtIndex:index];
//        CLLocationCoordinate2D coordinate = location.coordinate;
//        coordinates[index] = coordinate;
//    }
//    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
//    [mapView addOverlay:polyLine];
//    [self centerMap];
//}

#pragma mark MKPolyline delegate functions
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor purpleColor];
    polylineView.lineWidth = 5.0;
    return polylineView;
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    FindVehicleVC *vc = [[FindVehicleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
