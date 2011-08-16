//
//  CodeViewController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "CodeViewController.h"

@implementation CodeViewController

-(id)init
{
    self = [super initWithNibName:@"CodeView" bundle:nil];
    return self;
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

-(void)showFile:(NSString *)file line:(NSInteger)line
{
    [fileView performSelectorOnMainThread:@selector(readRTFDFromFile:) withObject:file waitUntilDone:true];
    [fileView performSelectorOnMainThread:@selector(setFont:) withObject:[NSFont fontWithName:@"Monaco" size:12] waitUntilDone:true];
    [self performSelectorOnMainThread:@selector(highlightLine:)
                           withObject:[NSNumber numberWithInteger:line]
                        waitUntilDone:true];
}

@end
