//
//  OLPModel.m
//  OktaMobile
//
//  Created by Umang Shah on 1/13/16.
//  Copyright © 2016 com.okta. All rights reserved.
//

#import "OLPModel.h"

@implementation OLPModel
- (instancetype)initWithAPIResonse:(OLPAPIResonse *)apiResponse {
    self = [super init];
    if (self) {
        self.requestBaseURL = apiResponse.requestBaseURLString;
        self.requestURL = apiResponse.requestURLString;
        self.error = [self processError:apiResponse.error];
        if (self.error == nil) { // if no error validate API response
            if (![self validate:apiResponse.results]) {
                self.error = [OLPAPIResonse APIFailErrorWithLocalizedErrorDescription:NSLocalizedString(@"", "")];
            }
        }
    }
    return self;
}


- (NSError *)processError:(NSError *)error {
    return error;
}

- (BOOL)validate:(NSDictionary *)apiResponse {
    return YES;
}

@end
