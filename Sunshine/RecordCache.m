//
//  RecordCache.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "RecordCache.h"
#import "RecordParserDelegate.h"

@implementation RecordCache

static NSMutableDictionary* recordCache;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        recordCache = [[NSMutableDictionary alloc] init];
    }
}

+(Record *)parseRecordWithPath:(NSString *)path {
    Record* record = [recordCache objectForKey:path];
    if (record == nil) {
        
        RecordParserDelegate* delegate = [RecordParserDelegate delegate];
        NSString *xmlPath = [[NSBundle mainBundle] pathForResource:path ofType:@"xml"];
        NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
        [parser setDelegate:delegate];
        [parser parse];
        record = delegate.record;
        [recordCache setValue:record forKey:path];
    }
    
    return record;
}

@end
