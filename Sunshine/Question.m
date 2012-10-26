//
//  Question.m
//  Sunshine
//
//  Created by Thomason Price on 10/26/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize question, answer, containsHTML, anchor;

+ (id)questionWithQuestion:(NSString *)question attributes:(NSDictionary *)atts {
    return [[Question alloc] initithQuestion:question attributes:atts];
}

- (id) initithQuestion:(NSString *)q attributes:(NSDictionary *)atts {
    question = q;
    answer = @"";
    anchor = [atts objectForKey:@"anchor"];
    
    return self;
}

@end
