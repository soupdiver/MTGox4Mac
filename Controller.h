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
    //stuff for loginView
    IBOutlet NSView *loginView;
    IBOutlet NSButton *loginButton;
    IBOutlet NSTextField *loginUsername;
    IBOutlet NSTextField *loginPassword;
    
    //stuff for the main view
    IBOutlet NSView *mainView;
    IBOutlet NSTextField *sell;
	IBOutlet NSTextField *buy;
	IBOutlet NSTextField *balanceUSD;
	IBOutlet NSTextField *balanceBTC;
	IBOutlet NSButton *refreshButton;
	IBOutlet NSTableView *openOrdersTable;
	IBOutlet NSTextField *amount;
	IBOutlet NSTextField *price;
    IBOutlet NSTextField *priceUpdate;
    
    IBOutlet NSWindow *mainWindow;
    
    //app state variables
	MTGONXController *gonx;
	NSArray *openOrders;
	bool refreshPrices;
    bool isLoggedIn;
}
-(IBAction)getPrices:(id)sender;
-(IBAction)getBalance:(id)sender;
-(IBAction)getOpenOrders:(id)sender;
-(IBAction)buyButtonPressed:(id)sender;
-(IBAction)sellButtonPressed:(id)sender;

-(IBAction)loginButtonPressed:(id)sender;

@end
