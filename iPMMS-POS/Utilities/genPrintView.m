//
//  genPrintView.m
//  salesapi
//
//  Created by Imac on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "genPrintView.h"

@implementation genPrintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    CGRect frame;
    intOrientation = p_forOrientation;
    frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, 703, 768);
    [wv setFrame:CGRectMake(10, 54, 683, 660)];
    [actIndicator setFrame:CGRectMake(340, 360, 37, 37)];
    [[self viewWithTag:10001] setFrame:frame];
}

- (id) initWithIdValue:(NSString*) p_idvalue andOrientation:(UIInterfaceOrientation) p_intOrientation andFrame:(CGRect) dispFrame andReporttype:(NSString*) p_reporttype andIdFldName:(NSString*) p_idfldname andNotification:(NSString*) p_notificationname
{
    self = [super initWithFrame:dispFrame];
    if (self) {
        initialFrame = dispFrame;
        [self addNIBView:@"genPrintView" forFrame:dispFrame];
        _idValue = [[NSString alloc] initWithFormat:@"%@",p_idvalue];
        _reportType = [[NSString alloc] initWithFormat:@"%@",p_reporttype];
        _idFldName = [[NSString alloc] initWithFormat:@"%@", p_idfldname];
        _notificationName = [[NSString alloc] initWithFormat:@"%@", p_notificationname];
        //if ([_reportType isEqualToString:@"posbillpreview"]) [navTitle setTitle:@"POS Bill Preview"];
        intOrientation = p_intOrientation;
        actIndicator.hidden = NO;
        actIndicator.hidesWhenStopped = YES;
        [actIndicator startAnimating];
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        if ([stdDefaults valueForKey:@"LOCATIONSERVER"]) 
            MAIN_URL = [[NSString alloc] initWithFormat:@"http://%@/", [stdDefaults valueForKey:@"LOCATIONSERVER"]];
        else
            MAIN_URL = [[NSString alloc] initWithFormat:@"%@", HO_URL];
        [self generatePrintView];
    }
    return  self;
}

- (id) initWithDictionary:(NSDictionary*) p_inputParams andOrientation:(UIInterfaceOrientation) p_intOrientation andFrame:(CGRect) dispFrame andReporttype:(NSString*) p_reporttype  andNotification:(NSString*) p_notificationname
{
    self = [super initWithFrame:dispFrame];
    if (self) {
        initialFrame = dispFrame;
        [self addNIBView:@"genPrintView" forFrame:dispFrame];
        _reportType = [[NSString alloc] initWithFormat:@"%@",p_reporttype];
        _notificationName = [[NSString alloc] initWithFormat:@"%@", p_notificationname];
        if (p_inputParams) 
            inputParms = [[NSDictionary alloc] initWithDictionary:p_inputParams];
        //if ([_reportType isEqualToString:@"Accountpreview"]) [navTitle setTitle:@"Customer statement"];
        intOrientation = p_intOrientation;
        actIndicator.hidden = NO;
        actIndicator.hidesWhenStopped = YES;
        [actIndicator startAnimating];
        [self generatePrintView];
    }
    return  self;
}


- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName
                                                      owner:self
                                                    options:nil];
    UIView *newview = [nibViews objectAtIndex:0];
    [newview setFrame:forframe];
    newview.tag = 10001;
    [self addSubview:newview];        // Initialization code
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) generatePrintView
{
    NSString *pvURL; //[[NSString alloc]initWithFormat:@"%@%@%@reporttype=%@&%@=%@",MAIN_URL,WS_ENV,  @"/Reports/reportsGeneric.aspx?",_reportType, _idFldName, _colnId];
    if ([_reportType isEqualToString:@"posbillpreview"]==YES) 
    {
        pvURL=[[NSString alloc]initWithFormat:@"%@%@%@reporttype=%@&billid=%@",MAIN_URL,WS_ENV,  @"/Reports/reportsGeneric.aspx?",_reportType, _idValue];
    }
    //NSLog(@"the user URL is %@",pvURL);
    
    //pvURL = [NSString stringWithFormat:@"%@",@"http://194.170.6.30:81/reports/rwservlet?destype=cache&desformat=pdf&report=D:\\AASMIS\\Fin\\Reports\\Acr_DrCrstatemnt_Detailslpowise.rdf&userid=VG/VG@aasmis&paramform=NO&comp_code='API'&div_code='API'&YearCode=2012&todate='02/05/2012'&p_p1=0&p_p2=30&p_p3=31&p_p4=60&p_p5=61&p_p6=90&p_p7=91&sledtype='DR'&amtformat='FM999,999,990.00'&sessionid=1111&username='SYSTEM ADMINISTRATOR'&status=2&P_accountcode='11-02-01-100'&p_sledcode='A0185'&mdiv='API'&P_SALESMANCODE=0"];
    //NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:pvURL]];
    /*pvURL = (NSMutableString*)[pvURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pvURL]];
     NSLog(@"url string %@",pvURL);
     [[NSURLConnection alloc] initWithRequest:request delegate:self];
     webData = [[NSMutableData alloc] init];*/
    //NSLog(@"preview URL %@",pvURL);
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:pvURL]];
    [wv loadRequest:req];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [actIndicator stopAnimating];
    actIndicator.hidden=TRUE;
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSMutableString *jsonString=[[NSMutableString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    //NSLog(@"The received conrtent is is %@",jsonString);
    [wv loadData:webData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //actIndicator.hidden = NO;
    //[actIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [actIndicator stopAnimating];
    NSLog(@"report generation completed");
    actIndicator.hidden=YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"loading failed with error %@", error);
}

- (IBAction) goBack:(id) sender
{
    //[[NSNotifxicationCenter defaultCenter] postNotificationName:_notificationName object:self];
}

- (IBAction) printContents:(id) sender
{  
    UIBarButtonItem *printButton;
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler = 
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);	
        }
    };
    
    printButton = (UIBarButtonItem*) sender;
    
    // Obtain a printInfo so that we can set our printing defaults.
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    // This application produces General content that contains color.
    printInfo.outputType = UIPrintInfoOutputGeneral;
    
    // We'll use the URL as the job name
    printInfo.jobName = @"Collection Receipt Printing";
    if ([_reportType isEqualToString:@"Accountpreview"]==YES)
    {
        printInfo.jobName = @"Customer Statement";
        printInfo.orientation = UIPrintInfoOrientationLandscape;
    }
    // Set duplex so that it is available if the printer supports it. We
    // are performing portrait printing so we want to duplex along the long edge.
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // Use this printInfo for this print job.
    controller.printInfo = printInfo;
    
    
    // Be sure the page range controls are present for documents of > 1 page.
    controller.showsPageRange = YES;
    
    // This code uses a custom UIPrintPageRenderer so that it can draw a header and footer.
    genPrintRenderer *colnPrint = [[genPrintRenderer alloc] init];
    // The MyPrintPageRenderer class provides a jobtitle that it will label each page with.
    colnPrint.jobTitle = printInfo.jobName;
    // To draw the content of each page, a UIViewPrintFormatter is used.
    UIViewPrintFormatter *viewFormatter = [wv viewPrintFormatter];
    viewFormatter.startPage =0;
    
    
#if SIMPLE_LAYOUT
    /*
     For the simple layout we simply set the header and footer height to the height of the
     text box containing the text content, plus some padding.
     
     To do a layout that takes into account the paper size, we need to do that 
     at a point where we know that size. The numberOfPages method of the UIPrintPageRenderer 
     gets the paper size and can perform any calculations related to deciding header and
     footer size based on the paper size. We'll do that when we aren't doing the simple 
     layout.
     */
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT]; 
    CGSize titleSize = [colnPrint.jobTitle sizeWithFont:font];
    colnPrint.headerHeight = colnPrint.footerHeight = titleSize.height + HEADER_FOOTER_MARGIN_PADDING;
#endif
    [colnPrint addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // Set our custom renderer as the printPageRenderer for the print job.
    controller.printPageRenderer = colnPrint;
    
    // The method we use presenting the printing UI depends on the type of 
    // UI idiom that is currently executing. Once we invoke one of these methods
    // to present the printing UI, our application's direct involvement in printing
    // is complete. Our custom printPageRenderer will have its methods invoked at the
    // appropriate time by UIKit.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [controller presentFromBarButtonItem:printButton animated:YES completionHandler:completionHandler];  // iPad
    else
        [controller presentAnimated:YES completionHandler:completionHandler];  // iPhone
}

@end
