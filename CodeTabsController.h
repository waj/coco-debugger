//
//  CodeTabsController.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CodeViewController.h"

@protocol CodeTabsDelegate;

@interface CodeTabsController : NSViewController <CodeViewDelegate>
{
    IBOutlet NSTabView *tabView;
    NSMutableDictionary *tabControllers;
    id<CodeTabsDelegate> delegate;
}

-(void)showFile:(NSString *)file;
@property (assign) id<CodeTabsDelegate> delegate;
@end

@protocol CodeTabsDelegate <NSObject>

-(void) breakpointAdded:(NSString*)file line:(NSInteger)line;
-(void) breakpointRemoved:(NSString*)file line:(NSInteger)line;

@end

