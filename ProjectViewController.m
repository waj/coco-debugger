//
//  ProjectViewController.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/17/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "ProjectViewController.h"

@implementation ProjectViewController
@synthesize delegate;

NSString *up = @"..";

-(id)init
{
    self = [super initWithNibName:@"ProjectView" bundle:nil];
    if (self) {
        rootPath = NSHomeDirectory();
        contentCache = [NSMutableDictionary new];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    NSBrowserCell *cell = [NSBrowserCell new];
    [cell setLeaf:true];
    [column setDataCell:cell];
    
    [outline setTarget:self];
    [outline setAction:@selector(outlineAction:)];
    [outline setDoubleAction:@selector(outlineDoubleAction:)];
}

-(NSArray*)contentOfPath:(NSString*)path
{
    NSError *error;
    NSArray *content = [contentCache objectForKey:path];
    if (!content) {
        content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
        content = [content sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        content = [content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF beginswith[c] '.'"]];
        [contentCache setObject:content forKey:path];
    }
    return content;
}

-(BOOL)isDirectory:(NSString*)path
{
    NSError *error;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    return [attrs objectForKey:NSFileType] == NSFileTypeDirectory;
}

-(BOOL)isFile:(NSString*)path
{
    NSError *error;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    return [attrs objectForKey:NSFileType] == NSFileTypeRegular;
}

-(void)outlineAction:(id)sender
{
    if (outline.clickedRow > 0) {
        NSString *path = [outline itemAtRow:outline.clickedRow];
        if ([self isFile:path]) {
            [delegate projectViewFileSelected:path];
        }
    }
}

-(void)outlineDoubleAction:(id)sender
{
    if (outline.clickedRow == 0) {
        rootPath = [rootPath stringByDeletingLastPathComponent];
        [rootPath retain];
        [outline reloadData];
    } else {
        NSString *path = [outline itemAtRow:outline.clickedRow];
        if ([self isDirectory:path]) {
            rootPath = path;
            [outline reloadData];
        }
    }
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (index == 0 && item == nil)
        return up;
    
    if (item == nil) index--;
    
    NSString *path = item == nil ? rootPath : item;
    NSArray *dir = [self contentOfPath:path];
    id object = [dir objectAtIndex:index];
    NSString *data = [NSString stringWithFormat:@"%@/%@", path, object];
    return [data retain];
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == up)
        return 0;
    
    NSString *path = item == nil ? rootPath : item;
    NSArray *dir = [self contentOfPath:path];
    return [dir count] + (item ? 0 : 1);
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (item == up)
        return false;
    
    return [self isDirectory:item];
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if (item == up)
        return up;
    
    return [item lastPathComponent];
}

-(void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSImage *image;
    if (item == up)
        image = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
    else
        image = [[NSWorkspace sharedWorkspace] iconForFile:item];
    [image setSize:NSMakeSize(16, 16)];
    [cell setImage:image];
}


@end
