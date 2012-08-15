//
//  memberSearch.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberSearch.h"

@implementation memberSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"MEMBERSLIST"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLMEMBERS"];
        _gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberListDataGenerated:)  name:_proxynotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberControllerInfoUpdate:)  name:@"memberControllerInfoUpdate" object:nil];
        _notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
        _currControllerIndex = 0;
        [actIndicator startAnimating];
        sBar.text = @"";
        [self generateData];
    }
    return self;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sBar.text, @"p_searchtext" , nil];
        if (refreshTag==1) 
        {
            [inputDict setValue:[[NSString alloc] initWithString:@""] forKey:@"p_searchtext"];
            gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
        }
        else
        {
            if ([sBar.text isEqualToString:@""]) 
            {
                NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                if ([stdDefaults valueForKey:_cacheName]==nil) 
                {
                    [inputDict setValue:[[NSString alloc] initWithString:@""] forKey:@"p_searchtext"];
                    gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
                }
                else
                {
                    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
                    [returnInfo setValue:[stdDefaults valueForKey:_cacheName] forKey:@"data"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:_proxynotification object:self userInfo:returnInfo];
                }
            }
            else
                gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
        }
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    //[super setForOrientation:p_forOrientation]; 
    /*[self generateTableView];
    if ([dataForDisplay count]>0) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[dataForDisplay objectAtIndex:0] forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];   
    }*/
}

- (void) memberControllerInfoUpdate:(NSNotification*) controllerInfo
{
    NSString *recdIndexStr = (NSString*) [controllerInfo userInfo];
    _currControllerIndex = [recdIndexStr intValue];
}

