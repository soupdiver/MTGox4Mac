//
//  mtgonxClientAppDelegate.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/10/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "mtgonxClientAppDelegate.h"

@implementation mtgonxClientAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
}
-(void)awakeFromNib
{
	[username setStringValue:@"viech0r"];
	[password setStringValue:@"obacht"];
}

@end
