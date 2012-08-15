//
//  posFunctions.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol posFunctions <NSObject>

@optional
- (void) initialize;
- (IBAction) ButtonPressed:(id)sender;
- (IBAction) entryButtonsPressed :(id)sender;
- (IBAction) actionButtonPressed:(id)sender;
- (IBAction) confirmButtonPressed :(id)sender;
- (void) generateTableView;
- (id) getButtonForNavigation:(NSString*) p_btnTask;
- (void) setButtonsForDiffMode;
- (void) posItemSelectedInSearch:(NSDictionary*) p_itemDict;

@end
