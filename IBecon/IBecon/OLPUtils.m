//
//  OLPUtils.m
//  OktaMobile
//
//  Created by Christine Wang on 9/29/15.
//  Copyright (c) 2015 com.okta. All rights reserved.
//

#import "OLPUtils.h"
#import <AudioToolbox/AudioServices.h>

static NSString *const K_OKTA_URLPATTERN = @"https://%@.okta.com";
static NSString *const K_HTTP_PREFIX = @"http";
static NSString *const K_HTTPS_PREFIX = @"https";
static NSString *const K_OKTA_URLSUFFIX = @".okta.com";

@interface OLPUtils ()

@end

@implementation OLPUtils

// TODO: the following utilites were ported directly from okta mobile utils, double check that all this logic still makes sense

+ (NSURL *)getBaseURLForSubDomain:(NSString *)subDomain {
    subDomain = [[subDomain lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSURL *url = nil;

    if ([subDomain hasPrefix:K_HTTP_PREFIX]) {
        url = [NSURL URLWithString:subDomain];
        
    } else if ([subDomain hasSuffix:K_OKTA_URLSUFFIX]) {
        // We know they typed something like xxx.okta.com
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", K_HTTPS_PREFIX, subDomain]];
        
    } else {
        NSArray *components = [subDomain componentsSeparatedByString:@"."];
        if ([components count] == 3) {
            // We have three components separated by dot, so assume they just forgot the prefix
            // and typed something like xxx.trexcloud.com
            // We may remove this one in the future, so even though it is functionally equivalent to the previous
            // one, we are leaving it here for now.
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", K_HTTPS_PREFIX,subDomain]];
        }
    }

    if (url == nil) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", K_HTTPS_PREFIX, subDomain,K_OKTA_URLSUFFIX]];
    }

    if (url && url.scheme && url.host) {
        return url;
    } else{
        return nil;
    }
}

+ (NSString *)cleanseSubDomain:(NSString *)subDomain {
    if (subDomain == nil) {
        return nil;
    }
    
    subDomain = [[subDomain lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([subDomain isEqualToString:@""]) {
        return nil;
    }

    if ([OLPUtils isURLValid:subDomain]){
        return subDomain;
    }

    NSArray *components = [subDomain componentsSeparatedByString:@"."];
    if([components count] == 2 || [components count] == 1) {
            return [components objectAtIndex:0];
    }

    return subDomain;
}

+ (BOOL)isURLValid:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if(url != nil && url.scheme && url.host) {
        return true;
    } else {
        return false;
    }
}

+ (NSURL *)getURLwithBaseURL:(NSURL *)baseURL andPath:(NSString *)path {
    return [NSURL URLWithString:path relativeToURL:baseURL];
}

+(UIColor *)themeTintColor {
    return [UIColor colorWithRed: 0.004 green: 0.488 blue: 0.758 alpha: 1.000];
}

+ (BOOL)urlHostMatches:(NSString *)urlStr1 withURL:(NSString *)urlStr2 {
    BOOL ret = NO;

    if ((urlStr1 != nil) && (urlStr2 != nil)) {
        NSURL *url1 =[NSURL URLWithString:urlStr1];
        NSURL *url2 = [NSURL URLWithString:urlStr2];
        if (([url1 host] != nil) && [[url1 host] isEqualToString:[url2 host]]) {
            ret = YES;
        }
    }
    return ret;
}

@end
