//
//  VehicleProfilePageVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 01/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "VehicleProfilePageVC.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "UserProfileVC.h"
#import "AddInsuranceVC.h"
#import "AppDelegate.h"
#import "MyVehicleVC.h"
#import "EditVehicleVC.h"
#import "EditInsuranceVC.h"

@interface VehicleProfilePageVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation VehicleProfilePageVC
NSString *make;
NSString *model;
NSString *photo1,*photo2,*photo3;
NSString *insuranceCompanyName;
NSString *phoneNo;
NSInteger intImage;
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
    
    _btnEditInfo.layer.borderWidth=1.0f;
    _btnEditInfo.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    _btnDelete.layer.borderWidth=1.0f;
    _btnDelete.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _arrVehicle = [[NSDictionary alloc]init];
    _arrVehicle = [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
    
    NSLog(@"vehicle id :%@",_strVehicleId);
    NSLog(@"vehicle if:: %@",appDelegate.strVehicleId);
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    /*userId
     pin
     latitude
     longitude
     vehicleId
     make
     model
     os
*/
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Please connect to the internet to continue."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:UserID forKey:@"userId"];
    [param setValue:appDelegate.strVehicleId forKey:@"vehicleId"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    [param setValue:pin forKey:@"pin"];
   
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        @try {
            [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/getVehicleProfile.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSLog(@"url : %@",manager);
            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      
                      NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                      
                      NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                      NSLog(@"data : %@",jsonDictionary);
                      //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                      
                      //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      NSLog(@"Json dictionary :: %@",jsonDictionary);
                      NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                      NSLog(@"message %@",EntityID);
                      
                      
                      if ([EntityID isEqualToString:@"failure"])
                      {
                          
                      }
                      else
                      {
                          _lblAccessories.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"accessories_unique_features"];
                          _lblNodyType.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"body_type"];
                          _lblColor.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"colour"];
                          _lblEngineNo.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"engine_no"];
                          _lblMake2.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"make"];
                          make = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"make"];
                          //_lblMake.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"make"];
                          _lblModel.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"model"];
                          model = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"model"];
                          _lblModel2.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"model"];
                          _lblRegistrationNo.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"registration_serial_no"];
                          _lblStatus.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"status"];
                          _lblVehicleType.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"vehicle_type"];
                          _lblVin.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"vin_chasis_no"];
                          _lblCompanyName.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_company_name"];
                          _lblPolicyNo.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_policy_no"];
                          phoneNo = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_company_number"];
                          NSString *str1 = [make stringByAppendingString:@" "];
                          _lblMake1.text = [str1 stringByAppendingString:model];
                          _lblMake.text = [str1 stringByAppendingString:model];
                          photo1 = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"photo_1"];
                          photo2 = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"photo_2"];
                          photo3 = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"photo_3"];
                          insuranceCompanyName = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_company_name"];
                          
                          [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                          NSDate *str = [dateFormatter dateFromString:[[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_expiry_date"]];
                          
                          NSLog(@"date : %@",str);
                          NSString *date = [dateFormatter stringFromDate:str];
                          
                          NSLog(@"date1 : %@",date);
                          
                          
                          _lblExpiry.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_expiry_date"];
                          /*Bicycle
                           Car
                           Motor Cycle
                           Other*/
                          
                          if([_lblVehicleType.text isEqualToString:@"Bicycle"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_cycle.png"]];
                          }
                          else if ([_lblVehicleType.text isEqualToString:@"Car"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_car.png"]];
                          }
                          else if ([_lblVehicleType.text isEqualToString:@"Motor Cycle"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_bike.png"]];
                              
                          }
                          else if ([_lblVehicleType.text isEqualToString:@"Other"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
                          }
                          else
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
                          }
                          
                          if([_lblStatus.text isEqualToString:@""])
                          {
                              
                          }
                          else
                          {
                              [_imgStatus setImage:[UIImage imageNamed:@"incomplete.png"]];
                          }
                          
                          if([_lblCompanyName.text isEqualToString:@""])
                          {
                              [_view4 setHidden:YES];
                              [_view4 setAlpha:0];
                          }
                          else
                          {
                              [_view4 setAlpha:1];
                              [_view4 setHidden:NO];
                          }
                          
                          if([_lblCompanyName.text isEqualToString:@""])
                          {
                              [_btnAddInsurance setTitle:@"Add Insurance" forState:UIControlStateNormal];
                              // [_btnAddInsurance setBackgroundColor:[UIColor blueColor]];
                          }
                          else
                          {
                              [_btnAddInsurance setTitle:@"Edit Insurance" forState:UIControlStateNormal];
                              [_btnAddInsurance setBackgroundColor:[UIColor whiteColor]];
                              _btnAddInsurance.layer.borderWidth=1.0f;
                              
                              _btnAddInsurance.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                              _btnAddInsurance.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                              [_btnAddInsurance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                              
                          }
                          
                      }
                      [SVProgressHUD dismiss];
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                  }];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }
        @catch (NSException *exception) {
            [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/getVehicleProfile.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSLog(@"url : %@",manager);
            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      
                      NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                      
                      NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                      NSLog(@"data : %@",jsonDictionary);
                      //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                      
                      //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      NSLog(@"Json dictionary :: %@",jsonDictionary);
                      NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                      NSLog(@"message %@",EntityID);
                      
                      
                      if ([EntityID isEqualToString:@"failure"])
                      {
                          
                      }
                      else
                      {
                          _lblAccessories.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"accessories_unique_features"];
                          _lblNodyType.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"body_type"];
                          _lblColor.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"colour"];
                          _lblEngineNo.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"engine_no"];
                          _lblMake2.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"make"];
                          make = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"make"];
                          //_lblMake.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"make"];
                          _lblModel.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"model"];
                          model = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"model"];
                          _lblModel2.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"model"];
                          _lblRegistrationNo.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"registration_serial_no"];
                          _lblStatus.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"status"];
                          _lblVehicleType.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"vehicle_type"];
                          _lblVin.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"vin_chasis_no"];
                          _lblCompanyName.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_company_name"];
                          _lblPolicyNo.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_policy_no"];
                          phoneNo = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_company_number"];
                          NSString *str1 = [make stringByAppendingString:@" "];
                          _lblMake1.text = [str1 stringByAppendingString:model];
                          _lblMake.text = [str1 stringByAppendingString:model];
                          photo1 = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"photo_1"];
                          photo2 = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"photo_2"];
                          photo3 = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"photo_3"];
                          insuranceCompanyName = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_company_name"];
                          
                          [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                          NSDate *str = [dateFormatter dateFromString:[[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_expiry_date"]];
                          
                          NSLog(@"date : %@",str);
                          NSString *date = [dateFormatter stringFromDate:str];
                          
                          NSLog(@"date1 : %@",date);
                          
                          
                          _lblExpiry.text = [[[jsonDictionary valueForKey:@"response" ] objectAtIndex:0] valueForKey:@"insurance_expiry_date"];
                          /*Bicycle
                           Car
                           Motor Cycle
                           Other*/
                          
                          if([_lblVehicleType.text isEqualToString:@"Bicycle"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_cycle.png"]];
                          }
                          else if ([_lblVehicleType.text isEqualToString:@"Car"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_car.png"]];
                          }
                          else if ([_lblVehicleType.text isEqualToString:@"Motor Cycle"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_bike.png"]];
                              
                          }
                          else if ([_lblVehicleType.text isEqualToString:@"Other"])
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
                          }
                          else
                          {
                              [_imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
                          }
                          
                          if([_lblStatus.text isEqualToString:@""])
                          {
                              
                          }
                          else
                          {
                              [_imgStatus setImage:[UIImage imageNamed:@"incomplete.png"]];
                          }
                          
                          if([_lblCompanyName.text isEqualToString:@""])
                          {
                              [_view4 setHidden:YES];
                              [_view4 setAlpha:0];
                          }
                          else
                          {
                              [_view4 setAlpha:1];
                              [_view4 setHidden:NO];
                          }
                          
                          if([_lblCompanyName.text isEqualToString:@""])
                          {
                              [_btnAddInsurance setTitle:@"Add Insurance" forState:UIControlStateNormal];
                              // [_btnAddInsurance setBackgroundColor:[UIColor blueColor]];
                          }
                          else
                          {
                              [_btnAddInsurance setTitle:@"Edit Insurance" forState:UIControlStateNormal];
                              [_btnAddInsurance setBackgroundColor:[UIColor whiteColor]];
                              _btnAddInsurance.layer.borderWidth=1.0f;
                              
                              _btnAddInsurance.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                              _btnAddInsurance.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                              [_btnAddInsurance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                              
                          }
                          
                      }
                      [SVProgressHUD dismiss];
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                  }];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }
        @finally {
            
        }
        
    }
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

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark camera click
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        intImage = 2;
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = (id)self;
        //[_btnprofilePic setBackgroundImage:controller forState:UIControlStateNormal];
        
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        intImage =1;
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = (id)self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    [_imgvehicle1 setImage:image];
    [_btnPhoto1 setImage:image forState:UIControlStateNormal];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    
    [param setValue:UserID forKey:@"userId"];
    //   // [param setValue:@"1111" forKey:@"pin"];
    
    
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    
    [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/uploadProfilePic.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"profilePic.png" mimeType:@"image/png"];
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
         NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
         NSLog(@"data : %@",jsonDictionary);
         
         NSString *EntityID = [jsonDictionary valueForKey:@"status"];
         NSLog(@"message %@",EntityID);
         if ([EntityID isEqualToString:@"failure"])
         {
             UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Couldn't finish"
                                                                 message:@"Image has not been uploaded."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
             [CheckAlert show];
         }
         else
         {
             NSString *photo_url = [jsonDictionary valueForKey:@"response"] ;
             [[NSUserDefaults standardUserDefaults] setValue:photo_url forKey:@"photo_url"];
             NSArray *parts = [photo_url componentsSeparatedByString:@"/"];
             NSString *filename = [parts objectAtIndex:[parts count]-1];
             NSLog(@"file name : %@",filename);
             
             NSString *str = @"My_Wheels_";
             NSString *strFileName = [str stringByAppendingString:filename];
             NSLog(@"strfilename : %@",strFileName);
             // Store the data
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             
             [defaults setObject:imageData forKey:strFileName];
             [defaults synchronize];
             
             //  UIImage *contactImage = [UIImage imageWithData:imageData];
             _imgvehicle1.image = [UIImage imageWithData:imageData];
             
             
             
         }
         
         [SVProgressHUD dismiss];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@ ***** %@", operation.responseString, error);
     }];
    
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (error != nil)
    {
        NSLog(@"Image Can not be saved");
    }
    else
    {
        NSLog(@"Successfully saved Image");
    }
}

