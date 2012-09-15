//
//  Record.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "Record.h"

@implementation Record

@synthesize name;
@synthesize sections;

+(BOOL) isRecord:(NSString *)qName {
    return [qName caseInsensitiveCompare:@"record"] == NSOrderedSame;
}

+(NSString*) removeSpecialCharacters:(NSString *)text {
    text = [text  stringByReplacingOccurrencesOfString:@"‚Äù" withString:@"\""];
    text = [text  stringByReplacingOccurrencesOfString:@"‚Äò" withString:@"'"];
    text = [text  stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
    text = [text  stringByReplacingOccurrencesOfString:@"‚Äì" withString:@"-"];
    text = [text  stringByReplacingOccurrencesOfString:@"‚Äë" withString:@"-"];
    return text;
}

-(id) initWithAttributes: (NSDictionary*) attributes {
    self = [super init];
    name = [attributes valueForKey:@"name"];
    sections = [[NSMutableArray alloc] init];
    return self;
}

-(void) addSection: (id) section {
    
}

@end
