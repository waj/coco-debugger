//
//  MainWindowController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "MainWindowController.h"

@implementation MainWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        variablesController = [VariablesViewController new];
        codeController = [CodeTabsController new];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [variablesController.view setFrame:[variablesView bounds]];
    [variablesView addSubview:variablesController.view];
    
    [codeController.view setFrame:[codeView bounds]];
    [codeView addSubview:codeController.view];
}

- (IBAction)attach:(id)sender
{
    debug = [[DebugClient alloc] init];
    debug.delegate = self;
    variablesController.debug = debug;
    [debug connect];
}

- (IBAction)interrupt:(id)sender
{
    [debug interrupt];
}

- (IBAction)stop:(id)sender
{
    [debug quit];
}

- (IBAction)step:(id)sender {
    [debug step];
}

- (IBAction)cont:(id)sender {
    [debug cont];
}

- (IBAction)next:(id)sender {
    [debug next];
}

-(void)debugSuspended:(DebugClient *)debugger file:(NSString *)file line:(NSInteger)line
{
    [codeController showFile:file line:line];
    [debugger varLocals];
}

-(void)debugLocalVariablesChanged:(DebugClient *)debug
{
    [variablesController reloadData];
}

@end
