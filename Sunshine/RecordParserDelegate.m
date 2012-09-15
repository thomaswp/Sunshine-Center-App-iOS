//
//  RecordParser.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "RecordParserDelegate.h"
#import "Record.h"
#import "Section.h"

@implementation RecordParserDelegate

@synthesize record;

Record* currentRecord;
Section* currentSection;

+(id) delegate {
    return [[RecordParserDelegate alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([Record isRecord:elementName]) {
        currentRecord = [Record recordWithAttributes: attributeDict];
        NSLog(@"record %@", currentRecord.name);
    } else if ([Section isSection:elementName]) {
        currentSection = [Section sectionWithAttributes:attributeDict];
        [currentRecord addSection:currentSection];
        NSLog(@"section");
    }
    record = currentRecord;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string.length > 0) {
        
    }
}
@end
