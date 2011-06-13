//
//  mtgonxClientAppDelegate.h
//  mtgonxClient
//
//  Created by Felix Gläske on 6/10/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface mtgonxClientAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet NSTextField *username;
	IBOutlet NSTextField *password;
}

@property (assign) IBOutlet NSWindow *window;

@end
