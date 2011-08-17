//
//  CodeViewController.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CodeViewController : NSViewController
{
    IBOutlet NSTextView* textView;
}

-(void) loadFile:(NSString*)file;
-(void) highlightLine:(NSInteger)line;

@end
