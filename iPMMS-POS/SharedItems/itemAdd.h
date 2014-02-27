//
//  itemAdd.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "poscategorySearch.h"
#import "posFunctions.h"
#import "posWSProxy.h"

@interface itemAdd : baseSearchForm <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, posFunctions>
{
    CGPoint scrollOffset;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName;
    UITextField *txtItemName, *txtItemPrice, *txtItemCode, *txtCategoryName;
    int _categoryId;
    UIColor *bgcolor;
    UIColor *lblTextColor;
    NSMutableArray *locPriceDetail;
    poscategorySearch *posCatSelect;
    NSString *currMode;
    NSDictionary *_initDict;
    NSDictionary *_itemDict;
    posWSProxy *posCoreCall;
    NSMutableArray *recdItemArray;
    METHODCALLBACK _controllerCallBack;
    
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation withControllerCallback:(METHODCALLBACK) p_controllerCallBack;
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation  forEditData:(NSDictionary*) p_initData withControllerCallback:(METHODCALLBACK) p_controllerCallBack;
- (BOOL) validateData;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
- (void) showAlertMessage:(NSString *) dispMessage;
- (UITableViewCell*) getSingleContentCell:(int) p_rowno;
- (NSDictionary*) getDictionaryToUpdate;
- (UITableViewCell*) getLocationPriceHeaderCell;
- (UITableViewCell*) getLocationPriceCell:(int) p_rowno;
- (NSString *)htmlEntitycode:(NSString *)string;
- (void) posItemDataGenerated : (NSDictionary*) p_posItemInfo;
- (void) posCategorySelected : (NSDictionary*) catSelectInfo;
- (void) setTextFieldFocus:(int) p_focusTag;

@end
