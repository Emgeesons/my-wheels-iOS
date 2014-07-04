//
//  AddInsuranceVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 01/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInsuranceVC : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSDateFormatter *dateFormatter;
    UITextField *activeTextField;
    UIActionSheet *sheet;
    UIDatePicker *timePicker;
}

@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UIButton *btnExpiry,*btnInsurance;
@property (nonatomic,retain) NSMutableArray *arrinsurance,*arrTelephone;
@property (nonatomic,retain) IBOutlet UIPickerView *pkvInsurance;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UITextField *txtPhoneNo;
@property (nonatomic,retain) IBOutlet UITextField *txtPolicyNo,*txtCompanyName,*txtExpiry;
@property (nonatomic,retain) IBOutlet UITextField *txtOtherInsurance;
@property (nonatomic,retain) NSString *strVehicleId;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

@property (nonatomic,retain) NSString *strmake,*strModel,*strVehicleType;


-(IBAction)btnBack_click:(id)sender;

-(IBAction)btnAdd_click:(id)sender;
@end
