//
//  signIn.h
//  dssapi
//
//  Created by Raja T S Sekhar on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "login.h"
#import "locationSearch.h"
#import "defaults.h"

@interface signIn : UIViewController {
    login *signLogin;
    locationSearch *locSearch;
    //NSString *_notificationName;
    METHODCALLBACK _callBackMethod;
    UIInterfaceOrientation currOrientation;
    NSUserDefaults *standardUserDefaults;
}

- (id) initWithNotifyMethod:(METHODCALLBACK) p_notifyMethod;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) loginSuccessfulMethod : (NSDictionary*) p_dictInfo;
- (void) locationNotifyLogin : (NSDictionary*) locInfo;
@end
