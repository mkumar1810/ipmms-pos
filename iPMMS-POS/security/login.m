//
//  login.m
//  aahg
//
//  Created by Raja T S Sekhar on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "login.h"

@implementation login

static bool shouldScroll = true;

- (id) initWithFrame:(CGRect)frame andNotificationName:(NSString*) p_notifyName withOrientation:(UIInterfaceOrientation) p_intOrientation
{
    self = [self initWithFrame:frame];
    _notificationName = [[NSString alloc] initWithString:p_notifyName];
    intOrientationType = p_intOrientation;
    self.backgroundColor = [UIColor blackColor];
    //[Email setFrame:CGRectMake(Email.frame.origin.x, Email.frame.origin.y, Email.frame.size.width, 54)];
    [Email setBorderStyle:UITextBorderStyleRoundedRect];
    [actview stopAnimating];
    //Password.backgroundColor = Email.backgroundColor;
    //[Password setBorderStyle:UITextBorderStyleRoundedRect];
    return self;
}

- (id) initWithFrame:(CGRect)frame andNotificationMethod:(METHODCALLBACK) p_notifyMethod withOrientation:(UIInterfaceOrientation) p_intOrientation
{
    self = [self initWithFrame:frame];
    _postLoginResult = p_notifyMethod;
    intOrientationType = p_intOrientation;
    self.backgroundColor = [UIColor blackColor];
    //[Email setFrame:CGRectMake(Email.frame.origin.x, Email.frame.origin.y, Email.frame.size.width, 54)];
    [Email setBorderStyle:UITextBorderStyleRoundedRect];
    [actview stopAnimating];
    //Password.backgroundColor = Email.backgroundColor;
    //[Password setBorderStyle:UITextBorderStyleRoundedRect];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"login"
                                                          owner:self
                                                        options:nil];
    //self = [nibViews objectAtIndex:0];
    //[[nibViews objectAtIndex:0] setFrame:frame];
    [self addSubview:[nibViews objectAtIndex:0]];
    Email.text= @"ed";
    Password.text = @"1234";
    actview.hidesWhenStopped = TRUE;
    _notificationName = [[NSString alloc] initWithString:@"loginSuccessful"];
    actview.transform = CGAffineTransformMakeScale(5.00, 5.00);        
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 }
 
*/


- (void) setForOrientation:(UIInterfaceOrientation) orientationType
{
    if (UIInterfaceOrientationIsPortrait(orientationType)) 
    {
        intOrientationType = UIInterfaceOrientationPortrait;
        [mainImage setFrame:CGRectMake(255, 86, 257, 257)];
        [loginControl setFrame:CGRectMake(121, 382 , 500, 500)];
        [actview setFrame:CGRectMake(370, 300, 37, 37)];
        [btnLogin setFrame:CGRectMake(130, 272, 257, 257)];
    }
    else
    {
        intOrientationType = UIInterfaceOrientationLandscapeRight;
        [mainImage setFrame:CGRectMake(385, 30, 257, 257)];
        [loginControl setFrame:CGRectMake(250, 265 , 500, 500)];
        //[actview setFrame:CGRectMake(480, 200, 37, 37)];
        [actview setFrame:CGRectMake(498, 145, 37, 37)];
        [btnLogin setFrame:CGRectMake(130, 211, 257, 257)];
    }
}


-(IBAction)Login
{
    [actview startAnimating];
    NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%@",Email.text], @"p_eMail",[[NSString alloc] initWithFormat:@"%@",Password.text], @"p_passWord" , nil];
    //_wsProxy = [[posWSProxy alloc] initWithReportType:@"USERLOGIN" andInputParams:inputDict andNotificatioName:_notificationName];
    _wsProxy = [[posWSProxy alloc] initWithReportType:@"USERLOGIN" andInputParams:inputDict andResponseMethod:_postLoginResult];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


-(BOOL)validate
{
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    shouldScroll = true;
    [scrollView setContentOffset:scrollOffset animated:YES]; 
    if([textField isEqual:Email])
    {
        [Password becomeFirstResponder];
    }
    else if([textField isEqual:Password])
    {
        [textField resignFirstResponder];
        scrollOffset = scrollView.contentOffset;
        scrollOffset.y = 0;
        if (UIInterfaceOrientationIsPortrait(intOrientationType)==NO)
            [scrollView setContentOffset:scrollOffset animated:YES];  
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (shouldScroll) {
        scrollOffset = scrollView.contentOffset;
        CGPoint scrollPoint;
        CGRect inputFieldBounds = [textField bounds];
        inputFieldBounds = [textField convertRect:inputFieldBounds toView:scrollView];
        scrollPoint = inputFieldBounds.origin;
        scrollPoint.x = 0;
        if([textField isEqual:Email])
            scrollPoint.y = 60;
        else if([textField isEqual:Password])
            scrollPoint.y = 150;
        else
            scrollPoint.y=0;
        
        if (UIInterfaceOrientationIsPortrait(intOrientationType)==NO)
            [scrollView setContentOffset:scrollPoint animated:YES];  
        shouldScroll = false;
    }
}

- (BOOL) textFieldDidEndEditing:(UITextField *) textField {
    
    return YES;
}

- (void) resetValues
{
    [actview stopAnimating];
}

@end
