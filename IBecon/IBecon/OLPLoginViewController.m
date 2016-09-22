//
//  LoginViewController.m
//  OktaMobile
//
//  Created by Christine Wang on 9/14/15.
//  Copyright © 2015 com.okta. All rights reserved.
//

#import "OLPLoginViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "OLPUtils.h"
#import "OLPConstants.h"
#import "UIImageView+AFNetworking.h"
#import "OLPWindowOverlay.h"
#import "IBCUserManager.h"

static NSString *const OLP_LOGO_URI_FMT = @"/api/v1/mobile/org/logo";


@interface OLPLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UITextField *domain;
@property (weak, nonatomic) IBOutlet UIView *domainTextHintViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) UITextField *activeField;
@property (assign, nonatomic) CGSize kbSize;
@property (assign, nonatomic) BOOL justClickedSignIn;
@property (nonatomic, strong) NSString *stateToken;
@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *sessionId;


@end

@implementation OLPLoginViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.domain.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
    self.username.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
    self.password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
    
    self.domain.leftViewMode = UITextFieldViewModeAlways;
    self.username.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    
    self.domain.layer.borderColor = [ UIColor colorWithRed: 0.828 green: 0.828 blue: 0.831 alpha: 1.000 ].CGColor;
    self.username.layer.borderColor = [ UIColor colorWithRed: 0.828 green: 0.828 blue: 0.831 alpha: 1.000 ].CGColor;
    self.password.layer.borderColor = [ UIColor colorWithRed: 0.828 green: 0.828 blue: 0.831 alpha: 1.000 ].CGColor;

    self.domain.layer.borderWidth = 0.5f;
    self.username.layer.borderWidth = 0.5f;
    self.password.layer.borderWidth = 0.5f;
    
    self.domain.textColor = [OLPUtils themeTintColor];
    self.username.textColor = [OLPUtils themeTintColor];
    self.password.textColor = [OLPUtils themeTintColor];
    
    
    self.message.text = nil;
    [self.domain becomeFirstResponder];
    

    [self registerForKeyboardNotifications];
    
    self.justClickedSignIn = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self enableLoginFields];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.message.text == nil) {
        [self.domain becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self enableLoginFields];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)showSignInFailed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [OLPWindowOverlay showMessage:@"Sign in failed!" duration:3.0f window:self.view.window];
    });
}
#pragma mark -
#pragma mark - UITextFieldDelegate functions

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    
    // If keyboard is open and its size is set for the current screen orientation
    if (self.kbSize.height > 0 && self.kbSize.width == self.loginView.frame.size.width) {
        [self scrollToActiveField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.domain) {
        [self.username becomeFirstResponder];
    } else if (textField  == self.username) {
        [self.password becomeFirstResponder];
    } else if (textField == self.password) {
        [textField resignFirstResponder];
        [self signInButtonClicked:nil];
    }
    return true;
}

#pragma mark - Actions

- (IBAction)signInButtonClicked:(id)sender {
    if ([[IBCUserManager user] loginWithUserName:self.username.text andOrgURL:self.domain.text]) {
        [self performSegueWithIdentifier:@"loginSucess" sender:self];
    } else {
        [self showSignInFailed];
    }
}
 
- (void)disableLoginFields {
    [self.activityIndicator startAnimating];
    self.signInButton.alpha = 0;
    self.signInButton.enabled = NO;
    self.domain.enabled = NO;
    self.username.enabled = NO;
    self.password.enabled = NO;
}

- (void)enableLoginFields {
    self.signInButton.enabled = YES;
    self.domain.enabled = YES;
    self.username.enabled = YES;
    self.password.enabled = YES;
    self.signInButton.alpha = 1;
    [self.activityIndicator stopAnimating];
}

- (IBAction)cancelButtonClicked:(id)sender {
}

#pragma mark - Keyboard tasks

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    self.kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self scrollToActiveField];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - ScrollView tasks

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.scrollView setContentSize:CGSizeMake(self.loginView.frame.origin.x + self.loginView.frame.size.width, self.loginView.frame.origin.y + self.loginView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.scrollView.scrollEnabled = false;
}

- (void)scrollToActiveField {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.scrollView setContentSize:CGSizeMake(self.loginView.frame.origin.x + self.loginView.frame.size.width, self.loginView.frame.origin.y + self.loginView.frame.size.height + self.loginView.frame.size.height/2 - 20)];
        self.scrollView.scrollEnabled = true;
        return;
    }

    // Calculate active part of screen (part that is not hidden by the keyboard)
    CGRect aRect = self.view.frame;
    
    // Subtract the keyboard height from the height of the fullview
    aRect.size.height -= self.kbSize.height;
 
    // Add the keyboard height to the contents of the scrollview, to make the scrollview scrollable
    [self.scrollView setContentSize:CGSizeMake(self.loginView.frame.origin.x + self.loginView.frame.size.width, self.loginView.frame.origin.y + self.loginView.frame.size.height + self.kbSize.height + 70)];
    
    // Calculate the Y origin- not the entire rect
    CGFloat effectiveOriginY = self.scrollView.frame.origin.y + self.activeField.frame.origin.y + self.activeField.frame.size.height;

    // Check that it falls within the active part of the screen
    if (effectiveOriginY > aRect.size.height) {
        // Calculate the amount we need to scroll for the active field to be fully displayed in the active part of the screen
        CGFloat offset = (self.scrollView.frame.origin.y + self.activeField.frame.origin.y + self.activeField.frame.size.height) - aRect.size.height;
        [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
        self.scrollView.scrollEnabled = true;
    } else {
        // Active field is visible, reset scroll view to original positioning
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.scrollView.scrollEnabled = false;
    }
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
