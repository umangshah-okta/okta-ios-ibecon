//
//  IBCLocationManager.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "IBCLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "IBCOktaAPI.h"
#import "IBCLoginManager.h"

@interface IBCLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) NSMutableDictionary *beaconRegions;
@property (strong, nonatomic) dispatch_queue_t locationManagerQueue;
@end

@implementation IBCLocationManager


+ (IBCLocationManager *)locationManager {
    static IBCLocationManager *ibcLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ibcLocationManager = [[self alloc] init];
    });
    return ibcLocationManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locationManagerQueue = dispatch_queue_create("IBCLocationManager", DISPATCH_QUEUE_SERIAL);
        self.beaconRegions = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)requestLocationAccess {
    [self.locManager requestAlwaysAuthorization];
}

- (void)getUpdatedBeconsListAndStartMonitoring {
    dispatch_async(self.locationManagerQueue, ^{
        NSString *userName = [[IBCLoginManager user] cachedUserName];
        BeconRegions *beconRegions = [IBCOktaAPI getKnownBeconsForUser:userName];
        if ([beconRegions error] == nil) {
            NSArray *regions = beconRegions.Regions;
            for (BeconRegion *region in regions) {
                [self registerBeaconRegion:region];
            }
        }
    });

}

- (void)registerBeaconRegion:(BeconRegion *)beconRegion {

    if (self.beaconRegions[beconRegion.proximityUUID] != nil) {
        return;
    }
    
    NSUUID *proximityUUID = [[NSUUID alloc]
                             initWithUUIDString:beconRegion.proximityUUID];
    
    
    // Create the beacon region to be monitored.
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    major:beconRegion.major
                                    minor:beconRegion.minor
                                    identifier:beconRegion.proximityUUID];
    
    // Register the beacon region with the location manager.
    [self.locManager startMonitoringForRegion:beaconRegion];
    self.beaconRegions[beconRegion.proximityUUID] = beaconRegion;
}



- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    //[self.locManager requestStateForRegion:self.beaconRegion];
    [self.locManager requestStateForRegion:region];
    
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    dispatch_async(self.locationManagerQueue, ^{
        if (state == CLRegionStateInside) {
            [self postBeconEvent:region event:BeconEventEnter];
        } else {
            [self postBeconEvent:region event:BeconEventExit];
        }
    });
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    dispatch_async(self.locationManagerQueue, ^{
        [self postBeconEvent:region event:BeconEventEnter];
    });
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    dispatch_async(self.locationManagerQueue, ^{
        [self postBeconEvent:region event:BeconEventExit];
    });
}

- (void)postBeconEvent:(CLRegion *)region event:(BeconEvent)eventType {
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSString *userName = [[IBCLoginManager user] cachedUserName];
    NSString *proximityUUID = [beaconRegion.proximityUUID UUIDString];
    [IBCOktaAPI reportBeconEventForUser:userName bluetoothAddresss:nil proximityUUID:proximityUUID major:beaconRegion.major minor:beaconRegion.minor type:eventType];
}



@end
