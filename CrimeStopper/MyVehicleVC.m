//
//  MyVehicleVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 03/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "MyVehicleVC.h"
#import "MyVehicleCell.h"
#import "UserProfileVC.h"
#import "AddVehiclesVC.h"
#import "VehicleProfilePageVC.h"
#import "AppDelegate.h"

@interface MyVehicleVC ()
{
    AppDelegate *app;
}
@end

@implementation MyVehicleVC

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
    _arrVehicles = [[NSDictionary alloc]init];
    _arrVehicles = [[NSUserDefaults standardUserDefaults] objectForKey:@"vehicles"];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"arr vehicles : %@",_arrVehicles);
    
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
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrVehicles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyVehicleCell";
    MyVehicleCell *cell = (MyVehicleCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyVehicleCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    NSString *str = [[_arrVehicles valueForKey:@"vehicle_make"] objectAtIndex:indexPath.row];
    NSString *str1 = [[_arrVehicles valueForKey:@"vehicle_model"] objectAtIndex:indexPath.row];
    NSString *str4 = [str stringByAppendingString:@" "];
    NSString *str2 = [str4 stringByAppendingString:str1];
    cell.lblMakeModel.text = str2;
    cell.lblRegistrationNumber.text = [[_arrVehicles valueForKey:@"registration_serial_no"] objectAtIndex:indexPath.row];
    cell.lblStatus.text = [[_arrVehicles valueForKey:@"vehicle_status"] objectAtIndex:indexPath.row];
    NSString *vehivleType = [[_arrVehicles valueForKey:@"vehicle_type"] objectAtIndex:indexPath.row];
    NSString *strStatus = [[_arrVehicles valueForKey:@"vehicle_status"] objectAtIndex:indexPath.row];
    if(strStatus == nil || strStatus == (id)[NSNull null] || [strStatus isEqualToString:@""])
    {
        [cell.lblStatus setHidden:YES];
        [cell.imgStatus setHidden:YES];
        [cell.lblMakeModel setTextColor:[UIColor blueColor]];
        
    }
    else
    {
        [cell.lblStatus setHidden:NO];
        [cell.imgStatus setHidden:NO];
        [cell.lblMakeModel setTextColor:[UIColor orangeColor]];
        [cell.lblStatus setTextColor:[UIColor orangeColor]];

    }
    if([vehivleType isEqualToString:@"Car"])
    {
        [cell.lblRegNo setText:@"Registration No:"];
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_car.png"]];
    }
    else if ([vehivleType isEqualToString:@"Bicycle"])
    {
        [cell.lblRegNo setText:@"Serial Number:"];
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_cycle2.png"]];
    }
    else if ([vehivleType isEqualToString:@"Motor Cycle"])
    {
         [cell.lblRegNo setText:@"Registration No:"];
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_bike.png"]];
    }
    else
    {
         [cell.lblRegNo setText:@"Registration No:"];
        [cell.imgVehicleType setImage:[UIImage imageNamed:@"ic_other.png"]];
    }
    [cell.imgStatus setImage:[UIImage imageNamed:@"incomplete.png"]];
    
 //    cell.lblExercise.text = [ExerciseArray objectAtIndex:[indexPath row]];
//    cell.lblDuration.text = [NSString stringWithFormat:@"%@",[DurationArray objectAtIndex:[indexPath row]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VehicleProfilePageVC *vc = [[VehicleProfilePageVC alloc]init];
    vc.strVehicleId = [[_arrVehicles valueForKey:@"vehicle_id"] objectAtIndex:indexPath.row];
    app.strVehicleId = NULL;
    app.strVehicleId = [[_arrVehicles valueForKey:@"vehicle_id"] objectAtIndex:indexPath.row];
    vc.arrVehiclesCount = [[NSDictionary alloc]init];
    vc.arrVehiclesCount = [_arrVehicles mutableCopy];
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
   
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnAddVehicle_click:(id)sender
{
    AddVehiclesVC *vc = [[AddVehiclesVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
