//
//  UserProfileVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 24/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "UserProfileVC.h"
#import "HomePageVC.h"
#import "THProgressView.h"
#import "AddDetailsVC.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "EditDetailsVC.h"
#import "AddVehiclesVC.h"
#import "AddInsuranceVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "MyVehicleVC.h"

NSInteger intImage;
@interface UserProfileVC ()
{
    AppDelegate *appDelegate;
}
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *progressViews;
@end

@implementation UserProfileVC
@synthesize customActionSheetView;
NSDate *datedob;
NSString *dob1 ;
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
    self.library = [[ALAssetsLibrary alloc] init];
    // NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
          NSString *Fname = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"];
         NSString *Lname = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"];
         NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
         NSString *dob = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
    NSLog(@"dob :%@",dob);
         NSString *Mobileno = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile_number"];
        NSString *gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
        NSString *samaritan_points =  [[NSUserDefaults standardUserDefaults] objectForKey:@"samaritan_points"];
  
    int intSamaritan_points = [samaritan_points intValue];
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    
    if(intSamaritan_points > 0)
    {
        [_viewsamaritan setBackgroundColor: [UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1]];
        [_btnsamaritan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_imgsamaritan setImage:[UIImage imageNamed:@""]];
        [_lblsamaritan setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [_viewsamaritan setBackgroundColor:[UIColor grayColor]];
        [_btnsamaritan setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
         [_lblsamaritan setTextColor:[UIColor darkGrayColor]];
    }
    
    
    
    _lblFname.text = Fname;
    _lblLname.text = Lname;
    _lblMobileNo.text = Mobileno;
    _lblEmail.text =  email;
    
    if([gender isEqualToString:@"male"])
    {
        [_img setImage:[UIImage imageNamed:@"ic_male"]];
    }
    else
    {
        [_img setImage:[UIImage imageNamed:@"ic_female"]];
    }
    
    //NSString *birthDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timePicker.date]];
   
   
    CATransition *transDown=[CATransition animation];
    [transDown setDuration:0.5];
    [transDown setType:kCATransitionPush];
    [transDown setSubtype:kCATransitionFromTop];
    [transDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [customActionSheetView.layer addAnimation:transDown forKey:nil];
    
    
   NSString *strPostCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"postcode"];
    NSLog(@"postcode : %@",strPostCode);
//    NSString *strStreet = [[NSUserDefaults standardUserDefaults] objectForKey:@"street"];
//    NSString *strLicenceno = [[NSUserDefaults standardUserDefaults] objectForKey:@"license_no"];
    
    if(strPostCode == nil || strPostCode == (id)[NSNull null] || [strPostCode isEqualToString:@""])
    {
        [_btnAddDetails setTitle:@"Add Details" forState:UIControlStateNormal];
    }
    else
    {
        [_btnAddDetails setTitle:@"Edit Details" forState:UIControlStateNormal];
    }
    
    
     NSString *profile_completed = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_completed"];
    NSLog(@"profile complete :: %@",profile_completed);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(27 / 2.0f,
                                                                   340,
                                                                  273,
                                                                  21)];
    
   
//    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile_bar.png"]];
    
//    THProgressView *bottomProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(3 / 2.0f,
//                                                                                          2/2.0f,
//                                                                                          273,
//                                                                                         21)];
//
    THProgressView *bottomProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          273,
                                                                                          21)];

    
    [bottomView addSubview:bottomProgressView];
    [self.view addSubview:bottomView];
    
    self.progressViews = @[ bottomProgressView ];
    
    
   bottomProgressView.layer.borderWidth = 0.0f;
    bottomView.layer.borderWidth = 0.0f;
    
    NSInteger int1 = [profile_completed intValue];
    if(int1 == 30)
    {
        bottomProgressView.progressTintColor = [UIColor redColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.30f animated:YES];
        }];
        
        _lblprofile.text = @"Your Profile is 30% complete.";
        _lblstm.text = @"Complete your profile and add Vehicles.";

    }
    else if (int1 >= 31 && int1 <=50)
    {
        bottomProgressView.progressTintColor = [UIColor orangeColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.50f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 50% complete.";
        _lblstm.text = @"Add Vehicles to your profile.";
    }
    else if (int1 >= 51 && int1 <=80)
    {
        bottomProgressView.progressTintColor = [UIColor yellowColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.80f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 80% complete.";
        _lblstm.text = @"Add information about your Vehicle now.";
    }
    else if (int1 >= 81)
    {
        bottomProgressView.progressTintColor = [UIColor greenColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.95f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 90% complete.";
        _lblstm.text = @"Add information about your Vehicle now.";
    }
    else if (int1 >=100)
    {
        bottomProgressView.hidden = YES;
       
    }
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
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
        
        [param setValue:latitude forKey:@"latitude"];
        [param setValue:longitude forKey:@"longitude"];
        [param setValue:pin forKey:@"pin"];
        
        [param setValue:@"ios7" forKey:@"os"];
        [param setValue:@"iPhone" forKey:@"make"];
        [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/getProfile.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSLog(@"url : %@",manager);
        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  
                  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                  
                  NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                
                  NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                  NSLog(@"message %@",EntityID);
                  
                  
                  if ([EntityID isEqualToString:@"failure"])
                  {
                      
                  }
                  else
                  {
                      NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                      NSLog(@"data : %@",jsonDictionary);
                      appDelegate.strUserID = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"user_id"];
                      
                     dob1 = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"dob"];
                      NSString *email = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"email"];
                      NSString *emergencyContact = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"emergency_contact"];
                      NSString *emergency_contact_number = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"emergency_contact_number"];
                      NSString *fb_id = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"fb_id"];
                      NSString *fb_token = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"fb_token"];
                      NSString *first_name = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"first_name"];
                      NSString *gender = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"gender"];
                      NSString *last_name = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"last_name"];
                      NSString *license_no = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"license_no"];
                      NSString *license_photo_url = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"license_photo_url"];
                      NSString *mobile_number = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"mobile_number"];
                      NSString *modified_at = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"modified_at"];
                      NSString *photo_url = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"photo_url"];
                      NSString *postcode = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"postcode"];
                      NSString *profile_completed = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"profile_completed"];
                      NSString *samaritan_points = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"samaritan_points"];
                      NSString *security_answer = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_answer"];
                      NSString *security_question = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_question"];
                      NSString *street = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"street"];
                      NSString *suburb = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"suburb"];
                      NSDictionary *arrVehicle = [[NSDictionary alloc]init];
                      arrVehicle = [jsonDictionary valueForKey:@"vehicles"];
                      
                      [dateFormatter setDateFormat:@"'yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
                      datedob = [dateFormatter dateFromString:dob1];
                      NSDate *todayDate = [NSDate date];
                      
                      
                      NSLog(@"dob : %@",datedob);
                      
                      int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:dob]];
                      int allDays = (((time/60)/60)/24);
                      int days = allDays%365;
                      int years = (allDays-days)/365;
                      
                      NSLog(@"You live since %i years and %i days",years,days);
                      _lbldob.text = [[NSString stringWithFormat:@"%i",years] stringByAppendingString:@" yrs"];
                      
                      [[NSUserDefaults standardUserDefaults] setValue:appDelegate.strUserID forKey:@"UserID"];
                      [[NSUserDefaults standardUserDefaults] setValue:dob1 forKey:@"dob"];
                      [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
                      [[NSUserDefaults standardUserDefaults] setValue:emergencyContact forKey:@"emergencyContact"];
                      [[NSUserDefaults standardUserDefaults] setValue:emergency_contact_number forKey:@"emergency_contact_number"];
                      [[NSUserDefaults standardUserDefaults] setValue:fb_id forKey:@"fb_id"];
                      [[NSUserDefaults standardUserDefaults] setValue:fb_token forKey:@"fb_token"];
                      [[NSUserDefaults standardUserDefaults] setValue:first_name forKey:@"first_name"];
                      [[NSUserDefaults standardUserDefaults] setValue:gender forKey:@"gender"];
                      [[NSUserDefaults standardUserDefaults] setValue:last_name forKey:@"last_name"];
                      [[NSUserDefaults standardUserDefaults] setValue:license_no forKey:@"license_no"];
                      [[NSUserDefaults standardUserDefaults] setValue:license_photo_url forKey:@"license_photo_url"];
                      [[NSUserDefaults standardUserDefaults] setValue:mobile_number forKey:@"mobile_number"];
                      [[NSUserDefaults standardUserDefaults] setValue:modified_at forKey:@"modified_at"];
                      [[NSUserDefaults standardUserDefaults] setValue:photo_url forKey:@"photo_url"];
                      [[NSUserDefaults standardUserDefaults] setValue:postcode forKey:@"postcode"];
                      [[NSUserDefaults standardUserDefaults] setValue:profile_completed forKey:@"profile_completed"];
                      [[NSUserDefaults standardUserDefaults] setValue:samaritan_points forKey:@"samaritan_points"];
                      [[NSUserDefaults standardUserDefaults] setValue:security_answer forKey:@"security_answer"];
                      [[NSUserDefaults standardUserDefaults] setValue:security_question forKey:@"security_question"];
                      [[NSUserDefaults standardUserDefaults] setValue:street forKey:@"street"];
                      [[NSUserDefaults standardUserDefaults] setValue:suburb forKey:@"suburb"];
                      [[NSUserDefaults standardUserDefaults] setValue:arrVehicle forKey:@"vehicles"];
                     
                  }
                  [SVProgressHUD dismiss];
                 
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@ ***** %@", operation.responseString, error);
              }];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        _lblsamaritan.text = samaritan_points;
        NSLog(@"dob1 : %@",dob1 );
       
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    NSMutableArray *vehicle = [[NSMutableArray alloc]init];
   vehicle = [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
  
    if([vehicle count] == 0)
    {
        [_btnAddVehicle setTitle:@"Add Vehicle" forState:UIControlStateNormal];
    }
    else
    {
        [_btnAddVehicle setTitle:@"My Vehicle" forState:UIControlStateNormal];
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    NSString *photoURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
    
    // Create the Album:
    NSString *albumName = @"My Wheels";
    [self.library addAssetsGroupAlbumWithName:albumName
                                  resultBlock:^(ALAssetsGroup *group) {
                                      NSLog(@"added album:%@", albumName);
                                  }
                                 failureBlock:^(NSError *error) {
                                     NSLog(@"error adding album");
                                 }];
    
    __block ALAssetsGroup* groupToAddTo;
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                        NSLog(@"found album %@", albumName);
                                        groupToAddTo = group;
                                    }
                                }
                              failureBlock:^(NSError* error) {
                                  NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                              }];
    
    
    NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    NSLog(@"file name : %@",filename);
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
    
    UIImage *image1 = [UIImage imageWithData:imageData];
    
    if(photoURL == nil || photoURL == (id)[NSNull null])
    {
        _imgUserProfilepic.image = [UIImage imageNamed:@"default_profile_home"];
    }
    else
    {
        if(filename == nil || filename == (id)[NSNull null])
        {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
            _imgUserProfilepic.image = [UIImage imageWithData:imageData];
        }
        else
        {
             _imgUserProfilepic.image = image1;
        }
        
        
    }
    
    NSLog(@"photo url : %@",photoURL);

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
    [_img1 setImage:image];
  
    [_btnprofilePic setImage:image forState:UIControlStateNormal];
    
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
            
