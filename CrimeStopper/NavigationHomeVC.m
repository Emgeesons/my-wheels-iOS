//
//  NavigationHomeVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 17/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "NavigationHomeVC.h"
#import "TableViewCell.h"

@interface NavigationHomeVC ()

@end

@implementation NavigationHomeVC
@synthesize arrImage,arrList;

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
    
    arrList = [[NSMutableArray alloc] initWithObjects:@"Home",@"Emergency Number",@"Feedback",@"Share App",@"Rate us",@"Logout", nil];
    
    arrImage=[[NSMutableArray alloc]initWithObjects:@"ic_nav_home.png",@"ic_nav_emergency_numbers.png",@"ic_nav_feedback",@"ic_nav_share_app.png",@"ic_nav_rate_us.png",@"ic_nav_logout.png", nil];
    
        self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Methods...
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblList.text = [arrList objectAtIndex:[indexPath row]];
    [cell.imgList setImage:[UIImage imageNamed:[arrImage objectAtIndex:[indexPath row]]]];
    
    if(indexPath.row == 1)
    {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,140, 320, 1)];
        [lbl setBackgroundColor:[UIColor whiteColor]];
        [_tblNavigation addSubview:lbl];
        
    }
    else if (indexPath.row == 4)
    {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,325, 320, 1)];
        [lbl setBackgroundColor:[UIColor whiteColor]];
        [_tblNavigation addSubview:lbl];
    }
    else
    {
    
    }
    
  //  [cell.imgList setImage:[UIImage imageNamed:[arrImage objectAtIndex:[indexPath row]]]];
   
     
   // cell.lblDuration.text = [NSString stringWithFormat:@"%@",[DurationArray objectAtIndex:[indexPath row]]];
    return cell;
}

@end
