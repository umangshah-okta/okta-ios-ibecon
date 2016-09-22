//
//  OLPConstants.h
//  OktaMobile
//
//  Created by Christine Wang on 11/5/15.
//  Copyright © 2015 com.okta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_RGBA(_r, _a) [UIColor colorWithRed:((float)((_r & 0xFF0000) >> 16))/255.0 green:((float)((_r & 0xFF00) >> 8))/255.0 blue:((float)(_r & 0xFF))/255.0 alpha:_a]
#define COLOR_RGB(_r) COLOR_RGBA(_r, 1.0)

@interface OLPConstants : NSObject

extern NSString *const K_OLP_BASE_URL;
extern NSString *const K_OLP_ACCOUNT_NAME;
extern NSString *const K_TOKEN_REFERENCE;
extern NSString *const N_OLP_SESSION_EXPIRED;
extern NSString *const N_OLP_LOGIN_COMPLETE;
extern NSString *const N_OLP_CANCEL_LOGIN_COMPLETE;
extern NSString *const N_OLP_LOGOUT_COMPLETE;
extern NSString *const N_OLP_CANCEL_FORCE_MFA;
extern NSString *const N_OLP_FORCEMFA_COMPLETE;
extern NSString *const K_OLP_SHARED_APP_GROUP;
extern NSString* const N_STATUS_BAR_LIGHT;
extern NSString* const N_STATUS_BAR_DEFAULT;


extern NSString *const K_OLP_SHARED_APP_GROUP;

extern NSString *const N_OLP_RENEW_SESSION_WITH_MFA_COMPLETE;
extern NSString *const N_OLP_RENEW_SESSION_WITH_MFA_FAILED_SHOULD_LOGOUT;
extern NSString *const N_OLP_RENEW_SESSION_WITH_MFA_FAILED;

@end
