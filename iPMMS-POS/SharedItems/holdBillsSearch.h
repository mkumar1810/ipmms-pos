//
//  holdBillsSearch.h
//  iPMMS-POS
//
//  Created by Macintosh User on 26/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"

@interface holdBillsSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString *_notificationName, *_proxynotification, *_webdataName, *_cacheName,*_gobacknotifyName;
    NSString *currMode;
    BOOL isSplitMode;
    NSDictionary *selectedItem;
}

- (id)initWithDataNotification:(NSString*) p_datanotification;
- (NSDictionary*) returnSelectedItem;
@end
