//
//  Record.h
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property(readonly) NSString* name;
@property(readonly) NSMutableArray* sections;

+(BOOL) isRecord: (NSString*) qName;
+(NSString*) removeSpecialCharacters: (NSString*) text;

-(id) initWithAttributes: (NSDictionary*) attributes;
-(void) addSection: (id) section;

@end
