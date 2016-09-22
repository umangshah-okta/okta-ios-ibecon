//
//  IBCOktaAPI.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "IBCOktaAPI.h"

@implementation IBCOktaAPI
+ (NSArray<BeconRegion *> *)getKnownBeconsForUser:(NSString *)userName {
    NSMutableArray<BeconRegion *> *regions = [NSMutableArray array];
    BeconRegion *region = [[BeconRegion alloc] init];
    
    region.proximityUUID = @"2B162531-FD29-4758-85B4-555A6DFF00FF";
    region.major = 54687;
    region.minor = 2592;
    
    [regions addObject:region];
    return regions;
}
@end
