//
//  locationSearch.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 18/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"

@interface locationSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString *_notificationName, *_proxynotification, *_webdataName, *_cacheName,*_gobacknotifyName;
    NSString *currMode;
    BOOL isSplitMode;
    METHODCALLBACK _returnMethod;
    //METHODCALLBACK _wsReturnMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnCallback:(METHODCALLBACK) p_cbReturn
    andIsSplit:(BOOL) p_issplitmode;
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname andIsSplit:(BOOL) p_issplitmode;
- (void) locationListDataGenerated:(NSDictionary *)generatedInfo;

@end
