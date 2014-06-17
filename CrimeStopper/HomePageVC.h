//
//  HomePageVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 10/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PPRevealSideViewController.h"
#import <MapKit/MapKit.h>
@interface HomePageVC : UIViewController

@property (nonatomic,retain) IBOutlet UIButton *btnNav;
@property (nonatomic,retain) IBOutlet UIView *viewReport,*viewNewReport,*viewAboutUs,*viewUpdates;
@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,retain) IBOutlet UIButton *btnParking,*btnVehicles;
-(IBAction)btnNav_click:(id)sender;

@end
