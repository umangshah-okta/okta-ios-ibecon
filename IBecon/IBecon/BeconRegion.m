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
        //self.apiToken = apiResponse.results[@"api_token"];
        //self.sessionId = apiResponse.results[@"session"];
    }
    return self;
}

- (BOOL)validate:(NSDictionary *)apiResponse {
    return YES;
}
@end
