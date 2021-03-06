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
        projectController = [ProjectViewController new];
        projectController.delegate = self;
        codeController.delegate = self;
        
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(debugSuspended:) name:DebugSuspendedEvent object:nil];
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
    
    drawer.contentView = projectController.view;
    [drawer setContentSize:NSMakeSize(200, 0)];
    [drawer open:self];
}

- (IBAction)attach:(id)sender
{
    debug = [[DebugClient alloc] init];
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

- (IBAction)finish:(id)sender {
    [debug finish];
}

-(void)debugSuspended:(NSNotification*)notification
{
}

-(void)debugEnd:(DebugClient *)debug
{
    [self->debug release];
    self->debug = nil;
}

-(void)projectViewFileSelected:(NSString *)path
{
    [codeController showFile:path];
}

-(void)breakpointAdded:(NSString *)file line:(NSInteger)line
{
    [debug addBreakpoint:file line:line];
}

-(void)breakpointRemoved:(NSString *)file line:(NSInteger)line
{
    [debug removeBreakpoint:file line:line];
}

@end
