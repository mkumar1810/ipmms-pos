//
//  itemNavigator.h
//  iPMMS-POS
//
//  Created by Macintosh User on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "posItemSearch.h"
#import "posFunctions.h"
#import "posBill.h"

@interface itemNavigator : UIViewController <posFunctions>
{
    posItemSearch *positemSelect;
    UIInterfaceOrientation currOrientation;
    NSString *currMode;
}

@property (strong, nonatomic) posBill *posBillTransaction;

- (void) generateItemsList;


@end
