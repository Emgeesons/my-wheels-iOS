//
//  ReportSightingViewController.h
//  CrimeStopper
//
//  Created by Yogesh Suthar on 30/06/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface ReportSightingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)btnSendClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *txtSighting;
@property (weak, nonatomic) IBOutlet UITextField *txtDateTime;
@property (weak, nonatomic) IBOutlet UITextField *txtRegistrationNo;
@property (weak, nonatomic) IBOutlet UITextField *txtMake;
@property (weak, nonatomic) IBOutlet UITextField *txtComments;
@property (weak, nonatomic) IBOutlet UITextField *txtModel;
@property (weak, nonatomic) IBOutlet UITextField *txtColor;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;
- (IBAction)addImage:(id)sender;

@end
