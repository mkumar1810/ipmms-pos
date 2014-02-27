//
//  posItemSearch.m
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "posItemSearch.h"

@implementation posItemSearch

- (id) initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotifyMethod:(METHODCALLBACK) p_callbackMethod andControllerCallBack:(METHODCALLBACK) p_controllerCallBack
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        [actIndicator setFrame:CGRectMake(141, 321, 37, 37)];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"POSITEMSLIST"];
        _itemSearchCallBack = p_callbackMethod;
        _controllerCallBack = p_controllerCallBack;
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        [actIndicator startAnimating];
        sBar.text = @"";
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
        [self generateData];
    }
    return self;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
        populationOnProgress = YES;
        METHODCALLBACK l_itemSearchReturn = ^ (NSDictionary* p_dictInfo)
        {
            [self posItemsListDataGenerated:p_dictInfo];
        };
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:sBar.text, @"p_searchtext" , [stdUserDefaults valueForKey:@"LOGGEDLOCATION"], @"p_locationid",   nil];
        //posWSCorecall = [[posWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
        posWSCorecall = [[posWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andResponseMethod:l_itemSearchReturn];
    }    
}

- (void) posItemsListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    viewItemNo = 0;
    curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
    populationOnProgress = NO;
    [self generateTableView];
}


- (void) generateTableView
{
    int ystartPoint;
    int sBarwidth;
    int reqdHeight;
    if (dispTV) 
    {
        //[dispTV removeFromSuperview];
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            [actIndicator setFrame:CGRectMake(141, 281, 37, 37)];
        else
            [actIndicator setFrame:CGRectMake(141, 361, 37, 37)];
        [dispTV reloadData];
        [actIndicator stopAnimating];
        return;
    }
    CGRect tvrect;
    ystartPoint = sBar.frame.size.height+1;
    reqdHeight =  (768-45-sBar.frame.size.height-1)/60;
    reqdHeight = reqdHeight*60;
    //NSLog(@"reqd height %d and ystart point is %d", reqdHeight, ystartPoint);
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 320, 600);
        [actIndicator setFrame:CGRectMake(141, 281, 37, 37)];
    }
    else
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 320,reqdHeight);
        [actIndicator setFrame:CGRectMake(141, 361, 37, 37)];
    }
    [sBar setFrame:CGRectMake(0, 0, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
    [self addSubview:dispTV];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [actIndicator stopAnimating];
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 NSString *key;
 if (UIInterfaceOrientationIsPortrait(intOrientation))
 key =  [[NSString alloc] initWithString:@"     Cust Code                       Customer Name"];
 else
 key =  [[NSString alloc] initWithString:@"     Cust Code                                              Customer Name"];
 key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
 return key;
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataForDisplay count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  30.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    viewItemNo = indexPath.row;
    curIndPath = [NSIndexPath indexPathForRow:viewItemNo inSection:0];
    [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    _itemSearchCallBack(returnInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cellPosItem";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblItemName, *lblPrice;
    NSString *itemName, *itemPrice;
    int labelHeight = 30;
    int lblShort, lblLong;
    lblShort = 70;
    lblLong = 250;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        lblItemName = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, lblLong, labelHeight-1)];
        lblItemName.font = [UIFont systemFontOfSize:14.0f];
        lblItemName.tag = 1;
        [lblItemName setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblItemName];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(lblLong+1, 1, lblShort, labelHeight-1)];
        lblPrice.font = [UIFont systemFontOfSize:12.0f];
        lblPrice.tag = 2;
        [lblPrice setTextColor:[UIColor whiteColor]];
        [lblPrice setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lblPrice];
        [lblItemName setBackgroundColor:[UIColor blackColor]];
        [lblPrice setBackgroundColor:[UIColor blackColor]];
    }
    
    itemName = [[NSString alloc] initWithFormat:@"  %@ ",[tmpDict valueForKey:@"ITEMNAME"]];
    double unitprice  =[[tmpDict valueForKey:@"ITEMPRICE"] doubleValue];
    itemPrice = [[[NSString alloc]initWithFormat:@" %@  ",[frm stringFromNumber:[NSNumber numberWithDouble:unitprice]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lblItemName = (UILabel*) [cell.contentView viewWithTag:1];
    lblItemName.text = itemName;
    
    lblPrice = (UILabel*) [cell.contentView viewWithTag:2];
    lblPrice.text = itemPrice;
    
    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    refreshTag = 1;
    [self generateData];
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
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:nil forKey:@"data"];
    _itemSearchCallBack(returnInfo);
}

- (void) addNewItem
{
    currMode = @"I";
    newItem = [[itemAdd alloc] initWithFrame:self.frame forOrientation:intOrientation withControllerCallback:_controllerCallBack];
    [self addSubview:newItem];
}

- (void) addNewCategory
{
    currMode = @"CI";
    [newItem addNewCategory];
}

- (void) addUpdateCategory
{
    [newItem addUpdateCategory];
}

- (void) cancelCategoryAddUpdation
{
    [newItem cancelCategoryAddUpdation];
}

- (void) editItem:(NSDictionary*) p_itemDict
{
    //NSLog(@"the data to be edited for path %@ is %@",  curIndPath, [dataForDisplay objectAtIndex:curIndPath.row]);
    currMode = @"E";
    newItem = [[itemAdd alloc] initWithFrame:self.frame forOrientation:intOrientation forEditData:[dataForDisplay objectAtIndex:curIndPath.row] withControllerCallback:_controllerCallBack];
    [self addSubview:newItem];
}

- (void) cancelItemUpdation
{
    NSDictionary *itemUpdateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
    _controllerCallBack(itemUpdateInfo);
    [newItem removeFromSuperview];
    newItem = nil;
    currMode = @"L";
}

- (void) updateItem
{
    if ([newItem validateData]) 
    {
        [actIndicator startAnimating];
        //ADDUPDATEPOSITEM
        METHODCALLBACK l_itemUpdateReturn = ^ (NSDictionary* p_dictInfo)
        {
            [self posItemsUpdated:p_dictInfo];
        };
        posWSCorecall = [[posWSProxy alloc] initWithReportType:@"ADDUPDATEPOSITEM" andInputParams:[newItem getDictionaryToUpdate] andResponseMethod:l_itemUpdateReturn];
    }
}

- (void) posItemsUpdated:(NSDictionary *)updateInfo
{
    NSDictionary *returnedDict =  [[updateInfo valueForKey:@"data"] objectAtIndex:0];
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    if ([respCode isEqualToString:@"0"]) 
    {
        if ([currMode isEqualToString:@"I"]) 
        {
            [dataForDisplay insertObject:returnedDict atIndex:0];
            curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [dispTV reloadData];
        }
        else
        {
            NSArray *updateInfo = [[NSArray alloc] initWithObjects:curIndPath, nil];
            [dataForDisplay replaceObjectAtIndex:curIndPath.row withObject:returnedDict];
            [dispTV reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
        }
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        NSDictionary *itemUpdateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
        _controllerCallBack(itemUpdateInfo);
        [newItem removeFromSuperview];
        newItem = nil;
        currMode = @"L";
    }
    else
        [self showAlertMessage:respMsg];
    [actIndicator stopAnimating];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) cancelCategorySelection
{
    [newItem cancelCategorySelection];
}

@end
