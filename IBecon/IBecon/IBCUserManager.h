//
//  IBCUserManager.h
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBCUserManager : NSObject
+ (IBCUserManager *)user;
- (BOOL)loggedInWithCachedCreds;
- (BOOL)loginWithUserName:(NSString *)userName andOrgURL:(NSString *)orgURL;
- (void)logOutUser;
- (NSString *)cachedUserName;
- (NSURL *)cachedOrgURL;
@end
