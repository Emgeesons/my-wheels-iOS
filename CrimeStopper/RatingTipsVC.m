//
//  RatingTipsVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 11/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "RatingTipsVC.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SVProgressHUD.h"
#import "ImParkingHereVC.h"
#import "VehicleTipsCell.h"
#import "TipsDetailsVC.h"

@interface RatingTipsVC ()

@end

@implementation RatingTipsVC

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
    _arrTips = [[NSMutableArray alloc]init];
    _lblLocation.text = _strLocation;
    _lblRating.text = _strrating;
    
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
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
        
        
        NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
        NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        NSString *strVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
        /*//userId (0 if guest user)
        // vehicleId (0 if default)
         //latitude (can be borrowed from previous screen)
         //longitude (can be borrowed from previous screen)
         //noTips (initially this will be 0) - paging call
         os
         make
         mode
         //pinl
         
         */
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        if(UserID == nil || UserID == (id)[NSNull null])
        {
            [param setValue:@"0" forKey:@"userId"];
        }
        else
        {
            [param setValue:UserID forKey:@"userId"];
        }
        [param setValue:pin forKey:@"pin"];
        [param setValue:latitude forKey:@"latitude"];
        [param setValue:longitude forKey:@"longitude"];
        if(strVehicleID == nil || strVehicleID == (id)[NSNull null])
        {
            [param setValue:@"0" forKey:@"vehicleId"];
        }
        else
        {
            [param setValue:strVehicleID forKey:@"vehicleId"];
        }
        [param setValue:@"0" forKey:@"noTips"];
        [param setValue:OS_VERSION forKey:@"os"];
        [param setValue:MAKE forKey:@"make"];
        [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
        [param setValue:@"test11" forKeyPath:@"test"];
        NSLog(@"param : %@",param);
       
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        
//         NSString *url = [NSString stringWithFormat:@"%@getParkingTips.php", SERVERNAME];
//        
//        [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//            
//            NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
//            NSLog(@"data : %@",jsonDictionary);
//            
//            NSString *EntityID = [jsonDictionary valueForKey:@"status"];
//            NSLog(@"message %@",EntityID);
//            if ([EntityID isEqualToString:@"success"])
//            {
//                [_arrTips addObjectsFromArray:[jsonDictionary valueForKey:@"response"]];
//                
//                NSLog(@"arr : %@",_arrTips);
//                self.tblRating.delegate=self;
//                self.tblRating.dataSource=self;
//                [_tblRating reloadData];
//            }
//            else
//            {
//                UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
//                                                                    message:[jsonDictionary valueForKey:@"message"]
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil, nil];
//                [CheckAlert show];
//
//                
//            }
//            [SVProgressHUD dismiss];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//        }];
//        
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *url = [NSString stringWithFormat:@"%@getParkingTips.php", SERVERNAME];
        [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSLog(@"url : %@",manager);
        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                             NSLog(@"data : %@",jsonDictionary);
                  //
                              NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                             NSLog(@"message %@",EntityID);
                  if ([EntityID isEqualToString:@"success"])
                  {
                            [_arrTips addObjectsFromArray:[jsonDictionary valueForKey:@"response"]];
                     
                                  NSLog(@"arr : %@",_arrTips);
                                      self.tblRating.delegate=self;
                                      self.tblRating.dataSource=self;
                                      [_tblRating reloadData];
                      
                }
                  else
                  {
                      NSString *strmessage = [jsonDictionary valueForKey:@"message"];
                      UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
                                                                          message:strmessage
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

        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count : %d",[_arrTips count]);
    return [_arrTips count];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"VehicleTipsCell";
    VehicleTipsCell *cell = (VehicleTipsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VehicleTipsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.lblTips setText:[[_arrTips objectAtIndex:indexPath.row] valueForKey:@"feedback"]];
    NSString *time = [[_arrTips objectAtIndex:indexPath.row] valueForKey:@"time"];
    NSDate *time1 = [dateFormatter dateFromString:time];
    
    NSLog(@"time 1 : %@",time1);
     NSLog(@"time 1 : %@",[dateFormatter stringFromDate:time1]);
    [cell.lblDate setText:time];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TipsDetailsVC *vc = [[TipsDetailsVC alloc]init];
    vc.strLocation = _lblLocation.text;
    vc.strRating = _lblRating.text;
    vc.strTips = [[_arrTips objectAtIndex:indexPath.row] valueForKey:@"feedback"];
    vc.strdate = [[_arrTips objectAtIndex:indexPath.row] valueForKey:@"time"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark button  click event
-(IBAction)btnBack_click:(id)sender
{
    ImParkingHereVC *vc = [[ImParkingHereVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
