//
//  IBCOktaAPI.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeconRegion.h"

@interface IBCOktaAPI : NSObject
+ (NSArray<BeconRegion *> *)getKnownBeconsForUser:(NSString *)userName;
@end
