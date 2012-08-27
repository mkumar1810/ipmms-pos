//
//  itemAdd.m
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "itemAdd.h"

@implementation itemAdd

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification forEditData:(NSDictionary*) p_initData
{
    self = [self initWithFrame:frame forOrientation:p_intOrientation andNotification:p_notification];
    _initDict = [NSDictionary dictionaryWithDictionary:p_initData];
    currMode = @"Edit";
    [self generateData];
    return self;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification 
{
    self = [super initWithFrame:frame];
    if (self) {
        _initDict = nil;
        [super addNIBView:@"getSearch" forFrame:frame];
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        _notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden = YES;
        lblTextColor = [UIColor whiteColor];
        NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
        locPriceDetail = [[NSMutableArray alloc] initWithArray:[stdUserDefaults valueForKey:@"LOCATIONSLIST"] copyItems:YES];
        currMode = [[NSString alloc] initWithString:@"Insert"];
        [self generateTableView];
    }
    return self;
}


- (void) generateData
{
    //POSITEMDATA
    //NSLog(@"the received information %@", _initDict);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(posItemDataGenerated:)  name:@"posItemDataGenerated" object:nil];
    posCoreCall = [[posWSProxy alloc] initWithReportType:@"POSITEMDATA" andInputParams:_initDict andNotificatioName:@"posItemDataGenerated"];
}

- (void) posItemDataGenerated : (NSNotification*) p_posItemInfo
{
    //NSLog(@"the received data is %@", p_posItemInfo);
    NSDictionary *recdData = [p_posItemInfo userInfo];
    recdItemArray =[[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"posItemDataGenerated" object:nil];
    [self displayDataForList];
}

- (void) displayDataForList
{
    NSDictionary *tmpDict = [recdItemArray objectAtIndex:0];
    if (txtItemCode) 
        txtItemCode.text = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"ITEMCODE"]];
    if (txtItemName) 
        txtItemName.text = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"ITEMNAME"]];
    if (txtItemPrice) 
        txtItemPrice.text = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"ITEMPRICE"]];
    if (txtCategoryName) 
    {
        txtCategoryName.text = [[NSString alloc] initWithFormat:@"%@ - %@", [tmpDict valueForKey:@"CATEGORYCODE"], [tmpDict valueForKey:@"CATEGORYNAME"]];
        _categoryId = [[tmpDict valueForKey:@"CATEGORYID"] intValue];
    }
    
    for (int l_loopcounter = 0; l_loopcounter < [locPriceDetail count] ; l_loopcounter++) 
    {
        NSDictionary *tmpDict = [locPriceDetail objectAtIndex:l_loopcounter];
        UITableViewCell *reqCell = [dispTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:l_loopcounter inSection:1]];
        UITextField *priceField = (UITextField*)  [reqCell.contentView viewWithTag:2];
        priceField.text = @"0.00";
        for (NSDictionary *locPriceDict in recdItemArray) 
        {
            if ([[locPriceDict valueForKey:@"DATATYPE"] isEqualToString:@"2"]) 
            {
                NSString *gymLocId = [NSString stringWithString:[tmpDict valueForKey:@"GYMLOCATIONID"]];
                NSString *priceLocId = [NSString stringWithString:[locPriceDict valueForKey:@"LOCATIONID"]];
                if ([gymLocId isEqualToString:priceLocId]) 
                    priceField.text = [locPriceDict valueForKey:@"LOCATIONPRICE"];
            }
        }
    }
}

- (void) generateTableView
{
    int ystartPoint;
    int sBarwidth;
    if (dispTV) 
        [dispTV removeFromSuperview];
    
    CGRect tvrect;
    ystartPoint = 45;
    sBarwidth = 320;
    tvrect = CGRectMake(0, ystartPoint, 320, 720);
    [actIndicator setFrame:CGRectMake(140, 300, 37, 37)];
    //[sBar setFrame:CGRectMake(0, 0, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
    [dispTV setBounces:NO];
    [self addSubview:dispTV];
    dispTV.separatorColor = bgcolor;
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [dispTV setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [actIndicator stopAnimating];
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int l_noofRows = 0;
    switch (section) 
    {
        case 0:
            l_noofRows = 4;
            break;
        default:
            l_noofRows = [locPriceDetail count];
            break;
    }
    return l_noofRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  35.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
     [returnInfo setValue:[NSString stringWithString:@"BillCycleSelected"] forKey:@"notify"];
     [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
     [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];*/
    if (indexPath.section==0 & indexPath.row==3) 
    {
        NSDictionary *catSelInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"CatList",@"data", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"controllerNotify" object:self userInfo:catSelInfo];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(posCategorySelected:)  name:@"posCategorySelectForItem" object:nil];
        posCatSelect = [[poscategorySearch alloc] initWithFrame:self.frame forOrientation:intOrientation andNotification:@"posCategorySelectForItem" withNewDataNotification:@"posCategorySelection"];
        [self addSubview:posCatSelect];
    }
}

