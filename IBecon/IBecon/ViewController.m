//
//  ViewController.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "ViewController.h"
#import "IBCLocationManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IBCLocationManager locationManager] requestLocationAccess];
    [[IBCLocationManager locationManager] registerBeaconRegionWithUUID:@"8B3E8616-F524-424A-A0A1-CB610A4F2916" andIdentifier:@"com.okta.hack"];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
