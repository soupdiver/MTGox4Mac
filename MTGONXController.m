//
//  MTGONXController.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/11/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "MTGONXController.h"
#import "JSON.h"

@implementation MTGONXController
@synthesize delegate;
@synthesize orders;

-(id)init
{
	orders = [[NSMutableArray alloc]init];
	
	return self;
}
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
-(void)getOpenOrders:(NSMutableDictionary*)userData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSURL *url = [ NSURL URLWithString: @"https://mtgox.com/code/getOrders.php"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSString *type = [NSString stringWithString:@"application/x-www-form-urlencoded"];
	NSString *bodyString = [NSString stringWithFormat:@"name=%@&pass=%@", [userData objectForKey:@"username"], [userData objectForKey:@"password"]];
	NSData *body = [NSData dataWithData:[bodyString dataUsingEncoding:1]];
	[request addValue:type forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *data = [[NSString alloc] initWithData:response 
										   encoding:NSUTF8StringEncoding];
	
	NSDictionary *result = [data JSONValue];
	NSArray *orders_ = [result objectForKey:@"orders"];
	orders = orders_;
	
	if(delegate && [delegate respondsToSelector:@selector(gonxController:ReceivedOpenOrders:)]) {
		[delegate gonxController:self ReceivedOpenOrders: orders_];
	}
	
	[pool drain];
}
-(void)getPrices
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//getting the actual sell and bid values
	NSURL *url = [ NSURL URLWithString: [ NSString stringWithFormat: @"https://mtgox.com/code/data/ticker.php"] ]; 
	NSString *test = [NSString stringWithContentsOfURL:url
											  encoding:1
												 error:NULL];
	
	NSDictionary *result;
	
	result = [test JSONValue];
	result = [result objectForKey:@"ticker"];
	if (delegate && [delegate respondsToSelector:@selector(gonxController:ReceivedPrices:)]) {
		[delegate gonxController:self ReceivedPrices:result];
	}
	
	[pool drain];
}
-(void)getBalance:(NSMutableDictionary *)userData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSURL *url = [ NSURL URLWithString: @"https://mtgox.com/code/getFunds.php"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSString *type = [NSString stringWithString:@"application/x-www-form-urlencoded"];
	NSString *bodyString = [NSString stringWithFormat:@"name=%@&pass=%@", [userData objectForKey:@"username"], [userData objectForKey:@"password"]];
	NSData *body = [NSData dataWithData:[bodyString dataUsingEncoding:1]];
	[request addValue:type forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *data = [[NSString alloc] initWithData:response 
										   encoding:NSUTF8StringEncoding];
	
	NSDictionary *result = [data JSONValue];
	
	if(delegate && [delegate respondsToSelector:@selector(gonxController:ReceivedBalance:)]) {
		[delegate gonxController:self ReceivedBalance: result];
	}
	
	[pool drain];
}
-(void)startPlacingOrder:(NSString *)username andPassword:(NSString *)password andAmount:(NSString *)amount andType:(NSString *)type andPrice:(NSString*)price
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
	
	NSURL *url = [ NSURL URLWithString: [NSString stringWithFormat: @"https://mtgox.com/code/%@BTC.php", [data objectForKey:@"type"]]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSString *type = [NSString stringWithString:@"application/x-www-form-urlencoded"];
	NSString *bodyString = [NSString stringWithFormat:@"name=%@&pass=%@&amount=%@&price=%@", [data objectForKey:@"username"], [data objectForKey:@"password"], [data objectForKey:@"amount"], [data objectForKey:@"price"]];
	NSData *body = [NSData dataWithData:[bodyString dataUsingEncoding:1]];
	[request addValue:type forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	if(delegate && [delegate respondsToSelector:@selector(gonxControllerPlacedAnOrder:)])
	{
		[delegate gonxControllerPlacedAnOrder:self];
	}
	
	[pool drain];
}
@end
