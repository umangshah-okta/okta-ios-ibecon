//
//  BeconRegion.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeconRegion : NSObject
@property (nonatomic, strong) NSString *proximityUUID;
@property (nonatomic, assign) int major;
@property (nonatomic, assign) int minor;
@end
