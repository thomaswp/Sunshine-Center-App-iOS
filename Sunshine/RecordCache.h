//
//  RecordCache.h
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"

@interface RecordCache : NSObject
extern NSString* const RECORDS[];
extern int const NUM_RECORDS;

+(Record*) parseRecordWithPath: (NSString*) path;
+(NSString*) getStyle;
@end
