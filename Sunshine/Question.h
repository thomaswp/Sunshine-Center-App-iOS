//
//  Question.h
//  Sunshine
//
//  Created by Thomason Price on 10/26/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property(readonly) NSString* question;
@property(assign) NSString* answer;
@property(readonly) NSString* anchor;
@property(assign) BOOL containsHTML;

+ (id) questionWithQuestion: (NSString*) question attributes: (NSDictionary*) atts;
- (id) initithQuestion: (NSString*) question attributes: (NSDictionary*) atts;
@end
