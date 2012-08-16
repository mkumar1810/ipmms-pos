//
//  baseSearchForm.m
//  salesapi
//
//  Created by Imac on 4/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "baseSearchForm.h"


@implementation baseSearchForm

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
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
    if (sBar.hidden==YES) 
        ystartPoint = 90;
    else
        ystartPoint = 140;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        sBarwidth = 768;
        tvrect = CGRectMake(0, ystartPoint, 768, 768);
        [actIndicator setFrame:CGRectMake(365, 484, 37, 37)];
    }
    else
    {
        sBarwidth = 1028;
        tvrect = CGRectMake(0, ystartPoint, 1004, 500);
        [actIndicator setFrame:CGRectMake(515, 335, 37, 37)];
    }
    [sBar setFrame:CGRectMake(0, 45, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
    [self addSubview:dispTV];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [actIndicator stopAnimating];
}

- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName
                                                      owner:self
                                                    options:nil];
    UIView *newview = [nibViews objectAtIndex:0];
    [newview setFrame:forframe];
    newview.tag = 20001;
    [self addSubview:newview];        // Initialization code
    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);        
}

- (void) setViewBackGroundColor:(UIColor*) p_reqColor
{
    [navidataview setBackgroundColor:p_reqColor];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation
{
    CGRect frame;
    CGRect navidataframe;
    intOrientation = p_forOrientation;
    if (UIInterfaceOrientationIsPortrait(p_forOrientation)) 
    {
        frame = CGRectMake(0, 0, 768, 1004);
        navidataframe = CGRectMake(40, 88, 648, 40);
        //NSLog(@"portraint orientation is identified");
    }
    else
    {
        frame = CGRectMake(0, 0, 1028, 768);
        navidataframe = CGRectMake(170, 88, 648, 40);
        //NSLog(@"landscape orientation is identified");
    }
    [self setFrame:frame];
    //[navidataview setFrame:navidataframe];
    [self generateTableView];   
    [self addPreviousNextButtons];
}

- (IBAction) goBack:(id) sender
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
}



-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar’s cancel button while in edit mode
    sBar.showsCancelButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    sBar.showsCancelButton = NO;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [sBar resignFirstResponder];
    sBar.text = @" ";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    actIndicator.hidden=FALSE;
    [actIndicator startAnimating];
}

- (void) addPreviousNextButtons
{
    if (_navigationNeeded==NO) return;
    UIImage *leftbuttonImage = [UIImage imageNamed:@"previous.png"];
    UIImage *rightbuttonImage = [UIImage imageNamed:@"Next.png"];
    leftButton = (UIButton*) [[self viewWithTag:20001] viewWithTag:20002];
    if (!leftButton) {
        leftButton = [[UIButton alloc] initWithFrame:CGRectMake(60,10,30,30)];
        leftButton.titleLabel.text=@"Previous";
        leftButton.tag = 20002;
        [leftButton setImage:leftbuttonImage forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(previousButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [[self viewWithTag:20001] addSubview:leftButton];
    }
    
    rightButton = (UIButton*) [[self viewWithTag:20001] viewWithTag:20003];
    if (!rightButton) 
    {
        rightButton = [[UIButton alloc] init];
        if (UIInterfaceOrientationIsPortrait(intOrientation)==YES)
            [rightButton setFrame:CGRectMake(678,10,30,30)];
        else
            [rightButton setFrame:CGRectMake(938,10,30,30)];
        rightButton.titleLabel.text=@"Next";
        rightButton.tag = 20003;
        [rightButton setImage:rightbuttonImage forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [[self viewWithTag:20001] addSubview:rightButton];
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(intOrientation)==YES)
            [rightButton setFrame:CGRectMake(678,10,30,30)];
        else
            [rightButton setFrame:CGRectMake(938,10,30,30)];
    }
}

@end
