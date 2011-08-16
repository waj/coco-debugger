//
//  VariablesView.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/14/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "VariablesViewController.h"

@implementation VariablesViewController
@synthesize debug;

-(id)init
{
    self = [super initWithNibName:@"VariablesView" bundle:nil];
    return self;
}

-(void)reloadData
{
    [tableView reloadData];
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
