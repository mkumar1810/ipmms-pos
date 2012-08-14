//
//  AppDelegate.m
//  iPMMS-POS
//
//  Created by Macintosh User on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "itemNavigator.h"

#import "posBill.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceeded:) name:@"loginSucceeded" object:nil];
    
    nav=[[UINavigationController alloc]init];
    nav.navigationBar.hidden=YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    signIn *signin=[[signIn alloc]initWithNotificationName:@"loginSuccessful"];
    [nav pushViewController:signin animated:YES];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) loginSucceeded : (NSNotification*) loginInfo
{
    itemNavigator *itemBrowse = [[itemNavigator alloc] initWithNibName:@"itemNavigator" bundle:nil];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:itemBrowse];
    
    
    posBill *billTransaction = [[posBill alloc] initWithNibName:@"posBill" bundle:nil]; 
    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:billTransaction];
    
    itemBrowse.posBillTransaction = billTransaction;
    
    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.delegate = billTransaction;
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController , detailNavigationController, nil];
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
}

@end
