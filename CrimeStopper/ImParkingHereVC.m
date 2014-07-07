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
}
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
    NSString *strVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleID"];
    NSString *strCurrentVehicleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentVehicleName"];
    [_btnVehicleName setTitle:strCurrentVehicleName forState:UIControlStateNormal];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdelegate str vehicle type: %@",appDelegate.strVehicleType);
    _arrrandValue = [[NSMutableArray alloc]init];
    _arrrandValue = [self getEightRandomLessThan:3];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    if(IsIphone5)
    {
        _viewComment.frame = CGRectMake(0 , 410, 320, 44);
     
    }
    else
    {
        _viewComment.frame = CGRectMake(0 , 370, 320, 44);
        
    }
    
    _arrCar = [[NSMutableArray alloc]init];
    [_arrCar addObject:@"what’s the My Wheels User Rating here?"];
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
    [_arrBike addObject:@"what’s the My Wheels User Rating here?"];
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
    [_arrcycle addObject:@"what’s the My Wheels User Rating here?"];
    [_arrcycle addObject:@"well lit spot?"];
    [_arrcycle addObject:@"spot in full view of people?"];
    [_arrcycle addObject:@"got a good quality lock – cable or D-lock, padlock and chain?"];
    [_arrcycle addObject:@"frame and both wheels locked to something immovable?"];
    [_arrcycle addObject:@"removed everything that can be taken – helmet, light, pump?"];
    [_arrcycle addObject:@"near a security camera or on-site staff?"];
    [_arrcycle addObject:@"if home – locked in garage or inside house?"];
    
    
    
    //for calling api for rating
    NSLog(@"in api");
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
  
    /*vehicleId (0 if default)
     userId (0 if default)
     pin
     latitude
     longitude
     os
     make
     model

     */
    NSString *latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:UserID forKey:@"userId"];
    [param setValue:pin forKey:@"pin"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    
    [param setValue:strVehicleID forKey:@"vehicleId"];
  
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/parkingHere.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
        NSLog(@"data : %@",jsonDictionary);
        
        NSString *EntityID = [jsonDictionary valueForKey:@"status"];
        NSLog(@"message %@",EntityID);
        if ([EntityID isEqualToString:@"failure"])
        {
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                message:@"Something went wrong. Please Try Again."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [CheckAlert show];
        }
        else
        {
            NSString *strRating = @"rating";
            NSString *strRate = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"rating"];
            NSString *str = [strRate stringByAppendingString:strRating];
            [_btnRating setTitle:str forState:UIControlStateApplication];
            
            
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    



    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    NSLog(@"check list: %@",[self getEightRandomLessThan:[_arrCar count]]);
    int chk = [[_arrrandValue objectAtIndex:indexPath.row ] intValue];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mParkingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
      if([appDelegate.strVehicleType isEqualToString:@"Bicycle"])
    {
//        [self getEightRandomLessThan:[_arrcycle count]];
//        NSLog(@"check list: %@",[self getEightRandomLessThan:[_arrcycle count]]);
//
        [cell.lblCheckList setText:[_arrcycle objectAtIndex: chk]];
    }
    else if([appDelegate.strVehicleType isEqualToString:@"Motor Cycle"])
    {
//        [self getEightRandomLessThan:[_arrBike count]];
//        NSLog(@"check list: %@",[self getEightRandomLessThan:[_arrBike count]]);
//        int chk = [[[self getEightRandomLessThan:3] objectAtIndex:indexPath.row ] intValue];
        [cell.lblCheckList setText:[_arrBike objectAtIndex: chk]];
    }
    else
    {
        
         [cell.lblCheckList setText:[_arrCar objectAtIndex: chk]];
 }
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    [cell.imgCheck setImage:[UIImage imageNamed:@""]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView reloadSections:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    
    //get cell for the currently selected row
       mParkingCell *cell = (mParkingCell *)[tableView cellForRowAtIndexPath:indexPath];

    cell.imgCheck.frame = CGRectMake(400, 31, 25, 22);

    //set image
    [cell.imageView setImage: [UIImage imageNamed:@"tick_mark.png"]];
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
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _lblLocation.text = [NSString stringWithFormat:@"%@ \n%@",
                                placemark.thoroughfare,
                                  placemark.locality
                                
                                 ];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    HomePageVC *vc = [[HomePageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
