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
#import "ProjectViewController.h"

@interface MainWindowController : NSWindowController <DebugClientDelegate, ProjectViewDelegate>
{
    IBOutlet NSView *variablesView;
    IBOutlet NSView *codeView;
    IBOutlet NSDrawer *drawer;
    VariablesViewController *variablesController;
    CodeTabsController *codeController;
    ProjectViewController *projectController;
    DebugClient *debug;
}
@end
