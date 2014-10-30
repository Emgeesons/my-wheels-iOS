//
//  ReportSummaryViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 17/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ReportSummaryViewController.h"
#import "UpdatesViewController.h"
#import "AFNetworking.h"
#import "UIColor+Extra.h"
#import "UIButton+AFNetworking.h"
#import "CustomImageView.h"
@import QuickLook;
#import "HomePageVC.h"

#define MIN_HEIGHT 10.0f

@interface ReportSummaryViewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    NSInteger top;
    NSMutableArray *selectedImage;
    NSString *insurerNumber;
}
- (IBAction)backButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnCallPoliceClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCallPolice;
@property (weak, nonatomic) IBOutlet UIButton *btnCallInsurer;
- (IBAction)btnCallInsurerClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCallPoliceXPositionConstraint;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

@end

@implementation ReportSummaryViewController

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
    
    // set navigationBar height to 55
    self.navBarHeightConstraint.constant = 55;
    [self.navBar setNeedsUpdateConstraints];
    
    self.btnCallPolice.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
    self.btnCallInsurer.backgroundColor = self.btnCallPolice.backgroundColor;
    
    ////NSLog(@"%d", self.detailsArray.count);
    [self displayDetails];
}

-(void)displayDetails {
    // create a background view as container
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 0)];
    
    // string to check vehicle is cycle or something else
    NSString *vehicleType = @"Registration number:";
    
    // ImageView for vehicle_type
    UIImageView *ivVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 15)];
    // set Image here
    if ([self.detailsArray[0][@"vehicle_type"] isEqualToString:@"Bicycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_cycle.png"];
        vehicleType = @"Serial number:";
    } else if ([self.detailsArray[0][@"vehicle_type"] isEqualToString:@"Car"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_car.png"];
    } else if ([self.detailsArray[0][@"vehicle_type"] isEqualToString:@"Motorcycle"]) {
        ivVehicle.image = [UIImage imageNamed:@"ic_bike.png"];
    } else {
        ivVehicle.image = [UIImage imageNamed:@"ic_other.png"];
    }
    [viewContainer addSubview:ivVehicle];
    
    // Add Vehicle's make & model here
    UILabel *lblMakeModel = [[UILabel alloc] initWithFrame:CGRectMake(ivVehicle.frame.origin.x + ivVehicle.frame.size.width + 5, ivVehicle.frame.origin.x, 180, MIN_HEIGHT)];
    lblMakeModel.numberOfLines = 0;
    lblMakeModel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    lblMakeModel.text = [NSString stringWithFormat:@"%@ %@", self.detailsArray[0][@"make"], self.detailsArray[0][@"model"]];
    lblMakeModel.textColor = [UIColor colorWithHexString:@"#0067AD"];
    CGSize constraint = CGSizeMake(lblMakeModel.frame.size.width, 20000.0f);
    
    CGRect textRect = [lblMakeModel.text boundingRectWithSize:constraint
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:@{NSFontAttributeName:lblMakeModel.font}
                                                      context:nil];
    
    [lblMakeModel setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMakeModel setAdjustsFontSizeToFitWidth:NO];
    [lblMakeModel setFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y, lblMakeModel.frame.size.width, MAX(textRect.size.height, MIN_HEIGHT))];
    [viewContainer addSubview:lblMakeModel];
    
    // Add Type of report here.
    UILabel *lblTypeReport = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x + lblMakeModel.frame.size.width + 5, lblMakeModel.frame.origin.y, 75, 30)];
    lblTypeReport.numberOfLines = 2;
    lblTypeReport.textAlignment = NSTextAlignmentRight;
    lblTypeReport.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblTypeReport.text = [NSString stringWithFormat:@"%@", self.detailsArray[0][@"report_type"]];
    lblTypeReport.textColor = [UIColor colorWithHexString:@"#FF444C"];
    [viewContainer addSubview:lblTypeReport];
    
    // Add Registration number here
    UILabel *lblRegistration = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblMakeModel.frame.origin.y + lblMakeModel.frame.size.height, 268, 20)];
    lblRegistration.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    lblRegistration.text = [NSString stringWithFormat:@"%@ %@",vehicleType, self.detailsArray[0][@"registration_serial_no"]];
    [viewContainer addSubview:lblRegistration];
    
    // Add horizontal line here
    UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblRegistration.frame.origin.y + lblRegistration.frame.size.height + 5, lblRegistration.frame.size.width, 1)];
    ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewContainer addSubview:ivHR];
    
    // Add Date here
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, ivHR.frame.origin.y + ivHR.frame.size.height + 10, 200, 20)];
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt = [dtFormat dateFromString:self.detailsArray[0][@"selected_date"]];
    [dtFormat setDateFormat:@"E,MMMM dd,yyyy"];
    lblDate.text = [dtFormat stringFromDate:dt];
    [viewContainer addSubview:lblDate];
    
    // Add Time here
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblDate.frame.origin.x + lblDate.frame.size.width, lblDate.frame.origin.y, 100, lblDate.frame.size.height)];
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.font = lblDate.font;
    
    [dtFormat setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dtFormat dateFromString:self.detailsArray[0][@"selected_time"]];
    [dtFormat setDateFormat:@"HH:mm"];
    lblTime.text = [dtFormat stringFromDate:time];
    [viewContainer addSubview:lblTime];
    
    // Add Location icon here
    UIImageView *ivLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(lblMakeModel.frame.origin.x, lblDate.frame.origin.y + lblDate.frame.size.height + 5, 7, 10)];
    ivLocationIcon.image = [UIImage imageNamed:@"ic_location.png"];
    [viewContainer addSubview:ivLocationIcon];
    
    // Add Location here
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(ivLocationIcon.frame.origin.x + ivLocationIcon.frame.size.width + 5, ivLocationIcon.frame.origin.y - 4, 240, 20)];
    lblLocation.font = lblDate.font;
    lblLocation.numberOfLines = 0;
    lblLocation.text = self.detailsArray[0][@"location"];
    
    CGSize constraintLocation = CGSizeMake(lblLocation.frame.size.width, 20000.0f);
    
    CGRect textRectLocation = [lblLocation.text boundingRectWithSize:constraintLocation
                                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName:lblLocation.font}
                                                             context:nil];
    
    [lblLocation setLineBreakMode:NSLineBreakByWordWrapping];
    [lblLocation setAdjustsFontSizeToFitWidth:NO];
    [lblLocation setFrame:CGRectMake(lblLocation.frame.origin.x, lblLocation.frame.origin.y, lblLocation.frame.size.width, MAX(textRectLocation.size.height, MIN_HEIGHT))];
    
    [viewContainer addSubview:lblLocation];
    
    // Add HR if comment OR image is present
    NSString *strComment = self.detailsArray[0][@"comments"];
    NSString *strImage1 = self.detailsArray[0][@"photo1"];
    
    top = lblLocation.frame.origin.y + lblLocation.frame.size.height;
    
    if (strComment.length > 0 || strImage1.length > 0) {
        // Add HR here
        // Add horizontal line here
        UIImageView *ivHR = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLocation.frame.origin.y + lblLocation.frame.size.height + 10, 300, 1)];
        ivHR.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [viewContainer addSubview:ivHR];
        
        top = ivHR.frame.origin.y + ivHR.frame.size.height;
        
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
            
            top = lblComment.frame.origin.y + lblComment.frame.size.height;
            
            [viewContainer addSubview:lblComment];
        }
        
        if (strImage1.length > 0) {
            
            CustomImageView *ivImage1 = [[CustomImageView alloc] initWithFrame:CGRectMake(10, top + 10, 60, 60)];
            [ivImage1 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
            ivImage1.layer.cornerRadius = 30;
            ivImage1.clipsToBounds = YES;
            ivImage1.userInteractionEnabled = YES;
            ivImage1.imageFileURL = strImage1;
            [ivImage1 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strImage1] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
            [viewContainer addSubview:ivImage1];
            
            top = ivImage1.frame.origin.y + ivImage1.frame.size.height;
            
            CustomImageView *ivImage2 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage1.frame.origin.x + ivImage1.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage2.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage2.clipsToBounds = ivImage1.clipsToBounds;
            if ([self.detailsArray[0][@"photo2"] length] > 0) {
                [ivImage2 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                ivImage2.userInteractionEnabled = YES;
                ivImage2.imageFileURL = self.detailsArray[0][@"photo2"];
                [ivImage2 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.detailsArray[0][@"photo2"]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                [viewContainer addSubview:ivImage2];
            }
            
            CustomImageView *ivImage3 = [[CustomImageView alloc] initWithFrame:CGRectMake(ivImage2.frame.origin.x + ivImage2.frame.size.width + 10, ivImage1.frame.origin.y, 60, 60)];
            ivImage3.layer.cornerRadius = ivImage1.layer.cornerRadius;
            ivImage3.clipsToBounds = ivImage1.clipsToBounds;
            if ([self.detailsArray[0][@"photo3"] length] > 0) {
                [ivImage3 addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                ivImage3.userInteractionEnabled = YES;
                ivImage3.imageFileURL = self.detailsArray[0][@"photo3"];
                [ivImage3 setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.detailsArray[0][@"photo3"]] placeholderImage:[UIImage imageNamed:@"add_photos_grey.png"]];
                [viewContainer addSubview:ivImage3];
            }
            
        }
    }
    
    // Add horizontal line here
    UIImageView *ivHR2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, top + 20, 300, 1)];
    ivHR2.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewContainer addSubview:ivHR2];
    
    // Add Vehicles Details label here
    UILabel *lblVehicleDetails = [[UILabel alloc] initWithFrame:CGRectMake(5, top + 30, 300, 20)];
    lblVehicleDetails.text = @"Vehicle Details";
    lblDate.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    [viewContainer addSubview:lblVehicleDetails];
    
    top = lblVehicleDetails.frame.origin.y + lblVehicleDetails.frame.size.height + 20;
    //Add Vehicle Type here
    [viewContainer addSubview:[self addLabelWithText1:@"Vehicle Type: " andText2:self.detailsArray[0][@"vehicle_type"]]];
    if([self.detailsArray[0][@"vehicle_type"] isEqualToString:@"Car"])
    {
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Make: " andText2:self.detailsArray[0][@"make"]]];
        
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Model: " andText2:self.detailsArray[0][@"model"]]];
        
        top = top + 20;
        //Add BodyType here
        [viewContainer addSubview:[self addLabelWithText1:@"Body Type: " andText2:self.detailsArray[0][@"body_type"]]];
        
        top = top + 20;
        //Add EngineNo here
        [viewContainer addSubview:[self addLabelWithText1:@"EngineNo: " andText2:self.detailsArray[0][@"engine_no"]]];
        
        top = top + 20;
        //Add VN here
        [viewContainer addSubview:[self addLabelWithText1:@"VIN: " andText2:self.detailsArray[0][@"vin_chassis_no"]]];
        
        top = top + 20;
        //Add Color here
        [viewContainer addSubview:[self addLabelWithText1:@"Color: " andText2:self.detailsArray[0][@"colour"]]];
        
        top = top + 20;
        //Add Accessories here
        [viewContainer addSubview:[self addLabelWithText1:@"Accessories: " andText2:self.detailsArray[0][@"accessories_unique_features"]]];

    }
    else if ([self.detailsArray[0][@"vehicle_type"] isEqualToString:@"Bicycle"])
    {
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Make: " andText2:self.detailsArray[0][@"make"]]];
        
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Model: " andText2:self.detailsArray[0][@"model"]]];
        
        
        top = top + 20;
        //Add EngineNo here
        [viewContainer addSubview:[self addLabelWithText1:@"SerialNo2: " andText2:self.detailsArray[0][@"engine_no"]]];
        
        top = top + 20;
        //Add VN here
        [viewContainer addSubview:[self addLabelWithText1:@"e-bike battery no: " andText2:self.detailsArray[0][@"vin_chassis_no"]]];
        
        top = top + 20;
        //Add Color here
        [viewContainer addSubview:[self addLabelWithText1:@"Color: " andText2:self.detailsArray[0][@"colour"]]];
        
        top = top + 20;
        //Add Accessories here
        [viewContainer addSubview:[self addLabelWithText1:@"Accessories: " andText2:self.detailsArray[0][@"accessories_unique_features"]]];

    }
    else if ([self.detailsArray[0][@"vehicle_type"] isEqualToString:@"Motorcycle"])
    {
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Make: " andText2:self.detailsArray[0][@"make"]]];
        
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Model: " andText2:self.detailsArray[0][@"model"]]];
        
        
        top = top + 20;
        //Add EngineNo here
        [viewContainer addSubview:[self addLabelWithText1:@"EngineNo: " andText2:self.detailsArray[0][@"engine_no"]]];
        
        top = top + 20;
        //Add VN here
        [viewContainer addSubview:[self addLabelWithText1:@"VIN: " andText2:self.detailsArray[0][@"vin_chassis_no"]]];
        
        top = top + 20;
        //Add Color here
        [viewContainer addSubview:[self addLabelWithText1:@"Color: " andText2:self.detailsArray[0][@"colour"]]];
        
        top = top + 20;
        //Add Accessories here
        [viewContainer addSubview:[self addLabelWithText1:@"Accessories: " andText2:self.detailsArray[0][@"accessories_unique_features"]]];

    }
    else 
    {
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Make: " andText2:self.detailsArray[0][@"make"]]];
        
        top = top + 20;
        //Add Make here
        [viewContainer addSubview:[self addLabelWithText1:@"Model: " andText2:self.detailsArray[0][@"model"]]];
        
        
        top = top + 20;
        //Add EngineNo here
        [viewContainer addSubview:[self addLabelWithText1:@"EngineNo: " andText2:self.detailsArray[0][@"engine_no"]]];
        
        top = top + 20;
        //Add VN here
        [viewContainer addSubview:[self addLabelWithText1:@"VIN: " andText2:self.detailsArray[0][@"vin_chassis_no"]]];
        
        top = top + 20;
        //Add Color here
        [viewContainer addSubview:[self addLabelWithText1:@"Color: " andText2:self.detailsArray[0][@"colour"]]];
        
        top = top + 20;
        //Add Accessories here
        [viewContainer addSubview:[self addLabelWithText1:@"Accessories: " andText2:self.detailsArray[0][@"accessories_unique_features"]]];

    }
    top = top + 30;
    // Add horizontal line here
    UIImageView *ivHR1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, top, 280, 1)];
    ivHR1.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [viewContainer addSubview:ivHR1];
    
    top = top + 10;
    //Add Insurance Company Name here
    [viewContainer addSubview:[self addLabelWithText1:@"Insurance Company Name: " andText2:self.detailsArray[0][@"insurance_company_name"]]];
    
    top = top + 20;
    //Add Insurance Policy No here
    [viewContainer addSubview:[self addLabelWithText1:@"Insurance Policy No: " andText2:self.detailsArray[0][@"insurance_policy_no"]]];
    
    // set insurance company number
    insurerNumber = self.detailsArray[0][@"insurance_company_number"];
    
    if (insurerNumber == nil || [insurerNumber isEqualToString:@""]) {
        // hide btnCallInsurer button
        self.btnCallInsurer.hidden = YES;
        
        // rearrange btnCallPolice button in middle
        self.btnCallPoliceXPositionConstraint.constant = 95;
        [self.btnCallPolice setNeedsUpdateConstraints];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:self.detailsArray[0][@"insurance_expiry_date"]];
    [format setDateFormat:@"dd-MM-yyyy"];
    NSString *dtString = [format stringFromDate:date];
    
    if (dtString == NULL) {
        dtString = @"";
    }
    
    top = top + 20;
    //Add Expiry Date here
    [viewContainer addSubview:[self addLabelWithText1:@"Expiry Date: " andText2:dtString]];
    
    UIView *lLast = [viewContainer.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    CGRect frame = viewContainer.frame;
    frame.size.height = wd + ht;
    viewContainer.frame = frame;
    
    [self.scrollView addSubview:viewContainer];
    
    float sizeOfContent = 0;
    UIView *lLast1 = [self.scrollView.subviews lastObject];
    NSInteger wd1 = lLast1.frame.origin.y;
    NSInteger ht1 = lLast1.frame.size.height;
    
    sizeOfContent = wd1+ht1;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
}

