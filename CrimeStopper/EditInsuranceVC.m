//
//  EditInsuranceVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 04/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "EditInsuranceVC.h"
#import "VehicleProfilePageVC.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface EditInsuranceVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation EditInsuranceVC
NSString *strDate;
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
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication ]delegate];
    ////NSLog(@"date :%@",_txtExpiry.text);
   
    ////NSLog(@"strvehicleId : %@",appdelegate.strVehicleId);
    if([_strVehicleType isEqualToString:@"Bicycle"])
    {
        _arrinsurance = [[NSMutableArray alloc]init];
        [_arrinsurance addObject:@"1Cover"];
        [_arrinsurance addObject:@"AAMI"];
        [_arrinsurance addObject:@"Allianz"];
        [_arrinsurance addObject:@"APIA"];
        [_arrinsurance addObject:@"Budget Direct"];
        [_arrinsurance addObject:@"Bupa/HBA"];
        [_arrinsurance addObject:@"CGU"];
        [_arrinsurance addObject:@"Coles"];
        [_arrinsurance addObject:@"CommInsure"];
        [_arrinsurance addObject:@"COTA"];
        [_arrinsurance addObject:@"Elders"];
        [_arrinsurance addObject:@"GIO"];
        [_arrinsurance addObject:@"NAB"];
        [_arrinsurance addObject:@"NRMA"];
        [_arrinsurance addObject:@"People’s Choice"];
        [_arrinsurance addObject:@"QBE"];
        [_arrinsurance addObject:@"RAA"];
        [_arrinsurance addObject:@"RAC"];
        [_arrinsurance addObject:@"RACT"];
        [_arrinsurance addObject:@"RACQ"];
        [_arrinsurance addObject:@"RACV"];
        [_arrinsurance addObject:@"SGIC"];
        [_arrinsurance addObject:@"SGIO"];
        [_arrinsurance addObject:@"Shannons"];
        [_arrinsurance addObject:@"St George"];
        [_arrinsurance addObject:@"Suncorp"];
        [_arrinsurance addObject:@"TIO"];
        [_arrinsurance addObject:@"Westpac"];
        [_arrinsurance addObject:@"Woolworths"];
        [_arrinsurance addObject:@"Youi"];
        [_arrinsurance addObject:@"BikeSure"];
        [_arrinsurance addObject:@"CycleCover"];
        [_arrinsurance addObject:@"RealBike"];
        [_arrinsurance addObject:@"Velosure"];
        [_arrinsurance addObject:@"Other"];
    }
    else
    {
        _arrinsurance = [[NSMutableArray alloc]init];
        [_arrinsurance addObject:@"1Cover"];
        [_arrinsurance addObject:@"AAMI"];
        [_arrinsurance addObject:@"Allianz"];
        [_arrinsurance addObject:@"APIA"];
        [_arrinsurance addObject:@"Budget Direct"];
        [_arrinsurance addObject:@"Bupa/HBA"];
        [_arrinsurance addObject:@"CGU"];
        [_arrinsurance addObject:@"Coles"];
        [_arrinsurance addObject:@"CommInsure"];
        [_arrinsurance addObject:@"COTA"];
        [_arrinsurance addObject:@"Elders"];
        [_arrinsurance addObject:@"GIO"];
        [_arrinsurance addObject:@"NAB"];
        [_arrinsurance addObject:@"NRMA"];
        [_arrinsurance addObject:@"People’s Choice"];
        [_arrinsurance addObject:@"QBE"];
        [_arrinsurance addObject:@"RAA"];
        [_arrinsurance addObject:@"RAC"];
        [_arrinsurance addObject:@"RACT"];
        [_arrinsurance addObject:@"RACQ"];
        [_arrinsurance addObject:@"RACV"];
        [_arrinsurance addObject:@"SGIC"];
        [_arrinsurance addObject:@"SGIO"];
        [_arrinsurance addObject:@"Shannons"];
        [_arrinsurance addObject:@"St George"];
        [_arrinsurance addObject:@"Suncorp"];
        [_arrinsurance addObject:@"TIO"];
        [_arrinsurance addObject:@"Westpac"];
        [_arrinsurance addObject:@"Woolworths"];
        [_arrinsurance addObject:@"Youi"];
        
        [_arrinsurance addObject:@"Other"];
    }
    
    
    if([_strVehicleType isEqualToString:@"Bicycle"])
    {
        _arrTelephone = [[NSMutableArray alloc]init];
        [_arrTelephone addObject:@"1300 885 996"];
        [_arrTelephone addObject:@"13 22 44"];
        [_arrTelephone addObject:@"13 10 13"];
        [_arrTelephone addObject:@"1300 301 799"];
        [_arrTelephone addObject:@"1300 139 591"];
        [_arrTelephone addObject:@"13 41 35"];
        [_arrTelephone addObject:@"13 24 80"];
        [_arrTelephone addObject:@"1300 265 374"];
        [_arrTelephone addObject:@"13 24 23"];
        [_arrTelephone addObject:@"1300 1300 50"];
        [_arrTelephone addObject:@"1300 554 184"];
        [_arrTelephone addObject:@"13 14 46"];
        [_arrTelephone addObject:@"1300 555 013"];
        [_arrTelephone addObject:@"13 11 23"];
        [_arrTelephone addObject:@"13 11 82"];
        [_arrTelephone addObject:@"13 37 23"];
        [_arrTelephone addObject:@"08 8202 4575"];
        [_arrTelephone addObject:@"13 17 03"];
        [_arrTelephone addObject:@"13 27 22"];
        [_arrTelephone addObject:@"13 72 02"];
        [_arrTelephone addObject:@"13 19 03"];
        [_arrTelephone addObject:@"13 32 33"];
        [_arrTelephone addObject:@"13 32 33"];
        [_arrTelephone addObject:@"13 46 46"];
        [_arrTelephone addObject:@"13 15 32"];
        [_arrTelephone addObject:@"13 25 24"];
        [_arrTelephone addObject:@"1300 301 833"];
        [_arrTelephone addObject:@"1800 805 458"];
        [_arrTelephone addObject:@"1300 10 1234"];
        [_arrTelephone addObject:@"13 96 84"];
        [_arrTelephone addObject:@"1300 441 543"];
        [_arrTelephone addObject:@"1300 733 055"];
        [_arrTelephone addObject:@"1300 277 002"];
        [_arrTelephone addObject:@"1300 835 678"];
        [_arrTelephone addObject:@""];
    }
    else
    {
        _arrTelephone = [[NSMutableArray alloc]init];
        [_arrTelephone addObject:@"1300 885 996"];
        [_arrTelephone addObject:@"13 22 44"];
        [_arrTelephone addObject:@"13 10 13"];
        [_arrTelephone addObject:@"1300 301 799"];
        [_arrTelephone addObject:@"1300 139 591"];
        [_arrTelephone addObject:@"13 41 35"];
        [_arrTelephone addObject:@"13 24 80"];
        [_arrTelephone addObject:@"1300 265 374"];
        [_arrTelephone addObject:@"13 24 23"];
        [_arrTelephone addObject:@"1300 1300 50"];
        [_arrTelephone addObject:@"1300 554 184"];
        [_arrTelephone addObject:@"13 14 46"];
        [_arrTelephone addObject:@"1300 555 013"];
        [_arrTelephone addObject:@"13 11 23"];
        [_arrTelephone addObject:@"13 11 82"];
        [_arrTelephone addObject:@"13 37 23"];
        [_arrTelephone addObject:@"08 8202 4575"];
        [_arrTelephone addObject:@"13 17 03"];
        [_arrTelephone addObject:@"13 27 22"];
        [_arrTelephone addObject:@"13 72 02"];
        [_arrTelephone addObject:@"13 19 03"];
        [_arrTelephone addObject:@"13 32 33"];
        [_arrTelephone addObject:@"13 32 33"];
        [_arrTelephone addObject:@"13 46 46"];
        [_arrTelephone addObject:@"13 15 32"];
        [_arrTelephone addObject:@"13 25 24"];
        [_arrTelephone addObject:@"1300 301 833"];
        [_arrTelephone addObject:@"1800 805 458"];
        [_arrTelephone addObject:@"1300 10 1234"];
        [_arrTelephone addObject:@"13 96 84"];
        
        [_arrTelephone addObject:@""];
        
    }
    [self.txtPhoneNo setDelegate:self];
    [self.txtPolicyNo setDelegate:self];
    [self.txtCompanyName setDelegate:self];
    [self.txtExpiry setDelegate:self];
    
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    
    [self.txtPhoneNo setInputAccessoryView:self.toolbar];
    [self.txtPolicyNo setInputAccessoryView:self.toolbar];
    
    if(IsIphone5)
    {
        _scroll.frame = CGRectMake(0 , 58, 320, 568+50);
        _scroll.contentSize = CGSizeMake(320, 700);
    }
    else
    {
        _scroll.frame = CGRectMake(0 , 58, 320, 568+50);
        
        _scroll.contentSize = CGSizeMake(320, 700);
    }
    
    if([_strCompanyName isEqualToString:@"1Cover"] || [_strCompanyName isEqualToString:@"AAMI"] || [_strCompanyName isEqualToString:@"Allianz"] || [_strCompanyName isEqualToString:@"APIA"] || [_strCompanyName isEqualToString:@"Budget Direct"] || [_strCompanyName isEqualToString:@"Bupa/HBA"] || [_strCompanyName isEqualToString:@"CGU"] || [_strCompanyName isEqualToString:@"Coles"] || [_strCompanyName isEqualToString:@"CommInsure"] || [_strCompanyName isEqualToString:@"COTA"] || [_strCompanyName isEqualToString:@"Elders"] || [_strCompanyName isEqualToString:@"GIO"]|| [_strCompanyName isEqualToString:@"NAB"] || [_strCompanyName isEqualToString:@"NRMA"] || [_strCompanyName isEqualToString:@"People’s Choice"] || [_strCompanyName isEqualToString:@"QBE"] || [_strCompanyName isEqualToString:@"RAA"] || [_strCompanyName isEqualToString:@"RACT"] || [_strCompanyName isEqualToString:@"RACQ"] || [_strCompanyName isEqualToString:@"RACV"] || [_strCompanyName isEqualToString:@"SGIC"] || [_strCompanyName  isEqualToString:@"Shannons"] || [_strCompanyName isEqualToString:@"St George"] || [_strCompanyName isEqualToString:@"Suncorp"] || [_strCompanyName isEqualToString:@"TIO"] || [_strCompanyName isEqualToString:@"Westpac"] || [_strCompanyName isEqualToString:@"Woolworths"] || [_strCompanyName isEqualToString:@"Youi"] || [_strCompanyName isEqualToString:@"BikeSure"] ||  [_strCompanyName isEqualToString:@"CycleCover"] || [_strCompanyName isEqualToString:@"RealBike"] || [_strCompanyName isEqualToString:@"Velosure"])
    {
        [_txtOtherInsurance setHidden:YES];
        _txtCompanyName.text = _strCompanyName;
    }
    else
    {
        _txtOtherInsurance  = [[UITextField alloc] initWithFrame:CGRectMake(9,48,301,30)];
        //txtAnswer  = [[UITextField alloc] initWithFrame:CGRectMake(5,400,300,30)];
        [self.view addSubview:_txtOtherInsurance];
        _txtOtherInsurance.borderStyle = UITextBorderStyleRoundedRect;
        _txtOtherInsurance.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
        _txtOtherInsurance.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:17];
        _txtOtherInsurance.keyboardType = UIKeyboardTypeDefault;
        _txtOtherInsurance.returnKeyType = UIReturnKeyDefault;
        
        _txtOtherInsurance.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtOtherInsurance.placeholder = @"specify vehicle insurance company";
        _txtOtherInsurance.tag = 2;
        _txtOtherInsurance.delegate = self;
        [_txtOtherInsurance setInputAccessoryView:self.toolbar];
        
        [self.scroll addSubview:_txtOtherInsurance];
        _txtCompanyName.frame = CGRectMake(9, 8, 301, 30);
        _txtPhoneNo.frame = CGRectMake(9, 88, 301, 30);
        _txtPolicyNo.frame =  CGRectMake(9, 128, 301, 30);
        _txtExpiry .frame = CGRectMake(9, 168, 301, 30);
        
        _txtCompanyName.text = @"Other";
        _txtOtherInsurance.text = _strCompanyName;
    }
    _txtPolicyNo.text = _strPolicyNo;
    _txtPhoneNo.text = _strPhoneNo;
    ////NSLog(@"strexpiry : %@",_strExpiry);
    if([_strExpiry isEqualToString:@""])
    {
        _txtExpiry.placeholder = @"expiry";
    }
    else
    {
         _txtExpiry.text = _strExpiry;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    VehicleProfilePageVC *vc = [[VehicleProfilePageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark selector method
- (void)DOBChanged:(id)sender
{
    // NSString *str = nss
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [_txtExpiry setText:[dateFormatter stringFromDate:timePicker.date]];
    _txtExpiry.userInteractionEnabled = NO;
    if([_txtExpiry.text isEqualToString:@""])
    {
        strDate = @"0000-00-00";
        ////NSLog(@"strdate : %@",strDate);
    }
    else
    {
        strDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timePicker.date]];
        ////NSLog(@"strdate : %@",strDate);
    }
    [self cancelClicked];
    
}
-(void)done_click:(id)sender
{
    [_pkvInsurance setHidden:YES];
    
    int row = [_pkvInsurance selectedRowInComponent:0];
    //  self.strPrintRepeat = [_pkvVehicleType objectAtIndex:row];
    [_txtCompanyName setText:[_arrinsurance objectAtIndex:row]];
    [_txtPhoneNo setText:[_arrTelephone objectAtIndex:row]];
  
    NSString *strInsurance = [_arrinsurance objectAtIndex:row];
    ////NSLog(@"strInsurance : %@",strInsurance);
    if([strInsurance isEqualToString:@"1Cover"] || [strInsurance isEqualToString:@"AAMI"] || [strInsurance isEqualToString:@"Allianz"] || [strInsurance isEqualToString:@"APIA"] || [strInsurance isEqualToString:@"Budget Direct"] || [strInsurance isEqualToString:@"Bupa/HBA"] || [strInsurance isEqualToString:@"CGU"] || [strInsurance isEqualToString:@"Coles"] || [strInsurance isEqualToString:@"CommInsure"] || [strInsurance isEqualToString:@"COTA"] || [strInsurance isEqualToString:@"Elders"] || [strInsurance isEqualToString:@"GIO"]|| [strInsurance isEqualToString:@"NAB"] || [strInsurance isEqualToString:@"NRMA"] || [strInsurance isEqualToString:@"People’s Choice"] || [strInsurance isEqualToString:@"QBE"] || [strInsurance isEqualToString:@"RAA"] || [strInsurance isEqualToString:@"RACT"] || [strInsurance isEqualToString:@"RACQ"] || [strInsurance isEqualToString:@"RACV"] || [strInsurance isEqualToString:@"SGIC"] || [strInsurance  isEqualToString:@"Shannons"] || [strInsurance isEqualToString:@"St George"] || [strInsurance isEqualToString:@"Suncorp"] || [strInsurance isEqualToString:@"TIO"] || [strInsurance isEqualToString:@"Westpac"] || [strInsurance isEqualToString:@"Woolworths"] || [strInsurance isEqualToString:@"Youi"] || [strInsurance isEqualToString:@"BikeSure"] ||  [strInsurance isEqualToString:@"CycleCover"] || [strInsurance isEqualToString:@"RealBike"] || [strInsurance isEqualToString:@"Velosure"])
    {
        _txtOtherInsurance.text = @"";
        [_txtOtherInsurance setHidden:YES];
        
        _txtCompanyName.text = strInsurance;
        _txtCompanyName.frame = CGRectMake(9, 8, 301, 30);
        _txtPhoneNo.frame = CGRectMake(9, 48, 301, 30);
        _txtPolicyNo.frame =  CGRectMake(9, 88, 301, 30);
        _txtExpiry .frame = CGRectMake(9, 128, 301, 30);
    }
    else
    {
        
        _txtOtherInsurance  = [[UITextField alloc] initWithFrame:CGRectMake(9,48,301,30)];
        //txtAnswer  = [[UITextField alloc] initWithFrame:CGRectMake(5,400,300,30)];
        [self.view addSubview:_txtOtherInsurance];
        _txtOtherInsurance.borderStyle = UITextBorderStyleRoundedRect;
        _txtOtherInsurance.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
        _txtOtherInsurance.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15];
        _txtOtherInsurance.keyboardType = UIKeyboardTypeDefault;
        _txtOtherInsurance.returnKeyType = UIReturnKeyDefault;
        
        _txtOtherInsurance.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtOtherInsurance.placeholder = @"specify vehicle insurance company*";
        _txtOtherInsurance.tag = 2;
        _txtOtherInsurance.delegate = self;
        [_txtOtherInsurance setInputAccessoryView:self.toolbar];
        
        [self.scroll addSubview:_txtOtherInsurance];
        _txtCompanyName.frame = CGRectMake(9, 8, 301, 30);
        _txtPhoneNo.frame = CGRectMake(9, 88, 301, 30);
        _txtPolicyNo.frame =  CGRectMake(9, 128, 301, 30);
        _txtExpiry .frame = CGRectMake(9, 168, 301, 30);
        
        _txtCompanyName.text = @"Other";
        _txtOtherInsurance.text = @"";
    }

    
    if([strInsurance isEqualToString:@"Budget Direct"] && [ _strVehicleType isEqualToString:@"Bicycle"])
    {
        [_txtPhoneNo setText:@"1800 069 336"];
        
    }
    if([strInsurance isEqualToString:@"QBE"] && [ _strVehicleType isEqualToString:@"Motorcycle"])
    {
        [_txtPhoneNo setText:@"1300 365 354"];
    }
    if([strInsurance isEqualToString:@"St George"] && [ _strVehicleType isEqualToString:@"Bicycle"])
    {
        [_txtPhoneNo setText:@"1300 655 489"];
    }
    if([strInsurance isEqualToString:@"Westpac"] && [ _strVehicleType isEqualToString:@"Bicycle"])
    {
        [_txtPhoneNo setText:@"1800 369 989"];
    }
    //1Cover
    if([strInsurance isEqualToString:@"1Cover"] && [ _strVehicleType isEqualToString:@"Bicycle"])
    {
        [_txtPhoneNo setText:@"1800 611 422"];
    }
    [self cancelClicked];
    
    
    
}


