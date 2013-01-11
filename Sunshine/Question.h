//
//  Question.h
//  Sunshine
//
//  Created by Thomason Price on 10/26/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Header;

@interface Question : NSObject
@property(readonly) NSString* question;
@property(retain) NSString* answer;
@property(readonly) NSString* anchor;
@property(readonly) Header* parent;
@property(assign) BOOL containsHTML;
@property(assign) BOOL collapsed;
@property(assign) int tempWeight;

+ (id) questionWithQuestion: (NSString*) question attributes: (NSDictionary*) atts andParent: (Header*) parent;
- (id) initithQuestion: (NSString*) question attributes: (NSDictionary*) atts andParent: (Header*) parent;
@end
