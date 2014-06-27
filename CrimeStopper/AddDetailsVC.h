//
//  AddDetailsVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 27/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDetailsVC : UIViewController <UITextFieldDelegate>
{
    UITextField *activeTextField;
    UIActionSheet *sheet;

}

@property (nonatomic,retain) IBOutlet UITextField *txtlicenceno,*txtPostCode,*txtStreet;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnSave_click:(id)sender;
- (IBAction)btnMinimize_Click:(id)sender;
- (IBAction)btnNext_Click:(id)sender;
- (IBAction)btnPreviuse_Click:(id)sender;

@end
