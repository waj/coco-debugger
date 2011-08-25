//
//  DebugClient.m
//  CocoDebugger
//
//  Created by Juan Wajnerman on 8/13/11.
//  Copyright 2011 Manas Technology Solutions. All rights reserved.
//

#import "DebugClient.h"

@interface DebugClient (hidden)
-(void)flushSomeData;
-(void)sendCommand:(NSString*)cmd;
@end

@interface DummyStream : NSInputStream
{
    BOOL sent;
    NSInputStream *iStream;
}

+(id)initWithInputStream:(NSInputStream*)stream;
@end

@implementation DummyStream

+(id)initWithInputStream:(NSInputStream *)stream
{
    DummyStream *obj = [[DummyStream alloc] init];
    [obj retain];
    obj->iStream = stream;
    obj->sent = false;
    
    return obj;
}

-(void)open
{
    [iStream open];
}

-(NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    if (sent)
        return [iStream read:buffer maxLength:len];
    strcpy((char*)buffer, "<root>");
    sent = true;
    return 6;
}

@end

@implementation DebugClient

@synthesize delegate;
@synthesize variables;

- (id)init
{
    self = [super init];
    if (self) {
        pending = [[NSMutableData alloc] init];
        variables = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)connect
{
    [NSStream getStreamsToHost:[NSHost hostWithAddress:@"0.0.0.0"] port:1234 inputStream:&iStream outputStream:&oStream];
    [iStream retain];
    [oStream retain];
    [iStream setDelegate:self];
    [oStream setDelegate:self];
    [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [iStream open];
    [oStream open];
    [self sendCommand:@"start\n"];
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if (eventCode == NSStreamEventErrorOccurred) {
        NSLog(@"%@", [aStream.streamError localizedDescription]);
        NSLog(@"Error in stream");
    } else if (eventCode == NSStreamEventHasSpaceAvailable) {
        [self flushSomeData];
    } else if (eventCode == NSStreamEventOpenCompleted && aStream == iStream) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithStream:[DummyStream initWithInputStream:iStream]];
        [parser retain];
        parser.delegate = self;
        [NSThread detachNewThreadSelector:@selector(parse) toTarget:parser withObject:nil];
    }
}

-(void)sendCommand:(NSString *)cmd
{
    [pending appendData:[cmd dataUsingEncoding:NSASCIIStringEncoding]];
    [self flushSomeData];
}

-(void)flushSomeData
{
    if (pending.length > 0 && oStream.hasSpaceAvailable) {
        NSInteger count = [oStream write:pending.bytes maxLength:pending.length];
        if (count > 0) {
            [pending replaceBytesInRange:NSMakeRange(0, count) withBytes:NULL length:0];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"Element: %@", elementName);
    if ([@"suspended" isEqual:elementName] || [@"breakpoint" isEqual:elementName]) {
        NSString *file = [attributeDict valueForKey:@"file"];
        NSString *line = [attributeDict valueForKey:@"line"];
        [attributeDict valueForKey:@"line"];
        [delegate debugSuspended:self file:file line:line.integerValue];
    } else if ([@"variables" isEqual:elementName]) {
        [variables removeAllObjects];
    } else if ([@"variable" isEqual:elementName]) {
        NSString *value = [attributeDict objectForKey:@"value"];
        if (value) {
            [variables setObject:value forKey:[attributeDict objectForKey:@"name"]];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([@"variables" isEqual:elementName]) {
        [delegate debugLocalVariablesChanged:self];
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Parse error: %@", parseError.localizedDescription);
}

-(void)interrupt
{
    [self sendCommand:@"interrupt\n"];
}

-(void)quit
{
    [self sendCommand:@"quit\n"];
}

-(void)step
{
    [self sendCommand:@"step+\n"];
}

-(void)next
{
    [self sendCommand:@"next+\n"];
}

-(void)finish
{
    [self sendCommand:@"finish\n"];
}

-(void)cont
{
    [self sendCommand:@"cont\n"];
}

-(void)varLocals
{
    [self sendCommand:@"var local\n"]; 
}

-(void)addBreakpoint:(NSString *)file line:(NSInteger)line
{
    [self sendCommand:[NSString stringWithFormat:@"break %@:%d\n", file, line]];
}

-(void)removeBreakpoint:(NSString *)file line:(NSInteger)line
{
    
}

@end
