//
//  Controller.h
//  mtgonxClient
//
//  Created by Felix Gläske on 6/10/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MTGONXController.h"

@interface Controller : NSObject <MTGONXDelegate, NSTableViewDataSource> {
	IBOutlet NSTextField *sell;
	IBOutlet NSTextField *buy;
	IBOutlet NSTextField *balanceUSD;
	IBOutlet NSTextField *balanceBTC;
	IBOutlet NSTextField *username;
	IBOutlet NSTextField *password;
	IBOutlet NSButton *refreshButton;
	IBOutlet NSTableView *openOrdersTable;
	IBOutlet NSTextField *amount;
	IBOutlet NSTextField *price;
	MTGONXController *gonx;
	NSArray *openOrders;
	bool refreshPrices;
}
-(IBAction)getPrices:(id)sender;
-(IBAction)getBalance:(id)sender;
-(IBAction)getOpenOrders:(id)sender;
-(IBAction)buyButtonPressed:(id)sender;
-(IBAction)sellButtonPressed:(id)sender;

@end
