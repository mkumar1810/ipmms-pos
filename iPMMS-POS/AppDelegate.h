//
//  AppDelegate.h
//  iPMMS-POS
//
//  Created by Macintosh User on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signIn.h"

@class signIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
     UINavigationController *nav;    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end
