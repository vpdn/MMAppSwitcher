//
//  MMAppSwitcher.m
//  PunchCard
//
//  Created by Vinh Phuc Dinh on 23.11.13.
//  Copyright (c) 2013 Mocava Mobile. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MMAppSwitcher.h"

@interface UIView(Rasterize)
- (UIImageView *)mm_rasterizedView;
@end

@interface MMAppSwitcher()

@property (nonatomic, weak) id<MMAppSwitcherDataSource> datasource;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIWindow *originalWindow;
@property (nonatomic, assign) BOOL showStatusBar;

@end

static MMAppSwitcher *_sharedInstance;

@implementation MMAppSwitcher

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [MMAppSwitcher new];
        _sharedInstance.originalWindow = [[UIApplication sharedApplication] keyWindow];
        _sharedInstance.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _sharedInstance.window.backgroundColor = [UIColor blackColor];
        _sharedInstance.window.windowLevel = UIWindowLevelStatusBar;
    });
    return _sharedInstance;
}

- (void)setDataSource:(id<MMAppSwitcherDataSource>)dataSource {
    _datasource = dataSource;
    if (_datasource) {
        [self enableNotifications];
    } else {
        [self disableNotifications];
    }
}

- (void)enableNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:@"UIApplicationWillBeginSuspendAnimationNotification" object:nil];
}

- (void)disableNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadCard {
    if ([self.datasource respondsToSelector:@selector(appSwitcher:viewForCardWithSize:)]) {
        UIView *view = [self.datasource appSwitcher:self viewForCardWithSize:[self cardSizeForCurrentOrientation]];
        if (view) {
            [self.view removeFromSuperview];
            UIImageView *cardView = [view mm_rasterizedView];
            self.view = cardView;
            self.view.frame = (CGRect){0, 0, self.window.bounds.size};
            [self.window addSubview:self.view];
        } else {
            [self.view removeFromSuperview];
            self.view = nil;
        }
    }
}

- (void)setNeedsUpdate {
    [self loadCard];
}

#pragma mark - Helper methods

- (BOOL)viewControllerBasedStatusBarAppearanceEnabled {
    CFBooleanRef viewControllerBasedStatusBarAppearance = CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), (CFStringRef)@"UIViewControllerBasedStatusBarAppearance");
    if (viewControllerBasedStatusBarAppearance==kCFBooleanTrue) {
        return YES;
    } else {
        return NO;
    }
}

- (CGSize)cardSizeForCurrentOrientation {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGSize cardSize;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        cardSize = (CGSize){ceilf(0.475*screenBounds.size.width), ceilf(0.475*screenBounds.size.height)};
    } else {
        cardSize = (CGSize){ceilf(0.5*screenBounds.size.width), ceilf(0.5*screenBounds.size.height)};
    }
    return cardSize;
}


#pragma mark - Notifications

- (void)appWillEnterForeground {
    [self.view removeFromSuperview];
    self.view = nil;
    self.window.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:self.showStatusBar];
}

- (void)appWillEnterBackground {
     self.showStatusBar = [[UIApplication sharedApplication] isStatusBarHidden];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self loadCard];
    self.window.hidden = NO;
}

@end



#pragma mark - Helper category

@implementation UIView(Rasterize)

- (UIImageView *)mm_rasterizedView {
    self.layer.magnificationFilter = kCAFilterNearest;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [[UIImageView alloc] initWithImage:img];
}

@end
