//
//  posBill.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "posFunctions.h"

@interface posBill : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate, posFunctions, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate >
{
    UIInterfaceOrientation currOrientation;
    IBOutlet UITextView *posDisplay;
    NSMutableArray *dataForDisplay;
    UITableView *posTranView;
    NSString *currMode;
    int transModeVal;
    NSDictionary *itemDict;
    NSNumberFormatter *frmFloat;
    NSNumberFormatter *frmInt;
    IBOutlet UITextField *txtBillNo, *txtTotQty, *txtTotAmount, *txtBalance;
    UIAlertView *dAlert;
}

@property (strong, nonatomic) UIPopoverController *itemNavigatorPop;

- (UITableViewCell*) getHeaderCellForTxns;
- (UITableViewCell*) getEmptyCell;
- (UITableViewCell*) getCellForRow:(int) p_rowNo;
- (NSString*) getDisplayData:(NSString*) p_curDisplay;
- (int) getOperationMode:(NSString*) p_curDisplay;
- (int) getSalesReturnQty:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addNewItemToGrid:(NSString*) p_transType withQty:(int) p_transQty andTransSign:(int) p_transSign;
- (void) setSummaryFieldAndBalance;
- (void) getVoidConfirmation;
- (void) processVoidTransaction;

@end
