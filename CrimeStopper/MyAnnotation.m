//
//  MyAnnotation.m
//  SimpleMapView
//
//  Created by Mayur Birari .

//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
 @synthesize image;

- (void)dealloc 
{
	
	self.title = nil;
	self.subtitle = nil;
    self.image = nil;
}
@end