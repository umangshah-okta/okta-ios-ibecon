//
//  BeconRegion.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "BeconRegion.h"

@implementation BeconRegion
- (instancetype)initWithAPIResonse:(NSDictionary *)apiResponse {
    self = [super init];
    if (self) {
        if ([self validate:apiResponse]) {
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            self.proximityUUID = apiResponse[@"uuid"];
            self.major = [formatter numberFromString:apiResponse[@"major"]];
            self.minor = [formatter numberFromString:apiResponse[@"minor"]];
            self.location = apiResponse[@"loc"];
        } else {
            self.error = [OLPAPIResonse APIFailErrorWithLocalizedErrorDescription:NSLocalizedString(@"BeconRegion data not valid", "BeconRegion data not valid")];
        }
    }
    return self;
}

- (BOOL)validate:(NSDictionary *)apiResponse {
    if (apiResponse[@"uuid"] == nil ||
        apiResponse[@"major"] == nil ||
        apiResponse[@"minor"] == nil ||
        apiResponse[@"loc"] == nil) {
        return NO;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;

    NSNumber *major = [formatter numberFromString:apiResponse[@"major"]];
    NSNumber *minor = [formatter numberFromString:apiResponse[@"minor"]];
    if (major ==  nil || minor == nil) {
        return NO;
    }
    
    return YES;
}
@end
