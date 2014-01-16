##What does it do?
This simple class allows you to replace the default scaled down app interface 
in the iOS7 app switcher with your own customized card view.

It's a demo of the idea outlined in [this blog post](http://vpdn.github.io/articles/iOS7-card-view).

![default screen](http://vpdn.github.io/images/2014-01-16_TimeBox/timbox_main_screen.png) ![](http://vpdn.github.io/images/2014-01-16_TimeBox/separator.png)  ![checkedIn](http://vpdn.github.io/images/2014-01-16_TimeBox/timbox_card_checked_in.png)


##How to use it?

If you want to play around, just dump MMAppSwitcher.h and MMAppSwitcher.m
into your project.

In the class that will be providing the card view:

    #import "MMAppSwitcher.h"

Then set it as the data source:

    [[MMAppSwitcher sharedInstance] setDataSource:self];


The protocol just has one single method that you need to implement:

    -(UIView *)appSwitcher:(MMAppSwitcher *)appSwitcher viewForCardWithSize:(CGSize)size;


Whenever the app enters the background, the card will be added to your app's view hierarchy
and presented in the app switcher. When the app is launched, the card view is automatically
dismissed again.


##Attribution

Thanks to the following designers and [The Noun Project](http://thenounproject.com) for
unuglifying the demo with their awesome icons:
- Box icon designed by Travis J. Lee from the Noun Project
- Brief case icon designed by (Al D)[http://thenounproject.com/albertine3/]
- Clock icon designed by (Travis Yunis)[https://twitter.com/mryunis]