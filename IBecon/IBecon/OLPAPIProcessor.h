//
//  OLPAPIProcessor.h
//  OktaMobile
//
//  Created by Umang Shah on 1/13/16.
//  Copyright © 2016 com.okta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLPAPIResonse.h"



@interface OLPAPIProcessor : NSObject

+ (void)addCookieWithName:(NSString *)cookieName andValue:(NSString *)value;
+ (void)removeCookieWithName:(NSString *)cookieName;
+ (NSString *)getCookieValueWithName:(NSString *)cookieName;
+ (void)addAuthorizationHeader:(NSString *)apiToken;
+ (void)removeAuthorizationHeader;

+ (void)removeAllCookies;



+ (void)setAPIBaseURL:(NSString *)baseURL;

+ (OLPAPIResonse *)postWithURLPath:(NSString *)urlPath;

+ (OLPAPIResonse *)postWithURLPath:(NSString *)urlPath parameters:(NSDictionary *)parameters;

+ (OLPAPIResonse *)getWithURLPath:(NSString *)urlPath;

+ (OLPAPIResonse *)getWithURLPath:(NSString *)urlPath parameters:(NSDictionary *)parameters;

+ (NSURLRequest *)generateURLRequestForWebView:(NSString *)urlPath;


@end


