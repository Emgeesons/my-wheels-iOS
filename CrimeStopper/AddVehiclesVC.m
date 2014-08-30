//
//  AddVehiclesVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 30/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "AddVehiclesVC.h"
#import "UserProfileVC.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "VehicleProfilePageVC.h"
#import "AppDelegate.h"

@interface AddVehiclesVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation AddVehiclesVC
NSString *strvehivcle;
NSString *strBody;
#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_pkvVehicleType setHidden:YES];
    _arrBodyType = [[NSMutableArray alloc]init];
    _arrVehicleType = [[NSMutableArray alloc]init];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
        [_arrVehicleType addObject:@"Bicycle"];
        [_arrVehicleType addObject:@"Car"];
        [_arrVehicleType addObject:@"Motorcycle"];
        [_arrVehicleType addObject:@"Other"];
    
    ////NSLog(@"arr :: :%@",_arrVehicleType);
    
    
    
        [_arrBodyType addObject:@"Micro/ Compact"];
        [_arrBodyType addObject:@"Convertible / Coupe"];
        [_arrBodyType addObject:@"Hatchback"];
        [_arrBodyType addObject:@"Sedan"];
        [_arrBodyType addObject:@"Station Wagon"];
        [_arrBodyType addObject:@"SUV"];
        [_arrBodyType addObject:@"People Mover"];
        [_arrBodyType addObject:@"Utility / Cab Chassis"];
        [_arrBodyType addObject:@"Van"];
    
    
    
    [self.txtAccessories setDelegate:self];
    [self.txtChassisNo setDelegate:self];
    [self.txtColor setDelegate:self];
    [self.txtEngineNo setDelegate:self];
    [self.txtMake setDelegate:self];
    [self.txtModel setDelegate:self];
    [self.txtRegistrationNo setDelegate:self];
    
    
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    
    [self.txtAccessories setInputAccessoryView:self.toolbar];
    [self.txtChassisNo setInputAccessoryView:self.toolbar];
    [self.txtColor setInputAccessoryView:self.toolbar];
    [self.txtEngineNo setInputAccessoryView:self.toolbar];
    [self.txtMake setInputAccessoryView:self.toolbar];
    [self.txtModel setInputAccessoryView:self.toolbar];
    [self.txtRegistrationNo setInputAccessoryView:self.toolbar];
    [self.txtOtherVehicle setInputAccessoryView:self.toolbar];
    [self.txtstate setInputAccessoryView:self.toolbar];
    
    if(IsIphone5)
    {
        _scroll.frame = CGRectMake(0 , 58, 320, 568+100);
        _scroll.contentSize = CGSizeMake(320, 900);
    }
    else
    {
        _scroll.frame = CGRectMake(0 , 58, 320, 568+50);
        
        _scroll.contentSize = CGSizeMake(320, 900);
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event

-(IBAction)btnAdd_click:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        ////NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Please connect to the internet to continue."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    }
    
    else
        
    {
        if ([strvehivcle isEqualToString:@"" ]|| strvehivcle == nil || strvehivcle == (id)[NSNull null]) {
            if (_txtMake.text.length==0 || _txtModel.text.length==0 || _txtRegistrationNo.text.length==0 || _txtEngineNo.text.length==0 || _txtChassisNo.text.length==0 || _txtColor.text.length==0 || _txtstate.text.length == 0 || _txtVehicleType.text.length == 0 || _txtBodyType.text.length == 0)
            {
            if(_txtVehicleType.text.length == 0)
            {
                [_txtVehicleType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if(_txtBodyType.text.length == 0)
            {
                    [_txtBodyType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
                
            if (_txtMake.text.length == 0)
            {
                [_txtMake setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtEngineNo.text.length == 0)
            {
                [_txtEngineNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtChassisNo.text.length == 0)
            {
                [_txtChassisNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtModel.text.length == 0)
            {
                [_txtModel setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtRegistrationNo.text.length == 0)
            {
                [_txtRegistrationNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtColor.text.length == 0)
            {
                [_txtColor setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtModel.text.length == 0)
            {
                [_txtModel setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtstate.text.length == 0)
            {
                [_txtstate setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if(_txtEngineNo.text.length == 0)
            {
                [_txtEngineNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            }
        }
        ////NSLog(@"There IS internet connection");
        
        // for only bicycle
        
        if([strvehivcle isEqualToString:@"Bicycle"] )
        {
            
            if(_txtVehicleType.text.length == 0 || _txtColor.text.length == 0 ||  (_txtMake.text.length == 0 && _txtModel.text.length == 0))
            {
                if(_txtVehicleType.text.length == 0)
                {
                    [_txtVehicleType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtColor.text.length == 0)
                {
                    [_txtColor setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
               
                if (_txtMake.text.length == 0)
                {
                    [_txtMake setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtModel.text.length == 0)
                {
                    [_txtModel setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
            }
            else
            {
                if(_txtRegistrationNo.text.length > 13)
                {
                    [_txtRegistrationNo setTextColor:[UIColor redColor]];
                }
                else if (_txtEngineNo.text.length!=0 && _txtEngineNo.text.length < 13)
                {
                    [_txtEngineNo setTextColor:[UIColor redColor]];
                }
                else if (_txtChassisNo.text.length !=0 && _txtChassisNo.text.length < 17)
                {
                    [_txtChassisNo setTextColor:[UIColor redColor]];
                }
                else if ( _txtColor.text.length <3)
                {
                    [_txtColor setTextColor:[UIColor redColor]];
                }
                else if ( _txtModel.text.length < 1 && _txtMake.text.length < 1)
                {
                    [_txtModel setTextColor:[UIColor redColor]];
                    [_txtMake setTextColor:[UIColor redColor]];
                }
                else
                {
                    [self Callapi];
                }
            }
        }
        // if vehicle type is car
       else if([strvehivcle isEqualToString:@"Car"] )
        {
            
            if(_txtVehicleType.text.length == 0 || _txtColor.text.length == 0 || _txtMake.text.length == 0 || _txtModel.text.length == 0 || _txtBodyType.text.length == 0 || _txtRegistrationNo.text.length == 0 || _txtstate.text.length == 0)
            {
                if(_txtVehicleType.text.length == 0)
                {
                    [_txtVehicleType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtColor.text.length == 0)
                {
                    [_txtColor setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtMake.text.length == 0)
                {
                    [_txtMake setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtModel.text.length == 0)
                {
                    [_txtModel setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtBodyType.text.length == 0)
                {
                    [_txtBodyType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtRegistrationNo.text.length == 0)
                {
                    [_txtRegistrationNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
                if (_txtstate.text.length == 0)
                {
                    [_txtstate setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                }
            }
            else
            {
                if(_txtRegistrationNo.text.length > 10)
                {
                    [_txtRegistrationNo setTextColor:[UIColor redColor]];
                }
                else if (_txtEngineNo.text.length!=0 && _txtEngineNo.text.length < 13)
                {
                    [_txtEngineNo setTextColor:[UIColor redColor]];
                }
                else if (_txtChassisNo.text.length !=0 && _txtChassisNo.text.length < 17)
                {
                    [_txtChassisNo setTextColor:[UIColor redColor]];
                }
                else if ( _txtColor.text.length <3)
                {
                    [_txtColor setTextColor:[UIColor redColor]];
                }
                else if ( _txtMake.text.length <2)
                {
                    [_txtMake setTextColor:[UIColor redColor]];
                }
                else if (_txtstate.text.length > 3)
                {
                    [_txtstate setTextColor:[UIColor redColor]];
                }
                else
                {
                    [self Callapi];
                }
            }
        }
        // for moter cycle
       else if([strvehivcle isEqualToString:@"Motorcycle"] )
       {
           
           if(_txtVehicleType.text.length == 0 || _txtColor.text.length == 0 || _txtMake.text.length == 0 || _txtModel.text.length == 0 ||  _txtRegistrationNo.text.length == 0 || _txtstate.text.length == 0)
           {
               if(_txtVehicleType.text.length == 0)
               {
                   [_txtVehicleType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtColor.text.length == 0)
               {
                   [_txtColor setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtMake.text.length == 0)
               {
                   [_txtMake setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtModel.text.length == 0)
               {
                   [_txtModel setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtRegistrationNo.text.length == 0)
               {
                   [_txtRegistrationNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtstate.text.length == 0)
               {
                   [_txtstate setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
           }
           else
           {
               if(_txtRegistrationNo.text.length > 10)
               {
                   [_txtRegistrationNo setTextColor:[UIColor redColor]];
               }
               else if (_txtEngineNo.text.length!=0 && _txtEngineNo.text.length < 13)
               {
                   [_txtEngineNo setTextColor:[UIColor redColor]];
               }
               else if (_txtChassisNo.text.length !=0 && _txtChassisNo.text.length < 17)
               {
                   [_txtChassisNo setTextColor:[UIColor redColor]];
               }

               else if ( _txtColor.text.length <3)
               {
                   [_txtColor setTextColor:[UIColor redColor]];
               }
               else if ( _txtMake.text.length <2)
               {
                   [_txtMake setTextColor:[UIColor redColor]];
               }
               else if (_txtstate.text.length >3)
               {
                   [_txtstate setTextColor:[UIColor redColor]];
               }
               else
               {
                   [self Callapi];
               }
           }
       }
        
        // for other vehicle type
        
              // for other vehicle type
      
       else if([strvehivcle isEqualToString:@"Other"] )
       {
           
           if(_txtVehicleType.text.length == 0 || _txtColor.text.length == 0 || _txtOtherVehicle.text.length == 0 ||  (_txtMake.text.length == 0 && _txtModel.text.length == 0))
           {
               if(_txtVehicleType.text.length == 0)
               {
                   [_txtVehicleType setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtColor.text.length == 0)
               {
                   [_txtColor setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
             
               if (_txtMake.text.length == 0)
               {
                   [_txtMake setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtModel.text.length == 0)
               {
                   [_txtModel setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
               if (_txtOtherVehicle.text.length == 0)
               {
                   [_txtOtherVehicle setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
               }
           }
           else
           {
               if(_txtRegistrationNo.text.length > 13)
               {
                   [_txtRegistrationNo setTextColor:[UIColor redColor]];
               }
               else if (_txtEngineNo.text.length!=0 && _txtEngineNo.text.length < 13)
               {
                   [_txtEngineNo setTextColor:[UIColor redColor]];
               }
               else if (_txtChassisNo.text.length !=0 && _txtChassisNo.text.length < 17)
               {
                   [_txtChassisNo setTextColor:[UIColor redColor]];
               }

               else if (_txtstate.text.length > 3)
               {
                   [_txtstate setTextColor:[UIColor redColor]];
               }
               else if ( _txtColor.text.length <3)
               {
                   [_txtColor setTextColor:[UIColor redColor]];
               }
               
               else
               {
                   [self Callapi];
               }
           }
       }
////////
        
    }

}
-(IBAction)btnBack_click:(id)sender
{
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark selectoe methods
-(void)done_click:(id)sender
{
    [_pkvVehicleType setHidden:YES];
    
    int row = [_pkvVehicleType selectedRowInComponent:0];
    [_txtVehicleType setText:[_arrVehicleType objectAtIndex:row]];
    strvehivcle = [_arrVehicleType objectAtIndex:row];
    [_txtVehicleType resignFirstResponder];
     ////NSLog(@"veicle : %@",strvehivcle);
    
    // if vehicle type is other
    if([strvehivcle isEqualToString:@"Other"])
    {
        [_txtBodyType setHidden:YES];
        
    _txtOtherVehicle  = [[UITextField alloc] initWithFrame:CGRectMake(9,60,301,30)];
    [self.view addSubview:_txtOtherVehicle];
    _txtOtherVehicle.borderStyle = UITextBorderStyleRoundedRect;
        _txtOtherVehicle.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
        _txtOtherVehicle.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15];
    _txtOtherVehicle.keyboardType = UIKeyboardTypeDefault;
    _txtOtherVehicle.returnKeyType = UIReturnKeyDefault;
   
    _txtOtherVehicle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtOtherVehicle.placeholder = @"specify Vehicle Type *";
        _txtstate.placeholder = @"state";
        _txtRegistrationNo.placeholder = @"registration  (max 13 chars)";
        _txtEngineNo.placeholder = @"engine no (min 13 chars)";
        _txtChassisNo.placeholder = @"VIN / chassis no (min 17 chars)";
        _txtMake.placeholder = @"make* ";
        _txtModel.placeholder = @"model* ";
        _txtColor.placeholder = @"colour *";
    _txtOtherVehicle.tag = 0;
    _txtOtherVehicle.delegate = self;
        [_txtstate setHidden:NO];
        [self.txtOtherVehicle setInputAccessoryView:self.toolbar];

        [self.scroll addSubview:_txtOtherVehicle];
        _txtVehicleType.frame = CGRectMake(9, 20, 301, 30);
        _txtMake.frame = CGRectMake(9, 100, 150, 30);
        _txtModel.frame = CGRectMake(161, 100, 150, 30);
       
        _txtRegistrationNo.frame = CGRectMake(9,140, 301, 30);
        _txtstate.frame = CGRectMake(9, 180, 301, 30);
        _txtEngineNo.frame = CGRectMake(9,220, 301, 30);
        _txtChassisNo.frame = CGRectMake(9, 260, 301, 30);
        _txtColor.frame = CGRectMake(9, 300, 301, 30);
        _txtAccessories.frame = CGRectMake(9, 340, 301, 30);
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtRegistrationNo.tag = 3;
        _txtstate.tag = 4;
        _txtEngineNo.tag = 5;
        _txtChassisNo.tag = 6;
        _txtColor.tag = 7;
        _txtAccessories.tag = 8;

       
        

    }
    
    // if vehicle type is bicycle
    if([strvehivcle isEqualToString:@"Bicycle"])
    {
        [_txtstate setHidden:YES];
        [_txtBodyType setHidden:YES];
        [_txtOtherVehicle setHidden:YES];
        _txtRegistrationNo.placeholder = @"serial no (max 13 chars)";
        _txtEngineNo.placeholder = @"engine no (min 13 chars)";
        _txtChassisNo.placeholder = @"VIN / chassis no (min 17 chars)";
        _txtMake.placeholder = @"make *";
        _txtModel.placeholder = @"model *";
        
        _txtVehicleType.frame = CGRectMake(9, 20, 301, 30);
        _txtMake.frame = CGRectMake(9, 60, 150, 30);
        _txtModel.frame = CGRectMake(161, 60, 150, 30);
       
        _txtRegistrationNo.frame = CGRectMake(9,100, 301, 30);
      
        _txtEngineNo.frame = CGRectMake(9,140, 301, 30);
        _txtChassisNo.frame = CGRectMake(9, 180, 301, 30);
        _txtColor.frame = CGRectMake(9, 220, 301, 30);
        _txtAccessories.frame = CGRectMake(9, 260, 301, 30);
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtRegistrationNo.tag = 3;
        _txtEngineNo.tag = 4;
        _txtChassisNo.tag = 5;
        _txtColor.tag = 6;
        _txtAccessories.tag = 7;
        
        
    }
    if([strvehivcle isEqualToString:@"Car"])
    {
        [_txtstate setHidden:NO];
        [_txtBodyType setHidden:NO];
        [_txtOtherVehicle setHidden:YES];
        _txtVehicleType.frame = CGRectMake(9, 20, 301, 30);
        _txtMake.frame = CGRectMake(9, 60, 150, 30);
        _txtModel.frame = CGRectMake(161, 60, 150, 30);
        _txtBodyType.frame = CGRectMake(9, 100 , 301, 30);
        _txtRegistrationNo.frame = CGRectMake(9,140, 301, 30);
        _txtstate.frame = CGRectMake(9,180, 301, 30);
        _txtEngineNo.frame = CGRectMake(9,220, 301, 30);
        _txtChassisNo.frame = CGRectMake(9, 260, 301, 30);
        _txtColor.frame = CGRectMake(9, 300, 301, 30);
        _txtAccessories.frame = CGRectMake(9, 340, 301, 30);
        _txtEngineNo.placeholder = @"engine no (min 13 chars)";
        _txtChassisNo.placeholder = @"VIN / chassis no (min 17 chars)";
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtBodyType.tag = 3;
        _txtRegistrationNo.tag = 4;
        _txtstate.tag = 5;
        _txtEngineNo.tag = 6;
        _txtChassisNo.tag = 7;
        _txtColor.tag = 8;
        _txtAccessories.tag = 9;
    }
    if([strvehivcle isEqualToString:@"Motorcycle"])
    {
        [_txtBodyType setHidden:YES];
        [_txtstate setHidden:NO];
        [_txtOtherVehicle setHidden:YES];
        _txtRegistrationNo.placeholder = @"registration no * (max 10 chars)";
        _txtEngineNo.placeholder = @"engine no (min 13 chars)";
        _txtChassisNo.placeholder = @"VIN / chassis no (min 17 chars)";
        _txtMake.frame = CGRectMake(9, 60, 150, 30);
        _txtModel.frame = CGRectMake(161, 60, 150, 30);
        _txtRegistrationNo.frame = CGRectMake(9,100, 301, 30);
        _txtstate.frame = CGRectMake(9, 140, 301, 30);
        _txtEngineNo.frame = CGRectMake(9,180, 301, 30);
        _txtChassisNo.frame = CGRectMake(9, 220, 301, 30);
        _txtColor.frame = CGRectMake(9, 260, 301, 30);
        _txtAccessories.frame = CGRectMake(9, 300, 301, 30);
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtRegistrationNo.tag = 3;
        _txtstate.tag = 4;
        _txtEngineNo.tag = 5;
        _txtChassisNo.tag = 6;
        _txtColor.tag = 7;
        _txtAccessories.tag = 8;
        
    }

    [self cancelClicked];
}
-(void)doneBody_click:(id)sender
{
    [_pkvBodyType setHidden:YES];
    
    int row = [_pkvBodyType selectedRowInComponent:0];
 
    strBody = [_arrBodyType objectAtIndex:row];
    [_txtBodyType setText:[_arrBodyType objectAtIndex:row]];
    [_txtBodyType resignFirstResponder];
    [self cancelClicked];
    
}
-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark
#pragma mark - PickerView Methods...
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _pkvVehicleType)
    {
        return [_arrVehicleType count];
    }
    else if (pickerView == _pkvBodyType)
    {
        return [_arrBodyType count];
    }
    else
    {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _pkvVehicleType)
    {
        return [_arrVehicleType objectAtIndex:row];
    }
    else if (pickerView == _pkvBodyType)
    {
        return [_arrBodyType objectAtIndex:row];
    }
    else
    {
        return 0;
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _pkvVehicleType)
    {
       // [_btnVehiclesType setTitle:[_arrVehicleType objectAtIndex:row] forState:UIControlStateNormal];
    }
}

#pragma mark textfeild delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    activeTextField=textField;
    NSInteger nextTag = activeTextField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
  
    }
    return YES;
    
    
}
-(bool)textFieldShouldBeginEditing:(UITextField *)textField
{
     [textField setTextColor:[UIColor blackColor]];
    if(textField == _txtVehicleType)
    {
       
    }
    if (textField == _txtBodyType) {
         [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField setTextColor:[UIColor blackColor]];
    activeTextField=textField;
    [textField selectAll:self];
    if(textField == _txtVehicleType)
    {
        [_pkvVehicleType setHidden:NO];
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        _pkvVehicleType = [[UIPickerView alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        [_pkvVehicleType setDelegate:self];
        _pkvVehicleType.backgroundColor = [UIColor whiteColor];
        
        //format datePicker mode. in this example time is used
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor grayColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(done_click:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarPicker addSubview:bbitem];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:_pkvVehicleType];
        [sheet showInView:self.view];
        [sheet setBounds:CGRectMake(0,0,320, 464)];
    }
    if(textField == _txtBodyType)
    {
        [_pkvBodyType setHidden:NO];
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        _pkvBodyType = [[UIPickerView alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        [_pkvBodyType setDelegate:self];
        _pkvBodyType.backgroundColor = [UIColor whiteColor];
        
        //format datePicker mode. in this example time is used
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor grayColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(doneBody_click:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarPicker addSubview:bbitem];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:_pkvBodyType];
        [sheet showInView:self.view];
        [sheet setBounds:CGRectMake(0,0,320, 464)];
        [textField resignFirstResponder];
    }
    int y=0;
    // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,380,300,30)];
    if(textField == _txtstate)
    {
        y=150;
    }
    if(textField == _txtEngineNo)
    {
        y=170;
    }
    if(textField == _txtChassisNo)
    {
        y=200;
    }
    if(textField == _txtColor)
    {
        y=200;
    }
    if(textField == _txtAccessories)
    {
        y=200;
    }
   
    ////NSLog(@"y = %d",y);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
   // return YES;

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
       
    int y=0;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
}

#pragma mark toolbarr's button click event
- (IBAction)btnMinimize_Click:(id)sender
{
    [activeTextField resignFirstResponder];
    if([_txtVehicleType.text isEqualToString: @"Bicycle"])
    {
        _txtRegistrationNo.placeholder = @"serial no (max 13 chars)";

    }else if([_txtVehicleType.text isEqualToString: @"Other"])
    {
        _txtRegistrationNo.placeholder = @"registration no (max 10 chars)";
        
    }else{
        _txtRegistrationNo.placeholder = @"registration no * (max 10 chars)";
    }
    
}
- (IBAction)btnNext_Click:(id)sender
{
    if([strvehivcle isEqualToString:@"Bicycle"])
    {
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtRegistrationNo.tag = 3;
        _txtEngineNo.tag = 4;
        _txtChassisNo.tag = 5;
        _txtColor.tag = 6;
        _txtAccessories.tag = 7;
    }
    else if ([strvehivcle isEqualToString:@"Motorcycle"] || [strvehivcle isEqualToString:@"Other"])
    {
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtRegistrationNo.tag = 3;
        _txtstate.tag = 4;
        _txtEngineNo.tag = 5;
        _txtChassisNo.tag = 6;
        _txtColor.tag = 7;
        _txtAccessories.tag = 8;
    }
    else
    {
        _txtMake.tag = 1;
        _txtModel.tag = 2;
        _txtBodyType.tag = 3;
        _txtRegistrationNo.tag = 4;
        _txtstate.tag = 5;
        _txtEngineNo.tag = 6;
        _txtChassisNo.tag = 7;
        _txtColor.tag = 8;
        _txtAccessories.tag = 9;
    }
        
    NSInteger nextTag = activeTextField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
}
- (IBAction)btnPreviuse_Click:(id)sender
{
    NSInteger nextTag = activeTextField.tag-1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
    
    
    
}
#pragma mark call api
-(void)Callapi
{
    ////NSLog(@"in api");
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:UserID forKey:@"userId"];
    [param setValue:pin forKey:@"pin"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    if([strvehivcle isEqualToString:@"Other"])
    {
        [param setValue:_txtOtherVehicle.text forKey:@"vehicleType"];
    }
    else
    {
        [param setValue:strvehivcle forKey:@"vehicleType"];
    }
    [param setValue:_txtMake.text forKey:@"vehicleMake"];
    [param setValue:_txtModel.text forKey:@"vehicleModel"];
    [param setValue:strBody forKey:@"vehicleBodyType"];
    [param setValue:_txtRegistrationNo.text forKey:@"registrationSerialNo"];
    [param setValue:_txtEngineNo.text forKey:@"engineNo"];
    [param setValue:_txtChassisNo.text forKey:@"vinChassisNo"];
    [param setValue:_txtColor.text forKey:@"colour"];
    [param setValue:_txtAccessories.text forKey:@"uniqueFeatures"];
    [param setValue:_txtstate.text forKey:@"state"];
    [param setValue:OS_VERSION forKey:@"os"];
    [param setValue:MAKE forKey:@"make"];
    [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
    
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@addVehicle.php", SERVERNAME];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        ////NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
        ////NSLog(@"data : %@",jsonDictionary);
        
        NSString *EntityID = [jsonDictionary valueForKey:@"status"];
        ////NSLog(@"message %@",EntityID);
        if ([EntityID isEqualToString:@"success"])
        {
            VehicleProfilePageVC *vc = [[VehicleProfilePageVC alloc]init];
            appdelegate.strVehicleId = @"";
            appdelegate.strVehicleId = [[[jsonDictionary valueForKey:@"response"]objectAtIndex:0] valueForKey:@"vehicle_id"];
            vc.strVehicleId = [[[jsonDictionary valueForKey:@"response"]objectAtIndex:0] valueForKey:@"vehicle_id"] ;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
                                                                message:[jsonDictionary valueForKey:@"message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [CheckAlert show];
            
            
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ////NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];


}


@end
