//
//  DeviceInfo.h
//  CrimeStopper
//
//  Created by Yogesh Suthar on 03/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject
+(NSString *)platformNiceString;
+(BOOL)isIphone5;
+ (NSString *)trimString:(NSString *)text;
+ (void)errorInConnection;
@end
