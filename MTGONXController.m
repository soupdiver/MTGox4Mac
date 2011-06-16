//
//  MTGONXController.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/11/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "MTGONXController.h"
#import "SBJson.h"

@implementation MTGONXController
@synthesize delegate;

-(void) startGettingBalance:(NSString *)username andPassword:(NSString *)password
{
	NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
	[userData setObject:username forKey:@"username"];
	[userData setObject:password forKey:@"password"];
	
	[self performSelectorInBackground:@selector(getBalance:) withObject:userData];
}
-(void)startGettingPrices
{
	[self performSelectorInBackground:@selector(getPrices) withObject:nil];
}
-(void)startGettingOpenOrders:(NSString *)username andPassword:(NSString *)password
{
	NSMutableDictionary *userData = [[NSMutableDictionary alloc]init];
	[userData setObject:username forKey:@"username"];
	[userData setObject:password forKey:@"password"];
	
	[self performSelectorInBackground:@selector(getOpenOrders:) withObject:userData];
}
-(NSDictionary*)sendRequest:(NSString *)url_ withBodyString:(NSString *)bodyString
{
	NSURL *url = [ NSURL URLWithString: url_];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	if (bodyString != nil) {
		NSString *type = [NSString stringWithString:@"application/x-www-form-urlencoded"];
		NSData *body = [NSData dataWithData:[bodyString dataUsingEncoding:2]];
		[request addValue:type forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:body];
		[request setHTTPMethod:@"POST"];
	}
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
	NSString *data = [[NSString alloc] initWithData:response 
										   encoding:NSUTF8StringEncoding];

    return [data JSONValue];
}
-(void)getOpenOrders:(NSMutableDictionary*)userData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSString *url = @"https://mtgox.com/code/getOrders.php";
	NSString *bodyString = [NSString stringWithFormat:@"name=%@&pass=%@", [userData objectForKey:@"username"], [userData objectForKey:@"password"]];
	
	NSDictionary* result = [self sendRequest:url withBodyString:bodyString];
	
	if (result == nil) {
        NSLog(@"Error while getting OpenOrders");
		return;
	}
	
	NSArray *orders = [result objectForKey:@"orders"];
	
	if(delegate && [delegate respondsToSelector:@selector(gonxController:ReceivedOpenOrders:)]) {
		[delegate gonxController:self ReceivedOpenOrders: orders];
	}
	
	[pool drain];
}
-(void)getPrices
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	//getting the actual sell and bid values
	NSString *url = @"https://mtgox.com/code/data/ticker.php";
	
	
	NSDictionary* result = [self sendRequest:url withBodyString:nil];
	
	if (result == nil) {
        NSLog(@"Stopped getting Prices");
		if(delegate && [delegate respondsToSelector:@selector(gonxControllerStoppedGettingPrices:)])
		{
			[delegate gonxControllerStoppedGettingPrices:self];
		}
		return;
	}
	
	result = [result objectForKey:@"ticker"];
	if (delegate && [delegate respondsToSelector:@selector(gonxController:ReceivedPrices:)]) {
		[delegate gonxController:self ReceivedPrices:result];
	}
		
	[pool drain];
}
-(void)getBalance:(NSMutableDictionary *)userData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSString *url = @"https://mtgox.com/code/getFunds.php";
	NSString *bodyString = [NSString stringWithFormat:@"name=%@&pass=%@", [userData objectForKey:@"username"], [userData objectForKey:@"password"]];
	
	NSDictionary* result = [self sendRequest:url withBodyString:bodyString];
	
	if (result == nil) {
        NSLog(@"Error while getting Balance");
		return;
	}
	
    NSLog(@"%@", result);
	
    //check if logn was correct
    NSString *error = [result objectForKey:@"error"];
    if (error != nil) {
        NSLog(@"Login was incorrect!");
        if(delegate && [delegate respondsToSelector:@selector(gonxControllerCouldNotLogin:)]) {
            [delegate gonxControllerCouldNotLogin:self];
        }
    }
    else {
        if(delegate && [delegate respondsToSelector:@selector(gonxController:ReceivedBalance:)]) {
            [delegate gonxController:self ReceivedBalance: result];
        }
    }
    
	[pool drain];
}
-(void)startPlacingOrderWithUsername:(NSString *)username andPassword:(NSString *)password andAmount:(NSString *)amount andType:(NSString *)type andPrice:(NSString*)price
{
	NSMutableDictionary	*data = [[NSMutableDictionary alloc] init];
	
	[data setObject:username forKey:@"username"];
	[data setObject:password forKey:@"password"];
	[data setObject:amount forKey:@"amount"];
	[data setObject:type forKey:@"type"];
	[data setObject:price forKey:@"price"];
	
	[self performSelectorInBackground:@selector(placeOrder:) withObject:data];
}
-(void)placeOrder:(NSDictionary *)data
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSString *url = [NSString stringWithFormat:@"https://mtgox.com/code/%@BTC.php", [data objectForKey:@"type"]];
	NSString *bodyString = [NSString stringWithFormat:@"name=%@&pass=%@&amount=%@&price=%@", [data objectForKey:@"username"], [data objectForKey:@"password"], [data objectForKey:@"amount"], [data objectForKey:@"price"]];

	NSDictionary* result = [self sendRequest:url withBodyString:bodyString];
	
	if (result == nil) {
        NSLog(@"Error while Placing Order");
		return;
	}	
	
	if(delegate && [delegate respondsToSelector:@selector(gonxControllerPlacedAnOrder:)])
	{
		[delegate gonxControllerPlacedAnOrder:self];
	}
	
	[pool drain];
}
@end
