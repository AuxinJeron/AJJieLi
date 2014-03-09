//
//  DVLogFormatter.m
//  DreamVoice
//
//  Created by Leon on 10/2/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "DVLogFormatter.h"
#import <libkern/OSAtomic.h>

@implementation DVLogFormatter

- (id) init
{
    if((self = [super init]))
    {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    }
    return self;
}

- (NSString *) formatLogMessage:(DDLogMessage *) logMessage
{
    NSString *fileString = [logMessage fileName];
    NSString *functionString = [logMessage methodName];
    NSString *logLevel = nil;
    NSString *logMsg = logMessage->logMsg;
    NSString *dateAndTime = [self stringFromDate:logMessage->timestamp];
    int lineNumber = logMessage->lineNumber;
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR : logLevel = @"Error"; break;
        case LOG_FLAG_WARN  : logLevel = @"Warning"; break;
        case LOG_FLAG_INFO  : logLevel = @"Info"; break;
        default             : logLevel = @"Verbose"; break;
    }
    return [NSString stringWithFormat:@"[%@] %@ (%@: %d) [%@] - %@", logLevel, dateAndTime, fileString, lineNumber, functionString, logMsg];
}

- (NSString *) stringFromDate:(NSDate *) date
{
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    NSString *dateFormatString = @"yyyy/MM/dd HH:mm:ss:SSS";
    
    if (loggerCount <= 1)
    {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil)
        {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [threadUnsafeDateFormatter setDateFormat:dateFormatString];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    }
    else
    {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:dateFormatString];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (void) didAddToLogger:(id <DDLogger>) logger
{
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void) willRemoveFromLogger:(id <DDLogger>) logger
{
    OSAtomicDecrement32(&atomicLoggerCount);
}


@end
