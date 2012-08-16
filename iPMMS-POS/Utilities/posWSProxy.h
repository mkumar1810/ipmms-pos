//
//  posWSProxy.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface posWSProxy :NSObject <NSXMLParserDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSString *_resultType;
	NSMutableData *webData;
    NSXMLParser *xmlParser; 
	NSMutableString *parseElement,*value;
    NSMutableString *respcode, *respmessage;
    NSMutableDictionary *resultDataStruct;
    NSMutableArray *dictData;
    NSString *_notificationName;
    NSDictionary *inputParms;
    BOOL _returnInputsAlso;
}

- (id) initWithReportType:(NSString*) resultType andInputParams:(NSDictionary*) prmDict andNotificatioName:(NSString*) notificationName;
- (void) generateData;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) processAndReturnXMLMessage;
- (NSString *)htmlEntityDecode:(NSString *)string;
- (NSString *)htmlEntitycode:(NSString *)string;

@end
