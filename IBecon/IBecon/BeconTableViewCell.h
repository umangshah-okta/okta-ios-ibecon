//
//  BeconTableViewCell.h
//  IBecon
//
//  Created by Umang Shah on 9/22/16.
//  Copyright © 2016 Umang Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeconTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (weak, nonatomic) IBOutlet UILabel *minor;
@end
