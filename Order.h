//
//  Order.h
//  mtgonxClient
//
//  Created by Felix Gläske on 6/12/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Order : NSObject {
	NSNumber *number;
	NSNumber *amount;
	NSNumber *price;
	NSNumber *type;
	NSNumber *status;
}

@property (assign)NSNumber* number;
@property (assign)NSNumber* amount;
@property (assign)NSNumber* price;
@property (assign)NSNumber* type;
@property (assign)NSNumber* status;

@end
