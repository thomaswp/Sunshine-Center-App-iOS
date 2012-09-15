//
//  RecordCache.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "RecordCache.h"
#import "RecordParserDelegate.h"

@implementation RecordCache

static NSDictionary* recordCache;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        recordCache = [[NSDictionary alloc] init];
    }
}

+(Record *)parseRecordWithPath:(NSString *)path {
    RecordParserDelegate* delegate = [RecordParserDelegate delegate];
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:path ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:delegate];
    [parser parse];
    return delegate.record;
}

@end
