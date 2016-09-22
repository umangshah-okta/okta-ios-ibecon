//
//  OLPWindowOverlay.m
//  Pods
//
//  Created by Marc Powell on 2/8/16.
//
//

#import "OLPWindowOverlay.h"
#import "OLPConstants.h"

#define DEFAULT_BACKGROUND_COLOR COLOR_RGBA(0xC44E4E, 1.0f)
#define DEFAULT_TEXT_COLOR              [UIColor whiteColor]
#define DEFAULT_FONT                    [UIFont systemFontOfSize:17.0f]

static BOOL isShowing = NO;

@implementation OLPWindowOverlay

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration window:(UIWindow *)window
{
    if (isShowing) {
        return;
    }
    isShowing = YES;
    
    // Trigger status bar color change
    [[NSNotificationCenter defaultCenter] postNotificationName:N_STATUS_BAR_LIGHT object:nil];

    // Calculate width of message
    CGFloat textWidth = [message boundingRectWithSize:CGSizeMake(window.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:DEFAULT_FONT} context:nil].size.width;
    
    // Calculate overlay frame
    CGFloat frameHeight = 64.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        frameHeight = 44.0f;
    }
    CGFloat frameWidth = window.bounds.size.width;
    CGRect frame = CGRectMake(0.0f, 0.0f, frameWidth, frameHeight);
    
    // Construct overlay view
    OLPWindowOverlay *overlay = [[OLPWindowOverlay alloc] initWithFrame:frame];
    overlay.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    // Calculate label frame
    CGSize labelSize = CGSizeMake(ceil(textWidth), 20.0f);
    if (labelSize.width > frameWidth) {
        labelSize.width = frameWidth;
    }
    CGFloat indentX = (frame.size.width - labelSize.width) / 2;
    CGFloat indentY = 20.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        indentY = 10.0f;
    }
    CGRect labelFrame = CGRectMake(indentX, indentY, labelSize.width, labelSize.height);

    // Construct label view
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.font = DEFAULT_FONT;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.alpha = 0.0f;
    
    // Resize label
    [label sizeToFit];
    labelFrame.origin.x = (frame.size.width - labelFrame.size.width) / 2;
    labelFrame.origin.y = (frame.size.height - labelFrame.size.height) / 2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        labelFrame.origin.y = labelFrame.origin.y + 8;
    }
    label.frame = labelFrame;

    // Show overlay view + label
    [overlay addSubview:label];
    [window addSubview:overlay];

    // Rotation handling via AutoresizingMask
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

    // Position overlay view off-screen
    CGRect overlayFrame = overlay.frame;
    frame.origin.y = -1 * frame.size.height;
    overlay.frame = frame;
    
    // Animate overlay view on-screen
    [UIView animateKeyframesWithDuration:0.2f delay:0.0f options:0
        animations:^{
            overlay.frame = overlayFrame;
            // fade the label in starting at 99% of the duration until the end of the duration
            [UIView addKeyframeWithRelativeStartTime:0.9999 relativeDuration:0.0001 animations:^{
                label.alpha = 1.0f;
            }];
        } completion:nil];
    
    // Animate overlay view off-screen after delay
    [UIView animateWithDuration:0.2f delay:duration options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            overlay.frame = frame;
            label.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:N_STATUS_BAR_DEFAULT object:nil];
            [overlay removeFromSuperview];
            isShowing = NO;
        }];
}

@end
