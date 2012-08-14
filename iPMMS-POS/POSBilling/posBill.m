//
//  posBill.m
//  iPMMS-POS
//
//  Created by Macintosh User on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "posBill.h"

@implementation posBill

@synthesize itemNavigatorPop;
@synthesize posTranView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self initialize];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) initialize
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
    btnRefresh.tag = 0;
    self.navigationItem.leftBarButtonItem = btnRefresh;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerNotification:)  name:@"controllerNotify" object:nil];
    //[self generateItemsList];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Items", @"Items");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.itemNavigatorPop = popoverController;	
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.itemNavigatorPop = nil;
}

- (IBAction) entryButtonsPressed :(id)sender
{
    
}

- (IBAction) actionButtonPressed:(id)sender
{
    
}

- (IBAction) confirmButtonPressed :(id)sender
{
    
}

@end
