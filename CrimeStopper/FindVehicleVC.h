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
#import "StarRatingControl.h"

@interface FindVehicleVC : UIViewController<CLLocationManagerDelegate,MKAnnotation,UIActionSheetDelegate,UIToolbarDelegate,UITextViewDelegate,StarRatingDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
     UIActionSheet *sheet;
     UITextView *activeTextField;
}
@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,retain) IBOutlet UILabel *lblParking;
@property (nonatomic,retain) IBOutlet UIButton *btnLocated;
@property (nonatomic,retain) IBOutlet UIButton *btnPost,*btnSkip;
@property (nonatomic,retain) IBOutlet UIView *viewLocated;
@property (nonatomic,retain) IBOutlet UILabel *lblplaceholder;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIView *viewHeading;
@property (nonatomic,retain) IBOutlet UITextView *txtComment;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UISlider *slide;
@property (nonatomic,retain) IBOutlet UILabel *lblRating;
@property (nonatomic,retain) IBOutlet UIView *viewLocation,*viewTransparent;

@property (weak) IBOutlet StarRatingControl *starRatingControl;
@property (strong) UIImage *star;
@property (strong) UIImage *highlightedStar;


-(IBAction)GoOt_click:(id)sender;
-(IBAction)btnLocated_click:(id)sender;
-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnPost_click:(id)sender;
-(IBAction)btnSkip_click:(id)sender;
-(IBAction)btnDirection_click:(id)sender;
@end
