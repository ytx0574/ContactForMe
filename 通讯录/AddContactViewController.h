//
//  AddContactViewController.h
//  通讯录
//
//  Created by Johnson on 23/09/2016.
//  Copyright © 2016 BB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactViewController : UITableViewController

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) void(^addComplete)(NSString *name, NSString *phone);

@end
