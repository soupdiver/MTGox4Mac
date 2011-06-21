//
//  Controller.h
//  mtgonxClient
//
//  Created by Felix Gläske on 6/10/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MTGONXController.h"
#import "SupportController.h"
#import "EMKeychainItem.h"

@class PreferencesController;

@interface Controller : NSObject <MTGONXDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    //stuff for loginView
    IBOutlet NSView *loginView;
    IBOutlet NSButton *loginButton;
    IBOutlet NSTextField *loginUsername;
    IBOutlet NSTextField *loginPassword;
    IBOutlet NSButton *rememberCheckbox;
    
    //stuff for the main view
    IBOutlet NSView *mainView;
    IBOutlet NSTextField *sell;
	IBOutlet NSTextField *buy;
	IBOutlet NSTextField *balanceUSD;
	IBOutlet NSTextField *balanceBTC;
	IBOutlet NSButton *refreshButton;
    IBOutlet NSButton *cancelButton;
	IBOutlet NSTableView *openOrdersTable;
	IBOutlet NSTextField *amount;
	IBOutlet NSTextField *price;
    
    IBOutlet NSWindow *mainWindow;
    
    //app state variables
	MTGONXController *gonx;
	NSArray *openOrders;
	bool refreshPrices;
    bool isLoggedIn;
    PreferencesController *preferenceController;
    SupportController *supportController;
}

+(void)initialize;

-(NSPoint)PointForCenterOriginWithFrameSize:(NSSize) size;
-(void)saveUsernameToKeyChain:(NSString*)username 
                  andPassword:(NSString*)password;
-(NSString*)userpasswordFromKeychainWithUsername:(NSString*)username;
-(void)removeUserdatafromKeychainWithUsername:(NSString*)username;

-(IBAction)showPreferencesWindow:(id)sender;
-(IBAction)showSupportWindow:(id)sender;

-(IBAction)getPrices:(id)sender;
-(IBAction)getBalance:(id)sender;
-(IBAction)getOpenOrders:(id)sender;
-(IBAction)buyButtonPressed:(id)sender;
-(IBAction)sellButtonPressed:(id)sender;
-(IBAction)cancelOrder:(id)sender;

-(IBAction)loginButtonPressed:(id)sender;

@end
