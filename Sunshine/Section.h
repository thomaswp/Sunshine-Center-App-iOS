//
//  Section.h
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface Section : NSObject

@property(readonly) NSString* title;
@property(readonly) NSMutableArray* headers;

+(id) sectionWithAttributes: (NSDictionary*) attributes;
+(BOOL) isSection: (NSString*) qName;

-(id) initWithAttributes: (NSDictionary*) attributes;
-(void) addHeader: (Header*) header;

@end
