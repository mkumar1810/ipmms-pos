//
//  itemNavigator.m
//  iPMMS-POS
//
//  Created by Macintosh User on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "itemNavigator.h"

@implementation itemNavigator

@synthesize posBillTransaction = _billTransaction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Items", @"Items");
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
    currMode = [[NSString alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchItemNavigationReturn:) name:@"searchItemNavigationReturn" object:nil];   
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
    btnRefresh.tag = 0;
    self.navigationItem.leftBarButtonItem = btnRefresh;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerNotification:)  name:@"controllerNotify" object:nil];
    [self generateItemsList];    
}

- (void) searchItemNavigationReturn:(NSNotification *)itemInfo
{
    
}

- (void) generateItemsList
{
    CGRect myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    positemSelect = [[posItemSearch alloc] initWithFrame:myFrame forOrientation:currOrientation  andNotification:@"searchItemNavigationReturn" withNewDataNotification:@"posItemSearchGenerated_Main"];
    currMode = @"L";
    [self.view addSubview:positemSelect];
    [self setButtonsForDiffMode];
}

- (void) setButtonsForDiffMode
{
    if ([currMode isEqualToString:@"L"]) 
    {
        self.navigationItem.leftBarButtonItem = [self getButtonForNavigation:@"Refresh"];
        self.navigationItem.rightBarButtonItem = [self getButtonForNavigation:@"Insert"];
        self.navigationItem.title = @"Items";
    }

    if ([currMode isEqualToString:@"I"]) 
    {
        self.navigationItem.leftBarButtonItem = [self getButtonForNavigation:@"Save"];
        self.navigationItem.rightBarButtonItem = [self getButtonForNavigation:@"Cancel"];
        self.navigationItem.title = @"Add Item";
    }
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
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (id) getButtonForNavigation:(NSString*) p_btnTask
{
    UIBarButtonItem *retBtn;
    
    if ([p_btnTask isEqualToString:@"Insert"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 1;
    }
    else if ([p_btnTask isEqualToString:@"Edit"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 2;
    }
    else if ([p_btnTask isEqualToString:@"List"] | [p_btnTask isEqualToString:@"Refresh"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 0;
    }
    else if ([p_btnTask isEqualToString:@"Cancel"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 3;
    }
    else if ([p_btnTask isEqualToString:@"Save"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 4;
    }
    /*else if ([p_btnTask isEqualToString:@"Refresh"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 5;
    }*/
    else
        //if ([p_btnTask isEqualToString:@"Plan"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithTitle:p_btnTask style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        //retBtn.tag = 4;
    }
    
    return retBtn;
}

- (IBAction) ButtonPressed:(id)sender
{
    NSDictionary *notifyInfo;
    UIBarButtonItem *recdBtn = (UIBarButtonItem*) sender;
    switch (recdBtn.tag) {
        case 0: //refresh button pressed
            //notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
            currMode = @"L";
            [positemSelect refreshData:nil];
            break;
        case 1: // Add button clicked
            currMode = @"I";
            [positemSelect addNewItem];
            break;
        case 2:  // edit button clicked
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"data", nil];
            break;
        case 3:
            currMode = @"L";
            [positemSelect cancelItemUpdation];
            break;
        case 4:
            //notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save",@"data", nil];
            [positemSelect updateItem];
            break;
        case 5:
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Refresh",@"data", nil];
            break;
        default:
            break;
    }
    [self setButtonsForDiffMode];
}

- (void) controllerNotification:(NSNotification*) notifyInfo
{
    NSString *recdMode = [[notifyInfo userInfo] valueForKey:@"data"];
    
    if ([recdMode isEqualToString:@"List"]) 
    {
        currMode = @"L";
        [self setButtonsForDiffMode];
    }
}

@end
