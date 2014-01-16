//
//  MMAppSwitcherCardView.h
//  Clockshots
//
//  Created by Vinh Phuc Dinh on 15.01.14.
//  Copyright (c) 2014 Mocava Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMAppSwitcherDemoCardView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCheckInLabel;

@end
