//
//  VariablesView.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/14/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "VariablesView.h"

@implementation VariablesView
@synthesize debug;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.dataSource = self;
}




-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return debug.variables.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *key = [debug.variables.allKeys objectAtIndex:row];
    if (tableColumn == nameColumn) {
        return key;
    } else {
        return [debug.variables objectForKey:key];
    }
}


@end
