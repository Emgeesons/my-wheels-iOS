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
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HomePageVC : UIViewController <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (nonatomic,retain) IBOutlet UIButton *btnNav;
@property (nonatomic,retain) IBOutlet UIView *viewReport,*viewNewReport,*viewAboutUs,*viewUpdates;
@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,retain) IBOutlet UIButton *btnParking,*btnVehicles;
@property (nonatomic,retain) IBOutlet UIButton *btnAboutUs;
@property (nonatomic,retain) IBOutlet UIButton *btnprofile;
@property (nonatomic,retain) IBOutlet UIImageView *imgProfilepic;
@property (strong, atomic) ALAssetsLibrary* library;
@property (nonatomic,retain) IBOutlet UIButton *btnHeading;
@property (nonatomic,retain) IBOutlet UIView *voewMakeModel;
@property (nonatomic,retain) IBOutlet UITableView *tblMakeModel;
@property (nonatomic,retain) NSDictionary *arrVehicles;
@property (nonatomic,retain) IBOutlet UIView *ViewMain;
@property (nonatomic,retain) IBOutlet UIButton *btnMParking;
@property (nonatomic,retain) IBOutlet UIButton *btnFindVehicle;
@property (nonatomic,retain) IBOutlet UIImageView *imgTick;
@property (nonatomic,retain) IBOutlet UIView *viewHeading;
@property (nonatomic) int intblue;

-(IBAction)btnMParking_click:(id)sender;
-(IBAction)btnFindVehicle_click:(id)sender;
-(IBAction)btnNav_click:(id)sender;
-(IBAction)btnAboutUs_Click:(id)sender;
-(IBAction)btnProfile_click:(id)sender;
-(IBAction)btnHeading_click:(id)sender;
-(IBAction)btnCancel_clck:(id)sender;

@end
