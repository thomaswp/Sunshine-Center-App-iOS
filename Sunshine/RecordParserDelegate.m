//
//  RecordParser.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "RecordParserDelegate.h" 

@implementation RecordParserDelegate

+(id) delegate {
    return [[RecordParserDelegate alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    NSLog(@"<%@>", elementName);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"</%@>", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string.length > 0) {
        NSLog(@"!%@!", string);
    }
}
@end
