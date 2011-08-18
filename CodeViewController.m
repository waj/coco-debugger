//
//  CodeViewController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "CodeViewController.h"
#import "NSThreadAdditions.h"
#import "NoodleLineNumberView.h"
#import "MarkerLineNumberView.h"
#import "NoodleLineNumberMarker.h"

@implementation CodeViewController
@synthesize delegate;

-(id)init
{
    self = [super initWithNibName:@"CodeView" bundle:nil];
    return self;
}

-(void)loadView
{
    [super loadView];
    MarkerLineNumberView *lineNumberView = [[MarkerLineNumberView alloc] initWithScrollView:scrollView];
    lineNumberView.delegate = self;
    [scrollView setVerticalRulerView:lineNumberView];
    [scrollView setHasHorizontalRuler:false];
    [scrollView setHasVerticalRuler:true];
    [scrollView setRulersVisible:true];
}

-(void)loadFile:(NSString *)file
{
    [[NSThread mainThread] performBlock:^{
        [textView readRTFDFromFile:file];
        [textView setFont:[NSFont fontWithName:@"Monaco" size:12]];
    } waitUntilDone:true];
    _file = file;
}

-(NSString *)file
{
    return _file;
}

-(void)highlightLine:(NSInteger)line
{
    [[NSThread mainThread] performBlock:^{
        NSUInteger loc = 0;
        NSUInteger start, end;
        for (int i = 0; i < line; i++) {
            [textView.string getLineStart:&start end:&end contentsEnd:nil forRange:NSMakeRange(loc, 0)];
            loc += end - start;
        }
        
        [textView.textStorage removeAttribute:NSBackgroundColorAttributeName
                                        range:NSMakeRange(0, textView.string.length)];
        NSRange range = NSMakeRange(start, end - start);
        [textView.textStorage addAttribute:NSBackgroundColorAttributeName
                                     value:[NSColor greenColor]
                                     range:range];
        
        [textView scrollRangeToVisible:range];
    } waitUntilDone:true];
}

-(void)markerAdded:(NoodleLineNumberMarker *)marker
{
    [delegate codeView:self breakpointAdded:[marker lineNumber]];
}

-(void)markerRemoved:(NoodleLineNumberMarker *)marker
{
    [delegate codeView:self breakpointRemoved:[marker lineNumber]];
}


@end
