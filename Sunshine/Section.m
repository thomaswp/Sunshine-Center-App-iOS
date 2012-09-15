//
//  Section.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "Section.h"

@implementation Section

@synthesize headers;
@synthesize title;

+(id) sectionWithAttributes:(NSDictionary *)attributes {
    return [[Section alloc] init];
}

+(BOOL) isSection:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"section"] == NSOrderedSame;
}

-(id) initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    title = [attributes valueForKey:@"title"];
    headers = [NSMutableArray array];
    return self;
}

-(void) addHeader:(id)header {
    
}

@end
