//
//  APPChildViewController.h
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageContentProtocol <NSObject>

-(void)changeStatus;

@end



@interface APPChildViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ivwPage;
@property NSUInteger pageIndex;
@property NSString *imageFile;
@property (weak,nonatomic) id <PageContentProtocol>delegate;

@end
