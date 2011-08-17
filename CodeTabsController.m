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

@implementation CodeTabsController

-(id)init
{
    self = [super initWithNibName:@"CodeTabs" bundle:nil];
    if (self) {
        tabControllers = [NSMutableDictionary new];
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

-(void)showFile:(NSString *)file line:(NSInteger)line
{
    CodeViewController *tabController = [self ensureTabForFile:file];
    [tabController highlightLine:line];
}

@end
