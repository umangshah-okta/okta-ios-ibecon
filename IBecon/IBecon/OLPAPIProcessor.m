//
//  OLPAPIProcessor.m
//  OktaMobile
//
//  Created by Umang Shah on 1/13/16.
//  Copyright © 2016 com.okta. All rights reserved.
//

#import "OLPAPIProcessor.h"
#import "OLPAPIResonse.h"
#import "AFNetworking.h"

static NSString *const OK_AUTH_TOKEN_FMT = @"SSWS %@";

@interface OLPAPIProcessor ()
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSMutableDictionary *cookieMap;
@property (strong, nonatomic) NSMutableDictionary *httpHeaderMap;
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@property (strong, nonatomic) dispatch_queue_t apiDispatchQueue;

@end


@implementation OLPAPIProcessor


+ (OLPAPIProcessor *)processor {
    static OLPAPIProcessor *_processor = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _processor = [[OLPAPIProcessor alloc] init];
    });
    return _processor;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestManager = [AFHTTPRequestOperationManager manager];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.apiDispatchQueue = dispatch_queue_create("OLPAPIProcessor", DISPATCH_QUEUE_CONCURRENT);
        self.cookieMap = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)setAPIBaseURL:(NSString *)baseURL {
    [self.processor setAPIBaseURL:baseURL];
}




+ (void)addCookieWithName:(NSString *)cookieName andValue:(NSString *)value {
    [self.processor addCookieWithName:cookieName andValue:value];
}

+ (void)removeCookieWithName:(NSString *)name {
    [self.processor removeCookieWithName:name];
}

+ (NSString *)getCookieValueWithName:(NSString *)cookieName {
    return [self.processor getCookieValueWithName:cookieName];
}


+ (void)removeAllCookies {
    [self.processor removeAllCookies];
}

+ (void)addAuthorizationHeader:(NSString *)apiToken {
    [self.processor addAuthorizationHeader:apiToken];
}

+ (void)removeAuthorizationHeader {
    [self.processor removeAuthorizationHeader];
}


+ (OLPAPIResonse *)postWithURLPath:(NSString *)urlPath {
    return [self.processor callAPIWithURLPath:urlPath requesMethod:@"POST" parameters:nil];
}


+ (OLPAPIResonse *)postWithURLPath:(NSString *)urlPath parameters:(NSDictionary *)parameters {
    return [self.processor callAPIWithURLPath:urlPath requesMethod:@"POST" parameters:parameters];
}


+ (OLPAPIResonse *)getWithURLPath:(NSString *)urlPath {
    return [self.processor callAPIWithURLPath:urlPath requesMethod:@"GET" parameters:nil];
}


+ (OLPAPIResonse *)getWithURLPath:(NSString *)urlPath parameters:(NSDictionary *)parameters {
    return [self.processor callAPIWithURLPath:urlPath requesMethod:@"GET" parameters:parameters];
}

+ (NSURLRequest *)generateURLRequestForWebView:(NSString *)urlPath {
    NSError *requestGenerationError =  nil;
    NSMutableURLRequest *urlRequest = [self.processor getURLRequestWithURLPath:urlPath requesMethod:@"GET" parameters:nil error:&requestGenerationError];
    if (requestGenerationError != nil) {
        return nil;
    }
    return  [urlRequest copy];
}


- (void)setAPIBaseURL:(NSString *)baseURL {
    dispatch_barrier_async(self.apiDispatchQueue, ^{
        self.baseURL = baseURL;
    });
}




- (void)addCookieWithName:(NSString *)cookieName andValue:(NSString *)value {
    dispatch_barrier_async(self.apiDispatchQueue, ^{
        NSMutableDictionary *cookieProperties = [@{NSHTTPCookieOriginURL : self.baseURL,
                                           NSHTTPCookiePath : @"/",
                                           NSHTTPCookieName : cookieName,
                                           NSHTTPCookieValue: value
                                           } mutableCopy];
        
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        self.cookieMap[cookieName] = cookie;
    });
}

- (void)removeCookieWithName:(NSString *)name {
    dispatch_barrier_async(self.apiDispatchQueue, ^{
        [self.cookieMap removeObjectForKey:name];
    });
}

- (NSString *)getCookieValueWithName:(NSString *)cookieName {
    __block NSString *cookieValue = nil;
    dispatch_sync(self.apiDispatchQueue, ^{ // self.cookieMap is set by addCookieWithName:andValue on self.apiDispatchQueue
        cookieValue =  [(NSHTTPCookie *)self.cookieMap[cookieName] value];
    });
    
    return cookieValue;
}


- (void)removeAllCookies {
    dispatch_barrier_async(self.apiDispatchQueue, ^{
        [self.cookieMap removeAllObjects];
    });
}

- (void)addAuthorizationHeader:(NSString *)apiToken {
    dispatch_barrier_async(self.apiDispatchQueue, ^{
        [self.requestManager.requestSerializer setValue:[NSString stringWithFormat:OK_AUTH_TOKEN_FMT, apiToken] forHTTPHeaderField:@"Authorization"];
    });
}

