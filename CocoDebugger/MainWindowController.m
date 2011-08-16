//
//  MainWindowController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "MainWindowController.h"
#import <PSMTabBarControl/PSMRolloverButton.h>
#import <PSMTabBarControl/PSMAquaTabStyle.h>
#import <PSMTabBarControl/PSMAdiumTabStyle.h>

@implementation MainWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        variablesController = [VariablesViewController new];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [variablesController.view setFrame:[variablesView bounds]];
    [variablesView addSubview:variablesController.view];
}

- (IBAction)attach:(id)sender
{
    [tabBar setStyleNamed:@"Aqua"];
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

-(void)highlightLine:(NSNumber*)lineNumber
{
    NSInteger line = lineNumber.integerValue;
    NSUInteger loc = 0;
    NSUInteger start, end;
    for (int i = 0; i < line; i++) {
        [fileView.string getLineStart:&start end:&end contentsEnd:nil forRange:NSMakeRange(loc, 0)];
        loc += end - start;
    }
    
    [fileView.textStorage removeAttribute:NSBackgroundColorAttributeName range:NSMakeRange(0, fileView.string.length)];
    NSRange range = NSMakeRange(start, end - start);
    [fileView.textStorage addAttribute:NSBackgroundColorAttributeName
                                 value:[NSColor greenColor]
                                 range:range];
    
    NSRange glyphRange = [fileView.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:nil];
    NSRect rect = [fileView.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:fileView.textContainer];
    [fileView scrollRectToVisible:rect];
}

-(void)debugSuspended:(DebugClient *)debugger file:(NSString *)file line:(NSInteger)line
{
    [fileView performSelectorOnMainThread:@selector(readRTFDFromFile:) withObject:file waitUntilDone:true];
    [fileView performSelectorOnMainThread:@selector(setFont:) withObject:[NSFont fontWithName:@"Monaco" size:12] waitUntilDone:true];
    [self performSelectorOnMainThread:@selector(highlightLine:)
                           withObject:[NSNumber numberWithInteger:line]
                        waitUntilDone:true];
    
    [debugger varLocals];
}

-(void)debugLocalVariablesChanged:(DebugClient *)debug
{
    [variablesController reloadData];
}

@end
