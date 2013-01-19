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

//ViewController to perform a search over all the records
@implementation SearchViewController

//Max results to display at a time
int const MAX_RESULTS = 15;
//Search "words" which should be ignored because they will match HTML markings
NSString* const RESERVED = @"b,i,a,ul,ol,li,br";

//The search string
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
    //Should we be searching through the text of questions, answers, or both?
    BOOL searchQuestions = self.switchQuestions.on;
    BOOL searchAnswers = self.switchAnswers.on;
    
    //Can't be neither
    if (!searchQuestions && !searchAnswers) return;
    
    NSString* originalQuery = searchBar.text;
    
    //Make the query lowercase and escape any HTML notation
    NSString* query = [originalQuery lowercaseString];
    query = [self textToHtml:query];
    
    //Title for result header
    NSString* title = [NSString stringWithFormat:@"Search: %@", originalQuery];
    Header* results = [Header headerWithTitle: title];
    
    //This is the regex pattern for our search
    searchString = [NSMutableString stringWithString:@""];
    
    //Get each word in the search string
    NSArray* words = [query componentsSeparatedByString:@" "];
    
    for (int i = 0; i < words.count; i++) {
        NSString* word = [words objectAtIndex:i];
        if (word.length == 0) continue;
        if ([RESERVED rangeOfString:word].location != NSNotFound) continue;
        
        //We search for any words in the query, though we weight those will all of them
        if (searchString.length > 0) [searchString appendString:@"|"];
        //If it's not reserved, add it to the query
        [searchString appendFormat:@"\\b%@\\b", word];
        
    }
    
    if (searchString.length == 0) return;
    
    NSRegularExpression *pattern = [NSRegularExpression
                                  regularExpressionWithPattern:searchString
                                  options:NSRegularExpressionCaseInsensitive
                                  error: nil];
    
    //Search each Record, Header and Question/Answer
    for (int i = 0; i < NUM_RECORDS; i++) {
        Record* record = [RecordCache parseRecordWithPath:RECORDS[i]];
        for (int j = 0; j < record.sections.count; j++)
        {
            Section* section = [record.sections objectAtIndex:j];
            for (int k = 0; k < section.headers.count; k++) {
                Header * header = [section.headers objectAtIndex:k];
                for (int l = 0; l < header.questions.count; l++) {
                    Question* question = [header.questions objectAtIndex:l];
                    
                    //Weight the result for how good it was
                    int weight = 0;
                    
                    if (searchQuestions) {
                        //Give extra weight to the question
                        weight += 3 * [self searchWeightWithPattern:pattern text:question.question query:query];
                    }
                    if (searchAnswers) {
                        weight += [self searchWeightWithPattern:pattern text:question.answer query:query];
                    }
                    
                    //If there was any weight at all, add it to the result header
                    if (weight > 0) {
                        [results.questions addObject:question];
                        question.tempWeight = weight;
                    }
                }
            }
        }
    }
    
    //Sort by weight
    [results.questions sortUsingFunction:SortQuestions context:nil];
    
    //Remove any more than the max
    while (results.questions.count > MAX_RESULTS) {
        [results.questions removeLastObject];
    }
    
    //If we're left with any results, display them
    if (results.questions.count > 0) {
        [self performSegueWithIdentifier:@"push" sender:results];
        return;
    }
    
    //Otherwise let them know
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                    message:[NSString stringWithFormat:@"No results were found for '%@'.", originalQuery]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

NSInteger SortQuestions(id q1, id q2, void *context) {
    return [q2 tempWeight] - [q1 tempWeight];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setSearchString: searchString];
    [segue.destinationViewController setHeader: sender];
}

- (int) searchWeightWithPattern: (NSRegularExpression*) pattern text: (NSString*) text query: (NSString*) query {
    int count = 0;
    //For each instance of a word in the search, add one
    count += [pattern numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //If there was more than one word, add 10 for each occurrence of the whole search string
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
