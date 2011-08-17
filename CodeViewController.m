//
//  CodeViewController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "CodeViewController.h"
#import "NSThreadAdditions.h"

@implementation CodeViewController

-(id)init
{
    self = [super initWithNibName:@"CodeView" bundle:nil];
    return self;
}

-(void)loadFile:(NSString *)file
{
    [[NSThread mainThread] performBlock:^{
        [textView readRTFDFromFile:file];
        [textView setFont:[NSFont fontWithName:@"Monaco" size:12]];
    } waitUntilDone:true];
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
        
        NSRange glyphRange = [textView.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:nil];
        NSRect rect = [textView.layoutManager boundingRectForGlyphRange:glyphRange
                                                        inTextContainer:textView.textContainer];
        [textView scrollRectToVisible:rect];
    } waitUntilDone:true];
}


@end
