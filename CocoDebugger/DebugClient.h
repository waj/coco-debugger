//
//  DebugClient.h
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugClient : NSObject <NSStreamDelegate, NSXMLParserDelegate>
{
    NSInputStream *iStream;
    NSOutputStream *oStream;
    NSMutableData *pending;
    NSMutableDictionary *variables;
    NSNotificationCenter *notifCenter;
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

@end

extern NSString * const DebugSuspendedEvent;
extern NSString * const DebugVariablesEvent;
extern NSString * const DebugEndEvent;