//
//  categoryAddUpdate.m
//  iPMMS-POS
//
//  Created by Macintosh User on 23/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "categoryAddUpdate.h"

@implementation categoryAddUpdate

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification 
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
        [self generateTableView];
    }
    return self;
}


- (void) generateTableView
{
    int ystartPoint;
    int sBarwidth;
    //return;
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
     [returnInfo setValue:[NSString stringWithString:@"BillCycleSelected"] forKey:@"notify"];
     [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
     [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];*/
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getSingleContentCell:indexPath.row];
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
        
        UILabel *lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 1, 50)];
        lblDivider.backgroundColor = [UIColor grayColor];
        lblDivider.text = @"";
        [cell.contentView addSubview:lblDivider];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(83, 0, cell.frame.size.width, 50)];
        txt1.borderStyle = UITextBorderStyleNone;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.font = cell.textLabel.font;
        txt1.delegate = self;
        txt1.text = @"";
        [cell.contentView addSubview:txt1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    switch (p_rowno) 
    {
        case 0:
            txtCatCode = (UITextField*) [cell.contentView viewWithTag:2];
            cell.textLabel.text = @"Cat. Code";
            break;
        case 1:
            txtCatName = (UITextField*) [cell.contentView viewWithTag:2];
            cell.textLabel.text = @"Cat. Name";
            break;
        default:
            break;
    }
    return cell;
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
    
    l_resultVal = [self emptyCheckResult:txtCatCode andMessage:@"Category code is invalid"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtCatName andMessage:@"Category name is invalid"];
    
    if (l_resultVal==NO) return l_resultVal;
    
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
    if([textField isEqual:txtCatCode])
        [txtCatName becomeFirstResponder];
    else if ([textField isEqual:txtCatName])
        [txtCatName resignFirstResponder];
    
    return NO;
}

- (NSDictionary*) getDictionaryToUpdate
{
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:txtCatCode.text, @"p_catcode", txtCatName.text , @"p_catname" , nil];
    return returnDict;
}

@end
