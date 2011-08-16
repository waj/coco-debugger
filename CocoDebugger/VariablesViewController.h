//
//  VariablesView.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/14/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DebugClient.h"

@interface VariablesViewController : NSViewController <NSTableViewDataSource>
{
    IBOutlet NSTableView *tableView;
    IBOutlet NSTableColumn *nameColumn;
    IBOutlet NSTableColumn *valueColumn;
    DebugClient *debug;
}

-(void) reloadData;
@property (assign) DebugClient *debug;

@end
