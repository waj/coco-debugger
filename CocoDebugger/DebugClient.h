//
//  DebugClient.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DebugClientDelegate;

@interface DebugClient : NSObject <NSStreamDelegate, NSXMLParserDelegate>
{
    NSInputStream *iStream;
    NSOutputStream *oStream;
    NSMutableData *pending;
    id<DebugClientDelegate> delegate;
    NSMutableDictionary *variables;
}

- (void)connect;
- (void)interrupt;
- (void)quit;
- (void)step;
- (void)next;
- (void)finish;
- (void)cont;
- (void)varLocals;
- (void)addBreakpoint:(NSString*)file line:(NSInteger)line;
- (void)removeBreakpoint:(NSString*)file line:(NSInteger)line;

@property (assign) id<DebugClientDelegate> delegate;
@property (readonly) NSDictionary* variables;
@end

@protocol DebugClientDelegate <NSObject>

- (void)debugSuspended:(DebugClient*)debug file:(NSString*)file line:(NSInteger)line;
- (void)debugLocalVariablesChanged:(DebugClient*)debug;

@end
