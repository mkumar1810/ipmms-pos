//
//  baseProtocol.h
//  salesapi
//
//  Created by Imac on 4/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol baseProtocol <NSObject>
@optional
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (IBAction) refreshData:(id) sender;
- (IBAction) addItemData:(id) sender;
- (IBAction) goBack:(id) sender;
- (void) generateTableView;
- (void) generateData;
- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe;
- (IBAction) previousButtonPressed:(id) sender;
- (IBAction) nextButtonPressed:(id) sender;
- (void) addPreviousNextButtons;
- (void) setViewBackGroundColor:(UIColor*) p_reqColor;

@end

