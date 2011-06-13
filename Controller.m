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
	gonx = [[MTGONXController alloc] init];
	[gonx setDelegate:self];
	refreshPrices = FALSE;
	
	return self;
}

-(void)gonxController:(MTGONXController *)sender ReceivedPrices:(NSDictionary *)prices{
	[sell setStringValue:[prices objectForKey:@"sell"]];
	[buy setStringValue:[prices objectForKey:@"buy"]];
	
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
}
-(void)gonxController:(MTGONXController *)sender ReceivedOpenOrders:(NSArray *)orders
{
	openOrders = [orders copy];
	[openOrdersTable reloadData];
}
-(IBAction)getBalance:(id)sender
{
	[gonx startGettingBalance:[username stringValue] andPassword:[password stringValue]];
}
-(IBAction)getData:(id)sender
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
	[gonx startGettingOpenOrders:[username stringValue] andPassword:[password stringValue]];
}
-(int)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [openOrders count];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	id record, value;
	record = [openOrders objectAtIndex:row];
	value = [record objectForKey:[tableColumn identifier]];
	
	NSString *column = [[tableColumn identifier] description];
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
	[self getOpenOrders:self];
	[self getBalance:self];
}
-(void)gonxControllerStoppedGettingPrices:(MTGONXController *)sender
{
	[refreshButton setTitle:@"Get Prices"];
	[refreshButton display];
	refreshPrices = FALSE;
}
-(IBAction)buyButtonPressed:(id)sender
{
	[gonx startPlacingOrder:[username stringValue] 
				andPassword:[password stringValue]
				  andAmount:[amount stringValue]
					andType:@"buy"
				   andPrice:[price stringValue]];
}
-(IBAction)sellButtonPressed:(id)sender
{
	[gonx startPlacingOrder:[username stringValue] 
				andPassword:[password stringValue]
				  andAmount:[amount stringValue]
					andType:@"sell"
				   andPrice:[price stringValue]];
}
@end
