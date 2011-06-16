//
//  Controller.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/10/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "Controller.h"

@implementation Controller

-(id)init
{
	[super init];
    
    //initiaiting the controller
	gonx = [[MTGONXController alloc] init];
	[gonx setDelegate:self];
	refreshPrices = FALSE;
    isLoggedIn = FALSE;
	
	return self;
}
-(CGPoint)PointForCenterOriginWithFrameSize:(NSSize)size
{
    CGPoint result;
    result.x = [[NSScreen mainScreen]frame].size.width / 2 - (size.width / 2);
    result.y = [[NSScreen mainScreen]frame].size.height / 2 - (size.height / 2);
    
    return result;
}
-(void)awakeFromNib
{
    NSRect frame = [loginView frame];
    frame.origin = [self PointForCenterOriginWithFrameSize:frame.size];
    
    [mainWindow setFrame:frame display:TRUE animate:TRUE];
    [mainWindow setContentView:loginView];
    
    [loginUsername setStringValue:@"viech0r"];
    [loginPassword setStringValue:@"$l!pKn0t"];
}

-(IBAction)loginButtonPressed:(id)sender
{
    [gonx startGettingBalance:[loginUsername stringValue] andPassword:[loginPassword stringValue]]; //is used for checking logindata
}

-(void)gonxController:(MTGONXController *)sender ReceivedPrices:(NSDictionary *)prices{
	[sell setStringValue:[prices objectForKey:@"sell"]];
	[buy setStringValue:[prices objectForKey:@"buy"]];
    NSLog(@"%@", [NSCalendarDate date]);
	
	if(refreshPrices)
	{
		sleep(3);
		[gonx startGettingPrices];
	}
}
-(void)gonxController:(MTGONXController *)sender ReceivedBalance:(NSDictionary *)balances
{
	[balanceUSD setStringValue:[balances objectForKey:@"usds"]];
	[balanceBTC	setStringValue:[balances objectForKey:@"btcs"]];
    
    if(!isLoggedIn) //check for login process
    {
        [mainView setFrameOrigin:[mainWindow frame].origin];
        
        NSRect frame= [mainView frame];
        frame.origin = [self PointForCenterOriginWithFrameSize:frame.size];
        
        [mainWindow setFrame:frame display:TRUE animate:TRUE];
        [mainWindow setContentView:mainView];
        
        isLoggedIn = TRUE;
    }
    
}
-(void)gonxController:(MTGONXController *)sender ReceivedOpenOrders:(NSArray *)orders
{
	openOrders = [orders copy];
	[openOrdersTable reloadData];
}
-(IBAction)getBalance:(id)sender
{
	[gonx startGettingBalance:[loginUsername stringValue] andPassword:[loginPassword stringValue]];
}
-(IBAction)getPrices:(id)sender
{
	if(refreshPrices)
	{
		[sender setTitle:@"Get Prices"];
		refreshPrices = FALSE;
	}
	else {
		refreshPrices = TRUE;
		[sender setTitle:@"Stop refreshing"];
		[gonx startGettingPrices];
	}
}
-(IBAction)getOpenOrders:(id)sender
{
	[gonx startGettingOpenOrders:[loginUsername stringValue] andPassword:[loginPassword stringValue]];
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [openOrders count];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	id record, value;
	record = [openOrders objectAtIndex:row];
	value = [record objectForKey:[tableColumn identifier]];
	
	NSString *column = [[tableColumn identifier] description];
    
    //replacing api codes with readable strings
	if([column isEqual:@"type"])
	{
		if ([[value description] intValue] == 1) {
			return @"sell";
		}
		else {
			return @"buy";
		}
	}
	
	if([column isEqual:@"status"])
	{
		if ([[value description] intValue] == 1) {
			return @"active";
		}
		else {
			return @"Not enough founds";
		}
	}
			   
	return value;
}
-(void)gonxControllerPlacedAnOrder:(MTGONXController *)sender
{
    //refreshing the gui values
	[self getOpenOrders:self];
	[self getBalance:self];
}
-(void)gonxControllerStoppedGettingPrices:(MTGONXController *)sender
{
	[refreshButton setTitle:@"Get Prices"];
	[refreshButton display];
	refreshPrices = FALSE;
}
-(void)gonxControllerCouldNotLogin:(MTGONXController *)sender
{
    //chaning colos of username/password box to red if login fails
    [loginUsername setBackgroundColor: [NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [loginPassword setBackgroundColor: [NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
}
-(IBAction)buyButtonPressed:(id)sender
{
	[gonx startPlacingOrderWithUsername:[loginUsername stringValue] 
				andPassword:[loginPassword stringValue]
				  andAmount:[amount stringValue]
					andType:@"buy"
				   andPrice:[price stringValue]];
}
-(IBAction)sellButtonPressed:(id)sender
{
	[gonx startPlacingOrderWithUsername:[loginUsername stringValue] 
				andPassword:[loginPassword stringValue]
				  andAmount:[amount stringValue]
					andType:@"sell"
				   andPrice:[price stringValue]];
}
@end
