//
//  DetailsViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 11/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Extra.h"

#define MIN_HEIGHT 10.0f

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *comments, *first_name, *location, *photo1, *photo2, *photo3, *sighting_id, *report_type, *selected_date, *selected_time;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnReportSoghting;

@end

@implementation DetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    comments = [[NSMutableArray alloc] init];
    first_name = [[NSMutableArray alloc] init];
    location = [[NSMutableArray alloc] init];
    photo1 = [[NSMutableArray alloc] init];
    photo2 = [[NSMutableArray alloc] init];
    photo3 = [[NSMutableArray alloc] init];
    sighting_id = [[NSMutableArray alloc] init];
    report_type = [[NSMutableArray alloc] init];
    selected_date = [[NSMutableArray alloc] init];
    selected_time = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    //[self.btnReportSoghting setTintColor:[UIColor colorWithHexString:@"#00B268"]];
    [self.btnReportSoghting setBackgroundColor:[UIColor colorWithHexString:@"#00B268"]];
    
    [self loadDetailsUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadDetailsUpdates {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
    
    NSDictionary *parameters = @{@"userId" : UserID,
                                 @"pin" : pin,
                                 @"os" : OS_VERSION,
                                 @"make" : MAKE,
                                 @"model" : [DeviceInfo platformNiceString],
                                 @"vehicleId" : self.vehicleID};
    
    NSLog(@"%@", parameters);
    
    NSString *url = [NSString stringWithFormat:@"%@otherUpdatesDetails.php", SERVERNAME];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        // Stop Animating activityIndicator
        //[activityIndicator stopAnimating];
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if ([[json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *reportData = (NSArray *)[json objectForKey:@"response"];
            //NSLog(@"%d", reportData.count);
            for (int i = 0; i < reportData.count; i++) {
                [comments addObject:reportData[i][@"comments"]];
                [first_name addObject:reportData[i][@"first_name"]];
                [sighting_id addObject:reportData[i][@"sightings_id"]];
                [location addObject:reportData[i][@"location"]];
                [selected_date addObject:reportData[i][@"selected_date"]];
                [selected_time addObject:reportData[i][@"selected_time"]];
                [report_type addObject:reportData[i][@"sighting_type"]];
                [photo1 addObject:reportData[i][@"photo1"]];
                [photo2 addObject:reportData[i][@"photo2"]];
                [photo3 addObject:reportData[i][@"photo3"]];
            }
            
            [self.tableView reloadData];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [DeviceInfo errorInConnection];
        //[activityIndicator stopAnimating];
    }];
}

#pragma mark - UITableView Datasource/delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sighting_id.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.tableView.backgroundColor;
    }
    
    [cell.contentView addSubview:[self plotViewWithIndexNumber:indexPath.row andType:@"view"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [[self plotViewWithIndexNumber:indexPath.row andType:@"height"] floatValue];
    return height + 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self plotHeaderViewWithType:@"view"];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat height = [[self plotHeaderViewWithType:@"height"] floatValue];
        return height;
    }
    return 0;
}

