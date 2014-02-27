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
#import "holdBillsSearch.h"
#import "genPrintView.h"
#import "defaults.h"

@interface posBill : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate, posFunctions, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate >
{
    UIInterfaceOrientation currOrientation;
    IBOutlet UIView *actionView;
    IBOutlet UIView *entryView;
    IBOutlet UIButton *confirmButton;
    //IBOutlet UITextView *posDisplay;
    IBOutlet UITextField *posDisplay;
    NSMutableArray *dataForDisplay;
    UITableView *posTranView;
    NSString *currMode;
    int transModeVal;
    NSDictionary *itemDict;
    NSNumberFormatter *frmFloat;
    NSNumberFormatter *frmInt;
    IBOutlet UITextField *txtBillNo, *txtTotQty, *txtTotAmount, *txtBalance;
    UIAlertView *dAlert;
    UIColor *salesColor, *returnColor, *voidColor, *repeatColor, *discpercColor , *discamtColor, *cashColor, *cardColor;
    UIActivityIndicatorView *actIndicator;
    IBOutlet UIButton *holdButton, *recallButton;
    posWSProxy *posWSCall;
    int _prevBillId;
    holdBillsSearch *hldBillSelect;
    genPrintView *posPreview;
    METHODCALLBACK _reloginCallBack;
}

@property (strong, nonatomic) UIPopoverController *itemNavigatorPop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andReLoginCallback:(METHODCALLBACK) p_reloginCallBack;

- (UITableViewCell*) getHeaderCellForTxns;
- (UITableViewCell*) getEmptyCell;
- (UITableViewCell*) getCellForRow:(int) p_rowNo;
- (NSString*) getDisplayData:(NSString*) p_curDisplay;
- (int) getQtyFromDisplay:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature;
- (double) getAmtFromDisplay:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addNewItemToGrid:(int) p_transType withQty:(int) p_transQty andTransSign:(int) p_transSign;
- (void) setSummaryFieldAndBalance;
- (void) processVoidTransaction;
- (void) addMemberInfoAfterVerified:(NSString*) p_memberBarcode withAmount:(double) p_transAmt;
- (void) addDictionaryToDisplay:(NSMutableDictionary*) p_dispDict;
- (BOOL) validateEntriesforMode:(NSString*) p_validateMode;
- (void) saveDataForMode:(NSString*) p_saveMode;
- (NSString *)htmlEntitycode:(NSString *)string;
- (void) setOperationMode:(NSString*) p_opMode;
- (void) voidTheItemWithSlNo:(int) p_slNo;
- (void) showHoldBillsList;
- (void) reCallHoldBill:(NSDictionary*) p_holdBillInfo;
- (void) generatePOSBillPreview:(NSString*) p_billid;
- (void) recallDataGenerated:(NSDictionary*) holdData;
- (void) memberDataGenerated:(NSDictionary*) memberData;
- (void) posDataUpdated:(NSDictionary*) updatedInfo;
@end
