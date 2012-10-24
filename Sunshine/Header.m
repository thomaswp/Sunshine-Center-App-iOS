//
//  Header.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "Header.h"

@implementation Header

@synthesize questions;
@synthesize title;

+(id) headerWithAttributes:(NSDictionary *)attributes {
    return [[Header alloc] initWithAttributes:attributes];
}

+(BOOL) isHeader:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"header"] == NSOrderedSame;
}

+(BOOL) isHeaderElement:(NSString *)qName {
    return [Header isQuestion:qName] || [Header isAnswer:qName];
}

+(BOOL) isQuestion:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"question"] == NSOrderedSame;
}

+(BOOL) isAnswer:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"answer"] == NSOrderedSame;
}

-(id) initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    title = [attributes valueForKey:@"title"];
    questions = [NSMutableArray array];
    return self;
}

-(void) addElementWithName:(NSString *)qName attributes:(NSDictionary *)attributes body:(NSString *)body {
    
}

-(void) addQuestion:(id)header {
    
}

@end
