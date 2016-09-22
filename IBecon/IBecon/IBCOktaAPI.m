//
//  IBCOktaAPI.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "IBCOktaAPI.h"
#import "OLPAPIProcessor.h"

@implementation IBCOktaAPI
+ (BeconRegions *)getKnownBeconsForUser:(NSString *)userName {
    
    /*OLPAPIResonse *response = [OLPAPIProcessor getWithURLPath:@"/api/internal/v1/ibeacon/info"];
    BeconRegions *beconRegions = [[BeconRegions alloc] initWithAPIResonse:response];
    return beconRegions;*/
    
    
    BeconRegions *beconRegions = [[BeconRegions alloc] init];
    NSMutableArray<BeconRegion *> *regions = [NSMutableArray array];
    BeconRegion *region = [[BeconRegion alloc] init];
    
    region.proximityUUID = @"2B162531-FD29-4758-85B4-555A6DFF00FF";
    region.major = @(54687);
    region.minor = @(2592);
    
    [regions addObject:region];
    
    beconRegions.regions = regions;
    return beconRegions;
}


+ (BeconEventPost *)reportBeconEventForUser:(NSString *)userName bluetoothAddresss:(NSArray *)bluetoothAddresss proximityUUID:(NSString *)proximityUUID major:(NSNumber *)major minor:(NSNumber *)minor type:(BeconEvent)type {
    
    NSString *eventType = (type == BeconEventEnter) ? @"enter" : @"exit";
    NSString * requestPath = [NSString stringWithFormat:@"/api/internal/v1/ibeacon/event/beacon?userId=%@&uuid=%@&major=%@&minor=%@&type=%@", userName, proximityUUID, [major stringValue], [minor stringValue], eventType];
    
    OLPAPIResonse *response = [OLPAPIProcessor postWithURLPath:requestPath];
    BeconEventPost *beconEventPost = [[BeconEventPost alloc] initWithAPIResonse:response];
    return beconEventPost;
}


@end
