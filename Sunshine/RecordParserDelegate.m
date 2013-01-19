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

//Parses the XML files to create the Record, Section, Header and Question data structures
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
    //If we come across an elemnt, create an object to represent it
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
        //Otherwise, add the HTML element literally to the current body
        NSEnumerator* e = [attributeDict keyEnumerator];
        NSString *key;
        [currentBody appendFormat:@"<%@", elementName];
        while ((key = [e nextObject]) != nil) {
            [currentBody appendFormat: @" %@=\"%@\"", key, [attributeDict valueForKey:key]];
        }
        [currentBody appendString:@">"];
        //Right now we keep track of which Questions contain HTML, but we treat it all the same in reality
        //Optimization could treat them differently to minimize WebViews
        bodyContainsHTML = YES;
    } else {
        NSLog(@"Couldn't parse: %@", elementName);
    }
    record = currentRecord;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //If this is a "header element" ('q' or 'an')...
    if ([Header isHeaderElement:elementName]) {
        //Replace newlines and tabs with spaces, as a browser would ignore them
        [currentBody replaceOccurrencesOfString:@"\n"
                                     withString:@" "
                                        options:0
                                          range:NSMakeRange(0, [currentBody length])];
        [currentBody replaceOccurrencesOfString:@"\t"
                                     withString:@""
                                        options:0
                                          range:NSMakeRange(0, [currentBody length])];
        //And trim the string for any leading or trailing spaces
        NSString* trimmed = [currentBody stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        //And add the Question or Answer to the current Header
        [currentHeader addElementWithName:elementName attributes:currentAttributes body:trimmed containsHTML:bodyContainsHTML];
        currentBody = nil;
        bodyContainsHTML = NO;
    } else if (currentBody != nil) {
        [currentBody appendFormat:@"</%@>", elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (currentBody != nil) {
        [currentBody appendString:string];
    }
}
@end
