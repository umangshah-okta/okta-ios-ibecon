//
//  OLPConstants.m
//  OktaMobile
//
//  Created by Christine Wang on 11/5/15.
//  Copyright © 2015 com.okta. All rights reserved.
//

#import "OLPConstants.h"

@implementation OLPConstants

#pragma mark - Notifications

NSString *const K_OLP_BASE_URL = @"OLPBaseURL";
NSString *const K_OLP_ACCOUNT_NAME = @"OLPAccountName";
NSString *const K_TOKEN_REFERENCE = @"OLPAPITokenReference";

NSString *const N_OLP_SESSION_EXPIRED = @"OLPSessionExpired";
NSString *const N_OLP_LOGIN_COMPLETE = @"OLPLoginComplete";
NSString *const N_OLP_CANCEL_LOGIN_COMPLETE = @"OLPCancelLoginComplete";
NSString *const N_OLP_LOGOUT_COMPLETE = @"OLPLogoutComplete";

NSString *const N_OLP_RENEW_SESSION_WITH_MFA_COMPLETE = @"OLPRenewSessionWithMFAComplete";
NSString *const N_OLP_RENEW_SESSION_WITH_MFA_FAILED_SHOULD_LOGOUT = @"OLPRenewSessionWithMFAFailedShouldLogout";
NSString *const N_OLP_RENEW_SESSION_WITH_MFA_FAILED = @"OLPRenewSessionWithMFAFailed";





#if DEBUG
NSString *const K_OLP_SHARED_APP_GROUP = @"group.com.okta.shareddata";
#endif


#if APPSTORE
NSString *const K_OLP_SHARED_APP_GROUP = @"group.com.okta.ios.mobile";
#endif


#if ENTERPRISE
NSString *const K_OLP_SHARED_APP_GROUP = @"group.com.okta.shareddata";
#endif

NSString* const N_STATUS_BAR_LIGHT = @"StatusBarLight";
NSString* const N_STATUS_BAR_DEFAULT = @"StatusBarDefault";

@end