//            ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
//            [libraryFolder addAssetsGroupAlbumWithName:@"My Wheels" resultBlock:^(ALAssetsGroup *group)
//             {
//             resultBlock:^(ALAssetsGroup *group) {
//               //  NSLog(@"added album:%@", albumName);
//             }
//                 
//                 NSLog(@"Adding Folder:'My Album', success: %s", group.editable ? "Success" : "Already created: Not Success");
//                 
//                 
//
//                  // UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//             } failureBlock:^(NSError *error)
//             {
//                 NSLog(@"Error: Adding on Folder");
//             }];
           // Create the Album:
            NSString *albumName = @"My Wheels";
            [self.library addAssetsGroupAlbumWithName:albumName
                                          resultBlock:^(ALAssetsGroup *group) {
                                              NSLog(@"added album:%@", albumName);
                                          }
                                         failureBlock:^(NSError *error) {
                                             NSLog(@"error adding album");
                                         }];
          //  Find the Album:
            
            __block ALAssetsGroup* groupToAddTo;
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                                NSLog(@"found album %@", albumName);
                                                groupToAddTo = group;
                                            }
                                        }
                                      failureBlock:^(NSError* error) {
                                          NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                                      }];
          //  Save the Image to Asset Library, and put it into the album:
            
            CGImageRef img = [image CGImage];
            [self.library writeImageToSavedPhotosAlbum:img
                                              metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                                       completionBlock:^(NSURL* assetURL, NSError* error) {
                                           if (error.code == 0) {
                                               NSLog(@"saved image completed:\nurl: %@", assetURL);
                                               
                                               // try to get the asset
                                               [self.library assetForURL:assetURL
                                                             resultBlock:^(ALAsset *asset) {
                                                                 // assign the photo to the album
                                                                 [groupToAddTo addAsset:asset];
                                                                 NSLog(@"Added %@ to %@", [[asset defaultRepresentation] filename], albumName);
                                                             }
                                                            failureBlock:^(NSError* error) {
                                                                NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                                                            }];
                                           }
                                           else {
                                               NSLog(@"saved image failed.\nerror code %i\n%@", error.code, [error localizedDescription]);
                                           }
                                       }];        }

        [SVProgressHUD dismiss];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark button click event
