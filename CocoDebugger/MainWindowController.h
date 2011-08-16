//
//  MainWindowController.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DebugClient.h"
#import "VariablesViewController.h"
#import <PSMTabBarControl/PSMTabBarControl.h>

@interface MainWindowController : NSWindowController <DebugClientDelegate>
{
    IBOutlet NSTextView *fileView;
    IBOutlet PSMTabBarControl *tabBar;
    IBOutlet NSView *variablesView;
    VariablesViewController *variablesController;
    DebugClient *debug;
}
@end
