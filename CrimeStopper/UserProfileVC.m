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

#import "SVProgressHUD.h"
#import "AFNetworking.h"

NSInteger intImage;
@interface UserProfileVC ()
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *progressViews;
@end

@implementation UserProfileVC
@synthesize customActionSheetView;

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
          NSString *Fname = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"];
         NSString *Lname = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"];
         NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
         NSString *dob = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
         NSString *Mobileno = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile_number"];
        NSString *gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    
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
    NSDate *todayDate = [NSDate date];
    
    
    int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:dob]];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    int years = (allDays-days)/365;
    
    NSLog(@"You live since %i years and %i days",years,days);
    _lbldob.text = [[NSString stringWithFormat:@"%i",years] stringByAppendingString:@" yrs"];
   
    CATransition *transDown=[CATransition animation];
    [transDown setDuration:0.5];
    [transDown setType:kCATransitionPush];
    [transDown setSubtype:kCATransitionFromTop];
    [transDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [customActionSheetView.layer addAnimation:transDown forKey:nil];
    
    
   
     NSString *profile_completed = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_completed"];
    NSLog(@"profile complete :: %@",profile_completed);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(27 / 2.0f,
                                                                   340,
                                                                  273,
                                                                  21)];
   // bottomView.backgroundColor = [UIColor clearColor];
    bottomView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile_bar.png"]];
    
    THProgressView *bottomProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(3 / 2.0f,
                                                                                          2/2.0f,
                                                                                          273,
                                                                                         21)];
 
    [bottomView addSubview:bottomProgressView];
    [self.view addSubview:bottomView];
    
    self.progressViews = @[ bottomProgressView ];
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
            
            [progressView setProgress:0.30f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 80% complete.";
        _lblstm.text = @"Add information about your Vehicle now.";
    }
    else if (int1 >= 81)
    {
        bottomProgressView.progressTintColor = [UIColor greenColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.30f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 90% complete.";
        _lblstm.text = @"Add information about your Vehicle now.";
    }
    else if (int1 >=100)
    {
        bottomProgressView.hidden = YES;
       
    }
    


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
            
            ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
            [libraryFolder addAssetsGroupAlbumWithName:@"My Wheels" resultBlock:^(ALAssetsGroup *group)
             {
                 NSLog(@"Adding Folder:'My Album', success: %s", group.editable ? "Success" : "Already created: Not Success");
                 
                 

                  // UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
             } failureBlock:^(NSError *error)
             {
                 NSLog(@"Error: Adding on Folder");
             }];
        }

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
@end
