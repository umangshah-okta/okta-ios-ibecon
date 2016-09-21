//
//  OLPAPIResonse.h
//  OktaMobile
//
//  Created by Umang Shah on 1/13/16.
//  Copyright © 2016 com.okta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OLPAPIProcessorError) {
    OLPAPIProcessorNoNetworkConnection = 1024,
    OLPAPIProcessorAPICallFailedError = 1025,
    OLPAPIProcessorAuthenticationFailedError = 1026,
};

extern NSString *const OLPAPIProcessorErrorDomain;


@interface OLPAPIResonse : NSObject
@property (strong, nonatomic) NSString *requestBaseURLString;
@property (strong, nonatomic) NSString *requestURLString;
@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic) NSError *error;
+ (NSError *)generateAPIErrorWithErrorCode:(OLPAPIProcessorError)apiErrorCode oktaAPIErrorCode:(NSString *)oktaAPIErrorCode oktaErrorId:(NSString *)oktaErrorId oktaErrorLink:(NSString *)oktaErrorLink oktaErrorSummary:(NSString *)oktaErrorSummary localizedErrorDescription:(NSString *)localizedErrorDescription;
+ (NSError *)APIFailErrorWithLocalizedErrorDescription:(NSString *)localizedErrorDescription;
@end
