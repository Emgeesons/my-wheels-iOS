//
//  FeedBackVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 18/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackVC : UIViewController <UIAlertViewDelegate,UIActionSheetDelegate>
{
     UITextView *activeTextField;
}
@property (nonatomic,retain) IBOutlet UILabel *lblRating;
@property (nonatomic,retain) IBOutlet UISlider *slide;
@property (nonatomic,retain) IBOutlet UITextView *txtComment;
@property (nonatomic,retain) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

-(IBAction)btnSend_click:(id)sender;

@end
