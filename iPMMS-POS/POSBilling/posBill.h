//
//  posBill.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "posFunctions.h"
#import "posWSProxy.h"

@interface posBill : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate, posFunctions, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate >
{
    UIInterfaceOrientation currOrientation;
    IBOutlet UIView *actionView;
    IBOutlet UIView *entryView;
    IBOutlet UIButton *confirmButton;
    IBOutlet UITextView *posDisplay;
    IBOutlet UIView *hotKeysView;
    NSMutableArray *dataForDisplay;
    UITableView *posTranView;
    NSString *currMode;
    int transModeVal;
    NSDictionary *itemDict;
    NSNumberFormatter *frmFloat;
    NSNumberFormatter *frmInt;
    IBOutlet UITextField *txtBillNo, *txtTotQty, *txtTotAmount, *txtBalance;
    UIAlertView *dAlert;
    UIActivityIndicatorView *actIndicator;
    posWSProxy *posWSCall;
    int _prevBillId;
}

@property (strong, nonatomic) UIPopoverController *itemNavigatorPop;
@property (nonatomic, retain) UIView *hotKeysView;

- (UITableViewCell*) getHeaderCellForTxns;
- (UITableViewCell*) getEmptyCell;
- (UITableViewCell*) getCellForRow:(int) p_rowNo;
- (NSString*) getDisplayData:(NSString*) p_curDisplay;
- (int) getOperationMode:(NSString*) p_curDisplay;
- (int) getTransModeForTitle:(NSString*) p_title;
- (int) getQtyFromDisplay:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature;
- (double) getAmtFromDisplay:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addNewItemToGrid:(NSString*) p_transType withQty:(int) p_transQty andTransSign:(int) p_transSign;
- (void) addNewAmountToGrid:(NSString*) p_transType withAmt:(double) p_transAmt andTransSign:(int) p_transSign;
- (void) setSummaryFieldAndBalance;
- (void) getVoidConfirmation;
- (void) processVoidTransaction;
- (void) addMemberInfoAfterVerified:(NSString*) p_memberBarcode withAmount:(double) p_transAmt;
- (void) addDictionaryToDisplay:(NSDictionary*) p_dispDict;
- (BOOL) validateEntriesforMode:(NSString*) p_validateMode;
- (void) saveDataForMode:(NSString*) p_saveMode;
- (NSString *)htmlEntitycode:(NSString *)string;

@end
