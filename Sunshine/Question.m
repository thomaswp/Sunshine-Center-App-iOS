//
//  Question.m
//  Sunshine
//
//  Created by Thomason Price on 10/26/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "Question.h"

//Represents a single Question and Answer
@implementation Question

@synthesize question, answer, containsHTML, anchor, tempWeight, parent;

+ (id)questionWithQuestion:(NSString *)question attributes:(NSDictionary *)atts andParent:(Header*)parent{
    return [[Question alloc] initithQuestion:question attributes:atts andParent:parent];
}

- (id) initithQuestion:(NSString *)q attributes:(NSDictionary *)atts andParent:(Header*)p {
    question = q;
    answer = @"";
    anchor = [atts objectForKey:@"anchor"];
    parent = p;
    
    return self;
}

@end
