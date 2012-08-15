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
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
    btnRefresh.tag = 0;
    self.navigationItem.leftBarButtonItem = btnRefresh;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerNotification:)  name:@"controllerNotify" object:nil];
    self.navigationItem.leftBarButtonItem = nil;
    posDisplay.text = @"Sales*";
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
    tvrect = CGRectMake(25, 43, 469, 362);
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
    if (transModeVal==1 | transModeVal==2 | transModeVal==3) 
    {
        if (itemDict) 
        {
            if ([entryButtonTitle isEqualToString:@"0"] | [entryButtonTitle isEqualToString:@"1"] | [entryButtonTitle isEqualToString:@"2"] | [entryButtonTitle isEqualToString:@"3"] | [entryButtonTitle isEqualToString:@"4"] | [entryButtonTitle isEqualToString:@"5"] | [entryButtonTitle isEqualToString:@"6"] | [entryButtonTitle isEqualToString:@"7"] | [entryButtonTitle isEqualToString:@"8"] | [entryButtonTitle isEqualToString:@"9"]) 
                posDisplay.text = [NSString stringWithFormat:@"%@%@", posDisplay.text, entryButtonTitle]; 
        }
        return;
    }
    if (transModeVal==4 | transModeVal==5 | transModeVal==6) 
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
    }
}

- (IBAction) actionButtonPressed:(id)sender
{
    UIButton *btnClicked = (UIButton*) sender;
    NSString *btnLabel = [NSString stringWithString:btnClicked.titleLabel.text];
    if ([currMode isEqualToString:@"I"]) 
    {
        posDisplay.text =[[NSString alloc] initWithFormat:@"%@*", btnClicked.titleLabel.text];
        if ([btnLabel isEqualToString:@"Sales"]) 
            transModeVal = 1;
        else if ([btnLabel isEqualToString:@"Return"])
            transModeVal = 2;
        else if ([btnLabel isEqualToString:@"Void"])
            [self getVoidConfirmation];
        else if ([btnLabel isEqualToString:@"Add"])
            transModeVal = 4;
        else if ([btnLabel isEqualToString:@"Less"])
            transModeVal = 5;
        else if ([btnLabel isEqualToString:@"Cash"])
            transModeVal = 6;
        else if ([btnLabel isEqualToString:@"Member"])
            transModeVal = 7;
        else if ([btnLabel isEqualToString:@"Cheque"])
            transModeVal = 8;
        else if ([btnLabel isEqualToString:@"Card"])
            transModeVal = 9;
        itemDict = nil;
    }
}


- (void) getVoidConfirmation
{
    if ([currMode isEqualToString:@"I"]) 
    {
        if ([dataForDisplay count]>0) 
        {
            NSDictionary *tmpDict = [dataForDisplay objectAtIndex:[dataForDisplay count]-1];
            NSString *opType = [tmpDict valueForKey:@"OPERATION"];
            if ([opType isEqualToString:@"Sales"] | [opType isEqualToString:@"Return"]) 
            {
                dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure\nto Void previous Entry?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Void", nil];
                dAlert.cancelButtonIndex = 0;
                dAlert.delegate = self;
                dAlert.tag = 3;
                [dAlert show];
            }
            else
            {
                [self showAlertMessage:@"No voidable transaction!"];
                posDisplay.text =[[NSString alloc] initWithFormat:@"%@*", @"Sales"];
                transModeVal = 1;
            }
        }
        else
        {
            [self showAlertMessage:@"No voidable transaction!"];
            posDisplay.text =[[NSString alloc] initWithFormat:@"%@*", @"Sales"];
            transModeVal = 1;
        }
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        switch (alertView.tag) 
        {
            case 3:
                [self processVoidTransaction];
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
                posDisplay.text =[[NSString alloc] initWithFormat:@"%@*", @"Sales"];
                transModeVal = 1;
                break;
            default:
                break;
        }
    }
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
        posDisplay.text = @"Sales*";
        transModeVal = 1;
        [self setSummaryFieldAndBalance];
    }
}

