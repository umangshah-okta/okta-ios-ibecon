//
//  OLPWindowOverlay.h
//  Pods
//
//  Created by Marc Powell on 2/8/16.
//
//

#import <UIKit/UIKit.h>

@interface OLPWindowOverlay : UIView

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration window:(UIWindow *)window;

@end
