//
//  OLPModel.h
//  OktaMobile
//
//  Created by Umang Shah on 1/13/16.
//  Copyright © 2016 com.okta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLPAPIResonse.h"



@interface OLPModel : NSObject
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *requestBaseURL;
@property (nonatomic, strong) NSString *requestURL;


- (instancetype)initWithAPIResonse:(OLPAPIResonse *)apiResponse;

@end