#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnAdd_click:(id)sender
{

}
-(IBAction)btnAddInsurance_click:(id)sender
{
    
    
    if([_lblCompanyName.text isEqualToString:@""])
    {
        AddInsuranceVC *vc = [[AddInsuranceVC alloc]init];
        vc.strmake = make;
        vc.strModel = model;
        vc.strVehicleType = _lblVehicleType.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        EditInsuranceVC *vc = [[EditInsuranceVC alloc]init];
        vc.strCompanyName = _lblCompanyName.text;
        vc.strPhoneNo = phoneNo;
        vc.strPolicyNo = _lblPolicyNo.text;
        vc.strExpiry = _lblExpiry.text;
        vc.strmake = make;
        vc.strModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
-(IBAction)btnEditInfo_click:(id)sender
{
    EditVehicleVC *vc = [[EditVehicleVC alloc]init];
    
    vc.strVehicleID = appDelegate.strVehicleId;
    vc.strVehicleType = _lblVehicleType.text;
    vc.strMake = _lblMake2.text;
    vc.strModel = _lblModel2.text;
    vc.strBodyType = _lblNodyType.text;
    vc.strRegistrationNo = _lblRegistrationNo.text;
    vc.strEngineNo = _lblEngineNo.text;
    vc.strVIN = _lblVin.text;
    vc.strColour = _lblColor.text;
    vc.strAccessories = _lblAccessories.text;
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnDelete_click:(id)sender
{
    
    UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Delete Vehicle ?"
                                                        message:@"Do you really want to delete this vehicle ? All information stored will be lost."
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO", nil];
    CheckAlert.tag = 1;
    
    [CheckAlert show];
}
-(IBAction)btnAddPhoto_click:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo",
                            @"Choose Existing",
                            
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)btnAddPhoto1_click:(id)sender
{

}
-(IBAction)btnAddPhoto2_click:(id)sender
{

}
-(IBAction)btnAddPhoto3_click:(id)sender
{

}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable) {
                NSLog(@"There IS NO internet connection");
                UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                    message:@"Please connect to the internet to continue."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                [CheckAlert show];
            }
            else
            {
                /*
                 userId
                 vehicleId
                 photosExist (0 / 1)
                 insuranceDetailsExist (0 / 1)
                 additionalDetailsExist (0 / 1)
                 noVehicles (including this one)
                 profileCompleteness
                 os
                 make
                 model
                 [[NSUserDefaults standardUserDefaults] setValue:strVehicleId forKey:@"CurrentVehicleID"];
                 [[NSUserDefaults standardUserDefaults] setValue:str2 forKey:@"CurrentVehicleName"];

                 */
                NSString *vid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
//                NSString *vname = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleName"];
                
                
                
                NSMutableArray  *arr = [[NSMutableArray alloc]init];
                arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"] mutableCopy];
                
                NSLog(@"arr : %@",arr);
                NSLog(@"current vehicle id : %@",appDelegate.strVehicleId);
                for(int i=0;i< [arr count];i++)
                {
                    NSString *veh = [[arr objectAtIndex:i] valueForKey:@"vehicle_id"];
                    NSLog(@"veh : %@",veh);
                    if(veh == appDelegate.strVehicleId)
                    {
                        if([arr count] == 1)
                        {
                            [arr removeObjectAtIndex:0];
                        }
                        else
                        {
                            [arr removeObjectAtIndex:i];
                        }
                        
                        
                        
                    }
                    if(veh == vid)
                    {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
                    }
                    
                }
                 [[NSUserDefaults standardUserDefaults] setValue:arr forKey:@"vehicles"];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
                NSLog(@"dixt : %@",dic);
                
                NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
                NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
                NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
                NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
                NSString *profile_completed = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_completed"];
                NSString *licence = [[NSUserDefaults standardUserDefaults] objectForKey:@"license_no"];
                NSLog(@"profile complete :: %@",profile_completed);
                
                UIApplication *app = [UIApplication sharedApplication];
                NSArray *eventArray = [app scheduledLocalNotifications];
                for (int i=0; i<[eventArray count]; i++)
                {
                    UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
                    NSDictionary *userInfoCurrent = oneEvent.userInfo;
                    NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"vehicle_id"]];
                    if ([uid isEqualToString:appDelegate.strVehicleId])
                    {
                        //Cancelling local notification
                        [app cancelLocalNotification:oneEvent];
                        break;
                    }
                }

                NSLog(@"There IS internet connection");
                NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
                [param setValue:UserID forKey:@"userId"];
                [param setValue:appDelegate.strVehicleId forKey:@"vehicleId"];
                [param setValue:latitude forKey:@"latitude"];
                [param setValue:longitude forKey:@"longitude"];
                [param setValue:pin forKey:@"pin"];
                if( [photo1 isEqualToString:@""] &&  [photo1 isEqualToString:@""] &&  [photo1 isEqualToString:@""])
                {
                    [param setValue:@"0" forKey:@"photosExist"];
                }
                else
                {
                    [param setValue:@"1" forKey:@"photosExist"];
                }
                if([insuranceCompanyName isEqualToString:@""])
                {
                    [param setValue:@"0" forKey:@"insuranceDetailsExist"];
                }
                else
                {
                    [param setValue:@"1" forKey:@"insuranceDetailsExist"];
                }
                if([licence isEqualToString:@""])
                {
                    [param setValue:@"0" forKey:@"additionalDetailsExist"];
                }
                else
                {
                    [param setValue:@"1" forKey:@"additionalDetailsExist"];
                }
                NSInteger countVehivle = [_arrVehicle count];
                NSString *strCount = [NSString stringWithFormat:@"%d",countVehivle];
                
                 [param setValue:strCount forKey:@"noVehicles"];
                [param setValue:profile_completed forKey:@"profileCompleteness"];
                
                [param setValue:@"ios7" forKey:@"os"];
                [param setValue:@"iPhone" forKey:@"make"];
                [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/deleteVehicle.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSLog(@"url : %@",manager);
                }
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          
                          NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                          
                          NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                          NSLog(@"data : %@",jsonDictionary);
                          //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                          
                          //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                          NSLog(@"Json dictionary :: %@",jsonDictionary);
                          NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                          NSLog(@"message %@",EntityID);
                          NSString *message = [jsonDictionary valueForKey:@"message"];
                          
                          if ([EntityID isEqualToString:@"failure"])
                          {
                              UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:nil
                                                                                  message:message
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"OK"
                                                                        otherButtonTitles:nil, nil];
                              CheckAlert.tag = 1;
                              
                              [CheckAlert show];
                          }
                          else
                          {
                              MyVehicleVC *vc = [[MyVehicleVC alloc]init];
                             
                              [self.navigationController pushViewController:vc animated:YES];
                              
                              
                          }
                          [SVProgressHUD dismiss];
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                      }];
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            }

        }
        else
        {
            
        }
    }
}


@end
