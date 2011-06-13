//
//  Order.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/12/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "Order.h"


@implementation Order

@synthesize number;
@synthesize amount;
@synthesize price;
@synthesize status;
@synthesize type;

-(void)initWithNumber:(NSNumber*)number
	   andPrice:(NSNumber*)price
		andAmount:(NSNumber*)amount
		  andType:(NSNumber*)type
		andStatus:(NSNumber*)status;
{
	self.amount = amount;
	self.type = type;
	self.status = status;
	self.number = number;
	self.price = price;
}
@end