- (void) posCategorySelected : (NSNotification*) catSelectInfo
{

    NSDictionary *recdData = [[catSelectInfo userInfo] valueForKey:@"data"];
    if (recdData) {
        txtCategoryName.text = [[NSString alloc] initWithFormat:@"%@ - %@", [recdData valueForKey:@"CATEGORYCODE"], [recdData valueForKey:@"CATEGORYNAME"]];
        _categoryId = [[recdData valueForKey:@"CATEGORYID"] intValue];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"posCategorySelectForItem" object:nil];
    NSDictionary *itemUpdateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:currMode ,@"data", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"controllerNotify" object:self userInfo:itemUpdateInfo];
}

- (void) cancelCategorySelection
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"posCategorySelectForItem" object:nil];
    [posCatSelect removeFromSuperview];
    NSDictionary *itemUpdateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:currMode ,@"data", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"controllerNotify" object:self userInfo:itemUpdateInfo];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
    {
        case 0:
            return [self getSingleContentCell:indexPath.row];
            break;
        /*case 1:
            return [self getLocationPriceHeaderCell];
            break;*/
        default:
            return [self getLocationPriceCell:indexPath.row];
            break;
    }
    return nil;
}

- (UITableViewCell*) getLocationPriceCell:(int) p_rowno
{
    NSDictionary *tmpDict = [locPriceDetail objectAtIndex:p_rowno];
    static NSString *cellid= @"CellLocPrice";
    UITextField *txt1;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
        
        UILabel *lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 103, 0, 1, 35)];
        lblDivider.backgroundColor = [UIColor grayColor];
        lblDivider.text = @"";
        [cell.contentView addSubview:lblDivider];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 0, 75, 35)];
        txt1.borderStyle = UITextBorderStyleNone;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.textAlignment = UITextAlignmentRight;
        txt1.font = cell.textLabel.font;
        txt1.delegate = self;
        txt1.text = @"";
        txt1.placeholder = @"(Price)";
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txt1];
        [txt1 setKeyboardType:UIKeyboardTypeNumberPad];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.numberOfLines = 2;
    }
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@\n%@",[tmpDict valueForKey:@"GYMNAME"],[tmpDict valueForKey:@"GYMADDRESS"]];
    
    return cell;
}

- (UITableViewCell*) getLocationPriceHeaderCell
{
    static NSString *cellid=@"CellLocPriceHeader";
    UIButton *btnAdd;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        cell.textLabel.text = @"Click to add New Location price";
        
        btnAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [btnAdd setFrame:CGRectMake(cell.frame.size.width - 50, 0, 35, 35)];
        btnAdd.titleLabel.text=@"";
        [cell.contentView addSubview:btnAdd];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (UITableViewCell*) getSingleContentCell:(int) p_rowno
{
    static NSString *cellid=@"CellMain";
    UITextField *txt1;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        
        UILabel *lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 1, 35)];
        lblDivider.backgroundColor = [UIColor grayColor];
        lblDivider.text = @"";
        [cell.contentView addSubview:lblDivider];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(83, 0, cell.frame.size.width, 35)];
        txt1.borderStyle = UITextBorderStyleNone;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.font = cell.textLabel.font;
        txt1.delegate = self;
        txt1.text = @"";
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:txt1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        switch (p_rowno) 
        {
            case 0:
                txtItemCode = (UITextField*) [cell.contentView viewWithTag:2];
                cell.textLabel.text = @"Item Code";
                break;
            case 1:
                txtItemName = (UITextField*) [cell.contentView viewWithTag:2];
                cell.textLabel.text = @"Item Name";
                break;
            case 2:
                txtItemPrice = (UITextField*) [cell.contentView viewWithTag:2];
                [txtItemPrice setKeyboardType:UIKeyboardTypeNumberPad];
                cell.textLabel.text = @"Item Price";
                break;
            case 3:
                txtCategoryName = (UITextField*) [cell.contentView viewWithTag:2];
                txtCategoryName.enabled = NO;
                cell.textLabel.text = @"Category";
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void) addNewCategory
{
    [posCatSelect addNewCategory];
}

- (void) addUpdateCategory
{
    [posCatSelect addUpdateCategory];
}

