//
//  IBCLocationManager.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBCLocationManager : NSObject
+ (IBCLocationManager *)locationManager;
- (void)requestLocationAccess;
- (void)getUpdatedBeconsListAndStartMonitoring;
@end
