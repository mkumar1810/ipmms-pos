//
//  poscategorySearch.m
//  iPMMS-POS
//
//  Created by Macintosh User on 22/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "poscategorySearch.h"

@implementation poscategorySearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andCatSelectCallback:(METHODCALLBACK) p_catSelectCallBack andControllerCallback:(METHODCALLBACK) p_controllerCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        [actIndicator setFrame:CGRectMake(141, 321, 37, 37)];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"POSCATEGORIESLIST"];
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _controllerCallBack = p_controllerCallback;
        _catSelectedCallback = p_catSelectCallBack;
        [actIndicator startAnimating];
        sBar.hidden = YES;
        sBar.text = @"";
        navBar.hidden = YES;
        [self generateData];
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
    }
    return self;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        METHODCALLBACK l_catDataCallback = ^ (NSDictionary* p_dictInfo)
        {
            [self posItemsListDataGenerated:p_dictInfo];
        };
        posWSCorecall = [[posWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andResponseMethod:l_catDataCallback];
    }    
}

- (void) posItemsListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
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
    ystartPoint =1;
    reqdHeight =  (768-45-1)/60;
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
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    curIndPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    _catSelectedCallback(returnInfo);
    [self removeFromSuperview];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cellCategoryItem";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UIButton *btnView;
    UILabel *lblCatCode, *lblCatName;
    NSString *catCode, *catName;
    int labelHeight = 30;
    int lblShort, lblLong;
    lblShort = 55;
    lblLong = 225;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        lblCatCode = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, lblShort-1, labelHeight-1)];
        lblCatCode.font = [UIFont systemFontOfSize:12.0f];
        lblCatCode.tag = 2;
        [lblCatCode setTextColor:[UIColor whiteColor]];
        [lblCatCode setTextAlignment:UITextAlignmentCenter];
        [cell.contentView addSubview:lblCatCode];
 
        lblCatName = [[UILabel alloc] initWithFrame:CGRectMake(lblShort+1, 1, lblLong, labelHeight-1)];
        lblCatName.font = [UIFont systemFontOfSize:14.0f];
        lblCatName.tag = 1;
        [lblCatName setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lblCatName];
        
        [lblCatName setBackgroundColor:[UIColor blackColor]];
        [lblCatCode setBackgroundColor:[UIColor blackColor]];

        btnView = [[UIButton alloc] initWithFrame:CGRectMake(281, 1, labelHeight-1, labelHeight-1)];
        btnView.titleLabel.textColor = btnView.titleLabel.backgroundColor;
        btnView.tag = 99;
        [btnView setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnView addTarget:self action:@selector(viewSelectedCategory:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnView];
    }
    
    catName = [[NSString alloc] initWithFormat:@"  %@ ",[tmpDict valueForKey:@"CATEGORYNAME"]];
    catCode = [[NSString alloc] initWithFormat:@" %@ ",[tmpDict valueForKey:@"CATEGORYCODE"]];
    
    lblCatName = (UILabel*) [cell.contentView viewWithTag:1];
    lblCatName.text = catName;
    
    lblCatCode = (UILabel*) [cell.contentView viewWithTag:2];
    lblCatCode.text = catCode;
    
    btnView = (UIButton*) [cell.contentView viewWithTag:99];
    btnView.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

- (void) viewSelectedCategory:(id)sender
{
    UIButton *btnclicked = (UIButton*) sender;
    int selIndex = [btnclicked.titleLabel.text intValue];
    if ([currMode isEqualToString:@"L"]) 
    {
        currMode = @"E";
        curIndPath = [NSIndexPath indexPathForRow:selIndex inSection:0];
        catAddUpdate = [[categoryAddUpdate alloc] initWithFrame:self.frame forOrientation:intOrientation andNotification:@"" forEditData:[dataForDisplay objectAtIndex:selIndex]];
        [self addSubview:catAddUpdate];
        NSDictionary *itemUpdateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"CatEdit",@"data", nil];
        _controllerCallBack(itemUpdateInfo);
    }
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
    _catSelectedCallback(returnInfo);
}

- (void) addNewCategory;
{
    /*newItem = [[itemAdd alloc] initWithFrame:self.frame forOrientation:intOrientation andNotification:@""];
    [self addSubview:newItem];*/
    catAddUpdate = [[categoryAddUpdate alloc] initWithFrame:self.frame forOrientation:intOrientation andNotification:@""];
    [self addSubview:catAddUpdate];
    currMode = @"I";
}

- (void) cancelItemUpdation
{
    //[newItem removeFromSuperview];
}

- (void) cancelCategoryAddUpdation
{
    [catAddUpdate removeFromSuperview];
    catAddUpdate = nil;
    currMode = @"L";
}

- (void) addUpdateCategory
{
    if ([catAddUpdate validateData]) 
    {
        [actIndicator startAnimating];
        METHODCALLBACK l_catUpdateCallback = ^ (NSDictionary* p_dictInfo)
        {
            [self posItemsListDataGenerated:p_dictInfo];
        };        
        posWSCorecall = [[posWSProxy alloc] initWithReportType:@"ADDUPDATECATEGORY" andInputParams:[catAddUpdate getDictionaryToUpdate] andResponseMethod:l_catUpdateCallback];
    }
}

- (void) addUpdateCategoryDone:(NSDictionary *)updateInfo
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
        NSDictionary *itemUpdateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"CatList",@"data", nil];
        _controllerCallBack(itemUpdateInfo);
        [catAddUpdate removeFromSuperview];
        catAddUpdate = nil;
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


@end
