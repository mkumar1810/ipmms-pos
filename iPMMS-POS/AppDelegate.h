//
//  AppDelegate.h
//  iPMMS-POS
//
//  Created by Macintosh User on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signIn.h"
#import "itemNavigator.h"
#import "defaults.h"
#import "posBill.h"

@class signIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
     UINavigationController *nav;    
     itemNavigator *itemBrowse;
     posBill *billTransaction;
     UINavigationController *masterNavigationController;
     UINavigationController *detailNavigationController;
    METHODCALLBACK _callBackMethod;
    METHODCALLBACK _reloginCallBack;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;
- (void) loginSucceeded : (NSDictionary*) loginInfo;
- (void) makeReLogin : (NSDictionary*) relogInfo;

@end
