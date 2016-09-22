//
//  BeconRegions.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "BeconRegions.h"

@implementation BeconRegions
- (instancetype)initWithAPIResonse:(OLPAPIResonse *)apiResponse {
    self = [super initWithAPIResonse:apiResponse];
    if (self) {
        //self.apiToken = apiResponse.results[@"api_token"];
        //self.sessionId = apiResponse.results[@"session"];
    }
    return self;
}

- (BOOL)validate:(NSDictionary *)apiResponse {
    return YES;
}
@end
