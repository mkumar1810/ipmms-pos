//
//  posBill.m
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "posBill.h"

@implementation posBill

@synthesize itemNavigatorPop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andReLoginCallback:(METHODCALLBACK) p_reloginCallBack
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _reloginCallBack = p_reloginCallBack;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self initialize];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) initialize
{
    self.title = @"Point of Sales";
    currMode = [[NSString alloc] initWithFormat:@"%@", @"I"];
    transModeVal = 1;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    
    /*UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
    btnRefresh.tag = 0;
    self.navigationItem.leftBarButtonItem = btnRefresh;*/
    
    UIBarButtonItem *btnLogout = [self getButtonForNavigation:@"Exit"];
    self.navigationItem.leftBarButtonItem = btnLogout;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);        
    //self.navigationItem.leftBarButtonItem = nil;
    [posDisplay setFrame:CGRectMake(posDisplay.frame.origin.x, posDisplay.frame.origin.y, posDisplay.frame.size.width, 82)];
    //posDisplay.text = @"Sales*";
    [self setOperationMode:@"Sales"];
    salesColor = [UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0];
    voidColor = [UIColor colorWithRed:155.0f/255.0f green:173.0f/255.0f blue:123.0f/255.0f alpha:1.0];
    discpercColor = [UIColor colorWithRed:255.0/255.0f green:135.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    discamtColor = [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    cashColor = [UIColor colorWithRed:133.0f/255.0f green:73.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    returnColor = [UIColor colorWithRed:65.0f/255.0f green:173.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    repeatColor = [UIColor colorWithRed:255.0f/255.0f green:9.0f/255.0f blue:13.0f/255.0f alpha:1.0];
    cardColor = [UIColor colorWithRed:0.0f/255.0f green:126.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    _prevBillId = 0;
    frmFloat = [[NSNumberFormatter alloc] init];
    [frmFloat setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frmFloat setCurrencySymbol:@""];
    [frmFloat setMaximumFractionDigits:2];
    frmInt = [[NSNumberFormatter alloc] init];
    [frmInt setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frmInt setCurrencySymbol:@""];
    [frmInt setMaximumFractionDigits:0];
    dataForDisplay = [[NSMutableArray alloc] init];
    [self generateTableView];   
    [self setButtonsForDiffMode];
}

- (void) generateTableView
{
    CGRect tvrect;
    tvrect = CGRectMake(7, 14, 500, 497);
    posTranView = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
    [self.view addSubview:posTranView];
    [posTranView setBackgroundView:nil];
    [posTranView setBackgroundView:[[UIView alloc] init]];
    [posTranView setBackgroundColor:[UIColor whiteColor]];
    [posTranView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [posTranView setSeparatorColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0f alpha:1.0f]];
    
    [posTranView setDelegate:self];
    [posTranView setDataSource:self];
    [posTranView reloadData];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Items", @"Items");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.itemNavigatorPop = popoverController;	
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.itemNavigatorPop = nil;
}

- (IBAction) entryButtonsPressed :(id)sender
{
    UIButton *btnEntryclicked = (UIButton*) sender;
    NSString *entryButtonTitle = [NSString stringWithString:btnEntryclicked.titleLabel.text];
    NSString *newResString;
    int posdispWidth = 0;
    // sales and return
    if (transModeVal==1 | transModeVal==2) 
    {
        if (itemDict) 
        {
            if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"]) 
                posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
            else if ([entryButtonTitle isEqualToString:@"<--"])
            {
                itemDict = [NSDictionary dictionaryWithDictionary:itemDict];
                NSString *oldText = [[NSString alloc] initWithFormat:@"%@*%@*",[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
                NSString *curText = posDisplay.text;
                NSString *qtyPart = [NSString stringWithString:[curText stringByReplacingOccurrencesOfString:oldText withString:@""]];
                //NSLog(@"old text %@ and qty part %@", oldText, qtyPart);
                if ([qtyPart length]>0) 
                    posDisplay.text = [NSString stringWithFormat:@"%@%@", oldText, [qtyPart substringWithRange:NSMakeRange(0, [qtyPart length] - 1) ] ];
            }
        }
        return;
    }
    if (transModeVal==3 | transModeVal==10 | transModeVal==11) 
    {
        if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"]) 
        {
            newResString = [NSString stringWithFormat:@"%@", posDisplay.text]; 
            if ([entryButtonTitle isEqualToString:@"."]) 
            {
                NSRange decimalRange = [newResString rangeOfString:entryButtonTitle options:NSCaseInsensitiveSearch];
                if (decimalRange.location == NSNotFound) 
                    posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
            }
            else
                posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
        }
        else if ([entryButtonTitle isEqualToString:@"<--"])
        {
            NSString *curText = posDisplay.text;
            if ([curText length]>0) 
                posDisplay.text = [NSString stringWithFormat:@"%@", [curText substringWithRange:NSMakeRange(0, [curText length] - 1) ] ];
        }
        return;
    }
    
    if ( transModeVal==6 | transModeVal==12)   // transModeVal==4 | transModeVal==5 |  add and less are removed
    {
        if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"] | [entryButtonTitle isEqualToString:@"."]) 
        {
            newResString = [NSString stringWithFormat:@"%@", posDisplay.text]; 
            if ([entryButtonTitle isEqualToString:@"."]) 
            {
                NSRange decimalRange = [newResString rangeOfString:entryButtonTitle options:NSCaseInsensitiveSearch];
                if (decimalRange.location == NSNotFound) 
                    posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
            }
            else
                posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
        }
        else if ([entryButtonTitle isEqualToString:@"<--"])
        {
            NSString *curText = posDisplay.text;
            //NSLog(@"old text %@ and qty part %@", oldText, qtyPart);
            if ([curText length]>0) 
                posDisplay.text = [NSString stringWithFormat:@"%@", [curText substringWithRange:NSMakeRange(0, [curText length] - 1) ] ];
        }
        return;
    }
    
    if (transModeVal==9) 
    {
        posdispWidth = [posDisplay.text length];
        if (posdispWidth>=0 & posdispWidth<3) 
        {
            if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"]) 
                posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
            else if ([entryButtonTitle isEqualToString:@"<--"])
            {
                NSString *curText = posDisplay.text;
                if ([curText length]>0) 
                    posDisplay.text = [NSString stringWithFormat:@"%@", [curText substringWithRange:NSMakeRange(0, [curText length] - 1) ] ];
            }
        }
        if (posdispWidth==3) 
        {
            if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"]) 
                posDisplay.text = [NSString stringWithFormat:@"%@%@*", posDisplay.text, entryButtonTitle]; 
            else if ([entryButtonTitle isEqualToString:@"<--"])
            {
                NSString *curText = posDisplay.text;
                if ([curText length]>0) 
                    posDisplay.text = [NSString stringWithFormat:@"%@", [curText substringWithRange:NSMakeRange(0, [curText length] - 1) ] ];
            }
        }
        if (posdispWidth>=5) 
        {
            if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"] | [entryButtonTitle isEqualToString:@"."]) 
            {
                newResString = [NSString stringWithFormat:@"%@", posDisplay.text]; 
                if ([entryButtonTitle isEqualToString:@"."]) 
                {
                    NSRange decimalRange = [newResString rangeOfString:entryButtonTitle options:NSCaseInsensitiveSearch];
                    if (decimalRange.location == NSNotFound) 
                        posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
                }
                else
                    posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
            }
            else if ([entryButtonTitle isEqualToString:@"<--"])
            {
                NSString *curText = posDisplay.text;
                if ([curText length]>5) 
                    posDisplay.text = [NSString stringWithFormat:@"%@", [curText substringWithRange:NSMakeRange(0, [curText length] - 1) ] ];
            }
        }
        return;
    }
    
}

- (IBAction) actionButtonPressed:(id)sender
{
    UIButton *btnClicked = (UIButton*) sender;
    NSString *btnLabel = [NSString stringWithString:btnClicked.titleLabel.text];
    if ([currMode isEqualToString:@"I"]) 
    {
        [self setOperationMode:btnLabel];
        //posDisplay.text =[[NSString alloc] initWithFormat:@"%@*", btnClicked.titleLabel.text];
        //transModeVal = [self getTransModeForTitle:btnLabel];
        /*if (transModeVal==3) 
            [self getVoidConfirmation];*/
        itemDict = nil;
    }
}

- (void) setOperationMode:(NSString*) p_opMode
{
    posDisplay.text = @"";
    if ([p_opMode isEqualToString:@"Sales"]) 
    {
        posDisplay.backgroundColor = salesColor;
        transModeVal = 1;
    }
    else if ([p_opMode isEqualToString:@"Return"])
    {
        posDisplay.backgroundColor = returnColor;
        transModeVal = 2;
    }
    else if ([p_opMode isEqualToString:@"Void"])
    {
        if ([dataForDisplay count]>0) 
        {
            posDisplay.text =  [[NSString alloc] initWithFormat:@"%d", [dataForDisplay count]];
            posDisplay.backgroundColor = voidColor;
            transModeVal = 3;
        }
        else
        {
            posDisplay.backgroundColor = salesColor;
            transModeVal = 1;
        }
    }
    else if ([p_opMode isEqualToString:@"Disc %"])
    {
        posDisplay.backgroundColor = discpercColor;
        transModeVal = 11;
    }
    else if ([p_opMode isEqualToString:@"Disc Amt"])
    {
        posDisplay.backgroundColor = discamtColor;
        transModeVal = 12;
    }
    else if ([p_opMode isEqualToString:@"Cash"])
    {
        posDisplay.backgroundColor = cashColor;
        transModeVal = 6;
    }
    else if ([p_opMode isEqualToString:@"Repeat"])
    {
        if ([dataForDisplay count]>0) 
        {
            posDisplay.text =  [[NSString alloc] initWithFormat:@"%d", [dataForDisplay count]];
            posDisplay.backgroundColor = repeatColor;
            transModeVal = 10;
        }
        else
        {
            posDisplay.backgroundColor = salesColor;
            transModeVal = 1;
        }
    }
    else if ([p_opMode isEqualToString:@"Card"])
    {
        posDisplay.backgroundColor = cardColor;
        transModeVal = 9;
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *holdBillData;
    if (buttonIndex!=0) 
    {
        switch (alertView.tag) 
        {
            case 3:
                [self processVoidTransaction];
                break;
            case 52:
                holdBillData = [hldBillSelect returnSelectedItem];
                if (holdBillData) 
                    [self reCallHoldBill:holdBillData];
                else
                    [self showAlertMessage:@"No bill is selected"];
                break;
            case 99:
                [self saveDataForMode:@"Cancel"];
                break;
            case 100:
                //[[NSNotxxificationCenter defaultCenter] removeObserver:self];
                //[[NSNotificaxxtionCenter defaultCenter] postNotificationName:@"doReLogin" object:self userInfo:nil];
                _reloginCallBack(nil);
                break;
            default:
                break;
        }
    }
    else
    {
        switch (alertView.tag) 
        {
            case 3:
                //posDisplay.text =[[NSString alloc] initWithFormat:@"%@*", @"Sales"];
                [self setOperationMode:@"Sales"];
                transModeVal = 1;
                break;
            default:
                break;
        }
    }
}

- (void) reCallHoldBill:(NSDictionary*) p_holdBillInfo
{
    //[[NSNotificaxxtionCenter defaultCenter] addObserver:self selector:@selector(recallDataGenerated:)  name:@"recallDataNotify_POS" object:nil];
    actIndicator.hidden = NO;
    [actIndicator startAnimating];
    METHODCALLBACK l_wsReturnMethod = ^ (NSDictionary* p_dictInfo)
    {
        [self recallDataGenerated:p_dictInfo];
    };  
    posWSCall = [[posWSProxy alloc] initWithReportType:@"RECALLHOLDDATA" andInputParams:p_holdBillInfo andResponseMethod:l_wsReturnMethod];
    actionView.userInteractionEnabled = NO;
    entryView.userInteractionEnabled = NO;
    confirmButton.enabled = NO;
}

- (void) recallDataGenerated:(NSDictionary*) holdData
{
    actIndicator.hidden = YES;
    [actIndicator stopAnimating];
    NSArray *mdArray = [[NSArray alloc] initWithArray:[holdData valueForKey:@"data"] copyItems:YES];
    if ([mdArray count]>0) 
    {
        for (NSDictionary *tmpDict in mdArray) 
        {
            int l_datatype = [[tmpDict valueForKey:@"DATATYPE"] intValue];
            if (l_datatype==1) 
            {
                txtBillNo.text = @"";
                _prevBillId = [[tmpDict valueForKey:@"BILLID"] intValue];
            }
            else
            {
                NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[tmpDict valueForKey:@"TRANSTYPE"], @"OPERATION", [tmpDict valueForKey:@"POSDESCRIPTION"], @"DESCRIPTION", [tmpDict valueForKey:@"UNITPRICE"], @"PRICE",[NSNumber numberWithInt:[[tmpDict valueForKey:@"TRANSQTY"] intValue]], @"QTY",[NSNumber numberWithDouble:[[tmpDict valueForKey:@"TRANSAMT"] doubleValue]], @"AMOUNT", [tmpDict valueForKey:@"POSITEMID"], @"POSITEMID", [tmpDict valueForKey:@"TRANSSIGN"], @"TRANSSIGN" , nil];
                [self addDictionaryToDisplay:newDict];
            }
        }
        [posTranView reloadData];
        itemDict = nil;
        //posDisplay.text = @"Sales*";
        [self setOperationMode:@"Sales"];
        transModeVal = 1;
        [self setSummaryFieldAndBalance];
    }
    else
        [self showAlertMessage:@"No valid records found"];
    actionView.userInteractionEnabled = YES;
    entryView.userInteractionEnabled = YES;
    confirmButton.enabled = YES;
    //[[NSNotificatixxonCenter defaultCenter] removeObserver:self name:@"recallDataNotify_POS" object:nil];
}


- (void) processVoidTransaction
{
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:[dataForDisplay objectAtIndex:[dataForDisplay count]-1]];
    NSString *opType = [tmpDict valueForKey:@"OPERATION"];
    int l_transSign = 0;
    if ([opType isEqualToString:@"Sales"] | [opType isEqualToString:@"Return"]) 
    {
        [tmpDict setValue:@"Void" forKey:@"OPERATION"];
        l_transSign = [[tmpDict valueForKey:@"TRANSSIGN"] intValue];
        [tmpDict setValue:[NSString stringWithFormat:@"%d", -l_transSign] forKey:@"TRANSSIGN"];
        [dataForDisplay addObject:tmpDict];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[dataForDisplay count] inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:newPath, nil];
        [posTranView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        [posTranView selectRowAtIndexPath:newPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        itemDict = nil;
        //posDisplay.text = @"Sales*";
        [self setOperationMode:@"Sales"];
        transModeVal = 1;
        [self setSummaryFieldAndBalance];
    }
}

- (IBAction) confirmButtonPressed :(id)sender
{
    int l_transQty = 0;
    double l_transAmt = 0;
    /*NSString *l_barCode;
    NSString *l_chequeNo;*/
    NSString *l_cardNo;
    NSMutableDictionary *dictForDisp;
    int dispDataWidth = 0;
    if ([currMode isEqualToString:@"I"]) 
    {
        //int l_opMode =[self getOperationMode:posDisplay.text];
        switch (transModeVal) 
        {
            case 1: // sales transaction
                if (!itemDict) 
                {
                    [self showAlertMessage:@"Select a valid item"];
                    return;
                }
                l_transQty = [self getQtyFromDisplay:posDisplay.text withTrans:@"Sales"];
                if (l_transQty==0) 
                    [self showAlertMessage:@"Quantity is not valid"];
                else
                {
                    [self addNewItemToGrid:1 withQty:l_transQty andTransSign:1];
                    itemDict = nil;
                    //posDisplay.text = @"Sales*";
                    [self setOperationMode:@"Sales"];
                    transModeVal = 1;
                }
                break;
            case 2: // return transaction
                if (!itemDict) 
                {
                    [self showAlertMessage:@"Select a valid item"];
                    return;
                }
                l_transQty = [self getQtyFromDisplay:posDisplay.text withTrans:@"Return"];
                if (l_transQty==0) 
                    [self showAlertMessage:@"Quantity is not valid"];
                else
                {
                    [self addNewItemToGrid:2 withQty:l_transQty andTransSign:-1];
                    itemDict = nil;
                    //posDisplay.text = @"Sales*";
                    [self setOperationMode:@"Sales"];
                    transModeVal = 1;
                }
                break;
            case 3: // void transaction
                l_transQty = [self getQtyFromDisplay:posDisplay.text withTrans:@"Void"];
                if (l_transQty==0) 
                    [self showAlertMessage:@"Item no is not valid!"];
                else
                {
                    [self voidTheItemWithSlNo:l_transQty];
                    itemDict = nil;
                    //posDisplay.text = @"Sales*";
                    [self setOperationMode:@"Sales"];
                    transModeVal = 1;
                }
                break;
            case 6: // cash transaction
                l_transAmt = [posDisplay.text doubleValue];
                if (l_transAmt==0) 
                    [self showAlertMessage:@"Amount is not valid"];
                else
                {
                    //[self addNewItemToGrid:@"Cash" withQty:l_transQty andTransSign:-1];
                    //[self addNewAmountToGrid:6 withAmt:l_transAmt andTransSign:-1];
                    NSMutableDictionary *dictForDisp = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", 6], @"OPERATION", @"Cash" , @"DESCRIPTION", [NSNumber numberWithDouble:l_transAmt], @"PRICE",[NSString stringWithFormat:@"%d", 1], @"QTY", [NSNumber numberWithDouble:l_transAmt], @"AMOUNT",[NSString stringWithString:@"0"] , @"POSITEMID",[NSString stringWithFormat:@"%d",-1], @"TRANSSIGN" , nil];
                    [self addDictionaryToDisplay:dictForDisp];
                    itemDict = nil;
                    //posDisplay.text = @"Sales*";
                    [self setOperationMode:@"Sales"];
                    transModeVal = 1;
                }
                break;
            case 9:
                dispDataWidth = [posDisplay.text length];
                if (dispDataWidth<5) 
                {
                    [self showAlertMessage:@"Data is not in valid format"];
                    return;
                }
                l_cardNo = [posDisplay.text substringWithRange:NSMakeRange(0, 4)];
                l_transAmt = [[posDisplay.text substringWithRange:NSMakeRange(5, dispDataWidth-5)] doubleValue];
                if (l_transAmt==0) 
                {
                    [self showAlertMessage:@"The amount cannot be zero"];
                    return;
                }
                dictForDisp = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",9] , @"OPERATION",[NSString stringWithFormat:@"%@: %@", @"Card", l_cardNo], @"DESCRIPTION", [NSNumber numberWithDouble:l_transAmt] , @"PRICE",[NSString stringWithFormat:@"%d", 1], @"QTY",[NSNumber numberWithDouble:l_transAmt], @"AMOUNT",[NSString stringWithString:@"0"] , @"POSITEMID",[NSString stringWithFormat:@"%d",-1], @"TRANSSIGN" , nil];
                [self addDictionaryToDisplay:dictForDisp];
                itemDict = nil;
                //posDisplay.text = @"Sales*";
                [self setOperationMode:@"Sales"];
                transModeVal = 1;
                break;
            case 10:  // repeat transaction
                l_transQty = [self getQtyFromDisplay:posDisplay.text withTrans:@"Repeat"];
                if (l_transQty==0) 
                    [self showAlertMessage:@"Item no is not valid!"];
                else
                {
                    dictForDisp = [[NSMutableDictionary alloc] initWithDictionary:[dataForDisplay objectAtIndex:l_transQty-1] copyItems:YES];
                    [self addDictionaryToDisplay:dictForDisp];
                    itemDict = nil;
                    //posDisplay.text = @"Sales*";
                    [self setOperationMode:@"Sales"];
                    transModeVal = 1;
                }
                break;
            case 11:
                l_transQty = [self getQtyFromDisplay:posDisplay.text withTrans:@"Disc %"];
                if (l_transQty==0 | l_transQty>100) 
                    [self showAlertMessage:@"Perc is not valid!"];
                else
                {
                    NSString *percDesc = [[NSString alloc] initWithFormat:@"Disc Perc", l_transQty];
                    l_transAmt = [[frmFloat numberFromString:txtTotAmount.text] doubleValue] * ((double) l_transQty) / 100.0 ;
                    if (l_transAmt>0) 
                    {
                        NSMutableDictionary *dictForDisp = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", 11], @"OPERATION", percDesc , @"DESCRIPTION", [NSNumber numberWithDouble:l_transAmt], @"PRICE",[NSString stringWithFormat:@"%d", l_transQty], @"QTY", [NSNumber numberWithDouble:l_transAmt], @"AMOUNT",[NSString stringWithString:@"0"] , @"POSITEMID",[NSString stringWithFormat:@"%d",-1], @"TRANSSIGN" , nil];
                        [self addDictionaryToDisplay:dictForDisp];
                        itemDict = nil;
                        //posDisplay.text = @"Sales*";
                        [self setOperationMode:@"Sales"];
                        transModeVal = 1;
                    }
                    else
                        [self showAlertMessage:@"Discount amount is not valid"];
                }
                break;
            case 12:
                l_transAmt = [posDisplay.text doubleValue];
                if (l_transAmt<=0 ) 
                    [self showAlertMessage:@"Amount is not valid!"];
                else
                {
                    NSString *amtDesc = [[NSString alloc] initWithString:@"Disc Amount"];
                    if (l_transAmt>0) 
                    {
                        NSMutableDictionary *dictForDisp = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", 12], @"OPERATION", amtDesc , @"DESCRIPTION", [NSNumber numberWithDouble:l_transAmt], @"PRICE",[NSString stringWithFormat:@"%d", 1], @"QTY", [NSNumber numberWithDouble:l_transAmt], @"AMOUNT",[NSString stringWithString:@"0"] , @"POSITEMID",[NSString stringWithFormat:@"%d",-1], @"TRANSSIGN" , nil];
                        [self addDictionaryToDisplay:dictForDisp];
                        itemDict = nil;
                        //posDisplay.text = @"Sales*";
                        [self setOperationMode:@"Sales"];
                        transModeVal = 1;
                    }
                    else
                        [self showAlertMessage:@"Discount amount is not valid"];
                }
                break;
            default:
                break;
        }
    }
}


- (void) voidTheItemWithSlNo:(int) p_slNo
{
    //NSMutableDictionary *tmpDict = [[NSMutableDictionary dictionaryWithDictionary:[dataForDisplay objectAtIndex:p_slNo-1]] copy];
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithDictionary:[dataForDisplay objectAtIndex:p_slNo-1] copyItems:YES];
    int isVoided = [[tmpDict valueForKey:@"ISVOIDED"] intValue];
    if (isVoided==0) 
        [tmpDict setValue:[NSString stringWithString:@"1"] forKey:@"ISVOIDED"];
    else
        [tmpDict setValue:[NSString stringWithString:@"0"] forKey:@"ISVOIDED"];
    [dataForDisplay replaceObjectAtIndex:(p_slNo-1) withObject:tmpDict];
    NSIndexPath *voidIndPath = [NSIndexPath indexPathForRow:p_slNo inSection:0];
    NSArray *updateInfo = [[NSArray alloc] initWithObjects:voidIndPath, nil];
    //[dataForDisplay replaceObjectAtIndex:voidIndPath.row withObject:returnedDict];
    [posTranView reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
    [self setSummaryFieldAndBalance];
}

- (void) addMemberInfoAfterVerified:(NSString*) p_memberBarcode withAmount:(double) p_transAmt
{
    //[[NSNotificxxationCenter defaultCenter] addObserver:self selector:@selector(memberDataGenerated:)  name:@"memberDataNotify_POS" object:nil];
    actIndicator.hidden = NO;
    [actIndicator startAnimating];
    NSDictionary *inputDict = [NSDictionary dictionaryWithObjectsAndKeys:p_memberBarcode,@"p_memberbarcode", [NSNumber numberWithDouble:p_transAmt],@"p_transamt", nil];
    METHODCALLBACK l_wsReturnMethod = ^ (NSDictionary* p_dictInfo)
    {
        [self recallDataGenerated:p_dictInfo];
    };  
    posWSCall = [[posWSProxy alloc] initWithReportType:@"MEMBERBARCODECHECK" andInputParams:inputDict andResponseMethod:l_wsReturnMethod];
    actionView.userInteractionEnabled = NO;
    entryView.userInteractionEnabled = NO;
    confirmButton.enabled = NO;
}

- (void) memberDataGenerated:(NSDictionary*) memberData
{
    int l_memberId = 0;
    actIndicator.hidden = YES;
    [actIndicator stopAnimating];
    NSArray *mdArray = [[NSArray alloc] initWithArray:[memberData valueForKey:@"data"] copyItems:YES];
    NSDictionary *inputParams = [memberData valueForKey:@"inputparams"];
    if ([mdArray count]>0) 
    {
        NSDictionary *tmpDict = [mdArray objectAtIndex:0];
        NSLog(@"the tmp dictionary data is %@", tmpDict);
        l_memberId = [[tmpDict valueForKey:@"MEMBERID"] intValue];
        if (l_memberId==0) 
            [self showAlertMessage:@"Entered barcode is not valid"];
        else
        {
            //NSString *mbrCurrStatus =[[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"CURRSTATUS"]];
            /*if ([mbrCurrStatus isEqualToString:@"Active"]) 
            {*/
                NSMutableDictionary *dictForDisp = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithString:@"Member"] , @"OPERATION", [NSString stringWithFormat:@"%@ - %@ %@" , [inputParams valueForKey:@"p_memberbarcode"], [tmpDict valueForKey:@"FIRSTNAME"],[tmpDict valueForKey:@"LASTNAME"]], @"DESCRIPTION", [inputParams valueForKey:@"p_transamt"], @"PRICE",[NSString stringWithFormat:@"%d", 1], @"QTY",[inputParams valueForKey:@"p_transamt"]   , @"AMOUNT",[tmpDict valueForKey:@"MEMBERID"], @"POSITEMID",[NSString stringWithFormat:@"%d",-1], @"TRANSSIGN" , nil];
                [self addDictionaryToDisplay:dictForDisp];
                itemDict = nil;
                //posDisplay.text = @"Sales*";
                [self setOperationMode:@"Sales"];
                transModeVal = 1;
            /*}
            else
                [self showAlertMessage:@"Member is not Active"];*/
        }
    }
    else
        [self showAlertMessage:@"Barcode is not valid"];
    actionView.userInteractionEnabled = YES;
    entryView.userInteractionEnabled = YES;
    confirmButton.enabled = YES;
    //[[NSNotificatxxionCenter defaultCenter] removeObserver:self name:@"memberDataNotify_POS" object:nil];
}

- (void) addDictionaryToDisplay:(NSMutableDictionary*) p_dispDict
{
    holdButton.enabled = YES;
    recallButton.enabled = NO;
    [dataForDisplay addObject:p_dispDict];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:[dataForDisplay count] inSection:0];
    NSArray *indexArray = [NSArray arrayWithObjects:newPath, nil];
    [posTranView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    [posTranView selectRowAtIndexPath:newPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self setSummaryFieldAndBalance];
}


- (void) addNewItemToGrid:(int) p_transType withQty:(int) p_transQty andTransSign:(int) p_transSign
{
    double l_amount = [[itemDict valueForKey:@"ITEMPRICE"] doubleValue]* ((double) p_transQty);
    NSMutableDictionary *dictForDisp = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", p_transType], @"OPERATION", [itemDict valueForKey:@"ITEMNAME"], @"DESCRIPTION", [itemDict valueForKey:@"ITEMPRICE"], @"PRICE",[NSString stringWithFormat:@"%d", p_transQty], @"QTY", [NSNumber numberWithDouble:l_amount], @"AMOUNT",[itemDict valueForKey:@"POSITEMID"], @"POSITEMID",[NSString stringWithFormat:@"%d",p_transSign], @"TRANSSIGN" , nil];
    [self addDictionaryToDisplay:dictForDisp];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int l_noofRows = 0;
    /*if ([dataForDisplay count]<10) 
        l_noofRows = 10;
    else*/
        l_noofRows = [dataForDisplay count] + 1;
        
    return l_noofRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  40.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) 
    {
        case 0:
            return [self getHeaderCellForTxns];
            break;
        default:
            return [self getCellForRow:indexPath.row];
            break;
    }
    return nil;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}
*/

- (UITableViewCell*) getCellForRow:(int) p_rowNo
{
    static NSString *cellid=@"CellTxn";
    NSMutableDictionary *tmpDict = [dataForDisplay objectAtIndex:p_rowNo-1];
    //NSLog(@"tmp dict is %@", tmpDict);
    UILabel *lbl1, *lbl2, *lbl3, *lbl4, *lblDivider, *lblStriker;
    int isVoided = 0;
    UIColor *lblColor;
    int   cellHeight, xPosition, xWidth ;
    int opType;
    cellHeight = 40;
    UITableViewCell  *cell = [posTranView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont boldSystemFontOfSize:13.0f];
        cell.backgroundColor = [UIColor grayColor];
        xPosition = 0; xWidth = 60;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentCenter;
        lbl1.tag = 1;
        lbl1.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl1];
        
        xPosition += xWidth + 1;xWidth = 245;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentLeft;
        lbl2.tag = 2;
        lbl2.numberOfLines = 2;
        lbl2.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl2];
        
        xPosition += xWidth+1; xWidth = 77;

        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];
        
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.tag = 3;
        lbl3.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl3];
        
        xPosition += xWidth+1; xWidth = 115;

        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];
        
        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.tag = 4;
        lbl4.textAlignment = UITextAlignmentRight;
        lbl4.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl4];
        
        lblStriker = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, xPosition+xWidth, cellHeight)];
        lblStriker.font = [UIFont boldSystemFontOfSize:17.0f];
        lblStriker.tag = 5;
        lblStriker.textAlignment = UITextAlignmentCenter;
        lblStriker.textColor = [UIColor blackColor];
        lblStriker.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lblStriker];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    opType = [[tmpDict valueForKey:@"OPERATION"] intValue];
    isVoided = [[tmpDict valueForKey:@"ISVOIDED"] intValue];
    
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl1.text =[NSString stringWithFormat:@"%d", p_rowNo];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:2];
    lbl2.text = [NSString stringWithFormat:@" %@", [tmpDict valueForKey:@"DESCRIPTION"]];
    
    lbl3 = (UILabel*) [cell.contentView viewWithTag:3];
    //[frm setMaximumFractionDigits:0];
    lbl3.text = [[NSString stringWithFormat:@"%@  ",[frmInt stringFromNumber:[NSNumber numberWithInt:[[tmpDict valueForKey:@"QTY"] intValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];

    lbl4 = (UILabel*) [cell.contentView viewWithTag:4];
    //[frm setMaximumFractionDigits:2];
    lbl4.text = [[NSString stringWithFormat:@"%@  ",[frmFloat stringFromNumber:[tmpDict valueForKey:@"AMOUNT"]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    if (opType==1) 
        lblColor = salesColor;
    else if (opType==2) 
        lblColor = returnColor;
    else if (opType==11) 
    {
        lblColor = discpercColor;
        lbl3.text = [[NSString stringWithFormat:@"%@  %%",[frmInt stringFromNumber:[NSNumber numberWithInt:[[tmpDict valueForKey:@"QTY"] intValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    }
    else if (opType==12) 
        lblColor = discamtColor;
    else if (opType==6) 
        lblColor = cashColor;
    else if (opType==9) 
        lblColor = cardColor;
    
    lblStriker = (UILabel*) [cell.contentView viewWithTag:5];
    if (isVoided==1) 
    {
        lblStriker.text = @"-----------------------------------------------------------------------------------------------";
        lblColor = voidColor;
    }
    else
        lblStriker.text = @"";
    lbl1.backgroundColor = lblColor;
    lbl2.backgroundColor = lblColor;
    lbl3.backgroundColor = lblColor;
    lbl4.backgroundColor = lblColor;
    return cell;
}


- (UITableViewCell*) getHeaderCellForTxns
{
    static NSString *cellid=@"cellHeader";
    UILabel *lbl1, *lbl2, *lbl3, *lbl4, *lblDivider;
    UIColor *lblColor;
    int   cellHeight, xPosition, xWidth ;
    cellHeight = 40;
    UITableViewCell  *cell = [posTranView dequeueReusableCellWithIdentifier:cellid];
    lblColor = [UIColor colorWithRed:248.0/255.0f green:1.0f blue:41.0/255.0f alpha:1.0f];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont boldSystemFontOfSize:13.0f];
        cell.backgroundColor = [UIColor grayColor];
        xPosition = 0; xWidth = 60;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentCenter;
        lbl1.tag = 1;
        lbl1.backgroundColor = lblColor;
        lbl1.textColor = [UIColor blackColor];
        lbl1.text = @"Sl#";
        [cell.contentView addSubview:lbl1];
        
        xPosition += xWidth + 1;xWidth = 245;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];

        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentCenter;
        lbl2.tag = 2;
        lbl2.backgroundColor =lblColor;
        lbl2.textColor = [UIColor blackColor];
        lbl2.text = @"Description";
        [cell.contentView addSubview:lbl2];
        
        xPosition += xWidth+1; xWidth = 77;

        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];
        
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentCenter;
        lbl3.tag = 3;
        lbl3.backgroundColor = lblColor;
        lbl3.textColor = [UIColor blackColor];
        lbl3.text = @"Qty";
        [cell.contentView addSubview:lbl3];
        
        xPosition += xWidth+1; xWidth = 123;

        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];

        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.tag = 4;
        lbl4.textAlignment = UITextAlignmentCenter;
        lbl4.backgroundColor = lblColor;
        lbl4.textColor = [UIColor blackColor];
        lbl4.text = @"Amount";
        [cell.contentView addSubview:lbl4];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*) getEmptyCell
{
    static NSString *cellid=@"cellEmpty";
    UITableViewCell  *cell = [posTranView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (id) getButtonForNavigation:(NSString*) p_btnTask
{
    UIBarButtonItem *retBtn;
    
    if ([p_btnTask isEqualToString:@"Insert"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 1;
    }
    else if ([p_btnTask isEqualToString:@"Edit"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 2;
    }
    else if ([p_btnTask isEqualToString:@"List"] | [p_btnTask isEqualToString:@"Refresh"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 0;
    }
    else if ([p_btnTask isEqualToString:@"Cancel"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 3;
    }
    else if ([p_btnTask isEqualToString:@"Save"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 4;
    }
    else if ([p_btnTask isEqualToString:@"Hold"]) 
    {
        //retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
        retBtn = [[UIBarButtonItem alloc] initWithTitle:@"Hold" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 5;
    }
    else if ([p_btnTask isEqualToString:@"New"]) 
    {
        //retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
        retBtn = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 6;
    }
    else if ([p_btnTask isEqualToString:@"Print"]) 
    {
        //retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
        retBtn = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 7;
    }
    else if ([p_btnTask isEqualToString:@"Bills"]) 
    {
        //retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
        retBtn = [[UIBarButtonItem alloc] initWithTitle:@"Bills" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 8;
    }
    else if ([p_btnTask isEqualToString:@"Exit"]) 
    {
        //retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
        //retBtn = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 9;
    }
    else
    {
        retBtn = [[UIBarButtonItem alloc] initWithTitle:p_btnTask style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        //retBtn.tag = 4;
    }
    
    return retBtn;
}

- (void) setButtonsForDiffMode
{
    if ([currMode isEqualToString:@"L"]) 
    {
        UIBarButtonItem *btnInsert = [self getButtonForNavigation:@"New"];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnInsert, nil];
        self.navigationItem.title = @"Point of Sales";
        actionView.userInteractionEnabled = NO;
        entryView.userInteractionEnabled = NO;
        confirmButton.enabled = NO;
        posDisplay.text = @"";
        holdButton.enabled = NO;
        recallButton.enabled = YES;
    }
    
    if ([currMode isEqualToString:@"I"]) 
    {
        UIBarButtonItem *btnCancel = [self getButtonForNavigation:@"Cancel"];
        UIBarButtonItem *btnSave = [self getButtonForNavigation:@"Save"];
        //UIBarButtonItem *btnHold = [self getButtonForNavigation:@"Hold"];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnSave, btnCancel,  nil];
        self.navigationItem.title = @"New POS Bill";
        actionView.userInteractionEnabled = YES;
        entryView.userInteractionEnabled = YES;
        confirmButton.enabled = YES;
        txtBillNo.text = @"";
        txtTotQty.text = @"";
        txtTotAmount.text = @"";
        txtBalance.text = @"";
        [dataForDisplay removeAllObjects];
        [posTranView reloadData];
        //posDisplay.text = @"Sales*";
        [self setOperationMode:@"Sales"];
        transModeVal = 1;
        holdButton.enabled = NO;
        recallButton.enabled = YES;
        _prevBillId = 0;
    }
    
    if ([currMode isEqualToString:@"P"]) 
    {
        UIBarButtonItem *btnBills = [self getButtonForNavigation:@"Bills"];
        UIBarButtonItem *btnPrint = [self getButtonForNavigation:@"Print"];
        //UIBarButtonItem *btnHold = [self getButtonForNavigation:@"Hold"];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnPrint, btnBills,  nil];
        self.navigationItem.title = @"POS Bill Preview";
        actionView.userInteractionEnabled = NO;
        entryView.userInteractionEnabled = NO;
        confirmButton.enabled = NO;
        posDisplay.text = @"";
        holdButton.enabled = NO;
        recallButton.enabled = YES;
    }
}

- (void) posItemSelectedInSearch:(NSDictionary*) p_itemDict
{
    if ([currMode isEqualToString:@"I"]) 
    {
        itemDict = [NSDictionary dictionaryWithDictionary:p_itemDict];
        switch (transModeVal) {
            case 1:
                posDisplay.text = [[NSString alloc] initWithFormat:@"%@*%@*",[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
                break;
            case 2:
                posDisplay.text = [[NSString alloc] initWithFormat:@"%@*%@*",[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
                break;
            case 3:
                
            default:
                break;
        }
    }
}

- (NSString*) getDisplayData:(NSString*) p_curDisplay
{
    NSString *l_retString = [[NSString alloc] initWithFormat:@"%@", @""];
    return l_retString;
}

- (int) getQtyFromDisplay:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature
{
    int l_returnval = 0;
    if ([p_transNature isEqualToString:@"Sales"] | [p_transNature isEqualToString:@"Return"]) 
    {
        NSString *itemDesc  = [[NSString alloc] initWithFormat:@"%@*%@*" ,[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
        NSString *restString = [p_curDisplay stringByReplacingOccurrencesOfString:itemDesc withString:@""];
        if ([restString isEqualToString:@""]) 
            return 1;
        else
            return [restString intValue];
    }
    if ([p_transNature isEqualToString:@"Void"] | [p_transNature isEqualToString:@"Repeat"] ) 
    {
        NSString *curText = posDisplay.text;
        int rowNo = [curText intValue];
        if (rowNo<=0) 
            l_returnval = 0;
        else if (rowNo > [dataForDisplay count])
            l_returnval = 0;
        else
            l_returnval = rowNo;
        return l_returnval;
    }
    if ([p_transNature isEqualToString:@"Disc %"]) 
    {
        NSString *curText = posDisplay.text;
        int l_disc = [curText intValue];
        if (l_disc<=0) 
            l_returnval = 0;
        else if (l_disc > 100)
            l_returnval = 0;
        else
            l_returnval = l_disc;
        return l_returnval;
    }
    return 0;
}

- (double) getAmtFromDisplay:(NSString*) p_curDisplay withTrans:(NSString*) p_transNature
{
    NSString *itemDesc  = [[NSString alloc] initWithFormat:@"%@*", p_transNature];
    NSString *restString = [p_curDisplay stringByReplacingOccurrencesOfString:itemDesc withString:@""];
    if ([restString isEqualToString:@""]) 
        return 0;
    else
        return [restString doubleValue];
    return 0;
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"POS" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) setSummaryFieldAndBalance
{
    int totQty = 0;
    double totAmount = 0;
    double finBalance = 0;
    double amtAdjusted = 0;
    int isVoided = 0;
    for (NSMutableDictionary *tmpDict in dataForDisplay) 
    {
        //NSString *transType = [tmpDict valueForKey:@"OPERATION"];
        int transTypeVal = [[tmpDict valueForKey:@"OPERATION"] intValue];
        isVoided = [[tmpDict valueForKey:@"ISVOIDED"] intValue];
        //if ([transType isEqualToString:@"Sales"] | [transType isEqualToString:@"Return"] | [transType isEqualToString:@"Void"] ) 
        if (isVoided==0) 
        {
            if (transTypeVal ==1 | transTypeVal==2) 
            {
                totQty += [[tmpDict valueForKey:@"QTY"] intValue]*[[tmpDict valueForKey:@"TRANSSIGN"] intValue] ;
                totAmount += [[tmpDict valueForKey:@"AMOUNT"] doubleValue] * [[tmpDict valueForKey:@"TRANSSIGN"] intValue] ;
            }
            else
                amtAdjusted += [[tmpDict valueForKey:@"AMOUNT"] doubleValue] * [[tmpDict valueForKey:@"TRANSSIGN"] intValue] ; 
        }
    }
    finBalance = totAmount + amtAdjusted;
    txtTotQty.text = [NSString stringWithFormat:@"%d", totQty];
    txtTotAmount.text = [frmFloat stringFromNumber:[NSNumber numberWithDouble:totAmount]];
    txtBalance.text = [frmFloat stringFromNumber:[NSNumber numberWithDouble:finBalance]];
}

- (IBAction) ButtonPressed:(id)sender
{
    NSDictionary *notifyInfo;
    UIBarButtonItem *recdBtn = (UIBarButtonItem*) sender;
    switch (recdBtn.tag) {
        case 0: //refresh button pressed
            //notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
            currMode = @"L";
            //[positemSelect refreshData:nil];
            break;
        case 1: // Add button clicked
            currMode = @"I";
            //[positemSelect addNewItem];
            break;
        case 2:  // edit button clicked
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"data", nil];
            break;
        case 3:
            if ([self validateEntriesforMode:@"Cancel"]) 
            {
                dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure\nto Cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                dAlert.cancelButtonIndex = 0;
                dAlert.delegate = self;
                dAlert.tag = 99;
                [dAlert show];
            }
            break;
        case 4:
            //notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save",@"data", nil];
            //[positemSelect updateItem];
            if ([self validateEntriesforMode:@"Save"]) 
                [self saveDataForMode:@"Save"];
            break;
        case 5:
            
            break;
        case 6:
            currMode = @"I";
            [self setButtonsForDiffMode];
            break;
        case 7: //print
            [posPreview printContents:sender];
            break;
        case 8: // BILLS list
            [posPreview removeFromSuperview];
            posPreview = nil;
            currMode = @"L";
            [self setButtonsForDiffMode];
            break;
        case 9:
            dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure\nto Logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            dAlert.cancelButtonIndex = 0;
            dAlert.delegate = self;
            dAlert.tag = 100;
            [dAlert show];
            break;
        case 51:
            if ([self validateEntriesforMode:@"Hold"]) 
                [self saveDataForMode:@"Hold"];
            break;
        case 52:
            [self showHoldBillsList];
            break;
        default:
            break;
    }
    //[self setButtonsForDiffMode];
}

- (void) showHoldBillsList
{
    hldBillSelect = [[holdBillsSearch alloc] init];
    dAlert = [[UIAlertView alloc] initWithTitle:@"Pick a Bill" message:@"\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
    dAlert.cancelButtonIndex = 0;
    dAlert.delegate = self;
    dAlert.tag = 52;
    [dAlert addSubview:hldBillSelect];
    [dAlert show];
}

- (BOOL) validateEntriesforMode:(NSString*) p_validateMode
{
    double l_balanceAmt = 0;
    if ([dataForDisplay count]==0) 
    {
        [self showAlertMessage:[NSString stringWithFormat:@"There is nothing to %@", p_validateMode]];
        return NO;
    }
    
    if ([p_validateMode isEqualToString:@"Save"]) 
    {
        l_balanceAmt = [[frmFloat numberFromString:txtBalance.text] doubleValue];
        if (l_balanceAmt>0) 
        {
            [self showAlertMessage:@"Balance is pending to collect"];
            return NO;
        }
    }
    
    return  YES;
}

- (void) saveDataForMode:(NSString*) p_saveMode
{
    int isVoided = 0;
    /*
     #define POSMASTER_XML @"<MASTER><LOCATIONID>%@</LOCATIONID><TOTQTY>%@</TOTQTY><TOTAMOUNT>%@</TOTAMOUNT><BALANCE>%@</BALANCE><PREVBILLID>%@</PREVBILLID><STATUS>%@</STATUS></MASTER>"
     
     #define POSDETAIL_XML @"<DETAIL><TRANSTYPE>%@</TRANSTYPE><POSITEMID>%@</POSITEMID><DESCRIPTION>%@</DESCRIPTION><PRICE>%@</PRICE><QTY>%@</QTY><AMOUNT>%@</AMOUNT><TRANSSIGN>%@</TRANSSIGN></DETAIL>"
     */
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSMutableString *l_detailXML = [[NSMutableString alloc] init ];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *billStatus;
    if ([p_saveMode isEqualToString:@"Save"]) 
        billStatus = [NSString stringWithString:@"OK"];
    else if ([p_saveMode isEqualToString:@"Hold"])
        billStatus = [NSString stringWithString:@"H"];
    else
        billStatus = [NSString stringWithString:@"NIL"];
    
    l_retXML = [NSString stringWithFormat:POSMASTER_XML,[stdDefaults valueForKey:@"LOGGEDLOCATION"],txtTotQty.text, [frmFloat numberFromString:txtTotAmount.text], [frmFloat numberFromString:txtBalance.text], [NSNumber numberWithInt:_prevBillId],billStatus, [stdDefaults valueForKey:@"SHORTNAME"]];
    for (NSMutableDictionary *tmpDict in dataForDisplay) 
    {
        
        isVoided = [[tmpDict valueForKey:@"ISVOIDED"] intValue];
        //NSLog(@"the tmpdictionary data is %@", tmpDict);
        if (isVoided==0)
        {
            l_detailXML = [NSString stringWithFormat:POSDETAIL_XML,[tmpDict valueForKey:@"OPERATION"],[tmpDict valueForKey:@"POSITEMID"],[tmpDict valueForKey:@"DESCRIPTION"], [tmpDict valueForKey:@"PRICE"], [tmpDict valueForKey:@"QTY"], [tmpDict valueForKey:@"AMOUNT"], [tmpDict valueForKey:@"TRANSSIGN"]];  
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_detailXML];
        }
    }
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<POSDATA>",l_retXML, @"</POSDATA>"];
    l_retXML = (NSMutableString*) [self htmlEntitycode:l_retXML];
    
    //[[NSNotificxxationCenter defaultCenter] addObserver:self selector:@selector(posDataUpdated:)  name:@"posDataUpdateNotify_POS" object:nil];
    METHODCALLBACK l_wsReturnMethod = ^ (NSDictionary* p_dictInfo)
    {
        [self posDataUpdated:p_dictInfo];
    };  
    actIndicator.hidden = NO;
    [actIndicator startAnimating];
    NSDictionary *inputDict = [NSDictionary dictionaryWithObjectsAndKeys:l_retXML,@"p_posdata", p_saveMode, @"opmode", nil];
    posWSCall = [[posWSProxy alloc] initWithReportType:@"ADDPOSDATA" andInputParams:inputDict andResponseMethod:l_wsReturnMethod];
    if ([p_saveMode isEqualToString:@"Save"] | [p_saveMode isEqualToString:@"Hold"]) 
    {
        actionView.userInteractionEnabled = NO;
        entryView.userInteractionEnabled = NO;
        confirmButton.enabled = NO;
    }
    else
    {
        actIndicator.hidden = YES;
        [actIndicator stopAnimating];
        currMode = @"I";
        [self setButtonsForDiffMode];
    }
}

- (void) posDataUpdated:(NSDictionary*) updatedInfo
{
    int l_responseCode = 0;
    NSString *l_respMessage;
    actIndicator.hidden = YES;
    [actIndicator stopAnimating];
    NSDictionary *inputParams = [updatedInfo valueForKey:@"inputparams"];
    if ([[inputParams valueForKey:@"opmode"] isEqualToString:@"Cancel"]) 
    {
        //[[NSNotificaxxtionCenter defaultCenter] removeObserver:self name:@"posDataUpdateNotify_POS" object:nil];
        return;
    }
    
    NSArray *mdArray = [[NSArray alloc] initWithArray:[updatedInfo valueForKey:@"data"] copyItems:YES];
    if ([mdArray count]>0) 
    {
        NSDictionary *tmpDict = [mdArray objectAtIndex:0];
        //NSLog(@"the tmp dictionary data is %@", tmpDict);
        l_responseCode = [[tmpDict valueForKey:@"RESPONSECODE"] intValue];
        l_respMessage = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"RESPONSEMESSAGE"]];
        if (l_responseCode!=0) 
            [self showAlertMessage:l_respMessage];
        else
        {
            currMode = @"L";
            txtBillNo.text = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"BILLNO"]];
            [self setButtonsForDiffMode];
            [self generatePOSBillPreview:[tmpDict valueForKey:@"BILLID"]];
            //[[NSNotificatxxionCenter defaultCenter] removeObserver:self name:@"posDataUpdateNotify_POS" object:nil];
            return;
        }
    }
    else
        [self showAlertMessage:@"Error during updation of data"];
    actionView.userInteractionEnabled = YES;
    entryView.userInteractionEnabled = YES;
    confirmButton.enabled = YES;
    //[[NSNotixxficationCenter defaultCenter] removeObserver:self name:@"posDataUpdateNotify_POS" object:nil];
}

- (void) generatePOSBillPreview:(NSString*) p_billid
{
    currMode = @"P";
    posPreview = [[genPrintView alloc] initWithIdValue:p_billid andOrientation:self.interfaceOrientation andFrame:self.view.frame andReporttype:@"posbillpreview" andIdFldName:@"billid" andNotification:@"printReturPOSBillPreview"];
    [posPreview setForOrientation:self.interfaceOrientation];
    [self.view addSubview:posPreview];    
    [self setButtonsForDiffMode];
}

-(NSString *)htmlEntitycode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}

@end
