//
//  IBCOktaAPI.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeconRegions.h"
#import "BeconEventPost.h"

typedef NS_ENUM(NSInteger, BeconEvent)
{
    BeconEventEnter,
    BeconEventExit
};


@interface IBCOktaAPI : NSObject
+ (BeconRegions *)getKnownBeconsForUser:(NSString *)userName;
//event type required. can be 'enter' or 'exit'
+ (BeconEventPost *)reportBeconEventForUser:(NSString *)userName bluetoothAddresss:(NSArray *)bluetoothAddresss proximityUUID:(NSString *)proximityUUID major:(NSNumber *)major minor:(NSNumber *)minor type:(BeconEvent)type;

@end