-(UIView *)addLabelWithText1:(NSString *)text1 andText2:(NSString *)text2 {
    UILabel *lblVehicleType = [[UILabel alloc] initWithFrame:CGRectMake(10, top, 300, 20)];
    
    NSString *lbl1 = text1;
    NSString *lbl2 = text2;
    
    NSString *strName = [NSString stringWithFormat:@"%@%@", lbl1, lbl2];
    
    NSMutableAttributedString *attrStringName = [[NSMutableAttributedString alloc] initWithString:strName];
    [attrStringName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f] range:NSMakeRange(0, strName.length)];
    [attrStringName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0f] range:NSMakeRange(lbl1.length, lbl2.length)];
    lblVehicleType.attributedText = attrStringName;
    return lblVehicleType;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    //NSLog(@"%@",self.navigationController.viewControllers);
    
    NSArray *VCS = self.navigationController.viewControllers;
    //NSLog(@"%@", [VCS[VCS.count - 2] class]);
    
    if ([VCS[VCS.count - 2] isKindOfClass:[UpdatesViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // navigate to home VC
        //[self.navigationController popToViewController:VCS[1] animated:YES];
        for (int i = 0 ; i < VCS.count; i++) {
            if ([VCS[i] isKindOfClass:[HomePageVC class]]) {
                [self.navigationController popToViewController:VCS[i] animated:YES];
                return;
            }
        }
    }
    
}
- (IBAction)btnCallPoliceClicked:(id)sender {
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"131444"]];
    [[UIApplication sharedApplication] openURL:telURL];
}

