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
#import "CodeTabsController.h"

@interface MainWindowController : NSWindowController <DebugClientDelegate>
{
    IBOutlet NSView *variablesView;
    IBOutlet NSView *codeView;
    VariablesViewController *variablesController;
    CodeTabsController *codeController;
    DebugClient *debug;
}
@end
