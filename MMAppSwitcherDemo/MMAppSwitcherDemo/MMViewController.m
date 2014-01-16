//
//  MMViewController.m
//  MMAppSwitcherDemo
//
//  Created by Vinh Phuc Dinh on 15.01.14.
//  Copyright (c) 2014 Mocava Mobile. All rights reserved.
//

#import "MMViewController.h"
#import "MMAppSwitcher.h"
#import "MMAppSwitcherDemoCardView.h"


@interface MMViewController ()
@property (nonatomic, strong) NSArray *trackedDurations;
@property (nonatomic, assign, getter = isTracking) BOOL tracking;
@property (nonatomic, assign) int secondsCounter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *checkInDate;
@property (nonatomic, strong) MMAppSwitcherDemoCardView *cardView;
@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDate];
    [self setupTable];
    self.trackedDurations = @[];
    self.cardView = [MMAppSwitcherDemoCardView new];
    [[MMAppSwitcher sharedInstance] setDatasource:self];
}

- (void)setupDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateLabel.text = [NSString stringWithFormat:@"It's %@.", [dateFormatter stringFromDate:[NSDate date]]];
    self.cardView.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (void)setupTable {
    self.timeTable.dataSource = self;
    self.timeTable.delegate = self;
}

- (IBAction)toggleTimeTracking:(id)sender {
    if ([self isTracking]) {
        // stop tracking
        [self.trackButton setTitle:NSLocalizedString(@"Start tracking time", nil) forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        NSMutableArray *trackedDurations = [self.trackedDurations mutableCopy];
        [trackedDurations insertObject:@(self.secondsCounter) atIndex:0];
        self.trackedDurations = [NSArray arrayWithArray:trackedDurations];
        self.secondsCounter = 0;
        self.checkInDate = nil;
    } else {
        // start tracking
        [self.trackButton setTitle:NSLocalizedString(@"Stop tracking time", nil) forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementSeconds) userInfo:nil repeats:YES];
        self.checkInDate = [NSDate date];
    }
    self.tracking = !self.tracking;
    [self.timeTable reloadData];
}

- (void)incrementSeconds {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.checkInDate];
    self.secondsCounter = floor(10*timeInterval);
    [self.timeTable reloadData];
}


#pragma mark - UITableViewDelegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isTracking]) {
        return self.trackedDurations.count + 1;
    } else {
        return self.trackedDurations.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeTableCell"];
    }
    
    int duration = 0;

    if ([self isTracking]) {
        if (indexPath.row==0) {
            duration = self.secondsCounter;
            cell.textLabel.textColor = [UIColor orangeColor];
        } else {
            duration = [self.trackedDurations[indexPath.row-1] intValue];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    } else {
        duration = [self.trackedDurations[indexPath.row] intValue];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [self detailedDurationStringForSeconds:duration];
    return cell;
}


#pragma mark - Helper

- (NSString *)detailedDurationStringForSeconds:(int)interval {
    int duration = interval;
    int seconds = duration % 60;
    duration = duration - seconds;
    int minutes = duration/60 % 60;
    duration = duration - minutes*60;
    int hours = truncf(duration/3600);
    return [NSString stringWithFormat:@"%02dh%02dm%02ds", hours, minutes, seconds];
}

- (NSString *)roughDurationStringForSeconds:(int)interval {
    int duration = interval;
    int seconds = duration % 60;
    duration = duration - seconds;
    int minutes = duration/60 % 60;
    duration = duration - minutes*60;
    int hours = truncf(duration/3600);
    return [NSString stringWithFormat:@"%02d:%02d", hours, minutes];
}


#pragma mark - App Switcher Delegate

- (UIView *)appSwitcher:(MMAppSwitcher *)appSwitcher viewForCardWithSize:(CGSize)size {
    if ([self isTracking]) { // checked in
        self.cardView.iconView.highlighted = YES;
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        self.cardView.checkInTimeLabel.text = [NSString stringWithFormat:@"since %@", [dateFormatter stringFromDate:self.checkInDate]];
        self.cardView.checkInStateLabel.text = @"Checked In";
        int duration = [[self.trackedDurations valueForKeyPath:@"@sum.self"] intValue];
        duration = duration + self.secondsCounter;
        self.cardView.totalCheckInLabel.text = [NSString stringWithFormat:@"%@+", [self roughDurationStringForSeconds:duration]];
    } else { // checked out
        self.cardView.iconView.highlighted = NO;
        self.cardView.checkInTimeLabel.text = @"Not tracking";
        self.cardView.checkInStateLabel.text = @"Checked Out";
        int duration = [[self.trackedDurations valueForKeyPath:@"@sum.self"] intValue];
        self.cardView.totalCheckInLabel.text = [self roughDurationStringForSeconds:duration];
    }
    return self.cardView;
}

@end
