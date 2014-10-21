//
//  UserProfileVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 24/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UserProfileVC : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSDateFormatter *dateFormatter;
}
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblFname,*lblLname,*lblEmail,*lbldob,*lblMobileNo;
@property (nonatomic,retain) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIView *customActionSheetView;
@property (nonatomic,retain) IBOutlet UIButton *btnprofilePic;
@property (nonatomic,retain) IBOutlet UIImageView *img1;
@property (strong, atomic) ALAssetsLibrary* library;
@property (nonatomic,retain) IBOutlet UILabel *lblprofile,*lblstm;
@property (nonatomic,retain) IBOutlet UIButton *btnAddDetails;
@property (nonatomic,retain) IBOutlet UIView *viewsamaritan;
@property (nonatomic,retain) IBOutlet UIButton *btnsamaritan;
@property (nonatomic,retain) IBOutlet UILabel *lblsamaritan;
@property (nonatomic,retain) IBOutlet UIImageView *imgsamaritan;
@property (nonatomic,retain) IBOutlet UIImageView *imgUserProfilepic;
@property (nonatomic,retain) IBOutlet UIButton *btnAddVehicle;
@property (nonatomic,retain) NSMutableData *receivedData;


-(IBAction)btnAddDetails_click:(id)sender;
-(IBAction)btnProfilepic_click:(id)sender;
-(IBAction)btnback_click:(id)sender;
-(IBAction)btnSamaritan_click:(id)sender;
-(IBAction)btnAddVehicles_click:(id)sender;


@end
