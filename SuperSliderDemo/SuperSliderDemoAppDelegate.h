//
//  SuperSliderDemoAppDelegate.h
//  SuperSliderDemo
//
//  Created by Eytan Moudahi on 11-09-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuperSliderDemoViewController;

@interface SuperSliderDemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SuperSliderDemoViewController *viewController;

@end