-(void)openImage:(CustomImageView *)imageView {
    
    [self deleteAllimageFiles];
    
    selectedImage = [[NSMutableArray alloc] init];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.currentPreviewItemIndex = 0;
    
    NSURL *URL = [NSURL URLWithString:imageView.imageFileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSString *fileName = [URL lastPathComponent];
    [selectedImage addObject:fileName];
    
    // save image here
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"/download"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, fileName];
    
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        [data writeToFile:filePath atomically:YES];
        //NSLog(@"saved");
        [self presentViewController:previewController animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"file downloading error : %@", [error localizedDescription]);
    }];
    [downloadRequest start];
    
}

#pragma mark - QLPreviewControllerDataSource Methods
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return [selectedImage count];
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *fileURL = nil;
    NSString *fileName = [selectedImage objectAtIndex:index];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"/download"];
    NSString *previewFileFullPath = [path stringByAppendingPathComponent:fileName];
    fileURL = [NSURL fileURLWithPath:previewFileFullPath];
    return fileURL;
}

-(void)deleteAllimageFiles {
    // Delete all r u rser's body picks from gallery folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:@"download/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

- (IBAction)btnCallInsurerClicked:(id)sender {
    NSLog(@"insurar nu. :%@",insurerNumber);
    NSString *secondString = [insurerNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"insurar nu. :%@",secondString);
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", secondString]];
    [[UIApplication sharedApplication] openURL:telURL];
}
@end
