//
//  posWSProxy.m
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "posWSProxy.h"

@implementation posWSProxy

- (id) initWithReportType:(NSString*) resultType andInputParams:(NSDictionary*) prmDict andResponseMethod:(METHODCALLBACK) p_methodCallback
{
    self = [super init];
    if (self) {
        _resultType = [[NSString alloc] initWithFormat:@"%@", resultType];
        _postProxyResult = p_methodCallback;
        if (prmDict) 
            inputParms = [[NSDictionary alloc] initWithDictionary:prmDict];
        dictData = [[NSMutableArray alloc] init];
        _returnInputsAlso = NO;
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        if ([stdDefaults valueForKey:@"LOCATIONSERVER"]) 
            MAIN_URL = [[NSString alloc] initWithFormat:@"http://%@/", [stdDefaults valueForKey:@"LOCATIONSERVER"]];
        else
            MAIN_URL = [[NSString alloc] initWithFormat:@"%@", HO_URL];
        [self generateData];
    }
    return self;    
}


- (void) generateData
{
    NSString *soapMessage,*msgLength,*soapAction;
    NSURL *url;
    NSMutableURLRequest *theRequest;
    NSURLConnection *theConnection;

    if ([_resultType isEqualToString:@"RECALLHOLDDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymGetPosBillData_pos xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_billid>%@</p_billid>\n"
                       "</gymGetPosBillData_pos>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"BILLID"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,RECALLHOLDDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/gymGetPosBillData_pos"];
    }
    
    if ([_resultType isEqualToString:@"HOLDBILLSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymGetPosHoldBills_pos xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_locationid>%@</p_locationid>\n"
                       "</gymGetPosHoldBills_pos>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"p_locationid"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,HOLDBILLSLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/gymGetPosHoldBills_pos"];
    }

    if ([_resultType isEqualToString:@"ADDUPDATECATEGORY"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateItemCategory_pos xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_categoryid>%@</p_categoryid>\n"
                       "<p_catcode>%@</p_catcode>\n"
                       "<p_catname>%@</p_catname>\n"
                       "</addUpdateItemCategory_pos>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_categoryid"], [inputParms valueForKey:@"p_catcode"], [inputParms valueForKey:@"p_catname"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,CATEGORYADDUPDATE_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/addUpdateItemCategory_pos"];
    }
    
    if ([_resultType isEqualToString:@"POSITEMDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymGetItemData_pos xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_positemid>%@</p_positemid>\n"
                       "</gymGetItemData_pos>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"POSITEMID"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,POSITEMDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/gymGetItemData_pos"];
    }

    if ([_resultType isEqualToString:@"POSCATEGORIESLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymGetPosCategories_pos xmlns=\"http://com.aahg.pos/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,POSCATEGORIESLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/gymGetPosCategories_pos"];
    }

    if ([_resultType isEqualToString:@"ADDPOSDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdatePOSBill xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_posdata>%@</p_posdata>\n"
                       "</addUpdatePOSBill>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_posdata"]];
        _returnInputsAlso = YES;
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,POSDATAADD_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/addUpdatePOSBill"];
    }
    
    if ([_resultType isEqualToString:@"MEMBERBARCODECHECK"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getMemberDataForPOS xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_memberbarcode>%@</p_memberbarcode>\n"
                       "</getMemberDataForPOS>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberbarcode"]];
        _returnInputsAlso = YES;
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERBARCODECHECK_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/getMemberDataForPOS"];
    }
    
    if ([_resultType isEqualToString:@"ADDUPDATEPOSITEM"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymAddUpdateItem_pos xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_itemdata>%@</p_itemdata>\n"
                       "</gymAddUpdateItem_pos>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_itemdata"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,ITEMADDUPDATE_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/gymAddUpdateItem_pos"];
    }

    if ([_resultType isEqualToString:@"POSITEMSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymGetPosItems_pos xmlns=\"http://com.aahg.pos/\">\n"
                       "<p_locationid>%@</p_locationid>\n"
                       "<p_searchtext>%@</p_searchtext>\n"
                       "</gymGetPosItems_pos>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"p_locationid"] , [inputParms valueForKey:@"p_searchtext"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,POSITEMSLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.pos/gymGetPosItems_pos"];
    }

    
    if ([_resultType isEqualToString:@"LOCATIONSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<LocationsData xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HO_URL,WS_ENV,LOCATIONS_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/LocationsData"];
    }
    
    if ([_resultType isEqualToString:@"USERLOGIN"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<userLogin xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_usercode>%@</p_usercode>\n"
                       "<p_passWord>%@</p_passWord>\n"
                       "</userLogin>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"p_eMail"],[inputParms valueForKey:@"p_passWord"]];     
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HO_URL, WS_ENV, LOGIN_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/userLogin"];
    }
    
    
    theRequest = [NSMutableURLRequest requestWithURL:url];
    msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
        webData = [[NSMutableData alloc] init];
    else 
        NSLog(@"theConnection is NULL");

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self processAndReturnXMLMessage];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errmsg = [error description];
    [self showAlertMessage:errmsg];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict   
{
    [parseElement setString:elementName];
    if ([elementName isEqualToString:@"Table"]) {
        resultDataStruct = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([parseElement isEqualToString:@""]==NO) 
        [resultDataStruct setValue:string forKey:parseElement];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [parseElement setString:@""];
    if ([elementName isEqualToString:@"Table"]) 
    {
        if (resultDataStruct) 
            [dictData addObject:resultDataStruct];
        
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) processAndReturnXMLMessage
{
    parseElement = [[NSMutableString alloc] initWithString:@""];	
	NSString *theXML = [self htmlEntityDecode:[[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding]];
    //NSLog(@"the data received %@",theXML);
    if (theXML) {
        if ([theXML isEqualToString:@""]==YES) 
            [self showAlertMessage:@"Web service failure"];
    }
    else
    {
        [self showAlertMessage:@"Web service failure"];
        return;
    }
    /*xmlParser = [[NSXMLParser alloc] initWithData:webData];*/
    @try 
    {
        xmlParser = [[NSXMLParser alloc] initWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        [xmlParser parse];
    }
    @catch (NSException *exception) {
        [self showAlertMessage:[exception description]];
        return;
    }
    
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:dictData forKey:@"data"];
    if (_returnInputsAlso) 
        [returnInfo setValue:inputParms forKey:@"inputparams"];
    //NSLog(@"the returned notification is %@", _notificationName);
    _postProxyResult(returnInfo);
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
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
