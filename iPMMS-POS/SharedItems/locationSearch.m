//
//  locationSearch.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 18/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "locationSearch.h"

@implementation locationSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname andIsSplit:(BOOL) p_issplitmode
{
    self = [super initWithFrame:frame];
    if (self) {
        isSplitMode = p_issplitmode;
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        if (isSplitMode) 
            [actIndicator setFrame:CGRectMake(310, 361, 37, 37)];
        else
            [actIndicator setFrame:CGRectMake(490, 330, 37, 37)];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"LOCATIONSLIST"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLLOCATIONS"];
        _gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationListDataGenerated:)  name:_proxynotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireCancelNotification:) name:@"fireCancelLocationSelect" object:nil];
        _notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        if (isSplitMode) 
        {
            navBar.hidden = YES;
            NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",@"fireCancelLocationSelect",@"btnnotification" ,  nil];
            NSDictionary *naviInfo = [[NSDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , @"Select a Location",@"navititle" ,nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationNotify" object:self userInfo:naviInfo];
        }
        else
        {
            navBar.hidden =NO;
            navTitle.title = @"Select a Location";
        }
        [self generateData];
    }
    return self;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        [actIndicator startAnimating];
        populationOnProgress = YES;
        posWSCorecall = [[posWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andNotificatioName:_proxynotification];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}

- (void) locationListDataGenerated:(NSNotification *)generatedInfo
{
    NSDictionary *recdData = [generatedInfo userInfo];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    [self setForOrientation:intOrientation];
    populationOnProgress = NO;
    [actIndicator stopAnimating];
    NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
    [stdUserDefaults setValue:dataForDisplay forKey:@"LOCATIONSLIST"];
    /*if (!isSplitMode) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"LocationSelected"] forKey:@"notify"];
        [returnInfo setValue:[dataForDisplay objectAtIndex:0] forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
    }*/
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
    int sBarwidth;
    //return;
    if (dispTV) 
        [dispTV removeFromSuperview];
    
    CGRect tvrect;
    if (sBar.hidden==YES) 
        ystartPoint = 45;
    else
        ystartPoint = 45;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 703, 1024);
        [actIndicator setFrame:CGRectMake(340, 490, 37, 37)];
    }
    else
    {
        if (isSplitMode) {
            sBarwidth = 320;
            tvrect = CGRectMake(0, ystartPoint, 703, 768);
            [actIndicator setFrame:CGRectMake(310, 361, 37, 37)];
        }
        else
        {
            tvrect = CGRectMake(0, ystartPoint, 1004, 768);
            [actIndicator setFrame:CGRectMake(490, 330, 37, 37)];
        }
    }
    [sBar setFrame:CGRectMake(0, 0, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
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
    return  90.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isSplitMode) 
        [actIndicator startAnimating];
    
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"LocationSelected"] forKey:@"notify"];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblGymName, *lblGymAddress;
    UIImageView *locPhoto;
    NSString *gymName, *gymAddress;
    NSURL *urlPath ;
    int lblWidth;
    if (isSplitMode) 
        lblWidth = 533;
    else
        lblWidth = 819;
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        locPhoto = [[UIImageView alloc] init];
        [locPhoto setFrame:CGRectMake(1, 1, 88, 88)];
        locPhoto.tag = 1;
        [cell.contentView addSubview:locPhoto];
        
        lblGymName = [[UILabel alloc] initWithFrame:CGRectMake(91, 1, lblWidth, 50)];
        lblGymName.font = [UIFont boldSystemFontOfSize:22.0f];
        [lblGymName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblGymName.tag = 2;
        [cell.contentView addSubview:lblGymName];
        
        lblGymAddress = [[UILabel alloc] initWithFrame:CGRectMake(91, 51, lblWidth, 39)];
        lblGymAddress.font = [UIFont boldSystemFontOfSize:15.0f];
        [lblGymAddress setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:170.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        lblGymAddress.tag = 3;
        [cell.contentView addSubview:lblGymAddress];
    }
    
    //NSLog(@"the dictionary data is %@",tmpDict);
    
    gymName = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"GYMNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    gymAddress = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"GYMADDRESS"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//GYM%d.JPG",MAIN_URL, WS_ENV, [[tmpDict valueForKey:@"GYMLOCATIONID"] intValue]]];
    //NSLog(@"the image location id %@", urlPath);
    locPhoto = (UIImageView*) [cell.contentView viewWithTag:1];
    lblGymName = (UILabel*) [cell.contentView viewWithTag:2];
    lblGymAddress = (UILabel*) [cell.contentView viewWithTag:3];
    locPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPath]];
    lblGymName.text = gymName;
    lblGymAddress.text = gymAddress;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if ([currMode isEqualToString:@"L"]) 
    {
        [super searchBarSearchButtonClicked:searchBar];
        [self generateData];
    }
    else
        sBar.text = @"";
}

- (IBAction) goBack:(id) sender
{
    if (isSplitMode) 
        [self fireCancelNotification:nil];
    else
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:nil forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
    }
}

- (void) fireCancelNotification:(NSNotification*) cancelInfo
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"LocationSelectCancel"] forKey:@"notify"];
    [returnInfo setValue:nil forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_gobacknotifyName object:self userInfo:returnInfo];
}

@end