- (IBAction) confirmButtonPressed :(id)sender
{
    int l_transQty = 0;
    double l_transAmt = 0;
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
                    [self addNewItemToGrid:@"Sales" withQty:l_transQty andTransSign:1];
                    itemDict = nil;
                    posDisplay.text = @"Sales*";
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
                    [self addNewItemToGrid:@"Return" withQty:l_transQty andTransSign:-1];
                    itemDict = nil;
                    posDisplay.text = @"Sales*";
                    transModeVal = 1;
                }
                break;
            case 4:
                l_transAmt = [self getAmtFromDisplay:posDisplay.text withTrans:@"Add"];
                if (l_transAmt==0) 
                    [self showAlertMessage:@"Amount is not valid"];
                else
                {
                    //[self addNewItemToGrid:@"Cash" withQty:l_transQty andTransSign:-1];
                    [self addNewAmountToGrid:@"Add" withAmt:l_transAmt andTransSign:-1];
                    itemDict = nil;
                    posDisplay.text = @"Sales*";
                    transModeVal = 1;
                }
                break;
            case 5:
                l_transAmt = [self getAmtFromDisplay:posDisplay.text withTrans:@"Less"];
                if (l_transAmt==0) 
                    [self showAlertMessage:@"Amount is not valid"];
                else
                {
                    //[self addNewItemToGrid:@"Cash" withQty:l_transQty andTransSign:-1];
                    [self addNewAmountToGrid:@"Less" withAmt:l_transAmt andTransSign:-1];
                    itemDict = nil;
                    posDisplay.text = @"Sales*";
                    transModeVal = 1;
                }
                break;
            case 6: // cash transaction
                l_transAmt = [self getAmtFromDisplay:posDisplay.text withTrans:@"Cash"];
                if (l_transAmt==0) 
                    [self showAlertMessage:@"Amount is not valid"];
                else
                {
                    //[self addNewItemToGrid:@"Cash" withQty:l_transQty andTransSign:-1];
                    [self addNewAmountToGrid:@"Cash" withAmt:l_transAmt andTransSign:-1];
                    itemDict = nil;
                    posDisplay.text = @"Sales*";
                    transModeVal = 1;
                }
                break;
            default:
                break;
        }
        [self setSummaryFieldAndBalance];
    }
}