- (void) cancelCategoryAddUpdation
{
    [posCatSelect cancelCategoryAddUpdation];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidBeginEditing:searchBar];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidEndEditing:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
}

// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarSearchButtonClicked:searchBar];
    [self generateData];
}

- (IBAction) goBack:(id) sender
{
    
}

- (BOOL) validateData
{
    BOOL l_resultVal;
    l_resultVal = [self emptyCheckResult:txtItemCode andMessage:@"Item code should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtItemName andMessage:@"Item name should be selected"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtItemPrice andMessage:@"Item Price should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtCategoryName andMessage:@"Category should be selected"];
    
    if (l_resultVal==NO) return l_resultVal;
    
    if ([txtItemPrice.text doubleValue]==0) 
    {
        [self showAlertMessage:@"Price should be a valid numeric value"];
        l_resultVal = NO;
    }
    
    if (l_resultVal==YES) 
    {
        for (int l_loopcounter = 0; l_loopcounter < [locPriceDetail count] ; l_loopcounter++) 
        {
            UITableViewCell *reqCell = [dispTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:l_loopcounter inSection:1]];
            NSString *locMessage = [[NSString alloc] initWithFormat:@"%@ \nPrice is not valid", reqCell.textLabel.text];
            UITextField *priceField = (UITextField*)  [reqCell.contentView viewWithTag:2];
            l_resultVal = [self emptyCheckResult:priceField andMessage:locMessage];
            if (l_resultVal==NO) return l_resultVal;
            if ([priceField.text doubleValue]==0) 
            {
                [self showAlertMessage:locMessage];
                l_resultVal = NO;
                return l_resultVal;
            }
        }
    }
    
    return l_resultVal;
}

- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg
{
    if (p_passField) 
    {
        //NSLog(@"the field text value is %@", p_passField.text);
        if ([p_passField.text isEqualToString:@""]) 
        {
            [self showAlertMessage:p_errMsg];
            return  NO;
        }
    }
    else
    {
        [self showAlertMessage:p_errMsg];
        return  NO;
    }
    return YES;
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:txtItemCode])
        [txtItemName becomeFirstResponder];
    else if([textField isEqual:txtItemName])
        [txtItemPrice becomeFirstResponder];
    else if ([textField isEqual:txtItemPrice])
        [txtItemPrice resignFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

- (NSDictionary*) getDictionaryToUpdate
{
    /*
     #define ITEMMASTER_XML @"<MASTER><ITEMID>%@</ITEMID><ITEMCODE>%@</ITEMCODE><ITEMNAME>%@</ITEMNAME><ITEMPRICE>%@</ITEMPRICE><CATEGORYID>%d</CATEGORYID></MASTER>"
     
     #define ITEMDETAIL_XML @"<DETAIL><LOCATIONID>%d</LOCATIONID><LOCATIONPRICE>%@</LOCATIONPRICE></DETAIL>"
     */
    NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSMutableString *l_detailXML = [[NSMutableString alloc] init ];
    if ([currMode isEqualToString:@"Insert"]) 
        l_retXML = [NSString stringWithFormat:ITEMMASTER_XML,@"0",txtItemCode.text, txtItemName.text , txtItemPrice.text , _categoryId, [stdUserDefaults valueForKey:@"LOGGEDLOCATION"]];
    else
        l_retXML = [NSString stringWithFormat:ITEMMASTER_XML,[_initDict valueForKey:@"POSITEMID"],txtItemCode.text, txtItemName.text , txtItemPrice.text , _categoryId, [stdUserDefaults valueForKey:@"LOGGEDLOCATION"]];
    
    for (int l_loopcounter = 0; l_loopcounter < [locPriceDetail count] ; l_loopcounter++) 
    {
        UITableViewCell *reqCell = [dispTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:l_loopcounter inSection:1]];
        UITextField *priceField = (UITextField*)  [reqCell.contentView viewWithTag:2];
        NSDictionary *tmpDict = [locPriceDetail objectAtIndex:l_loopcounter];
        l_detailXML = [NSString stringWithFormat:ITEMDETAIL_XML, [[tmpDict valueForKey:@"GYMLOCATIONID"] intValue] , priceField.text, [stdUserDefaults valueForKey:@"LOGGEDLOCATION"]];
        l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML, l_detailXML];
    }

    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<ITEMDATA>",l_retXML, @"</ITEMDATA>"];
    //NSLog(@"edit saving info %@",l_retXML);
    l_retXML = (NSMutableString*) [self htmlEntitycode:l_retXML];
    NSDictionary *returnDict = [[NSDictionary alloc] initWithObjectsAndKeys:l_retXML, @"p_itemdata", nil];
    return returnDict;
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
