//
//  categoryAddUpdate.h
//  iPMMS-POS
//
//  Created by Macintosh User on 23/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "posFunctions.h"

@interface categoryAddUpdate :baseSearchForm <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, posFunctions>
{
    NSString *_notificationName, *_proxynotification, *_webdataName;
    UITextField *txtCatCode, *txtCatName;
    UIColor *bgcolor;
    UIColor *lblTextColor;
    NSString *currMode;
    NSDictionary *_initDict;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification;
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification forEditData:(NSDictionary*) p_initData;
- (BOOL) validateData;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
- (void) showAlertMessage:(NSString *) dispMessage;
- (UITableViewCell*) getSingleContentCell:(int) p_rowno;
- (NSDictionary*) getDictionaryToUpdate;

@end
