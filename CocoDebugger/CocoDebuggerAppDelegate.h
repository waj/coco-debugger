//
//  CocoDebuggerAppDelegate.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface CocoDebuggerAppDelegate : NSObject <NSApplicationDelegate> {
    MainWindowController *mainWindowController;
}

@end
