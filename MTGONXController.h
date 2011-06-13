//
//  MTGONXController.h
//  mtgonxClient
//
//  Created by Felix Gläske on 6/11/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Order.h"

@interface MTGONXController : NSObject {
	id delegate;
	NSArray *orders;
}
-(void)startGettingBalance:(NSString*)username
			   andPassword:(NSString*)password;
-(void)startGettingPrices;
-(void)startGettingOpenOrders:(NSString*)username
				  andPassword:(NSString*)password;
-(void)startPlacingOrder:(NSString*)username 
			 andPassword:(NSString*)password 
			   andAmount:(NSString*)amount  
				 andType:(NSString*)type
				andPrice:(NSString*)price;
-(void)getBalance:(NSDictionary*)userData;
-(void)getPrices;
-(void)placeOrder:(NSDictionary*)data;

@property (assign) id delegate;
@property (assign) NSArray *orders;

@end

@protocol MTGONXDelegate

-(void)gonxController:(MTGONXController*)sender 
	  ReceivedBalance:(NSDictionary*)balances;
-(void)gonxController:(MTGONXController *)sender 
	   ReceivedPrices:(NSDictionary *)prices;
-(void)gonxController:(MTGONXController*)sender
   ReceivedOpenOrders:(NSArray*)orders;
-(void)gonxControllerPlacedAnOrder:(MTGONXController*)sender;

@end