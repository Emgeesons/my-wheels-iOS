//
//  WebApiController.h
//  Chirag Lukhi
//
//  Created by Lanetteam on 9/9/12.
//  Copyright (c) 2012 HongYing Dev Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWebApi.h"
#import "Reachability.h"
#import "TSearchInfo.h"



@interface WebApiController : NSObject

+ (Reachability *) checkServerConnection;
- (void)callAPI_POST:(NSString *)apiName  andParams:(NSDictionary *)params SuccessCallback:(SEL)successCallback andDelegate:delegateObj ;

- (void)callAPIWithImage:(NSString *)apiName WithImageParameter:(NSMutableDictionary *)Iparameter WithoutImageParameter:(NSMutableDictionary *)WIparameter SuccessCallback:(SEL)successCallback andDelegate:delegateObj ;

- (void)callAPI_GET:(NSString *)apiName andParams:(NSDictionary *)params SuccessCallback:(SEL)successCallback andDelegate:delegateObj;

-(void)setToken:(NSString *)token;

- (void)callAPIwithJSON_POST:(NSString *)apiName  json:(NSString *)json SuccessCallback:(SEL)successCallback andDelegate:delegateObj ;

- (void)callAPIwithToken_POST:(NSString *)apiName andParams:(NSDictionary *)params token:(NSString *)token SuccessCallback:(SEL)successCallback andDelegate:delegateObj;

@end