-(id)plotHeaderViewWithType:(NSString *)typeView {
    
    // Add 1 background view as container
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    viewBG.backgroundColor = [UIColor whiteColor];
    
    /************************************* Top view Starts ***********************************/
    
    // View for top
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewBG.frame.size.width, 30)];
    viewTop.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    // add UILabel for Name of user
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 290, 30)];
    NSString *strName = [NSString stringWithFormat:@"%@ lost her vehicle", self.firstNameHeader];
    
    // Attribute string for User name and activity
    NSMutableAttributedString *attrStringName = [[NSMutableAttributedString alloc] initWithString:strName];
    [attrStringName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f] range:NSMakeRange(0, strName.length)];
    [attrStringName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#0067AD"] range:NSMakeRange(0, [self.firstNameHeader length])];
    lblName.attributedText = attrStringName;
    [viewTop addSubview:lblName];
    [viewBG addSubview:viewTop];
    
    /************************************* Top view Ends ***********************************/
    
    /************************************* Bottom view Starts ***********************************/
    
    // Add Bottom view for other information
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, viewTop.frame.origin.y + viewTop.frame.size.height, 300, 50)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    // ImageView for vehicle_type
    UIImageView *ivVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 15)];
    // set Image here
    if ([self.vehicleHeader isEqualToString:@"Bicycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
    } else if ([self.vehicleHeader isEqualToString:@"Car"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([self.vehicleHeader isEqualToString:@"Motor Cycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        ivVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    [viewBottom addSubview:ivVehicle];
    
    // Add Vehicle's make & model here
    UILabel *lblMakeModel = [[UILabel alloc] initWithFrame:CGRectMake(ivVehicle.frame.origin.x + ivVehicle.frame.size.width + 5, ivVehicle.frame.origin.x, 180, MIN_HEIGHT)];
    lblMakeModel.numberOfLines = 0;
    lblMakeModel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    lblMakeModel.text = [NSString stringWithFormat:@"%@ %@", self.makeHeader, self.modelHeader];
    lblMakeModel.textColor = [UIColor colorWithHexString:@"#0067AD"];
    CGSize constraint = CGSizeMake(lblMakeModel.frame.size.width, 20000.0f);
    
    CGRect textRect = [lblMakeModel.text boundingRectWithSize:constraint
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:@{NSFontAttributeName:lblMakeModel.font}
                                                      context:nil];
    
    [lblMakeModel setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMakeModel setAdjustsFontSizeToFitWidth:NO];
    [lblMakeModel setFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y, lblMakeModel.frame.size.width, MAX(textRect.size.height, MIN_HEIGHT))];
    [viewBottom addSubview:lblMakeModel];
    
    // Add Type of report here.
    UILabel *lblTypeReport = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x + lblMakeModel.frame.size.width + 5, lblMakeModel.frame.origin.y, 75, 20)];
    lblTypeReport.numberOfLines = 0;
    lblTypeReport.textAlignment = NSTextAlignmentRight;
    lblTypeReport.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblTypeReport.text = [NSString stringWithFormat:@"%@", self.typeSightingHeader];
    lblTypeReport.textColor = [UIColor colorWithHexString:@"#FF444C"];
    [viewBottom addSubview:lblTypeReport];
    
    // Add Registration number here
    UILabel *lblRegistration = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y + lblMakeModel.frame.size.height, 268, 20)];
    lblRegistration.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblRegistration.text = [NSString stringWithFormat:@"Registration number: %@", self.regNoHeader];
    [viewBottom addSubview:lblRegistration];
    
    // Add horizontal line here
    UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblRegistration.frame.origin.y + lblRegistration.frame.size.height + 5, lblRegistration.frame.size.width, 1)];
    ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewBottom addSubview:ivHR];
    
    // Add Date here
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, ivHR.frame.origin.y + ivHR.frame.size.height + 10, 160, 20)];
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [dtFormat dateFromString:self.dateHeader];
    [dtFormat setDateFormat:@"E,MMMM dd,yyyy"];
    lblDate.text = [dtFormat stringFromDate:dt];
    
    [viewBottom addSubview:lblDate];
    
    // Add Time here
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x + lblDate.frame.size.width, lblDate.frame.origin.y, 100, lblDate.frame.size.height)];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.font = lblDate.font;
    
    [dtFormat setDateFormat:@"hh:mm:ss"];
    NSDate *time = [dtFormat dateFromString:self.timeHeader];
    [dtFormat setDateFormat:@"hh:mm"];
    lblTime.text = [dtFormat stringFromDate:time];
    
    [viewBottom addSubview:lblTime];
    
    // Add Location icon here
    UIImageView *ivLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblDate.frame.origin.y + lblDate.frame.size.height + 5, 7, 10)];
    ivLocationIcon.image = [UIImage imageNamed:@"ic_location.png"];
    [viewBottom addSubview:ivLocationIcon];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(ivLocationIcon.frame.origin.x + ivLocationIcon.frame.size.width + 5, ivLocationIcon.frame.origin.y - 4, 240, 20)];
    lblLocation.font = lblDate.font;
    lblLocation.numberOfLines = 0;
    lblLocation.text = self.locationHeader;
    
    CGSize constraintLocation = CGSizeMake(lblLocation.frame.size.width, 20000.0f);
    
    CGRect textRectLocation = [lblLocation.text boundingRectWithSize:constraintLocation
                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName:lblLocation.font}
                                                             context:nil];
    
    [lblLocation setLineBreakMode:NSLineBreakByWordWrapping];
    [lblLocation setAdjustsFontSizeToFitWidth:NO];
    [lblLocation setFrame:CGRectMake(lblLocation.frame.origin.x, lblLocation.frame.origin.y, lblLocation.frame.size.width, MAX(textRectLocation.size.height, MIN_HEIGHT))];
    
    [viewBottom addSubview:lblLocation];
    
    // Add HR if comment OR image is present
    NSString *strComment = self.commentHeader;
    NSString *strImage1 = self.photo1Header;
    
    if (strComment.length > 0 || strImage1.length > 0) {
        // Add HR here
        // Add horizontal line here
        UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLocation.frame.origin.y + lblLocation.frame.size.height + 10, 300, 1)];
        ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [viewBottom addSubview:ivHR];
        
        CGFloat top = ivHR.frame.origin.y + ivHR.frame.size.height;
        
        if (strComment.length > 0) {
            // Add Comment here
            UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, top + 10, 280, 20)];
            lblComment.font = lblDate.font;
            lblComment.numberOfLines = 0;
            lblComment.text = strComment;
            
            CGSize constraintComment = CGSizeMake(lblComment.frame.size.width, 20000.0f);
            
            CGRect textRectComment = [lblComment.text boundingRectWithSize:constraintComment
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:lblComment.font}
                                                                   context:nil];
            
            [lblComment setLineBreakMode:NSLineBreakByWordWrapping];
            [lblComment setAdjustsFontSizeToFitWidth:NO];
            [lblComment setFrame:CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, lblComment.frame.size.width, MAX(textRectComment.size.height, MIN_HEIGHT))];
            
            top = top + textRectComment.size.height + 10;
            
            [viewBottom addSubview:lblComment];
        }
        
        if (strImage1.length > 0) {
            UIImageView *ivImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, top + 10, 60, 60)];
            ivImage1.layer.cornerRadius = 30;
            ivImage1.clipsToBounds = YES;
            [ivImage1 setImageWithURL:[NSURL URLWithString:strImage1] placeholderImage:[UIImage imageNamed:@""]];
            [viewBottom addSubview:ivImage1];
            
            UIImageView *ivImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(ivImage1.frame.origin.x + ivImage1.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage2.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage2.clipsToBounds = ivImage1.clipsToBounds;
            if ([self.photo2Header length] > 0) {
                [ivImage2 setImageWithURL:[NSURL URLWithString:self.photo2Header] placeholderImage:[UIImage imageNamed:@""]];
            }
            [viewBottom addSubview:ivImage2];
            
            UIImageView *ivImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(ivImage2.frame.origin.x + ivImage2.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage3.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage3.clipsToBounds = ivImage1.clipsToBounds;
            if ([self.photo3Header length] > 0) {
                [ivImage3 setImageWithURL:[NSURL URLWithString:self.photo3Header] placeholderImage:[UIImage imageNamed:@""]];
            }
            [viewBottom addSubview:ivImage3];
        }
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [viewBottom.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    CGRect frame = viewBottom.frame;
    frame.size.height = wd+ht;
    viewBottom.frame = frame;
    
    [viewBG addSubview:viewBottom];
    
    UIView *vBG = [viewBG.subviews lastObject];
    NSInteger wd2 = vBG.frame.origin.y;
    NSInteger ht2 = vBG.frame.size.height;
    
    sizeOfContent = wd2 + ht2 + 10;
    CGRect frameBG = viewBG.frame;
    frameBG.size.height = wd2+ht2 + 10;
    viewBG.frame = frameBG;
    
    if ([typeView isEqualToString:@"height"]) {
        return [NSString stringWithFormat:@"%f", sizeOfContent];
    } else if ([typeView isEqualToString:@"view"]) {
        return viewBG;
    }
    
    return nil;
}

-(id)plotViewWithIndexNumber:(NSInteger)indexPath andType:(NSString *)typeView {
    
    // Add 1 background view as container
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 300, 80)];
    viewBG.backgroundColor = [UIColor whiteColor];
    
    /************************************* Top view Starts ***********************************/
    
    // View for top
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewBG.frame.size.width, 30)];
    viewTop.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    // add UILabel for Name of user
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    NSString *strName = [NSString stringWithFormat:@"%@ spotted the vehicle", first_name[indexPath]];
    
    // Attribute string for User anme and activity
    NSMutableAttributedString *attrStringName = [[NSMutableAttributedString alloc] initWithString:strName];
    [attrStringName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f] range:NSMakeRange(0, strName.length)];
    [attrStringName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#0067AD"] range:NSMakeRange(0, [first_name[indexPath] length])];
    lblName.attributedText = attrStringName;
    [viewTop addSubview:lblName];
    
    // Add Type of report here.
    UILabel *lblTypeReport = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x + lblName.frame.size.width + 5, lblName.frame.origin.y, 75, 30)];
    lblTypeReport.numberOfLines = 0;
    lblTypeReport.textAlignment = NSTextAlignmentRight;
    lblTypeReport.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblTypeReport.text = [NSString stringWithFormat:@"%@", report_type[indexPath]];
    lblTypeReport.textColor = [UIColor colorWithHexString:@"#FF444C"];
    [viewTop addSubview:lblTypeReport];
    
    [viewBG addSubview:viewTop];
    
    /************************************* Top view Ends ***********************************/
    
    /************************************* Bottom view Starts ***********************************/
    
    // Add Bottom view for other information
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, viewTop.frame.origin.y + viewTop.frame.size.height, 300, 50)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    /*// Add horizontal line here
    UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblRegistration.frame.origin.y + lblRegistration.frame.size.height + 5, lblRegistration.frame.size.width, 1)];
    ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewBottom addSubview:ivHR];*/
    
    // Add Date here
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 160, 20)];
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [dtFormat dateFromString:selected_date[indexPath]];
    [dtFormat setDateFormat:@"E,MMMM dd,yyyy"];
    lblDate.text = [dtFormat stringFromDate:dt];
    
    [viewBottom addSubview:lblDate];
    
    // Add Time here
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x + lblDate.frame.size.width, lblDate.frame.origin.y, 100, lblDate.frame.size.height)];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.font = lblDate.font;
    
    [dtFormat setDateFormat:@"hh:mm:ss"];
    NSDate *time = [dtFormat dateFromString:selected_time[indexPath]];
    [dtFormat setDateFormat:@"hh:mm"];
    lblTime.text = [dtFormat stringFromDate:time];
    
    [viewBottom addSubview:lblTime];
    
    // Add Location icon here
    UIImageView *ivLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x, lblDate.frame.origin.y + lblDate.frame.size.height + 5, 7, 10)];
    ivLocationIcon.image = [UIImage imageNamed:@"ic_location.png"];
    [viewBottom addSubview:ivLocationIcon];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(ivLocationIcon.frame.origin.x + ivLocationIcon.frame.size.width + 5, ivLocationIcon.frame.origin.y - 4, 240, 20)];
    lblLocation.font = lblDate.font;
    lblLocation.numberOfLines = 0;
    lblLocation.text = location[indexPath];
    
    CGSize constraintLocation = CGSizeMake(lblLocation.frame.size.width, 20000.0f);
    
    CGRect textRectLocation = [lblLocation.text boundingRectWithSize:constraintLocation
                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName:lblLocation.font}
                                                             context:nil];
    
    [lblLocation setLineBreakMode:NSLineBreakByWordWrapping];
    [lblLocation setAdjustsFontSizeToFitWidth:NO];
    [lblLocation setFrame:CGRectMake(lblLocation.frame.origin.x, lblLocation.frame.origin.y, lblLocation.frame.size.width, MAX(textRectLocation.size.height, MIN_HEIGHT))];
    
    [viewBottom addSubview:lblLocation];
    
    // Add HR if comment OR image is present
    NSString *strComment = comments[indexPath];
    NSString *strImage1 = photo1[indexPath];
    
    if (strComment.length > 0 || strImage1.length > 0) {
        // Add HR here
        // Add horizontal line here
        UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLocation.frame.origin.y + lblLocation.frame.size.height + 10, 300, 1)];
        ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [viewBottom addSubview:ivHR];
        
        CGFloat top = ivHR.frame.origin.y + ivHR.frame.size.height;
        
        if (strComment.length > 0) {
            // Add Comment here
            UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, top + 10, 280, 20)];
            lblComment.font = lblDate.font;
            lblComment.numberOfLines = 0;
            lblComment.text = strComment;
            
            CGSize constraintComment = CGSizeMake(lblComment.frame.size.width, 20000.0f);
            
            CGRect textRectComment = [lblComment.text boundingRectWithSize:constraintComment
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:lblComment.font}
                                                                   context:nil];
            
            [lblComment setLineBreakMode:NSLineBreakByWordWrapping];
            [lblComment setAdjustsFontSizeToFitWidth:NO];
            [lblComment setFrame:CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, lblComment.frame.size.width, MAX(textRectComment.size.height, MIN_HEIGHT))];
            
            top = top + textRectComment.size.height + 10;
            
            [viewBottom addSubview:lblComment];
        }
        
        if (strImage1.length > 0) {
            UIImageView *ivImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, top + 10, 60, 60)];
            ivImage1.layer.cornerRadius = 30;
            ivImage1.clipsToBounds = YES;
            [ivImage1 setImageWithURL:[NSURL URLWithString:strImage1] placeholderImage:[UIImage imageNamed:@""]];
            [viewBottom addSubview:ivImage1];
            
            UIImageView *ivImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(ivImage1.frame.origin.x + ivImage1.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage2.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage2.clipsToBounds = ivImage1.clipsToBounds;
            if ([photo2[indexPath] length] > 0) {
                [ivImage2 setImageWithURL:[NSURL URLWithString:photo2[indexPath]] placeholderImage:[UIImage imageNamed:@""]];
            }
            [viewBottom addSubview:ivImage2];
            
            UIImageView *ivImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(ivImage2.frame.origin.x + ivImage2.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage3.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage3.clipsToBounds = ivImage1.clipsToBounds;
            if ([photo3[indexPath] length] > 0) {
                [ivImage3 setImageWithURL:[NSURL URLWithString:photo3[indexPath]] placeholderImage:[UIImage imageNamed:@""]];
            }
            [viewBottom addSubview:ivImage3];
        }
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [viewBottom.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    CGRect frame = viewBottom.frame;
    frame.size.height = wd+ht;
    viewBottom.frame = frame;
    
    [viewBG addSubview:viewBottom];
    
    UIView *vBG = [viewBG.subviews lastObject];
    NSInteger wd2 = vBG.frame.origin.y;
    NSInteger ht2 = vBG.frame.size.height;
    
    sizeOfContent = wd2 + ht2 + 10;
    CGRect frameBG = viewBG.frame;
    frameBG.size.height = wd2+ht2 + 10;
    viewBG.frame = frameBG;
    
    if ([typeView isEqualToString:@"height"]) {
        return [NSString stringWithFormat:@"%f", sizeOfContent];
    } else if ([typeView isEqualToString:@"view"]) {
        return viewBG;
    }
    
    return nil;
}



@end