-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}
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
        ////NSLog(@"There IS internet connection");
        
        if([_txtCompanyName.text isEqualToString:@"Other"])
        {
            if(_txtOtherInsurance.text.length == 0)
            {
                [_txtOtherInsurance setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
        }
        
        if (_txtCompanyName.text.length==0 || _txtPhoneNo.text.length==0 || _txtPolicyNo.text.length==0 )
        {
            
            
            if (_txtPolicyNo.text.length == 0)
            {
                [_txtPolicyNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtCompanyName.text.length == 0)
            {
                [_txtCompanyName setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_txtPhoneNo.text.length == 0)
            {
                [_txtPhoneNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            
            
        }
      
        else if (_txtPolicyNo.text.length>0 && _txtPolicyNo.text.length <3)
        {
            [_txtPolicyNo setTextColor:[UIColor redColor]];
        }
      
        else if (_txtCompanyName.text.length == 0)
        {
            [_txtCompanyName setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else if (_txtPhoneNo.text.length == 0)
        {
            [_txtPhoneNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        
        else
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
             [param setValue:_txtPhoneNo.text forKey:@"insuranceCompanyNumber"];
            if([_txtCompanyName.text isEqualToString:@"Other"])
            {
                [param setValue:_txtOtherInsurance.text forKey:@"insuranceCompanyName"];
            }
            else
            {
                [param setValue:_txtCompanyName.text forKey:@"insuranceCompanyName"];
            }
            [param setValue:_txtPolicyNo.text forKey:@"insurancePolicyNumber"];
            
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate *date = [dateFormatter dateFromString:_txtExpiry.text];
            ////NSLog(@"expiry date : %@",date);
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strdat = [dateFormatter stringFromDate:date];
            [param setValue:strdat forKey:@"insuranceExpiryDate"];
            [param setValue:appdelegate.strVehicleId forKey:@"vehicleId"];
            [param setValue:OS_VERSION forKey:@"os"];
            [param setValue:MAKE forKey:@"make"];
            [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
            
            // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
             NSString *url = [NSString stringWithFormat:@"%@editVehicleInsurance.php", SERVERNAME];
            
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
                    // vc.strVehicleId = [[[jsonDictionary valueForKey:@"response"]objectAtIndex:0] valueForKey:@"vehicle_id"] ;
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
    }
    
}
#pragma mark toolbarr's button click event
- (IBAction)btnMinimize_Click:(id)sender
{
    [activeTextField resignFirstResponder];
}
- (IBAction)btnNext_Click:(id)sender
{
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
#pragma mark textfield delegate methods
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    activeTextField=textField;
    [textField setTextColor:[UIColor blackColor]];
    if(textField == _txtCompanyName)
    {
        [_txtCompanyName resignFirstResponder];
        [_pkvInsurance setHidden:NO];
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        _pkvInsurance = [[UIPickerView alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        [_pkvInsurance setDelegate:self];
        _pkvInsurance.backgroundColor = [UIColor whiteColor];
        
        //format datePicker mode. in this example time is used
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor grayColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(done_click:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarPicker addSubview:bbitem];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:_pkvInsurance];
        [sheet showInView:self.view];
        [sheet setBounds:CGRectMake(0,0,320, 464)];
    }
    if(textField == _txtExpiry)
    {
        // Open DatePicker when age textfield is clicked
        _txtExpiry.text = @"";
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        timePicker.backgroundColor = [UIColor whiteColor];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        timePicker.minimumDate = [NSDate date];
        
        
        //format datePicker mode. in this example time is used
        timePicker.datePickerMode = UIDatePickerModeDate;
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor grayColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(DOBChanged:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarPicker addSubview:bbitem];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:timePicker];
        [sheet showInView:self.view];
        
        NSDate *sevenDaysAgo = [timePicker.date dateByAddingTimeInterval:-7*24*60*60];
        [sheet setBounds:CGRectMake(0,0,320, 464)];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = sevenDaysAgo;
        NSString *str = [@"Insurance for " stringByAppendingString:_strmake];
        NSString *str1 = [str stringByAppendingString:@" "];
        NSString *str2= [str1 stringByAppendingString:_strModel];
        NSString *str3 = [str2 stringByAppendingString:@" is expire for service in a week"];
        
        localNotification.alertBody = str3;
        localNotification.alertAction = @"Reminder";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        // Request to reload table view data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
        [textField resignFirstResponder];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark
#pragma mark - PickerView Methods...
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _pkvInsurance)
    {
        return [_arrinsurance count];
    }
    
    else
    {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _pkvInsurance)
    {
        return [_arrinsurance objectAtIndex:row];
        
    }
    
    else
    {
        return 0;
    }
    
}

@end
