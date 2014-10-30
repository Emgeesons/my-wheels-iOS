//
//  ImParkingHereVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 05/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ImParkingHereVC.h"
#import "mParkingCell.h"
#import "AppDelegate.h"
#import "HomePageVC.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "RatingTipsVC.h"

@interface ImParkingHereVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation ImParkingHereVC
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *strRating1;
}
#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
NSMutableDictionary *dicCounter;
int counterForCell;
BOOL bool1,bool2,bool3;

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
    
    bool1 = false;
    bool2 = false;
    bool3 = false;
    
    
    [_viewTransparent setHidden:YES];
    
    NSString *strVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    NSString *strCurrentVehicleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleName"];
    _arrVehiclePark = [[NSMutableDictionary alloc]init];
   
    [_viewLocationGuide setHidden:YES];
    
//    [_btnVehicleName setTitle:strCurrentVehicleName forState:UIControlStateNormal];
      [_lblHeading setText:strCurrentVehicleName];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"appdelegate str vehicle type: %@",appDelegate.strVehicleType);
    _arrrandValue = [[NSMutableArray alloc]init];
    NSLog(@"vehicle type : %@",appDelegate.strVehicleType);
    if([appDelegate.strVehicleType isEqualToString:@"Bicycle"])
        _arrrandValue = [self getEightRandomLessThan:7];
    else if([appDelegate.strVehicleType isEqualToString:@"Motorcycle"])
        _arrrandValue = [self getEightRandomLessThan:13];
    else
        _arrrandValue = [self getEightRandomLessThan:10];
    NSLog(@"randome value : %@",_arrrandValue);
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
   
    
//    if(IsIphone5)
//    {
//        _viewComment.frame = CGRectMake(0 , 410, 320, 44);
//     
//    }
//    else
//    {
//        _viewComment.frame = CGRectMake(0 , 370, 320, 44);
//        
//    }
    [self.txtComment setDelegate:self];
    
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    
    [self.txtComment setInputAccessoryView:self.toolbar];
    _arrCar = [[NSMutableArray alloc]init];
    [_arrCar addObject:@"does this parking spot have a good MyWheels user rating ?"];
    [_arrCar addObject:@"well lit spot?"];
    [_arrCar addObject:@"spot in full view of people?"];
    [_arrCar addObject:@"windows closed and doors locked?"];
    [_arrCar addObject:@"all loose and valuable items in the boot?"];
    [_arrCar addObject:@"immobiliser activated or steering wheel lock on?"];
    [_arrCar addObject:@"near a security camera or on-site staff?"];
    [_arrCar addObject:@"no spare keys left in/on the car"];
    [_arrCar addObject:@"if home – keys out of sight?"];
    [_arrCar addObject:@"if home – off the road?"];
    [_arrCar addObject:@"if home – in a locked garage?"];
    
    _arrBike = [[NSMutableArray alloc]init];
    [_arrBike addObject:@"does this parking spot have a good MyWheels user rating ?"];
    [_arrBike addObject:@"well lit spot?"];
    [_arrBike addObject:@"spot in full view of people?"];
    [_arrBike addObject:@"steering and ignition locked and taking the key?"];
    [_arrBike addObject:@"locked to something immovable eg light pole?"];
    [_arrBike addObject:@"got a good quality lock – chain lock, U-wheel lock?"];
    [_arrBike addObject:@"forks or disk brakes lock with large, bright colour tags?"];
    [_arrBike addObject:@"near a security camera or on-site staff?"];
    [_arrBike addObject:@"not parked next to or between large trucks or SUVs?"];
    [_arrBike addObject:@"motorcycle cover is on?"];
    [_arrBike addObject:@"if riding with others – bikes locked together?"];
    [_arrBike addObject:@"if home – off the road?"];
    [_arrBike addObject:@"if home – in a locked garage?"];
    [_arrBike addObject:@"if home – chained to U-bolt in garage floor?"];
    
    _arrcycle = [[NSMutableArray alloc]init];
    [_arrcycle addObject:@"does this parking spot have a good MyWheels user rating ?"];
    [_arrcycle addObject:@"well lit spot?"];
    [_arrcycle addObject:@"spot in full view of people?"];
    [_arrcycle addObject:@"got a good quality lock – cable or D-lock, padlock and chain?"];
    [_arrcycle addObject:@"frame and both wheels locked to something immovable?"];
    [_arrcycle addObject:@"removed everything that can be taken – helmet, light, pump?"];
    [_arrcycle addObject:@"near a security camera or on-site staff?"];
    [_arrcycle addObject:@"if home – locked in garage or inside house?"];
    
    
    
    //for calling api for rating
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        //NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Please connect to the internet to continue."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    }
    
    else
        
    {
    //NSLog(@"in api");
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
     //NSLog(@"current location : %@",latitude);
    
    if([latitude isEqualToString:@"0.000000"])
    {
        [_viewLocationGuide setHidden:NO];
        [_viewTransparent setHidden:NO];
    }

    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        [param setValue:@"0" forKey:@"userId"];
        [param setValue:@"0" forKey:@"vehicleId"];
    }
    else
    {
         [param setValue:UserID forKey:@"userId"];
         [param setValue:strVehicleID forKey:@"vehicleId"];
    }
   
    [param setValue:pin forKey:@"pin"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    
   
  
        [param setValue:OS_VERSION forKey:@"os"];
        [param setValue:MAKE forKey:@"make"];
        [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
    
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
     NSString *url = [NSString stringWithFormat:@"%@parkingHere.php", SERVERNAME];
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
        
        //NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
        //NSLog(@"data : %@",jsonDictionary);
        
        NSString *EntityID = [jsonDictionary valueForKey:@"status"];
        //NSLog(@"message %@",EntityID);
        if ([EntityID isEqualToString:@"success"])
        {
            NSString *strRating = @" rating";
            NSString *strRate = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"rating"];
            
            NSString *strnoTips = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"noTips"];
            NSString *strTips = [strnoTips stringByAppendingString:@" tips for this location"];
            if(strRate == nil || strRate == (id)[NSNull null])
            {
                [_btnRating setTitle:@"" forState:UIControlStateNormal];
                [_btnTips setTitle:@"" forState:UIControlStateNormal];
               
            }
            else if([strRate isEqualToString: @"0"] || [strnoTips isEqualToString:@"0"] )
            {
                [_btnRating setTitle:@"0 rating" forState:UIControlStateNormal];
                [_btnTips setTitle:@"0 tips for this location" forState:UIControlStateNormal];
                [_btnRating setUserInteractionEnabled:NO];
                [_btnTips setUserInteractionEnabled:NO];
            }
            else
            {
            
                NSString *str = [strRate stringByAppendingString:strRating];
               if(str == nil || str == (id)[NSNull null] || [str isEqualToString:@""])
               {
                    strRating1 = @"";
                    [_btnRating setTitle:@"" forState:UIControlStateNormal];
               }
                else
                {
                    NSString *subString;
                    if(strRate.length > 1)
                    {
                        subString = [strRate substringWithRange:NSMakeRange(0,3)];
                    }
                   else
                   {
                       strRate = [strRate stringByAppendingString:@".00"];
                       subString = strRate;
                       
                   }
                  //  NSString *strr = [subString stringByAppendingString:strRating];
                    //NSLog(@"substring : %@",subString);
                    NSString *rate = [subString stringByAppendingString:@" "];
                    NSString *rat = [rate stringByAppendingString:strRating];
                    strRating1 = rat;
                    [_btnRating setTitle:rat forState:UIControlStateNormal];
                }
                if(strTips == nil || strTips == (id)[NSNull null] || [strTips isEqualToString:@""])
                {
                    
                    [_btnTips setTitle:@"" forState:UIControlStateNormal];
                }
                else
                {
                    NSString *subString;
                    if(strRate.length > 1)
                    {
                        subString = [strRate substringWithRange:NSMakeRange(0,3)];
                    }
                    else
                    {
                        subString = strRate;
                    }
                    //NSLog(@"substring : %@",subString);
                    NSString *rate = [subString stringByAppendingString:@" "];
                    NSString *rat = [rate stringByAppendingString:strRating];
                    strRating1 = rat;
                    [_btnRating setTitle:rat forState:UIControlStateNormal];
                }
                
                [_btnTips setTitle:strTips forState:UIControlStateNormal];
            }

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
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
                                                            message:@"Something went wrong. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        CheckAlert.tag = 5;
        [CheckAlert show];
        //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    
    if(IsIphone5)
    {
        _scroll.frame = CGRectMake(0 , 35, 320, 568+300);
        _scroll.contentSize = CGSizeMake(320, 700);
         _viewComment.frame = CGRectMake(0 , 400, 320, 44);
        _btnDone.frame = CGRectMake(0, 470, 320, 30);
        
    }
    else
    {
        _scroll.frame = CGRectMake(0 , 35, 320, 568+50);
        
        _scroll.contentSize = CGSizeMake(320, 700);
        _viewComment.frame = CGRectMake(0 , 315, 320, 44);
    }



    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            _lblLocation.text = @"";
            
        }
        else
        {
            [_viewLocationGuide setHidden:NO];
            [_viewTransparent setHidden:NO];
        }
    }
    if(alertView.tag ==5)
    {
        if(buttonIndex == 0)
        {
            HomePageVC *vc = [[HomePageVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
        
        }
    }
}

#pragma mark table view delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"mParkingCell";
    mParkingCell *cell = (mParkingCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    [self getEightRandomLessThan:[_arrCar count]];
//    //NSLog(@"check list: %@",[self getEightRandomLessThan:[_arrCar count]]);
    int chk = [[_arrrandValue objectAtIndex:indexPath.row ] intValue];
    
    NSLog(@"vehicle : %@",appDelegate.strVehicleType);
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mParkingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
      if([appDelegate.strVehicleType isEqualToString:@"Bicycle"])
    {
//        [self getEightRandomLessThan:[_arrcycle count]];
//        //NSLog(@"check list: %@",[self getEightRandomLessThan:[_arrcycle count]]);
//
        NSLog(@"index : %d",chk);
        NSLog(@"cycle array : %@",[_arrcycle objectAtIndex:chk]);
        [cell.lblCheckList setText:[_arrcycle objectAtIndex: chk]];
    }
    else if([appDelegate.strVehicleType isEqualToString:@"Motorcycle"])
    {
//        [self getEightRandomLessThan:[_arrBike count]];
//        //NSLog(@"check list: %@",[self getEightRandomLessThan:[_arrBike count]]);
//        int chk = [[[self getEightRandomLessThan:3] objectAtIndex:indexPath.row ] intValue];
        [cell.lblCheckList setText:[_arrBike objectAtIndex: chk]];
    }
    else
    {
        
         [cell.lblCheckList setText:[_arrCar objectAtIndex: chk]];
 }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    [cell.imgCheck setImage:[UIImage imageNamed:@""]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mParkingCell *cell = (mParkingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0){
        if(bool1){ // go from green to nothing
            bool1 = false;
            [cell.imgCheck setImage: [UIImage imageNamed:@""]];
        }else{// go from nothing to green
            bool1 = true;
            [cell.imgCheck setImage: [UIImage imageNamed:@"tick_mark1.png"]];
        }
    }else if(indexPath.row == 1){
        if(bool2){ // go from green to nothing
            bool2 = false;
            [cell.imgCheck setImage: [UIImage imageNamed:@""]];
        }else{// go from nothing to green
            bool2 = true;
            [cell.imgCheck setImage: [UIImage imageNamed:@"tick_mark1.png"]];
        }
    }else if(indexPath.row == 2){
        if(bool3){ // go from green to nothing
            bool3 = false;
            [cell.imgCheck setImage: [UIImage imageNamed:@""]];
        }else{// go from nothing to green
            bool3 = true;
            [cell.imgCheck setImage: [UIImage imageNamed:@"tick_mark1.png"]];
        }
    }
    
    
    
    
//    NSString *cellIdentifier = [NSString stringWithFormat:@"%d,%d", indexPath.section, indexPath.row];
//    //Get the old counter
//   counterForCell = [[dicCounter valueForKey:cellIdentifier] intValue];
//    //increment it
//    counterForCell++;
//    //set it in the dictionary
//    [dicCounter setValue:[NSNumber numberWithInt:counterForCell] forKey:cellIdentifier];
//    //NSLog(@"counter for cell : %d",counterForCell);
//    //NSLog(@"didcounter : %@",dicCounter);
//    //NSLog(@"section : %d",indexPath.section);
//    
//    //NSLog(@"deselect :%@",[self.tblCheckList indexPathForSelectedRow]);
     [self.tblCheckList deselectRowAtIndexPath:[self.tblCheckList indexPathForSelectedRow] animated:YES];

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblCheckList deselectRowAtIndexPath:[self.tblCheckList indexPathForSelectedRow] animated:YES];

//    mParkingCell *cell = (mParkingCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell.imgCheck setImage: [UIImage imageNamed:@""]];
    
    
}

-(NSMutableArray *)getEightRandomLessThan:(int)M {
    NSMutableArray *uniqueNumbers = [[NSMutableArray alloc] init];
    int r;
    while ([uniqueNumbers count] < 3) {
        r = arc4random() % M; // ADD 1 TO GET NUMBERS BETWEEN 1 AND M RATHER THAN 0 and M-1
        if (![uniqueNumbers containsObject:[NSNumber numberWithInt:r]]) {
            [uniqueNumbers addObject:[NSNumber numberWithInt:r]];
        }
    }
    return uniqueNumbers;
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    
    //NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    //NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
              NSLog(@"place : %@",placemark.thoroughfare);
            if (placemark.thoroughfare  == nil || placemark.thoroughfare == (id)[NSNull null])
            {
                        _lblLocation.text = [NSString stringWithFormat:@"%@",
                                     placemark.locality];
            }
            else
            {
                NSLog(@"place : %@",placemark.thoroughfare);
                _lblLocation.text = [NSString stringWithFormat:@"%@ \n%@",
                                     placemark.thoroughfare,
                                     placemark.locality];
            }
          
        } else {
            //NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    HomePageVC *vc = [[HomePageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnDone_click:(id)sender
{
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
      NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    NSString *strVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];

  
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        [_arrVehiclePark setValue:@"0" forKey:@"VehivleID"];
    }
    else
    {
       [_arrVehiclePark setValue:strVehicleID forKey:@"VehivleID"];
    }
    [_arrVehiclePark setValue:latitude forKey:@"parkingLatitude"];
    [_arrVehiclePark setValue:longitude forKey:@"prkingLongitude"];
    
    [_arrVehiclePark setValue:_txtComment.text forKey:@"Comment"];
    [appDelegate.arrMutvehiclePark addObject:_arrVehiclePark];
    
    //NSLog(@"vehicle : %@",appDelegate.arrMutvehiclePark);
     [[NSUserDefaults standardUserDefaults] setValue:appDelegate.arrMutvehiclePark forKey:@"parkVehicle"];
    HomePageVC *vc = [[HomePageVC alloc]init];
    //vc.intblue = 1;
    appDelegate.intMparking = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(IBAction)btnRating_click:(id)sender
{
    RatingTipsVC * vc = [[RatingTipsVC alloc]init];
    vc.strLocation = _lblLocation.text;
    vc.strrating = strRating1;
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnTip_click:(id)sender
{
    RatingTipsVC * vc = [[RatingTipsVC alloc]init];
    vc.strLocation = _lblLocation.text;
    vc.strrating = strRating1;
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnGotit_click:(id)sender
{
    [_viewLocationGuide setHidden:YES];
    [_viewTransparent setHidden:YES];
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
    
    [textField setTextColor:[UIColor blackColor]];
    activeTextField=textField;
       int y=0;
       if(textField == _txtComment)
    {
        y=200;
        //[btnSubmit setHidden:NO];
    }
    
    //NSLog(@"y = %d",y);
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
    
   
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = -20;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
}
#pragma mark toolbarr's button click event
- (IBAction)btnMinimize_Click:(id)sender
{
    [activeTextField resignFirstResponder];
    //int y=0;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [_txtComment bounds];
        rc = [_txtComment convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = -20;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
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
@end
