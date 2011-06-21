//
//  Controller.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/10/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "Controller.h"
#import "PreferencesController.h"
#import "EMKeychainItem.h"

@implementation Controller

NSString * const KEYCHAIN_SERVICE_NAME = @"MtGox4Mac";

+(void)initialize
{
    //setting the standard UserValues
    NSMutableDictionary *defaultValues = [[NSMutableDictionary alloc] init];
    [defaultValues setObject:[NSNumber numberWithInt:3] forKey:RefreshtimeKey];
    [defaultValues setObject:@"" forKey:UsernameKey];
    [defaultValues setObject:@"" forKey:PasswordKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

-(id)init
{
	[super init];
    
    //initiaiting the controller
    [openOrdersTable setDelegate:self];
	gonx = [[MTGONXController alloc] init];
	[gonx setDelegate:self];
	refreshPrices = FALSE;
    isLoggedIn = FALSE;
	
	return self;
}

-(NSPoint)PointForCenterOriginWithFrameSize:(NSSize)size
{
    NSPoint result;
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
    
    [loginUsername setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey]];
    
    [loginPassword setStringValue:[self userpasswordFromKeychainWithUsername:[loginUsername stringValue]]];
}

-(IBAction)showPreferencesWindow:(id)sender
{
    if(preferenceController == nil)
    {
        preferenceController = [[PreferencesController alloc] init];
    }
    
    [preferenceController showWindow:self];
}

-(IBAction)showSupportWindow:(id)sender
{
    if(supportController == nil)
    {
        supportController = [[SupportController alloc] init];
    }
    
    [supportController showWindow:self];
}

-(IBAction)loginButtonPressed:(id)sender
{
    //check if data should be remembered
    if ([rememberCheckbox state] == NSOnState) {
        [self saveUsernameToKeyChain:[loginUsername stringValue] andPassword:[loginPassword stringValue]];
        [[NSUserDefaults standardUserDefaults]setObject:[loginUsername stringValue] forKey:UsernameKey];
    }
    else {
        [self removeUserdatafromKeychainWithUsername:[loginUsername stringValue]];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:UsernameKey];
    }
    [gonx startGettingBalanceWithUsername:[loginUsername stringValue] andPassword:[loginPassword stringValue]]; //is used for checking logindata
}

-(void)gonxController:(MTGONXController *)sender ReceivedPrices:(NSDictionary *)prices{
	[sell setStringValue:[prices objectForKey:@"sell"]];
	[buy setStringValue:[prices objectForKey:@"buy"]];
	
	if(refreshPrices)
	{
		sleep([[NSUserDefaults standardUserDefaults] integerForKey:RefreshtimeKey]);
		[gonx startGettingPrices];
	}
}

-(void)gonxController:(MTGONXController *)sender ReceivedBalance:(NSDictionary *)balances
{
	[balanceUSD setStringValue:[balances objectForKey:@"usds"]];
	[balanceBTC	setStringValue:[balances objectForKey:@"btcs"]];
    
    if(!isLoggedIn) //check for login process
    {
        //getting current open orders
        [gonx   startGettingOpenOrders:[loginUsername stringValue] andPassword:[loginPassword stringValue]];
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
	[gonx startGettingBalanceWithUsername:[loginUsername stringValue] andPassword:[loginPassword stringValue]];
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

-(void)gonxControllerCanceledOrder:(MTGONXController *)sender
{
    [gonx startGettingOpenOrders:[loginUsername stringValue] andPassword:[loginPassword stringValue]];
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

-(IBAction)cancelOrder:(id)sender
{
    id identifier = @"oid";
    NSNumber *orderId = [self tableView:openOrdersTable objectValueForTableColumn:[openOrdersTable tableColumnWithIdentifier:identifier] row:[openOrdersTable selectedRow]];
    identifier = @"type";
    NSString *orderTypeString = [self tableView:openOrdersTable objectValueForTableColumn:[openOrdersTable tableColumnWithIdentifier:identifier] row:[openOrdersTable selectedRow]];
    
    NSNumber *orderType;
    
    if([orderTypeString isEqualToString:@"buy"])
    {
        orderType = [NSNumber numberWithInt:2];
    }
    else
    {
        orderType = [NSNumber numberWithInt:1];
    }
         
    
    [gonx startCancelingOrderWithUsername:[loginUsername stringValue] 
                              andPassword:[loginPassword stringValue] 
                               andOrderId:orderId 
                             andOrderType:orderType];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if([openOrdersTable selectedRow] != -1)
    {
        [cancelButton setEnabled:TRUE];
    }
    else
    {
        [cancelButton setEnabled:FALSE];
    }
}

-(void)saveUsernameToKeyChain:(NSString *)username andPassword:(NSString *)password
{
    EMKeychainItem *item = [EMGenericKeychainItem genericKeychainItemForService:KEYCHAIN_SERVICE_NAME withUsername:username];
    //item does not exist.. so create
    if(!item)
    {
        [EMGenericKeychainItem addGenericKeychainItemForService:KEYCHAIN_SERVICE_NAME withUsername:username password:password];
    }
    else
    {
        item.password = password;
        item.username = username;
    }
}

-(void)removeUserdatafromKeychainWithUsername:(NSString *)username
{
    EMKeychainItem *item = [EMGenericKeychainItem genericKeychainItemForService:KEYCHAIN_SERVICE_NAME withUsername:username];
    if(item)
    {
        item.username = @"";
        item.password = @"";
    }
}

-(NSString*)userpasswordFromKeychainWithUsername:(NSString *)username
{
    EMKeychainItem *item = [EMGenericKeychainItem genericKeychainItemForService:KEYCHAIN_SERVICE_NAME withUsername:username];
    if(item)
    {
        return item.password;
    }
    NSLog(@"No Keychain item with this username");
    return @"";
}

@end
