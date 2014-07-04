//
//  VehicleProfilePageVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 01/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleProfilePageVC : UIViewController
{
    NSDateFormatter *dateFormatter;
}


@property (nonatomic,retain) IBOutlet UILabel *lblMake,*lblModel,*lblMake1,*lblModel1,*lblMake2,*lblModel2;
@property (nonatomic,retain) IBOutlet UILabel *lblRegistrationNo,*lblVehicleType,*lblStatus,*lblNodyType,*lblEngineNo,*lblVin,*lblColor,*lblAccessories;
@property (nonatomic,retain) IBOutlet UILabel *lblCompanyName,*lblPolicyNo,*lblExpiry;

@property (nonatomic,retain) IBOutlet UIButton *btnBack,*btnAdd,*btnAddInsurance,*btnEditInfo,*btnDelete;
@property (nonatomic,retain) IBOutlet UIView *view1,*vew2,*view3,*view4;

@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

@property (nonatomic,retain) NSString *strVehicleId;

@property (nonatomic,retain) IBOutlet UIImageView *imgVehicleType,*imgStatus;
@property (nonatomic,retain) NSDictionary *arrVehicle;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnAdd_click:(id)sender;
-(IBAction)btnAddInsurance_click:(id)sender;
-(IBAction)btnEditInfo_click:(id)sender;
-(IBAction)btnDelete_click:(id)sender;


@end
