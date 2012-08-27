//
//  defaults.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define MAIN_URL @"http://194.170.6.30/"
#define MAIN_URL @"http://192.168.1.8/"
#define WS_ENV @"GYMWS"
#define M_PI        3.14159265358979323846264338327950288   /* pi */
#define M_PI_BY_2      1.57079632679489661923132169163975144   /* pi/2 */
#define M_PI_BY_4      0.785398163397448309615660845819875721  /* pi/4 */
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0
#define kTextFieldHeight		30.0
#define kToolbarHeight          48

#define LOGIN_URL @"/usersecurity.asmx?op=userLogin"
#define LOCATIONS_URL @"/memberlist.asmx?op=LocationsData"
#define POSITEMSLIST_URL @"/ipmms_pos.asmx?op=gymGetPosItems_pos"
#define ITEMADDUPDATE_URL @"/ipmms_pos.asmx?op=gymAddNewItem_pos"
#define MEMBERBARCODECHECK_URL @"/ipmms_pos.asmx?op=getMemberDataForPOS"
#define POSDATAADD_URL @"/ipmms_pos.asmx?op=addUpdatePOSBill"
#define POSCATEGORIESLIST_URL @"/ipmms_pos.asmx?op=gymGetPosCategories_pos"
#define POSITEMDATA_URL @"/ipmms_pos.asmx?op=gymGetItemData_pos"
#define CATEGORYADDUPDATE_URL @"/ipmms_pos.asmx?op=addUpdateItemCategory_pos"
#define HOLDBILLSLIST_URL @"/ipmms_pos.asmx?op=gymGetPosHoldBills_pos"
#define RECALLHOLDDATA_URL @"/ipmms_pos.asmx?op=gymGetPosBillData_pos"

#define ITEMMASTER_XML @"<MASTER><ITEMID>%@</ITEMID><ITEMCODE>%@</ITEMCODE><ITEMNAME>%@</ITEMNAME><ITEMPRICE>%@</ITEMPRICE><CATEGORYID>%d</CATEGORYID><LOCATIONID>%@</LOCATIONID></MASTER>"

#define ITEMDETAIL_XML @"<DETAIL><LOCATIONID>%d</LOCATIONID><LOCATIONPRICE>%@</LOCATIONPRICE><LOGGEDLOCATIONID>%@</LOGGEDLOCATIONID></DETAIL>"

#define POSMASTER_XML @"<MASTER><LOCATIONID>%@</LOCATIONID><TOTQTY>%@</TOTQTY><TOTAMOUNT>%@</TOTAMOUNT><BALANCE>%@</BALANCE><PREVBILLID>%@</PREVBILLID><STATUS>%@</STATUS><USERCODE>%@</USERCODE></MASTER>"

#define POSDETAIL_XML @"<DETAIL><TRANSTYPE>%@</TRANSTYPE><POSITEMID>%@</POSITEMID><DESCRIPTION>%@</DESCRIPTION><PRICE>%@</PRICE><QTY>%@</QTY><AMOUNT>%@</AMOUNT><TRANSSIGN>%@</TRANSSIGN></DETAIL>"

@protocol defaults <NSObject>

@end
