//
//  AppDelegate.m
//  iPMMS-POS
//
//  Created by Macintosh User on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    __block id myself = self;
    nav=[[UINavigationController alloc]init];
    nav.navigationBar.hidden=YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _callBackMethod = ^ (NSDictionary* p_dictInfo)
    {
        [myself loginSucceeded:p_dictInfo];
    };
    _reloginCallBack = ^ (NSDictionary* p_dictInfo)
    {
        [myself makeReLogin:p_dictInfo];
    };
    signIn *signin=[[signIn alloc] initWithNotifyMethod:_callBackMethod];
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

- (void) makeReLogin : (NSDictionary*) relogInfo
{
    [itemBrowse viewDidUnload];
    [billTransaction viewDidUnload];
    itemBrowse = nil;
    billTransaction = nil;
    [self.splitViewController viewDidUnload];
    self.splitViewController = nil;
    
    nav.navigationBar.hidden=YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    signIn *signin=[[signIn alloc]initWithNotifyMethod:_callBackMethod];
    [nav pushViewController:signin animated:YES];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}


- (void) loginSucceeded : (NSDictionary*) loginInfo
{
    itemBrowse = [[itemNavigator alloc] initWithNibName:@"itemNavigator" bundle:nil];
    masterNavigationController = [[UINavigationController alloc] initWithRootViewController:itemBrowse];
    
    billTransaction = [[posBill alloc] initWithNibName:@"posBill" bundle:nil andReLoginCallback:_reloginCallBack];
    detailNavigationController = [[UINavigationController alloc] initWithRootViewController:billTransaction];
    
    itemBrowse.posBillTransaction = billTransaction;
    
    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.delegate = billTransaction;
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController , detailNavigationController, nil];
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
}

@end
