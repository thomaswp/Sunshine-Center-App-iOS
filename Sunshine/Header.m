//
//  Header.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "Header.h"
#import "Question.h"
#import "Record.h"

@implementation Header

@synthesize questions;
@synthesize title;

+(id) headerWithAttributes:(NSDictionary *)attributes {
    return [[Header alloc] initWithAttributes:attributes];
}

+(id) headerWithTitle:(NSString *) title {
    return [[Header alloc] initWithTitle: title];
}

+(BOOL) isHeader:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"header"] == NSOrderedSame;
}

+(BOOL) isHeaderElement:(NSString *)qName {
    return [Header isQuestion:qName] || [Header isAnswer:qName];
}

+(BOOL) isQuestion:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"q"] == NSOrderedSame;
}

+(BOOL) isAnswer:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"an"] == NSOrderedSame;
}

-(id) initWithAttributes:(NSDictionary *)attributes {
    return [self initWithTitle:[attributes valueForKey:@"title"]];
}

-(id) initWithTitle:(NSString *) myTitle {
    self = [super init];
    title = myTitle;
    questions = [NSMutableArray array];
    return self;
    
}

-(void) addElementWithName:(NSString *)qName attributes:(NSDictionary *)attributes body:(NSString *)body containsHTML:(BOOL)html {
    body = [Record removeSpecialCharacters: body];
    if ([Header isQuestion:qName]) {
        [questions addObject: [Question questionWithQuestion:body attributes:attributes andParent: self]];
    } else if ([Header isAnswer:qName]) {
        Question* q = [questions objectAtIndex:[questions count] - 1];
        q.answer = body;
        q.containsHTML = html;
    }
}

@end
