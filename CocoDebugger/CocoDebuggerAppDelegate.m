//
//  CocoDebuggerAppDelegate.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "CocoDebuggerAppDelegate.h"

@implementation CocoDebuggerAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    mainWindowController = [MainWindowController new];
    [mainWindowController showWindow:self];
}

-(void)dealloc
{
    [mainWindowController release];
    [super dealloc];
}

@end