-(IBAction)btnback_click:(id)sender
{
    HomePageVC *vc = [[HomePageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnSamaritan_click:(id)sender
{
    UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Samaritan Points"
                                                        message:@"Earn Samaritan points against your activities like Report Sighting and Profile completeness in order to gain priority listing and other benefits."
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil, nil];
    CheckAlert.tag = 1;
    [CheckAlert show];
}
-(IBAction)btnProfilepic_click:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo",
                            @"Choose Existing",
                           
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}
-(IBAction)btnAddDetails_click:(id)sender
{
    NSString *strPostCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"postcode"];

    if(strPostCode == nil || strPostCode == (id)[NSNull null] || [strPostCode isEqualToString:@""] )
    {
        AddDetailsVC *vc = [[AddDetailsVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        EditDetailsVC *vc = [[EditDetailsVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [_btnAddDetails setTitle:@"Edit Details" forState:UIControlStateNormal];
    }
}
-(IBAction)btnAddVehicles_click:(id)sender
{
    NSMutableArray *vehicle = [[NSMutableArray alloc]init];
    vehicle = [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
    if([vehicle count] == 0)

    {
        AddVehiclesVC *vc = [[AddVehiclesVC alloc]init];
        // AddInsuranceVC *vc = [[AddInsuranceVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        MyVehicleVC *vc = [[MyVehicleVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    
}
@end
