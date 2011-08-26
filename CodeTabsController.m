//
//  CodeTabsController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/16/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "CodeTabsController.h"
#import "NSThreadAdditions.h"
#import "CodeViewController.h"
#import "DebugClient.h"

@implementation CodeTabsController
@synthesize delegate;

-(id)init
{
    self = [super initWithNibName:@"CodeTabs" bundle:nil];
    if (self) {
        tabControllers = [NSMutableDictionary new];
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(debugSuspended:) name:DebugSuspendedEvent object:nil];
    }
    return self;
}

-(CodeViewController*)ensureTabForFile:(NSString*)file
{
    NSInteger index = [tabView indexOfTabViewItemWithIdentifier:file];
    NSTabViewItem *tab;
    CodeViewController *tabController;
    
    if (index == NSNotFound) {
        tab = [[NSTabViewItem alloc] initWithIdentifier:file];
        tab.label = [file lastPathComponent];
        tab.toolTip = file;
        tabController = [CodeViewController new];
        tabController.delegate = self;
        tab.view = tabController.view;
        [tabView addTabViewItem:tab];
        [tabControllers setObject:tabController forKey:file];
        [tabController loadFile:file];
    } else {
        tab = [tabView tabViewItemAtIndex:index];
        tabController = [tabControllers objectForKey:file];
    }
    
    [tabView selectTabViewItem:tab];
    return tabController;
}

-(void)showFile:(NSString *)file
{
    [self ensureTabForFile:file];
}

-(void)showFile:(NSString *)file line:(NSInteger)line
{
    CodeViewController *tabController = [self ensureTabForFile:file];
    [tabController highlightLine:line];
}

-(void)debugSuspended:(NSNotification*)notification
{
    NSString *file = [notification.userInfo objectForKey:@"file"];
    NSInteger line = [[notification.userInfo objectForKey:@"line"] integerValue];
    [self showFile:file line:line];
}

-(void)codeView:(CodeViewController *)codeView breakpointAdded:(NSInteger)line
{
    [delegate breakpointAdded:codeView.file line:line];
}

-(void)codeView:(CodeViewController *)codeView breakpointRemoved:(NSInteger)line
{
    [delegate breakpointRemoved:codeView.file line:line];
}

@end
