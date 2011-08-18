//
//  CodeViewController.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MarkerLineNumberView.h"

@protocol CodeViewDelegate;

@interface CodeViewController : NSViewController <MarkerLineNumberDelegate>
{
    IBOutlet NSScrollView *scrollView;
    IBOutlet NSTextView* textView;
    NSString *_file;
    id<CodeViewDelegate> delegate;
}

-(void) loadFile:(NSString*)file;
-(NSString*) file;
-(void) highlightLine:(NSInteger)line;
@property (assign) id<CodeViewDelegate> delegate;

@end

@protocol CodeViewDelegate <NSObject>

-(void) codeView:(CodeViewController*)codeView breakpointAdded:(NSInteger)line;
-(void) codeView:(CodeViewController*)codeView breakpointRemoved:(NSInteger)line;

@end
