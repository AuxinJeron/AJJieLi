//
//  DVLogFormatter.h
//  DreamVoice
//
//  Created by Leon on 10/2/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVLogFormatter : NSObject<DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end
