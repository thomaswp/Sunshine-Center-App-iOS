//
//  Record.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "Record.h"

//Represents a whole XML file
@implementation Record

@synthesize name;
@synthesize sections;

+(id) recordWithAttributes:(NSDictionary *)attributes {
    return [[Record alloc] initWithAttributes:attributes];
}

+(BOOL) isRecord:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"record"] == NSOrderedSame;
}

//Right now we don't do anything, but if UTF-8 ever stops working, we could remove problematic character from the XML files
+(NSString*) removeSpecialCharacters:(NSString *)text {
//    text = [text  stringByReplacingOccurrencesOfString:@"‚Äù" withString:@"\""];
//    text = [text  stringByReplacingOccurrencesOfString:@"‚Äò" withString:@"'"];
//    text = [text  stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
//    text = [text  stringByReplacingOccurrencesOfString:@"‚Äì" withString:@"-"];
//    text = [text  stringByReplacingOccurrencesOfString:@"‚Äë" withString:@"-"];
    return text;
}

-(id) initWithAttributes: (NSDictionary*) attributes {
    self = [super init];
    name = [attributes valueForKey:@"name"];
    sections = [[NSMutableArray alloc] init];
    return self;
}

-(void) addSection: (Section*) section {
    [sections addObject:section];
}

@end