- (void)removeAuthorizationHeader {
    dispatch_barrier_async(self.apiDispatchQueue, ^{
        [self.requestManager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    });
}

- (NSMutableURLRequest *)getURLRequestWithURLPath:(NSString *)urlPath requesMethod:(NSString *)requesMethod parameters:(NSDictionary *)parameters error:(NSError **)error {
    __block NSMutableURLRequest *request = nil;
    
    dispatch_sync(self.apiDispatchQueue, ^{
        NSString *urlString = [self.baseURL stringByAppendingString:urlPath];
        request = [self.requestManager.requestSerializer requestWithMethod:requesMethod URLString:urlString parameters:parameters error:error];
        
        if (self.cookieMap.count > 0 && self.cookieMap[@"sid"] != nil) {
            NSHTTPCookie *cookie = self.cookieMap[@"sid"];
            NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:@[cookie]];
            [request setAllHTTPHeaderFields:headers];
        }
        
        if (self.cookieMap[@"DT"] != nil) {
            NSHTTPCookie *cookie = self.cookieMap[@"DT"];
            [request setValue:[cookie value] forHTTPHeaderField:@"X-Device-Token"];
        }
    });
    
    return request;
}


- (OLPAPIResonse *)callAPIWithURLPath:(NSString *)relativePath requesMethod:(NSString *)requesMethod parameters:(NSDictionary *)parameters {
    OLPAPIResonse *response = [[OLPAPIResonse alloc] init];
    NSError *requestGenerationError =  nil;
    
    
    // Already protected by dispatch_sync(self.apiDispatchQueue
    NSMutableURLRequest *urlRequest = [self getURLRequestWithURLPath:relativePath requesMethod:requesMethod parameters:parameters error:&requestGenerationError];
    if (requestGenerationError == nil) {
        dispatch_sync(self.apiDispatchQueue, ^{
            response.requestBaseURLString  = self.baseURL;
            response.requestURLString = [urlRequest.URL absoluteString];
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"API Call success:%@\nCookie Header:%@\nResults:%@", operation.request, operation.request.allHTTPHeaderFields, responseObject);
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    response.results = responseObject;
                } else if ([responseObject isKindOfClass:[NSArray class]]){
                    response.results = @{ @"resultList" : responseObject};
                }
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(AFHTTPRequestOperation *operation, NSError *requestError) {
                
                response.error = [self processNetworkErros:operation withRequestError:requestError];
                dispatch_semaphore_signal(semaphore);
            }];
            [self.requestManager.operationQueue addOperation:operation];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        });
                      
    } else {
        NSString *localizedErrorDescription = NSLocalizedString(@"invalid network request", "invalid network request");
        response.error = [OLPAPIResonse generateAPIErrorWithErrorCode:OLPAPIProcessorAPICallFailedError oktaAPIErrorCode:nil oktaErrorId:nil oktaErrorLink:nil oktaErrorSummary:nil localizedErrorDescription:localizedErrorDescription];
    }
    
    return response;
}



- (NSError *)processNetworkErros:(AFHTTPRequestOperation *)operation withRequestError:(NSError *)requestError {
    OLPAPIProcessorError errorCode =  OLPAPIProcessorAPICallFailedError;
    NSString *oktaAPIErrorCode = nil;
    NSString *oktaErrorId = nil;
    NSString *oktaErrorLink = nil;
    NSString *oktaErrorSummary = nil;
    NSString *localizedErrorDescription = nil;
    
    
    if (operation.response != nil) {
        long statusCode = (long)[operation.response statusCode];
        long statusCodeGroup = statusCode / 100;
        
        switch (statusCodeGroup) {
            case 4: // 4xx
                switch (statusCode) {
                        case 401:
                            errorCode = OLPAPIProcessorAuthenticationFailedError;
                            break;
                        default:
                            errorCode = OLPAPIProcessorAPICallFailedError;
                            break;
                }
            default: // 5xx, 3xx
                errorCode = OLPAPIProcessorAPICallFailedError;
                break;
        }
        
        
        
        if (operation.responseObject != nil && [operation.responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseObject = operation.responseObject;
            oktaAPIErrorCode = responseObject[@"errorCode"];
            oktaErrorId = responseObject[@"oktaErrorId"];
            oktaErrorLink = responseObject[@"oktaErrorLink"];
            oktaErrorSummary = operation.responseObject[@"oktaErrorSummary"];
        }
        
    } else { // response missing that means not able to reach to the server
        errorCode =  OLPAPIProcessorNoNetworkConnection;
        localizedErrorDescription = NSLocalizedString(@"No network connection", @"show to the user that there is no network connection");
    }
    

    return [OLPAPIResonse generateAPIErrorWithErrorCode:errorCode oktaAPIErrorCode:oktaAPIErrorCode oktaErrorId:oktaErrorId oktaErrorLink:oktaErrorLink oktaErrorSummary:oktaErrorSummary localizedErrorDescription:localizedErrorDescription];
}




@end
