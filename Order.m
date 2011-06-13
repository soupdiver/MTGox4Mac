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

-(void)initWithNumber:(NSNumber*)aNumber
	   andPrice:(NSNumber*)aPrice
		andAmount:(NSNumber*)anAmount
		  andType:(NSNumber*)aType
		andStatus:(NSNumber*)aStatus;
{
	self.amount = anAmount;
	self.type = aType;
	self.status = aStatus;
	self.number = aNumber;
	self.price = aPrice;
}
@end
