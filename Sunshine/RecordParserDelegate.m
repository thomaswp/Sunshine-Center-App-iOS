//
//  RecordParser.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "RecordParserDelegate.h"
#import "Record.h"
#import "Section.h"

@implementation RecordParserDelegate

@synthesize record;

Record* currentRecord;
Section* currentSection;
Header* currentHeader;
NSMutableString* currentBody;
NSDictionary* currentAttributes;
BOOL bodyContainsHTML = true;

+(id) delegate {
    return [[RecordParserDelegate alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([Record isRecord:elementName]) {
        currentRecord = [Record recordWithAttributes: attributeDict];
    } else if ([Section isSection:elementName]) {
        currentSection = [Section sectionWithAttributes:attributeDict];
        [currentRecord addSection:currentSection];
    } else if ([Header isHeader:elementName]) {
        currentHeader = [Header headerWithAttributes:attributeDict];
        [currentSection addHeader:currentHeader];
    } else if ([Header isHeaderElement:elementName]) {
        currentBody = [NSMutableString string];
        currentAttributes = [NSDictionary dictionaryWithDictionary:attributeDict];
    } else if (currentBody != nil) {
        NSEnumerator* e = [attributeDict keyEnumerator];
        NSString *key;
        while ((key = [e nextObject]) != nil) {
            [currentBody appendFormat: @" %@=\"%@\"", key, [attributeDict valueForKey:key]];
        }
        [currentBody appendString:@">"];
        bodyContainsHTML = YES;
    } else {
        NSLog(@"%@", elementName);
    }
    record = currentRecord;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([Header isHeaderElement:qName]) {
        [currentBody replaceOccurrencesOfString:@"\n"
                                     withString:@" "
                                        options:0
                                          range:NSMakeRange(0, [currentBody length])];
        [currentBody replaceOccurrencesOfString:@"\t"
                                     withString:@" "
                                        options:0
                                          range:NSMakeRange(0, [currentBody length])];
        [currentHeader addElementWithName:qName attributes:currentAttributes body:currentBody containsHTML:bodyContainsHTML];
        currentBody = nil;
        bodyContainsHTML = NO;
    } else if (currentBody != nil) {
        [currentBody appendFormat:@"</%@>", qName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (currentBody != nil) {
        [currentBody appendString:string];
    }
}
@end
