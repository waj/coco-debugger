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

-(BOOL)colorize: (NSString*)regex range:(NSRange*)range withColor:(NSColor*)color
{
    NSRange found = [textView.string rangeOfString:regex options:NSRegularExpressionSearch range: *range];
    if (found.location != NSNotFound) {
        if (color) {
            [[NSThread mainThread] performBlock:^{
                [textView.textStorage addAttribute:NSForegroundColorAttributeName
                                             value:color
                                             range:found];
            }];
        }
        range->location = found.location + found.length;
        range->length -= found.length;
        return true;
    }
    return false;
}

-(void)loadFile:(NSString *)file
{
    [[NSThread mainThread] performBlock:^{
        [textView readRTFDFromFile:file];
        [textView setFont:[NSFont fontWithName:@"Monaco" size:12]];
    } waitUntilDone:true];
    
    [NSThread performBlockInBackground:^{
        NSRange current = NSMakeRange(0, textView.string.length);
        while (current.location < textView.string.length) {
            if (
                [self colorize:@"^(attr_accessor|attr_reader|attr_writer|def|do|elsif|else|end|if|true|false|class|while|nil|yield|return|unless|next|break|module|retry|raise|rescue|begin|new|require)\\b" range:&current withColor: [NSColor blueColor]]
                || [self colorize:@"^(\"[^\"]*\"|'[^']*')" range:&current withColor: [NSColor purpleColor]]
                || [self colorize:@"^#.*" range:&current withColor: [NSColor grayColor]]
                || [self colorize:@"^[A-Z_]\\w*" range:&current withColor: [NSColor orangeColor]]
                || [self colorize:@"^@\\w+" range:&current withColor: [NSColor darkGrayColor]]
                || [self colorize:@"^::" range:&current withColor: nil]
                || [self colorize:@"^:(\\w|\\!|\\?)+" range:&current withColor: [NSColor redColor]]
                || [self colorize:@"^\\w+\\b" range:&current withColor: nil]
                || [self colorize:@"^\\s+" range:&current withColor: nil]
                ) continue;            
            current.location++;
            current.length--;        
        }
    }];
    
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
