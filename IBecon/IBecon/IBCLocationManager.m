//
//  IBCLocationManager.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "IBCLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface IBCLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
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
    }
    return self;
}

- (void)requestLocationAccess {
    [self.locManager requestAlwaysAuthorization];
}

- (void)registerBeaconRegionWithUUID:(NSString *)UUID andIdentifier:(NSString*)identifier {

    NSUUID *proximityUUID = [[NSUUID alloc]
                             initWithUUIDString:UUID];
    
    
    // Create the beacon region to be monitored.
    self.beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    major:1000
                                    minor:1000
                                    identifier:identifier];
    
    // Register the beacon region with the location manager.
    [self.locManager startMonitoringForRegion:self.beaconRegion];
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locManager requestStateForRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        //Start Ranging
        [manager startRangingBeaconsInRegion:self.beaconRegion];
    }
    else
    {
        //Stop Ranging here
    }
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
}

@end
