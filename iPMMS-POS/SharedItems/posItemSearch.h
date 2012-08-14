//
//  posItemSearch.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "itemAdd.h"

@interface posItemSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    itemAdd *newItem;
    int refreshTag;
    NSString *_notificationName, *_proxynotification, *_webdataName ;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    NSNumberFormatter *frm;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname;
- (void) addNewItem;
- (void) cancelItemUpdation;
- (void) updateItem;
- (void) showAlertMessage:(NSString *) dispMessage;

@end
