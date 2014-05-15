##What does it do?
This simple class allows you to replace the default scaled down app interface 
in the iOS7 app switcher with your own customized card view.

It's a demo of the idea outlined in [this blog post][1] and is part of the
upcoming [ClockShots time tracking app](http://clockshots.com).


----

![default screen][] ![separator][]  ![checked in screen][]

----

Make sure to also check out Adam Bell's post [here][4].
He describes many cool hacks (animations anyone?), some of which are waaay too awesome for
the App Store, but would work if you are developing apps for internal use.


##How to use it?

If you want to play around, just dump MMAppSwitcher.h and MMAppSwitcher.m
into your project or even simpler, use CocoaPods and add `MMAppSwitcher`
to your Podfile:
	
	pod 'MMAppSwitcher'

In the class that will be providing the card view:

    #import "MMAppSwitcher.h"

Then set it as the data source:

    [[MMAppSwitcher sharedInstance] setDataSource:self];


The protocol just has one single method that you need to implement:

    -(UIView *)appSwitcher:(MMAppSwitcher *)appSwitcher viewForCardWithSize:(CGSize)size;


Whenever the app enters the background, your custom card view will be queried
and added to your app's view hierarchy and subsequently presented in the app
switcher. When the app is launched, the card view is automatically dismissed
again.

If your app supports one of iOS7's [background modes][3], you can refresh your
card view by calling `[[MMAppSwitcher sharedInstance] setNeedsUpdate]` whenever
your app is awoken for background work. For background fetch, that would for
example be 

	- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	    [[MMAppSwitcher sharedInstance] setNeedsUpdate];
	    completionHandler(UIBackgroundFetchResultNewData);
	}

If your app supports push notifications, iOS7 now also allows you to send
silent push notifications that will wake your app up, but keep it in the
background. This should enable you to control card updates remotely
(at least if you don't excessively do it and get throttled).


##Known issues

- The custom switcher view does not show up on the iOS simulator. To see your custom view, you have to test the app on a real device.


##Attribution

Thanks to the following designers and [The Noun Project][2] for
unuglifying the demo with their awesome icons:
- Box icon designed by Travis J. Lee from the Noun Project
- Brief case icon designed by [Al D][]
- Clock icon designed by [Travis Yunis][]



[1]: http://vpdn.github.io/articles/iOS7-card-view
[2]: http://thenounproject.com
[3]: https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/ManagingYourApplicationsFlow/ManagingYourApplicationsFlow.html#//apple_ref/doc/uid/TP40007072-CH4-SW21
[4]: http://blog.adambell.ca/post/73339778302/dynamic-ios-multitasking

[separator]: http://vpdn.github.io/images/2014-01-16_TimeBox/separator.png
[default screen]: http://vpdn.github.io/images/2014-01-16_TimeBox/timbox_main_screen.png
[checked in screen]: http://vpdn.github.io/images/2014-01-16_TimeBox/timbox_card_checked_in.png
[Al D]: http://thenounproject.com/albertine3/
[Travis Yunis]: https://twitter.com/mryunis
