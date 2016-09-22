//
//  IBCUserManager.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "IBCLoginManager.h"
#import "OktaUtil.h"
#import "OLPAPIProcessor.h"


static NSString *const userLoggedIn = @"userLoggedIn";
static NSString *const cachedUserName = @"cachedUserName";
static NSString *const cachedOrgURL = @"cachedOrgURL";

@implementation IBCLoginManager

+ (IBCLoginManager *)user {
    static IBCLoginManager *ibcUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ibcUserManager = [[self alloc] init];
    });
    return ibcUserManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


- (BOOL)logInWithCachedCreds {
    BOOL isUserLoggedIn = [OktaUtil loadPersistedBoolForKey:userLoggedIn];
    NSString *userName = [OktaUtil loadPersistedValueForKey:cachedUserName];
    NSString *orgURL = [OktaUtil loadPersistedValueForKey:cachedOrgURL];
    
    if (isUserLoggedIn && userName != nil && orgURL != nil) {
        return [self loginWithUserName:userName andOrgURL:orgURL];
    }
    return NO;
}
- (BOOL)loginWithUserName:(NSString *)userName andOrgURL:(NSString *)orgURL{
    if (userName == nil || orgURL == nil) {
        return NO;
    }
    
    [OLPAPIProcessor setAPIBaseURL:orgURL];
    [OktaUtil persistKey:cachedUserName withValue:userName];
    [OktaUtil persistKey:cachedOrgURL withValue:orgURL];
    [OktaUtil persistKey:userLoggedIn withBool:YES];
    return YES;
}

- (void)logOutUser {
    [OktaUtil persistKey:userLoggedIn withBool:NO];
}

- (NSString *)cachedUserName {
    return [OktaUtil loadPersistedValueForKey:cachedUserName];
}
- (NSString *)cachedOrgURL {
    return [OktaUtil loadPersistedValueForKey:cachedOrgURL];
}
@end
