//
//  PreferencesController.h
//  mtgonxClient
//
//  Created by Felix Gläske on 6/17/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const RefreshtimeKey;
extern NSString * const UsernameKey;
extern NSString * const PasswordKey;

@interface PreferencesController : NSWindowController {
@private
    IBOutlet NSTextField *refreshTime;
}

-(IBAction)preferencesSaved:(id)sender;

-(NSNumber*)getRefreshtime;

@end
