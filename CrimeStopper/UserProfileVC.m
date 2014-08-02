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
NSString *first_name;
NSString *last_name;
NSString *mobile_number;
NSString *email1;

int years;
int intSamaritan_points;
NSDictionary *arrVehicle;
 NSString *samaritan_points1 = @"0";
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
    }
    self.library = [[ALAssetsLibrary alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
   arrVehicle = [[NSDictionary alloc]init];
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
        NSString *photoURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
    if(photoURL == nil || photoURL == (id)[NSNull null] || [photoURL isEqualToString:@""])
    {
    
    }
    else
    {
    NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    NSLog(@"file name : %@",filename);
    
    NSString *str = @"My_Wheels_";
    NSString *strFileName = [str stringByAppendingString:filename];
    NSLog(@"strfilename : %@",strFileName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:strFileName];
    UIImage *contactImage = [UIImage imageWithData:imageData];
    if(imageData == nil)
    {
        _imgUserProfilepic.image = [UIImage imageNamed:@"default_profile_2.png"];
    }
    else
    {
        _imgUserProfilepic.image = contactImage;
    }
    }
    
    //set image as round
    _imgUserProfilepic.layer.cornerRadius = 25;
    _imgUserProfilepic.clipsToBounds = YES;
    
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
    
    //for profile complete stateus bar
    
    CATransition *transDown=[CATransition animation];
    [transDown setDuration:0.5];
    [transDown setType:kCATransitionPush];
    [transDown setSubtype:kCATransitionFromTop];
    [transDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [customActionSheetView.layer addAnimation:transDown forKey:nil];

    
     NSString *profile_completed = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_completed"];
    NSLog(@"profile complete :: %@",profile_completed);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(27 / 2.0f,
                                                                   320,
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
    else if (int1 >=51 && int1 <=60){
        bottomProgressView.progressTintColor = [UIColor orangeColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.60f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 60% complete.";
        _lblstm.text = @"Add license details and add photos/indusrance details for your vehicle";
    }
    else if (int1 >= 61 && int1 <=80)
    {
        bottomProgressView.progressTintColor = [UIColor yellowColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.80f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 80% complete.";
        //license_no
        NSString *licenceNo = [[NSUserDefaults standardUserDefaults]objectForKey:@"license_no"];
        if(licenceNo == nil || licenceNo == (id)[NSNull null] || [licenceNo isEqualToString:@""])
        {
            _lblstm.text = @"Add license details to your profile";
        }
        else
        {
            _lblstm.text = @"Add photos/indusrance details for your vehicle";
        }
        
    }
    else if (int1 >= 81)
    {
        bottomProgressView.progressTintColor = [UIColor greenColor];
        [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
            
            [progressView setProgress:0.90f animated:YES];
        }];
        _lblprofile.text = @"Your Profile is 90% complete.";
        _lblstm.text = @"Add photos/indusrance details for your vehicle";
    }
    else if (int1 >=100)
    {
        bottomProgressView.hidden = YES;
       
    }
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    Reachability *networkReachability1 = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus1 = [networkReachability1 currentReachabilityStatus];
    if (networkStatus1 == NotReachable) {
        NSLog(@"There IS NO internet connection");
//        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
//                                                            message:@"Please connect to the internet to continue."
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil, nil];
//        [CheckAlert show];
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
        @try
        {
               NSString *url = [NSString stringWithFormat:@"%@getProfile.php", SERVERNAME];
            [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              
            }
             
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      
                      NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                      
                      NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                      
                      NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                      NSLog(@"message %@",EntityID);
                      
                      
                      if ([EntityID isEqualToString:@"success"])
                      {
                          NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                          NSLog(@"data : %@",jsonDictionary);
                          appDelegate.strUserID = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"user_id"];
                          
                          dob1 = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"dob"];
                          email1 = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"email"];
                          NSString *emergencyContact = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"emergency_contact"];
                          NSString *emergency_contact_number = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"emergency_contact_number"];
                          NSString *fb_id = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"fb_id"];
                          NSString *fb_token = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"fb_token"];
                          first_name = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"first_name"];
                          NSString *gender = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"gender"];
                          last_name = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"last_name"];
                          NSString *license_no = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"license_no"];
                          NSString *license_photo_url = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"license_photo_url"];
                          mobile_number = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"mobile_number"];
                          NSString *modified_at = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"modified_at"];
                          NSString *photo_url = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"photo_url"];
                          NSString *postcode = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"postcode"];
                          NSString *profile_completed = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"profile_completed"];
                          NSString  *samaritan_points = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"samaritan_points"];
                          NSString *security_answer = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_answer"];
                          NSString *security_question = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_question"];
                          NSString *street = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"address"];
                          NSString *suburb = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"suburb"];
                          NSDictionary *arrVehicle = [[NSDictionary alloc]init];
                          arrVehicle = [jsonDictionary valueForKey:@"vehicles"];
                          
                          
                          
                          [[NSUserDefaults standardUserDefaults] setValue:appDelegate.strUserID forKey:@"UserID"];
                          [[NSUserDefaults standardUserDefaults] setValue:dob1 forKey:@"dob"];
                          [[NSUserDefaults standardUserDefaults] setValue:email1 forKey:@"email"];
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
                          
                          intSamaritan_points  = [samaritan_points intValue];
                          _lblFname.text = first_name;
                          _lblLname.text = last_name;
                          _lblMobileNo.text = mobile_number;
                          _lblEmail.text =  email1;

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
                     
                      _lblFname.text = first_name;
                      _lblLname.text = last_name;
                      _lblMobileNo.text = mobile_number;
                      _lblEmail.text =  email1;
                      
                      NSString *strName = [first_name stringByAppendingString:@" "];
                      NSString *strFullName = [strName stringByAppendingString:last_name];
                      
                      _lblFname.text = strFullName;
                      
                      
                      NSLog(@"dob : %@",dob);
                      dateFormatter = [[NSDateFormatter alloc]init];
                      [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                      
                      datedob = [dateFormatter dateFromString:dob];
                      NSDate *todayDate = [NSDate date];
                      
                      
                      NSLog(@"dob : %@",datedob);
                      
                      int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:dob1]];
                      int allDays = (((time/60)/60)/24);
                      int days = allDays%365;
                      years = (allDays-days)/365;
                      
                      NSLog(@"You live since %i years and %i days",years,days);
                                          NSLog(@"dob1 : %@",dob1 );
                      
                      if([dob isEqualToString:@"0000-00-00 00:00:00"])
                      {
                          _lbldob.text = @"";
                      }
                      else
                      {
                           _lbldob.text = dob;
                      }
                      
                      
                      
                      NSString *ques = [[NSUserDefaults standardUserDefaults] objectForKey:@"security_question"];
                      NSLog(@"ques: %@",ques);
                      
                      samaritan_points1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"samaritan_points"];
                      _lblsamaritan.text = samaritan_points1;
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
                      

                      
                      [SVProgressHUD dismiss];
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                  }];
            
        }
        @catch (NSException *exception)
        {
            NSString *url = [NSString stringWithFormat:@"%@getProfile.php", SERVERNAME];
            [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               
            }
                 
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          
                          NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                          
                          NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                          
                          NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                          NSLog(@"message %@",EntityID);
                          
                          
                          if ([EntityID isEqualToString:@"success"])
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
                              NSString *street = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"address"];
                              NSString *suburb = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"suburb"];
                              
                              arrVehicle = [jsonDictionary valueForKey:@"vehicles"];
                              
                              
                              
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
                          NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                      }];
        }
        @finally 
        {
            NSLog(@"...");
        }
       
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
       
        
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    NSMutableArray *vehicle = [[NSMutableArray alloc]init];
   vehicle = [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
    if([vehicle count] == 0)
    {
        [_btnAddVehicle setTitle:@"Add Vehicles" forState:UIControlStateNormal];
    }
    else
    {
        [_btnAddVehicle setTitle:@"My Vehicles" forState:UIControlStateNormal];
    }
   
    
    NSString *photoURL1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
    if(photoURL1 == nil || photoURL1 == (id)[NSNull null] || [photoURL1 isEqualToString:@""])
    {
    
    }
    else
    {
    
    NSArray *parts = [photoURL1 componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    NSLog(@"file name : %@",filename);
    
    NSString *str = @"My_Wheels_";
    NSString *strFileName = [str stringByAppendingString:filename];
    NSLog(@"strfilename : %@",strFileName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:strFileName];
    
    if(imageData == nil)
    {
        
        [self downloadImageWithURL:[NSURL URLWithString:photoURL] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                _imgUserProfilepic.image = image;
                // Store the data
               

                
            }
        }];
        
        
           }
    else
    {  UIImage *contactImage = [UIImage imageWithData:imageData];
        _imgUserProfilepic.image = contactImage;
    }
    
    }
    
    
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   
                                   
                                   NSString *photoURL1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
                                   NSArray *parts = [photoURL1 componentsSeparatedByString:@"/"];
                                   NSString *filename = [parts objectAtIndex:[parts count]-1];
                                   NSLog(@"file name : %@",filename);
                                   
                                   NSString *str = @"My_Wheels_";
                                   NSString *strFileName = [str stringByAppendingString:filename];
                                   NSLog(@"strfilename : %@",strFileName);
                                   
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                  
                                   [defaults setObject:data forKey:strFileName];
                                   [defaults synchronize];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

