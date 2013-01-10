//
//  SearchViewController.m
//  Sunshine
//
//  Created by Thomason Price on 1/7/13.
//  Copyright (c) 2013 Sunshine Center or NC. All rights reserved.
//

#import "SearchViewController.h"
#import "RecordCache.h"
#import "HeaderViewController.h"
#import "Record.h"
#import "Section.h"
#import "Header.h"
#import "Question.h"

@implementation SearchViewController

int const MAX_RESULTS = 15;
NSString* const RESERVED = @"b,i,a,ul,ol,li";
NSMutableString* searchString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    BOOL searchQuestions = self.switchQuestions.on;
    BOOL searchAnswers = self.switchAnswers.on;
    
    if (!searchQuestions && !searchAnswers) return;
    
    NSString* originalQuery = searchBar.text;
    
    NSString* query = [originalQuery lowercaseString];
    query = [self textToHtml:query];
    
    NSString* title = [NSString stringWithFormat:@"Search: %@", originalQuery];
    Header* results = [Header headerWithTitle: title];
    
    searchString = [NSMutableString stringWithString:@""];
    NSArray* words = [query componentsSeparatedByString:@" "];
    
    for (int i = 0; i < words.count; i++) {
        NSString* word = [words objectAtIndex:i];
        if (word.length == 0) continue;
        if ([RESERVED rangeOfString:word].location != NSNotFound) continue;
        
        [searchString appendFormat:@"\\b%@\\b", word];
        if (i < words.count - 1) [searchString appendString:@"|"];
        
    }
    
    if (searchString.length == 0) return;
    
    NSRegularExpression *pattern = [NSRegularExpression
                                  regularExpressionWithPattern:searchString
                                  options:NSRegularExpressionCaseInsensitive
                                  error: nil];
    
    NSMutableDictionary* weights = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (int i = 0; i < NUM_RECORDS; i++) {
        Record* record = [RecordCache parseRecordWithPath:RECORDS[i]];
        for (int j = 0; j < record.sections.count; j++)
        {
            Section* section = [record.sections objectAtIndex:j];
            for (int k = 0; k < section.headers.count; k++) {
                Header * header = [section.headers objectAtIndex:k];
                for (int l = 0; l < header.questions.count; l++) {
                    Question* question = [header.questions objectAtIndex:l];
                    int weight = 0;
                    
                    if (searchQuestions) {
                        weight += 3 * [self searchWeightWithPattern:pattern text:question.question query:query];
                    }
                    if (searchAnswers) {
                        weight += [self searchWeightWithPattern:pattern text:question.answer query:query];
                    }
                    
                    if (weight > 0) {
                        [results.questions addObject:question];
                        NSNumber* numWeight = [[NSNumber alloc] initWithInt:weight];
                        [weights setObject:numWeight forKey:question];
                    }
                }
            }
        }
    }
    
    //[results.questions sortUsingFunction:SortQuestions context:(__bridge void *)(weights)];
    
    while (results.questions.count > MAX_RESULTS) {
        [results.questions removeLastObject];
    }
    
    if (results.questions.count > 0) {
        [self performSegueWithIdentifier:@"push" sender:results];
    }
}

NSInteger SortQuestions(id q1, id q2, void *context) {
    NSLog(@"!!");
    NSDictionary* weights = (__bridge NSDictionary*)context;
    return [[weights objectForKey:q1] compare:[weights objectForKey:q2]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setSearchString: searchString];
    [segue.destinationViewController setHeader: sender];
}

- (int) searchWeightWithPattern: (NSRegularExpression*) pattern text: (NSString*) text query: (NSString*) query {
    int count = 0;
    count += [pattern numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    if ([query rangeOfString:@" "].length > 0) {
        count += 10 * [self occurrencesOfSubstring:text inString:query];
    }
    return count;
}

-(int) occurrencesOfSubstring: (NSString*) substring inString: (NSString*) string {
    NSUInteger count = 0, length = [string length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [string rangeOfString: substring options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    return count;
}

- (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    return htmlString;
}

@end
