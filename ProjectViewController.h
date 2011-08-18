//
//  ProjectViewController.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/17/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProjectViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>
{
    IBOutlet NSOutlineView *outline;
    IBOutlet NSTableColumn *column;
    NSString *rootPath;
    NSMutableDictionary *contentCache;
}

@end
