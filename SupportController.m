//
//  SupportController.m
//  mtgonxClient
//
//  Created by Felix Gläske on 6/20/11.
//  Copyright 2011 PsyCoding. All rights reserved.
//

#import "SupportController.h"


@implementation SupportController

-(id)init
{
    if (![super initWithWindowNibName:@"SupportUs"]) return nil;
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)gotoGitHub:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/soupdiver/MTGox4Mac"]];
}

-(IBAction)copyAddress:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pb setString:@"18DmVtPiygrPXdnFMFin7XT6eLseqifeoT" forType:NSStringPboardType];
}

@end
