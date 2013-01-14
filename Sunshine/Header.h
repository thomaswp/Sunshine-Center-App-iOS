//
//  Header.h
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Header : NSObject

@property(readonly) NSString* title;
@property(readonly) NSString* tip;
@property(readonly) NSMutableArray* questions;

+(id) headerWithAttributes: (NSDictionary*) attributes;
+(id) headerWithTitle: (NSString*) title;
+(BOOL) isHeader: (NSString*) qName;
+(BOOL) isHeaderElement: (NSString*) qName;
+(BOOL) isQuestion: (NSString*) qName;
+(BOOL) isAnswer: (NSString*) qName;

-(id) initWithAttributes: (NSDictionary*) attributes;
-(id) initWithTitle: (NSString*) title;
-(void) addElementWithName: (NSString*) qName attributes: (NSDictionary*) attributes body: (NSString*) body containsHTML: (BOOL) html;

@end
