//
//  FileNewReportViewController.h
//  CrimeStopper
//
//  Created by Yogesh Suthar on 05/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

@import MapKit;

@interface FileNewReportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIView *vwNoVehicle;
@property (weak, nonatomic) IBOutlet UIView *vwFileReport;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)openProfile:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgVehicle;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lblRegistrationNumber;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;
@property (weak, nonatomic) IBOutlet UITextField *txtDateTime;
@property (weak, nonatomic) IBOutlet UITextField *txtSighting;
@property (weak, nonatomic) IBOutlet UITextField *txtComments;
@property (nonatomic,retain) IBOutlet UIView *viewLocationGuide;
@property (weak, nonatomic) IBOutlet UIButton *btnLetsGo;
@property (nonatomic,retain) IBOutlet UIView *viewTransparent;
@property (nonatomic,retain) NSMutableData *receivedData;

-(IBAction)btnGot_click:(id)sender;
- (IBAction)selectVehicles:(id)sender;
- (IBAction)addImages:(id)sender;
- (IBAction)sendClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSend;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIView *viewselectVehicle;
@property (weak, nonatomic) IBOutlet UITableView *tvSelectVehicle;
- (IBAction)btnCancelClicked:(id)sender;

@end
