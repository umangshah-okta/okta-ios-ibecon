//
//  OLPAPIResonse.m
//  OktaMobile
//
//  Created by Umang Shah on 1/13/16.
//  Copyright © 2016 com.okta. All rights reserved.
//

#import "OLPAPIResonse.h"

NSString *const OLPAPIProcessorErrorDomain = @"com.okta.olpapiprocessor";


@implementation OLPAPIResonse
+ (NSError *)generateAPIErrorWithErrorCode:(OLPAPIProcessorError)apiErrorCode oktaAPIErrorCode:(NSString *)oktaAPIErrorCode oktaErrorId:(NSString *)oktaErrorId oktaErrorLink:(NSString *)oktaErrorLink oktaErrorSummary:(NSString *)oktaErrorSummary localizedErrorDescription:(NSString *)localizedErrorDescription {
    
    
    if (oktaAPIErrorCode == nil || ![oktaAPIErrorCode isKindOfClass:[NSString class]]) {
        oktaAPIErrorCode = @"UNKNOWN";
    }
    
    if (oktaErrorId == nil || ![oktaErrorId isKindOfClass:[NSString class]]) {
        oktaAPIErrorCode = @"UNKNOWN";
    }
    
    if (oktaErrorLink == nil || ![oktaErrorLink isKindOfClass:[NSString class]]) {
        oktaErrorLink = @"UNKNOWN";
    }
    
    if (oktaErrorSummary == nil || ![oktaErrorSummary isKindOfClass:[NSString class]]) {
        oktaErrorSummary = @"UNKNOWN";
    }
    
    if (localizedErrorDescription == nil || ![localizedErrorDescription isKindOfClass:[NSString class]]) {
        localizedErrorDescription = @"";
    }
    
    
    
    NSDictionary *userInfo = @{
                               @"oktaAPIErrorCode" : oktaAPIErrorCode,
                               @"oktaErrorId" : oktaAPIErrorCode,
                               @"oktaErrorLink" : oktaAPIErrorCode,
                               @"oktaErrorSummary" : oktaErrorSummary,
                               NSLocalizedDescriptionKey: localizedErrorDescription // The model object should modify this field
                               };
    
    NSError *olpError = [[NSError alloc] initWithDomain:OLPAPIProcessorErrorDomain code:apiErrorCode userInfo:userInfo];
    return olpError;
    
}


+ (NSError *)APIFailErrorWithLocalizedErrorDescription:(NSString *)localizedErrorDescription {
    return [self generateAPIErrorWithErrorCode:OLPAPIProcessorAPICallFailedError oktaAPIErrorCode:nil oktaErrorId:nil oktaErrorLink:nil oktaErrorSummary:nil localizedErrorDescription:localizedErrorDescription];
}
@end
