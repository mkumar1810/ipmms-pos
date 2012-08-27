//
//  holdBillsSearch.m
//  iPMMS-POS
//
//  Created by Macintosh User on 26/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "holdBillsSearch.h"

@implementation holdBillsSearch

- (id)initWithDataNotification:(NSString*) p_datanotification
{
    self = [super initWithFrame:CGRectMake(15, 35, 220, 180)];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:CGRectMake(15, 35, 220, 180)];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        [actIndicator setFrame:CGRectMake(115, 70, 37, 37)];
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"HOLDBILLSLIST"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_datanotification];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden =YES;
        selectedItem = nil;
        [self generateData];
    }
    return self;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        [actIndicator startAnimating];
        NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
        populationOnProgress = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(holdBillsListDataGenerated:)  name:_proxynotification object:nil];
        NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[stdUserDefaults valueForKey:@"LOGGEDLOCATION"], @"p_locationid",   nil];
        posWSCorecall = [[posWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
    }    
}

- (void) holdBillsListDataGenerated:(NSNotification *)generatedInfo
{
    NSDictionary *recdData = [generatedInfo userInfo];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    [self generateTableView];
    populationOnProgress = NO;
    [actIndicator stopAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_proxynotification object:nil];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) generateTableView
{
    int ystartPoint;
    if (dispTV) 
        [dispTV removeFromSuperview];
    
    CGRect tvrect;
    ystartPoint = 0;
    tvrect = CGRectMake(15, 10, 220, 180);
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
    return  25.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //curIndPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    selectedItem = [NSDictionary dictionaryWithDictionary:[dataForDisplay objectAtIndex:indexPath.row]];
}

- (NSDictionary*) returnSelectedItem
{
    return selectedItem;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CellHold";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblBillNo, *lblBillDate;
    NSString *bilNo, *billDate;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        lblBillNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 25)];
        lblBillNo.font = [UIFont boldSystemFontOfSize:18.0f];
        [lblBillNo setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblBillNo.tag = 2;
        lblBillNo.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:lblBillNo];
        
        lblBillDate = [[UILabel alloc] initWithFrame:CGRectMake(86, 0, 135, 25)];
        lblBillDate.font = [UIFont boldSystemFontOfSize:18.0f];
        [lblBillDate setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:170.0f/255.0f blue:25.0f/255.0f alpha:1.0]];
        lblBillDate.tag = 3;
        lblBillDate.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:lblBillDate];
    }
    
    bilNo = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"BILLNO"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    billDate = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"BILLDATE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lblBillNo = (UILabel*) [cell.contentView viewWithTag:2];
    lblBillDate = (UILabel*) [cell.contentView viewWithTag:3];
    lblBillNo.text = bilNo;
    lblBillDate.text = billDate;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    //[dispTV removeFromSuperview];
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
}

- (IBAction) goBack:(id) sender
{
}


@end
