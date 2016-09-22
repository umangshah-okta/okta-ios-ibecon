//
//  BeconRegions.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLPModel.h"
#import "BeconRegion.h"

@interface BeconRegions : OLPModel
@property (nonatomic, strong) NSArray<BeconRegion *> *Regions;
@end
