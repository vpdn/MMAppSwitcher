//
//  MMAppSwitcher.h
//  PunchCard
//
//  Created by Vinh Phuc Dinh on 23.11.13.
//  Copyright (c) 2013 Mocava Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMAppSwitcherDataSource;

@interface MMAppSwitcher : NSObject

/**
 * Shared instance of app switcher. There can only be one
 * instance of the app switcher for the entire app.
 **/
+ (instancetype)sharedInstance;

/**
 * Sets the data source that will provide the app's custom card
 * view. The data source must implement the MMAppSwitcherDatasource
 * protocol.
 *
 * @param dataSource The object that will be responsible for returning
 * the app switcher's card view.
 **/
- (void)setDatasource:(id<MMAppSwitcherDataSource>)dataSource;

/**
 * Invalidates the current card view and forces a reload.
 **/
- (void)setNeedsUpdate;

@end


@protocol MMAppSwitcherDataSource <NSObject>

/**
 * Queries for the current card view, whenever the app enters the background.
 *
 * Device         |  Card size   |  Device screen size
 * ---------------|------------------------------------
 * 3.5" iPhone(r) |  304 x 456   |      640 x 960
 * 4.0" iPhone(r) |  304 x 540   |      640 x 1136
 * iPad           |  384 x 512   |     1024 x 768
 * iPad (retina)  |  768 x 1024  |     2048 x 1536
 *
 * @param size The 'native' size of the card as how the app interface appears
 * in the app switcher. Refer to table above for reference.
 **/
- (UIView *)appSwitcher:(MMAppSwitcher *)appSwitcher viewForCardWithSize:(CGSize)size;

@end