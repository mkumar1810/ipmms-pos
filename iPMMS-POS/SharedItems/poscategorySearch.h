//
//  poscategorySearch.h
//  iPMMS-POS
//
//  Created by Macintosh User on 22/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "categoryAddUpdate.h"
#import "posFunctions.h"

@interface poscategorySearch :baseSearchForm <UITableViewDataSource, UITableViewDelegate, posFunctions>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName ;
    categoryAddUpdate *catAddUpdate;
    NSIndexPath *curIndPath;    
    NSString *currMode;
    METHODCALLBACK _controllerCallBack;
    METHODCALLBACK _catSelectedCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andCatSelectCallback:(METHODCALLBACK) p_catSelectCallBack andControllerCallback:(METHODCALLBACK) p_controllerCallback;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) posItemsListDataGenerated:(NSDictionary *)generatedInfo;
- (void) addUpdateCategoryDone:(NSDictionary *)updateInfo;

@end
