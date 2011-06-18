//
//  PreferencesController.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/17/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "PreferencesController.h"

NSString * const RefreshtimeKey = @"Refreshtime";
NSString * const UsernameKey = @"Username";
NSString * const PasswordKey = @"Password";

@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)windowDidLoad
{
    [super windowDidLoad];
    [refreshTime setIntValue:[[self getRefreshtime] intValue]];
}

- (id)init
{
    if (![super initWithWindowNibName:@"Preferences"]) return nil;
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)preferencesSaved:(id)sender
{
    //saving preferences to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[refreshTime intValue]] forKey:RefreshtimeKey];
}

-(NSNumber*)getRefreshtime
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:RefreshtimeKey];
}

@end
