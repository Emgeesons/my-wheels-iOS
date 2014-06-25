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

-(IBAction)btnProfilepic_click:(id)sender;
-(IBAction)btnback_click:(id)sender;
-(IBAction)btnSamaritan_click:(id)sender;
- (IBAction)hideActionSheetView:(id)sender;
- (IBAction)takeNewPhotoFromCamera:(id)sender;
- (IBAction)choosePhotoFromExistingImages:(id)sender;
@end
