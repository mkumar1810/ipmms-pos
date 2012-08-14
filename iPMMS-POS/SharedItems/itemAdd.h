//
//  itemAdd.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface itemAdd : baseSearchForm <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSString *_notificationName, *_proxynotification, *_webdataName;
    UITextField *txtItemName, *txtItemPrice;
    UIColor *bgcolor;
    UIColor *lblTextColor;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification;
- (BOOL) validateData;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
- (void) showAlertMessage:(NSString *) dispMessage;
- (UITableViewCell*) getSingleContentCell:(int) p_rowno;
- (NSDictionary*) getDictionaryToUpdate;

@end
