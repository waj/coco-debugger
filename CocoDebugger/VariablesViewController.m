//
//  VariablesViewController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/14/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "VariablesViewController.h"

@implementation VariablesViewController

-(id)init
{
    self = [super initWithNibName:@"VariablesView" bundle:nil];
    if (self) {
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(debugSuspended:) name:DebugSuspendedEvent object:nil];
        [notifCenter addObserver:self selector:@selector(debugVariables:) name:DebugVariablesEvent object:nil];
    }
    return self;
}

-(void)debugSuspended:(NSNotification*)notification
{
    [notification.object varLocals];
}

-(void)debugVariables:(NSNotification*)notification
{
    variables = [notification.userInfo copy];
    [tableView reloadData];
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return variables.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *key = [variables.allKeys objectAtIndex:row];
    if (tableColumn == nameColumn) {
        return key;
    } else {
        return [variables objectForKey:key];
    }
}


@end
