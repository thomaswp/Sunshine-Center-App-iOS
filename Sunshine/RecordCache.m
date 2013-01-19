//
//  RecordCache.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "RecordCache.h"
#import "RecordParserDelegate.h"

//Cache that holds the records after they're loaded
@implementation RecordCache

static NSMutableDictionary* recordCache;
//The CSS for all webviews
static NSString* style;

//The three records
NSString* const RECORDS[] = {
    @"seekers",
    @"holders",
    @"laws"
};
int const NUM_RECORDS = 3;

+ (void)initialize
{
    //Statically initialize only once
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        recordCache = [[NSMutableDictionary alloc] init];
    }
}

+(Record *)parseRecordWithPath:(NSString *)path {
    Record* record = [recordCache objectForKey:path];
    
    //Only load it if we haven't already
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

+(NSString *)getStyle {
    if (style == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
        style = [NSString stringWithFormat:@"<head><style media='screen' type='text/css'>%@</style></head>",
                 [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:nil ]];
    }
        
    return style;
    
}

@end
