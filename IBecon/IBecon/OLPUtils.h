//
//  OLPUtils.h
//  OktaMobile
//
//  Created by Christine Wang on 9/29/15.
//  Copyright (c) 2015 com.okta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OLPUtils : NSObject

+ (NSString *)cleanseSubDomain:(NSString *)subDomain;
+ (NSURL *)getBaseURLForSubDomain:(NSString *)subDomain;
+ (BOOL)isURLValid:(NSString *)url;
+ (NSURL *)getURLwithBaseURL:(NSURL *)baseURL andPath:(NSString *)path;

+ (UIColor *)themeTintColor;
+ (BOOL)urlHostMatches:(NSString *)urlStr1 withURL:(NSString *)urlStr2;

@end