-(void)viewDidAppear:(BOOL)animated
{
   
        [super viewDidAppear:animated];
       NSString *photoURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_url"];
         // NSString *photoURL = @"https://pullquotesandexcerpts.files.wordpress.com/2013/11/silver-apple-logo.png?w=360";
     
        NSString *albumName = @"My Wheels";
        [self.library addAssetsGroupAlbumWithName:albumName
                                      resultBlock:^(ALAssetsGroup *group) {
                                          NSLog(@"added album:%@", albumName);
                                      }
                                     failureBlock:^(NSError *error) {
                                         NSLog(@"error adding album");
                                     }];
        
        
        
        NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
        NSString *filename = [parts objectAtIndex:[parts count]-1];
        NSLog(@"file name : %@",filename);
    
    
            if(photoURL == nil || photoURL == (id)[NSNull null] || [photoURL isEqualToString:@""])
            {
                _imgUserProfilepic .image = [UIImage imageNamed:@"default_profile_2.png"];
            }
            else
            {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
//                  //  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
//                    
////                    UIImage *image = [UIImage imageWithData:imageData];
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
//                        
//                      //  _imgUserProfilepic.image = image;
//                        NSArray *parts = [photoURL componentsSeparatedByString:@"/"];
//                        NSString *filename = [parts objectAtIndex:[parts count]-1];
//                        NSLog(@"file name : %@",filename);
//                        
//                        NSString *str = @"My_Wheels_";
//                        NSString *strFileName = [str stringByAppendingString:filename];
//                        NSLog(@"strfilename : %@",strFileName);
//                       
//                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                        NSData *imageData = [defaults dataForKey:strFileName];
//                      
//                        if(imageData == nil)
//                        {
//                              NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
//                             UIImage *image = [UIImage imageWithData:imageData];
//                            _imgUserProfilepic.image = image;
//                           
//                            // Store the data
//                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                            
//                            [defaults setObject:imageData forKey:strFileName];
//                            [defaults synchronize];
//                        }
//                        else
//                        {  UIImage *contactImage = [UIImage imageWithData:imageData];
//                            _imgUserProfilepic.image = contactImage;
//                        }
//                        
//                    });
//                });
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
    [_imgUserProfilepic setImage:image];
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
 NSString *url = [NSString stringWithFormat:@"%@uploadProfilePic.php", SERVERNAME];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
        if ([EntityID isEqualToString:@"success"])
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
            _imgUserProfilepic.image = [UIImage imageWithData:imageData];
        }
        else
        {
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:nil
                                                                message:[jsonDictionary valueForKey:@"message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [CheckAlert show];
            
            
                
         
    
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
