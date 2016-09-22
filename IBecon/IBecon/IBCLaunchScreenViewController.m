//
//  IBCLaunchScreenViewController.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "IBCLaunchScreenViewController.h"
#import "IBCUserManager.h"

@interface IBCLaunchScreenViewController ()

@end

@implementation IBCLaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // call API to get list of devices 
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    if (YES || [[IBCUserManager user] loggedInWithCachedCreds]) {
        [self performSegueWithIdentifier:@"loginSucess" sender:self];
    } else {
        [self performSegueWithIdentifier:@"loginUser" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)unwindMDMConfigModalViewControllers:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqual:@"unwindFromUserAgreement"]) {
        
    }
}




@end
