//
//  posBill.h
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "posFunctions.h"

@interface posBill : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate, posFunctions>
{
    UIInterfaceOrientation currOrientation;
    IBOutlet UITableView *posTranView;
}

@property (strong, nonatomic) UIPopoverController *itemNavigatorPop;
@property (nonatomic, retain) UITableView *posTranView;

- (void) initialize;
- (IBAction) entryButtonsPressed :(id)sender;
- (IBAction) actionButtonPressed:(id)sender;
- (IBAction) confirmButtonPressed :(id)sender;

@end
