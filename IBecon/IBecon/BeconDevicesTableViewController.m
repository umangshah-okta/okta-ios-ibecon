//
//  BeconDevicesTableViewController.m
//  IBecon
//
//  Created by Umang Shah on 9/21/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import "BeconDevicesTableViewController.h"
#import "IBCLoginManager.h"
#import "IBCLocationManager.h"
#import "BeconTableViewCell.h"
#import "BeconRegion.h"

@interface BeconDevicesTableViewController ()
@property (nonatomic, strong) NSArray *becons;
@end

@implementation BeconDevicesTableViewController



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.becons = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beconsUpdated:) name:@"BeconsUpdated" object:nil];
    
    [[IBCLocationManager locationManager] getUpdatedBeconsListAndStartMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)logOut:(id)sender {
    [[IBCLoginManager user] logOutUser];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (void)beconsUpdated:(NSNotification *)notification {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.becons = notification.object;
        [self.tableView reloadData];
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.becons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beconDetails" forIndexPath:indexPath];
    BeconRegion *region = self.becons[indexPath.row];
    cell.location.text = region.proximityUUID;
    cell.uuid.text = region.proximityUUID;
    cell.major.text = [region.major stringValue];
    cell.minor.text = [region.minor stringValue];
    return cell;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