- (void) memberListDataGenerated:(NSNotification *)generatedInfo
{
    NSDictionary *recdData = [generatedInfo userInfo];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    //NSLog(@"received array list %@", dataForDisplay);
    if ([sBar.text isEqualToString:@""]) 
    {
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        if ([dataForDisplay count]==0) 
            [stdDefaults setValue:nil forKey:_cacheName];
        else
            [stdDefaults setValue:dataForDisplay forKey:_cacheName];
    }
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    viewItemNo = 0;
    curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
    populationOnProgress = NO;
    //[self setForOrientation:intOrientation];
    [self generateTableView];
    if ([dataForDisplay count]>0) 
    {
        [returnInfo setValue:[dataForDisplay objectAtIndex:0] forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];   
    }
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
    //[super generateTableView];
    int ystartPoint;
    int sBarwidth;
    int reqdHeight;
    //return;
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
    return  60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([currMode isEqualToString:@"I"]) 
    {
        //[dispTV deselectRowAtIndexPath: animated:NO];
        if (_currControllerIndex==0) 
            [dispTV deselectRowAtIndexPath:indexPath animated:NO];
        else
            [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];        
        return;
    }
    if ([currMode isEqualToString:@"U"]) 
    {
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        return;
    }
    if ([currMode isEqualToString:@"L"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
        viewItemNo = indexPath.row;
        curIndPath = [NSIndexPath indexPathForRow:viewItemNo inSection:0];
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        //NSLog(@"the didselect row ate index sets theposition");
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    //UILabel *lblFN, *lblLN, *lblGender, *lblNation, *lblAge;
    UILabel *lblFullName, *lblMobile, *lblNation, *lblAge;
    UIImageView *mbrPhoto;
    //NSString *firstName, *lastName, *gender, *nationality, *age;
    NSString *fullName, *mobile, *nationality, *age;
    NSURL *urlPath ;
    int labelHeight = 30;
    int lblShort, lblLong;
    lblShort = 87;
    lblLong = 130;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        mbrPhoto = [[UIImageView alloc] init];
        [mbrPhoto setFrame:CGRectMake(5, 5, 50, 50)];
        mbrPhoto.tag = 1;
        [cell.contentView addSubview:mbrPhoto];
        
        /*lblLN = [[UILabel alloc] initWithFrame:CGRectMake(61, 0, lblLong, labelHeight)];
        lblLN.font = [UIFont systemFontOfSize:14.0f];
        [lblLN setBackgroundColor:[UIColor whiteColor]];
        lblLN.tag = 2;
        [cell.contentView addSubview:lblLN];

        lblFN = [[UILabel alloc] initWithFrame:CGRectMake(62+lblLong, 0, lblLong, labelHeight)];
        lblFN.font = [UIFont systemFontOfSize:14.0f];
        [lblFN setBackgroundColor:[UIColor whiteColor]];
        lblFN.tag = 3;
        [cell.contentView addSubview:lblFN];*/
        
        lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(61, 1, 2*lblLong, labelHeight-1)];
        lblFullName.font = [UIFont systemFontOfSize:14.0f];
        //[lblFullName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblFullName.tag = 2;
        [cell.contentView addSubview:lblFullName];
    
        
        lblMobile = [[UILabel alloc] initWithFrame:CGRectMake(61, 30, lblShort, labelHeight-1)];
        lblMobile.font = [UIFont systemFontOfSize:12.0f];
        //[lblGender setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        lblMobile.tag = 4;
        [cell.contentView addSubview:lblMobile];
        
        lblNation = [[UILabel alloc] initWithFrame:CGRectMake(61+lblShort, 30, lblShort, labelHeight-1)];
        lblNation.font = [UIFont systemFontOfSize:12.0f];
        //[lblNation setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        lblNation.tag = 5;
        [cell.contentView addSubview:lblNation];

        lblAge = [[UILabel alloc] initWithFrame:CGRectMake(61+2*lblShort, 30, lblShort, labelHeight-1)];
        lblAge.font = [UIFont systemFontOfSize:12.0f];
        //[lblAge setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        lblAge.tag = 6;
        [lblAge setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lblAge];
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //[lblFullName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];        
        //[lblGender setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        //[lblNation setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        //[lblAge setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        [lblMobile setBackgroundColor:[UIColor blackColor]];
        [lblNation setBackgroundColor:[UIColor blackColor]];
        [lblAge setBackgroundColor:[UIColor blackColor]];
        lblMobile.textColor = [UIColor whiteColor];
        lblNation.textColor = [UIColor whiteColor];
        lblAge.textColor = [UIColor whiteColor];
        [lblFullName setBackgroundColor:[UIColor blackColor]];
        lblFullName.textColor = [UIColor whiteColor];
        
    }


    //NSLog(@"url path is  %@", urlPath);

    /*firstName = [[[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"FIRSTNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"]; 
    lastName = [[[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"LASTNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];*/
    fullName = [[NSString alloc] initWithFormat:@" %@ %@",[tmpDict valueForKey:@"FIRSTNAME"],[tmpDict valueForKey:@"LASTNAME"]];
    mobile = [[[NSString alloc] initWithFormat:@" %@", [tmpDict valueForKey:@"MOBILEPHONE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    nationality = [[[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"NATNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    age = [[[NSString alloc] initWithFormat:@"%@ Yrs  ", [tmpDict valueForKey:@"AGE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    //NSString *imgName = [[NSString alloc] initWithFormat:@"Imagem%d",[[tmpDict valueForKey:@"MEMBERID"] intValue]];
    NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[tmpDict valueForKey:@"MEMBERID"]];
    NSData *imgData = [stdDefaults valueForKey:imgName];
    // = (UIImage*) [stdDefaults valueForKey:imgName];
    if (!imgData) 
    {
        urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//m%d.jpeg",MAIN_URL, WS_ENV, [[tmpDict valueForKey:@"MEMBERID"]intValue]]];
        imgData = [NSData dataWithContentsOfURL:urlPath];
        [stdDefaults setValue:imgData forKey:imgName];
    }
    
    UIImage *memImage = [UIImage imageWithData:imgData];
    mbrPhoto= (UIImageView*) [cell.contentView viewWithTag:1];
    mbrPhoto.image = memImage;

    /*lblFN = (UILabel*) [cell.contentView viewWithTag:3];
    lblFN.text = firstName;
    
    lblLN = (UILabel*) [cell.contentView viewWithTag:2];
    lblLN.text = lastName;*/
    
    lblFullName = (UILabel*) [cell.contentView viewWithTag:2];
    lblFullName.text = fullName;
    
    lblMobile = (UILabel*) [cell.contentView viewWithTag:4];
    lblMobile.text = mobile;
    
    lblNation = (UILabel*) [cell.contentView viewWithTag:5];
    lblNation.text = nationality;
    
    lblAge = (UILabel*) [cell.contentView viewWithTag:6];
    lblAge.text = age;
    /*BOOL setSelectedColor = NO;
    
    if ([currMode isEqualToString:@"U"]) 
        if (viewItemNo==indexPath.row) 
            setSelectedColor = YES;
    
    if (setSelectedColor) 
    {
        lblFullName.backgroundColor = [UIColor blueColor];
        lblGender.backgroundColor = [UIColor blueColor];
        lblNation.backgroundColor = [UIColor blueColor];
        lblAge.backgroundColor = [UIColor blueColor];
    }
    else
    {
        if (lblFullName.backgroundColor==[UIColor blueColor]) 
        {
            [lblFullName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];        
            [lblGender setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
            [lblNation setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
            [lblAge setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:210.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        }
    }*/
    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    for (NSDictionary *tmpDict in dataForDisplay) 
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[tmpDict valueForKey:@"MEMBERID"]];
        [stdDefaults setValue:nil forKey:imgName];
    }
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
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:nil forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_gobacknotifyName object:self userInfo:returnInfo];
}

- (void) setInsertMode
{
    currMode = @"I";
    if (_currControllerIndex==0) 
        [dispTV deselectRowAtIndexPath:curIndPath animated:NO];
    else
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];        
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    /*if ([dataForDisplay count]>0) 
    {
        [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        NSLog(@"the list mode is setting the position");
    }*/
    
}

- (void) setEditMode
{
    currMode = @"U";
    [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (void) executeCancel
{
    currMode = @"L";
    //NSLog(@"currentindex path info is %@", curIndPath);
    [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[dataForDisplay objectAtIndex:curIndPath.row] forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];*/
    if (_currControllerIndex==0) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[dataForDisplay objectAtIndex:curIndPath.row] forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
        /*[dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];   */
    }
    viewItemNo = curIndPath.row;
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    if (p_savedInfo) 
    {
        if ([currMode isEqualToString:@"I"]) 
        {
            if (_currControllerIndex==0) 
            {
                NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                [dataForDisplay insertObject:p_savedInfo atIndex:0];
                //[dataForDisplay addObject:p_savedInfo];
                if ([dataForDisplay count]==0) 
                    [stdDefaults setValue:nil forKey:_cacheName];
                else
                    [stdDefaults setValue:dataForDisplay forKey:_cacheName];
                //[dispTV reloadData];
                curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [dispTV reloadData];
                [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
            else
            {
                [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];        
            }
        }
        if ([currMode isEqualToString:@"U"]) 
        {
            if (_currControllerIndex==0) 
            {
                NSArray *updateInfo = [[NSArray alloc] initWithObjects:curIndPath, nil];
                [dataForDisplay replaceObjectAtIndex:viewItemNo withObject:p_savedInfo];
                NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                if ([dataForDisplay count]==0) 
                    [stdDefaults setValue:nil forKey:_cacheName];
                else
                    [stdDefaults setValue:dataForDisplay forKey:_cacheName];
                [dispTV reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
            }
            [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    currMode = @"L";
}

@end
