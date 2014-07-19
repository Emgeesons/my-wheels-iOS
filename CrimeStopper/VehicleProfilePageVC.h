//
//  VehicleProfilePageVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 01/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleProfilePageVC : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSDateFormatter *dateFormatter;
}


@property (nonatomic,retain) IBOutlet UILabel *lblMake,*lblModel,*lblMake1,*lblModel1,*lblMake2,*lblModel2;
@property (nonatomic,retain) IBOutlet UILabel *lblRegistrationNo,*lblVehicleType,*lblStatus,*lblNodyType,*lblEngineNo,*lblVin,*lblColor,*lblAccessories;
@property (nonatomic,retain) IBOutlet UILabel *lblCompanyName,*lblPolicyNo,*lblExpiry;

@property (nonatomic,retain) IBOutlet UIButton *btnBack,*btnAdd,*btnAddInsurance,*btnEditInfo,*btnDelete;
@property (nonatomic,retain) IBOutlet UIView *view1,*vew2,*view3,*view4,*viewPics,*viewButton;;

@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

@property (nonatomic,retain) NSString *strVehicleId;

@property (nonatomic,retain) IBOutlet UIImageView *imgVehicleType,*imgStatus;
@property (nonatomic,retain) NSDictionary *arrVehicle;
@property (nonatomic,retain) IBOutlet UIButton *btnAddPhoto;
@property (nonatomic,retain) IBOutlet UIButton *btnPhoto1,*btnPhoto2,*btnPhoto3;
@property (nonatomic,retain) IBOutlet UIImageView *imgvehicle1,*imgvehicle2,*imgvehicle3;
@property (nonatomic,retain) IBOutlet UIImageView *imgRound1,*imgRound2,*imgRound3;
@property (nonatomic,retain) NSDictionary *arrVehiclesCount;
@property (nonatomic) NSInteger intPosition, intNoPhoto;


-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnAdd_click:(id)sender;
-(IBAction)btnAddInsurance_click:(id)sender;
-(IBAction)btnEditInfo_click:(id)sender;
-(IBAction)btnDelete_click:(id)sender;
-(IBAction)btnAddPhoto_click:(id)sender;
-(IBAction)btnAddPhoto1_click:(id)sender;
-(IBAction)btnAddPhoto2_click:(id)sender;
-(IBAction)btnAddPhoto3_click:(id)sender;

@end