- (void) addNewItemToGrid:(NSString*) p_transType withQty:(int) p_transQty andTransSign:(int) p_transSign
{
    double l_amount = [[itemDict valueForKey:@"ITEMPRICE"] doubleValue]* ((double) p_transQty);
    NSDictionary *dictForDisp = [NSDictionary dictionaryWithObjectsAndKeys:p_transType, @"OPERATION", [itemDict valueForKey:@"ITEMNAME"], @"DESCRIPTION", [itemDict valueForKey:@"ITEMPRICE"], @"PRICE",[NSString stringWithFormat:@"%d", p_transQty], @"QTY", [NSNumber numberWithDouble:l_amount], @"AMOUNT",[itemDict valueForKey:@"POSITEMID"], @"POSITEMID",[NSString stringWithFormat:@"%d",p_transSign], @"TRANSSIGN" , nil];
    [dataForDisplay addObject:dictForDisp];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:[dataForDisplay count] inSection:0];
    NSArray *indexArray = [NSArray arrayWithObjects:newPath, nil];
    [posTranView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    [posTranView selectRowAtIndexPath:newPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
}

- (void) addNewAmountToGrid:(NSString*) p_transType withAmt:(double) p_transAmt andTransSign:(int) p_transSign
{
    NSDictionary *dictForDisp = [NSDictionary dictionaryWithObjectsAndKeys:p_transType, @"OPERATION", p_transType , @"DESCRIPTION", 
                                 [NSNumber numberWithDouble:p_transAmt], @"PRICE",[NSString stringWithFormat:@"%d", 1], @"QTY", [NSNumber numberWithDouble:p_transAmt], @"AMOUNT",[NSString stringWithString:@"0"] , @"POSITEMID",[NSString stringWithFormat:@"%d",p_transSign], @"TRANSSIGN" , nil];
    [dataForDisplay addObject:dictForDisp];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:[dataForDisplay count] inSection:0];
    NSArray *indexArray = [NSArray arrayWithObjects:newPath, nil];
    [posTranView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    [posTranView selectRowAtIndexPath:newPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
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
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:p_rowNo-1];
    UILabel *lbl1, *lbl2, *lbl3, *lbl4, *lblDivider;
    UIColor *lblColor;
    int   cellHeight, xPosition, xWidth ;
    NSString *opType;
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
        
        xPosition += xWidth + 1;xWidth = 180;
        lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(xPosition-1, 0, 1, cellHeight)];
        lblDivider.text = @"";
        lblDivider.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lblDivider];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentLeft;
        lbl2.tag = 2;
        lbl2.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl2];
        
        xPosition += xWidth+1; xWidth = 110;

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
        
        xPosition += xWidth+1; xWidth = 116;

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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    opType = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"OPERATION"]];
    
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
    
    if ([opType isEqualToString:@"Sales"]) 
        lblColor = [UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Return"])
        lblColor = [UIColor colorWithRed:185.0f/255.0f green:153.0f/255.0f blue:93.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Void"])
        lblColor = [UIColor colorWithRed:155.0f/255.0f green:173.0f/255.0f blue:123.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Add"])
        lblColor = [UIColor colorWithRed:225.0/255.0f green:193.0f/255.0f blue:153.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Less"])
        lblColor = [UIColor colorWithRed:195.0f/255.0f green:213.0f/255.0f blue:183.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Cash"])
        lblColor = [UIColor colorWithRed:125.0f/255.0f green:233.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Member"])
        lblColor = [UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Cheque"])
        lblColor = [UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0];
    else if ([opType isEqualToString:@"Card"])
        lblColor = [UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0];
        
    
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
        
        xPosition += xWidth + 1;xWidth = 180;
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
        
        xPosition += xWidth+1; xWidth = 110;

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
        
        xPosition += xWidth+1; xWidth = 116;

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
        self.navigationItem.rightBarButtonItem = [self getButtonForNavigation:@"Insert"];
    
    if ([currMode isEqualToString:@"I"]) 
        self.navigationItem.rightBarButtonItem = [self getButtonForNavigation:@"Save"];
}

- (void) posItemSelectedInSearch:(NSDictionary*) p_itemDict
{
    if ([currMode isEqualToString:@"I"]) 
    {
        itemDict = [NSDictionary dictionaryWithDictionary:p_itemDict];
        //int l_opMode =[self getOperationMode:posDisplay.text];
        switch (transModeVal) {
            case 1:
                posDisplay.text = [[NSString alloc] initWithFormat:@"%@*%@*%@*", @"Sales",[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
                break;
            case 2:
                posDisplay.text = [[NSString alloc] initWithFormat:@"%@*%@*%@*", @"Return",[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
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
    NSString *itemDesc  = [[NSString alloc] initWithFormat:@"%@*%@*%@*", p_transNature ,[itemDict valueForKey:@"ITEMNAME"],[itemDict valueForKey:@"ITEMPRICE"]];
    NSString *restString = [p_curDisplay stringByReplacingOccurrencesOfString:itemDesc withString:@""];
    if ([restString isEqualToString:@""]) 
        return 1;
    else
        return [restString intValue];
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

- (int) getOperationMode:(NSString*) p_curDisplay
{
    //1 -- sales, 2 -- return, 3 -- void
    int l_retOperationMode = 0;
    int l_dispLength = 0;
    BOOL l_isAsterixExists = NO;
    NSString *strBeforeAsterix;
    if (!p_curDisplay) 
    {
        l_retOperationMode = 1;
        return l_retOperationMode;
    }
    l_dispLength = [p_curDisplay length];
    if (l_dispLength==0) 
    {
        l_retOperationMode = 1;
        return l_retOperationMode;
    }
    if ([p_curDisplay rangeOfString:@"*" options:NSCaseInsensitiveSearch].location==NSNotFound) 
        l_isAsterixExists = NO;
    else
        l_isAsterixExists = YES;
    
    if (l_isAsterixExists==NO) 
    {
        if ([p_curDisplay isEqualToString:@"Sales"]) 
            l_retOperationMode = 1;
        else if ([p_curDisplay isEqualToString:@"Return"])
            l_retOperationMode = 2;
        else if ([p_curDisplay isEqualToString:@"Void"])
            l_retOperationMode = 3;
        return l_retOperationMode;
    }
    
    if (l_isAsterixExists) 
    {
        NSRange asterixRange = [p_curDisplay rangeOfString:@"*" options:NSCaseInsensitiveSearch];
        strBeforeAsterix = [[NSString alloc] initWithFormat:@"%@", [p_curDisplay substringToIndex:asterixRange.location]];
        if ([strBeforeAsterix isEqualToString:@"Sales"]) 
            l_retOperationMode = 1;
        else if ([strBeforeAsterix isEqualToString:@"Return"])
            l_retOperationMode = 2;
        else if ([strBeforeAsterix isEqualToString:@"Void"])
            l_retOperationMode = 3;
        return l_retOperationMode;
    }
    
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
    for (NSDictionary *tmpDict in dataForDisplay) 
    {
        NSString *transType = [tmpDict valueForKey:@"OPERATION"];
        if ([transType isEqualToString:@"Sales"] | [transType isEqualToString:@"Return"] | [transType isEqualToString:@"Void"] ) 
        {
            totQty += [[tmpDict valueForKey:@"QTY"] intValue]*[[tmpDict valueForKey:@"TRANSSIGN"] intValue] ;
            totAmount += [[tmpDict valueForKey:@"AMOUNT"] doubleValue] * [[tmpDict valueForKey:@"TRANSSIGN"] intValue] ;
        }
        else
            amtAdjusted += [[tmpDict valueForKey:@"AMOUNT"] doubleValue] * [[tmpDict valueForKey:@"TRANSSIGN"] intValue] ; 
    }
    finBalance = totAmount + amtAdjusted;
    txtTotQty.text = [NSString stringWithFormat:@"%d", totQty];
    txtTotAmount.text = [frmFloat stringFromNumber:[NSNumber numberWithDouble:totAmount]];
    txtBalance.text = [frmFloat stringFromNumber:[NSNumber numberWithDouble:finBalance]];
}

@end
