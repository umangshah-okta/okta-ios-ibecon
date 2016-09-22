//
//  BeconRegion.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLPModel.h"

@interface BeconRegion : OLPModel
@property (nonatomic, strong) NSString *proximityUUID;
@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, assign) NSNumber *minor;
@property (nonatomic, strong) NSString *location;
- (instancetype)initWithAPIResonse:(NSDictionary *)apiResponse;
@end
