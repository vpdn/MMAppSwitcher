//
//  MMAppSwitcherCardView.m
//  Clockshots
//
//  Created by Vinh Phuc Dinh on 15.01.14.
//  Copyright (c) 2014 Mocava Mobile. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MMAppSwitcherDemoCardView.h"

@implementation MMAppSwitcherDemoCardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViewFromNib];
        self.borderView.layer.cornerRadius = 7.0;
    }
    return self;
}

- (void)addViewFromNib {
    UIView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"MMAppSwitcherDemoCardView" owner:self options:nil] firstObject];
    self.bounds = nibView.bounds;
    [self addSubview:nibView];
}

@end
