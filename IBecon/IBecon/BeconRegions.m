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
        NSMutableArray<BeconRegion *> *regions = [NSMutableArray array];
        if (self.error == nil) {
            for (NSDictionary *regionDict in apiResponse.results[@"beacons"]) {
                BeconRegion *region = [[BeconRegion alloc] initWithAPIResonse:regionDict];
                if (region.error == nil) {
                    [regions addObject:region];
                } else {
                    self.error = region.error;
                }
            }
            self.regions = regions;
        }
    }
    return self;
}

- (BOOL)validate:(NSDictionary *)apiResponse {
    if (apiResponse[@"beacons"] != nil) {
        return [apiResponse[@"beacons"] isKindOfClass:[NSArray class]];
    }
    
    return NO;
}
@end
