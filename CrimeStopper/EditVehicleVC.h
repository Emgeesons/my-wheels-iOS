//
//  EditVehicleVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 04/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditVehicleVC : UIViewController <UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField *activeTextField;
    UIActionSheet *sheet;
}
@property (nonatomic,retain) IBOutlet UIButton *btnVehiclesType,*btnBodyType;
@property (nonatomic,retain) IBOutlet UITextField *txtMake,*txtModel,*txtRegistrationNo,*txtEngineNo,*txtCin,*txtChassisNo,*txtColor,*txtAccessories,*txtOtherVehicle,*txtVehicleType,*txtBodyType;
@property (nonatomic,retain) IBOutlet UIPickerView *pkvVehicleType,*pkvBodyType;

@property (nonatomic,retain) NSMutableArray *arrVehicleType,*arrBodyType;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) NSDictionary *arrVehicles;
@property (nonatomic,retain) NSString *strVehicleID;
@property (nonatomic,retain) NSString *strVehicleType,*strMake,*strModel,*strBodyType,*strRegistrationNo,*strEngineNo,*strVIN,*strColour,*strAccessories;

-(IBAction)btnAdd_click:(id)sender;
-(IBAction)btnBack_click:(id)sender;

@end
