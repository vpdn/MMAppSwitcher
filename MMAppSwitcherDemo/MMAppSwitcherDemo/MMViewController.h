//
//  MMViewController.h
//  MMAppSwitcherDemo
//
//  Created by Vinh Phuc Dinh on 15.01.14.
//  Copyright (c) 2014 Mocava Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAppSwitcher.h"

@interface MMViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MMAppSwitcherDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *timeTable;
@property (weak, nonatomic) IBOutlet UIButton *trackButton;
@end
