//
//  HeaderViewController.m
//  Sunshine
//
//  Created by Thomason Price on 10/24/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "HeaderViewController.h"
#import "Header.h"
#import "Question.h"
#import "RecordCache.h"
#import "RecordViewController.h"

//Wraps a Question object with information about how it is being displayed in the TableView
@interface QRow : NSObject

//The question to wrap
@property(readonly) Question* question;
//Whether the question is extended (showing the answer) or not
@property(assign) BOOL extended;
//The height of the question's answer, as displayed in a WebVixew (stored for later use upon calculation)
@property(assign) int questionHeight;
//The index of this question in its parent header
@property(readonly) int index;

//Mutable strings for the question and answer after possible modification from a search (adding <b> tags to highlight the search phrase)
@property(readonly) NSMutableString* questionText;
@property(readonly) NSMutableString* answerText;

+ (id) rowWithQuestion: (Question*) question andIndex: (int) index;

- (id) initWithQuestion:(Question*) question andIndex: (int) index;
- (void) applySearchString:(NSString*) searchString;

@end

@implementation QRow

@synthesize question, index, questionHeight, questionText, answerText;


+ (id)rowWithQuestion:(Question *)q andIndex: (int) index {
    return [[QRow alloc] initWithQuestion:q andIndex: index];
}


- (id) initWithQuestion:(Question *)q andIndex: (int) idx {
    question = q;
    index = idx;
    questionHeight = 50;
    questionText = [NSMutableString stringWithString:question.question];
    answerText = [NSMutableString stringWithString:question.answer];
    return self;
}

//Bolds the any matches to a searchString
- (void) applySearchString:(NSString *)searchString {
    NSRegularExpression* pattern = [NSRegularExpression
                                    regularExpressionWithPattern:searchString
                                                         options:NSRegularExpressionCaseInsensitive
                                                           error:nil];
    
    //right now we can't bold the question text because the UITableViewCell has no was of displaying the HTML content without
    //making a WebView, which would be too much overhead
    //[pattern replaceMatchesInString:mQuestion options:0 range:NSMakeRange(0, mQuestion.length) withTemplate:@"<b>$0</b>"];
    
    //surround any matches with bold tags
    [pattern replaceMatchesInString:answerText options:0 range:NSMakeRange(0, answerText.length) withTemplate:@"<b>$0</b>"];
    
    //Remove any bold tags inside of <a> blocks
    NSRegularExpression* unBoldURL = [NSRegularExpression
                                        regularExpressionWithPattern:@"(<a[^>]+)<b>([^>]*)</b>([^>]+>)"
                                                             options:NSRegularExpressionCaseInsensitive
                                                               error:nil];
    [unBoldURL replaceMatchesInString:answerText options:0 range:NSMakeRange(0, answerText.length) withTemplate:@"$1$2$3"];

}

@end


@interface HeaderViewController ()

@end

@implementation HeaderViewController

//The header to display
@synthesize header;
//The UITableView we're working with
@synthesize table;
//The search string used to construct this header (will be null if this is not the result of a search)
@synthesize searchString;
//A "phantom button" with a segue that links back to this ViewController (for linking to a new Header)
@synthesize reloadButton;
//The anchor of the question being linked to in this header, for immediate display (will be null if this display is not the result of a link)
@synthesize questionAnchor;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup];
}

- (void) setup {
    self.navItem.title = header.title;
    self.table.dataSource = self;
    self.table.delegate = self;
    
    //Create the array of QRows two wrap our questions
    qnas = [NSMutableArray arrayWithCapacity:header.questions.count];
    for (int i = 0; i < header.questions.count; i++) {
        QRow* row = [QRow rowWithQuestion: [header.questions objectAtIndex:i] andIndex:i];
        if (searchString != nil) {
            [row applySearchString: searchString];
        }
        [qnas addObject: row];
    }
    
    if (questionAnchor != nil) {
        [self openQuestion:questionAnchor];
    }
}

- (void)viewDidUnload
{
    searchString = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //Each question has its own section
    return header.questions.count;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (searchString == nil)  {
        //If this isn't a search result, dislpay the tip for this header if there is one
        if (section == 0) return header.tip;
    } else {
        //If this is a search result, display the name of header that contained each Question result, however only do so if it's different from the header above
        QRow* qRow = [qnas objectAtIndex:section];
        NSString* title = qRow.question.parent.title;
        if (section == 0) return title;
        QRow* previous = [qnas objectAtIndex:section - 1];
        if (previous.question.parent != qRow.question.parent) return title;
    }
    return nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Each section will have either 1 row (if the question is not expanded) of 2 (if it is)
    QRow* qRow = [qnas objectAtIndex:section];
    return qRow.extended ? 2 : 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRow* qRow = [qnas objectAtIndex: indexPath.section];
    
    //If the row is 0, this cell is the question; if it's 1, it's the answer
    bool isQuestion = indexPath.row == 0;
    //Get the text to display
    NSString* text = isQuestion ? qRow.questionText : qRow.answerText;
    
    //Try to reuse a cell if we can
    NSString* resuseId = isQuestion ? @"Question" : @"Answer";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuseId];
    UIWebView* webView = nil;
    
    //If there are no cells to reuse...
    if (cell == nil) {
        //create one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseId];
        
        if (isQuestion) {
            //If it's a question, use the textLabel
            cell.textLabel.font = [UIFont boldSystemFontOfSize: FONT_SIZE];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.textAlignment = 0;
            
        } else {
            //If it's an answer, use a WebView. Start the height at 1 and let it autoresize
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(WIDTH_PADDING, HEIGHT_PADDING, table.frame.size.width - WIDTH_PADDING * 2, 1)];
            webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            webView.delegate = self;
            webView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            webView.opaque = NO;
            [cell.contentView addSubview:webView];
        
            //Add a background view for color
            UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            bgview.opaque = YES;
            bgview.backgroundColor = [UIColor colorWithRed:253/255.0f green:249/255.0f blue:227/255.0f alpha:1];
            [cell setBackgroundView:bgview];
        }
    }
    
    //Whether we had to create a new cell or not, we set the appropriate data here
    if (isQuestion) {
        cell.textLabel.text = text;
    } else {
        //Get the webview if it's nil
        if (webView == nil) {
            webView = [cell.contentView.subviews objectAtIndex:0];
        }
        //Load answer text, prepending the attached css
        webView.tag = [indexPath section];
        NSString* html = [NSString stringWithFormat:@"%@ %@", [RecordCache getStyle], text];
        [webView loadHTMLString:html baseURL:nil];
    }
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRow* qRow = [qnas objectAtIndex: indexPath.section];
    
    bool isQuestion = indexPath.row == 0;
    
    if (isQuestion) {
        //Measure the height the text will take up
        NSString* text = qRow.questionText;
        CGSize constraint = CGSizeMake(tableView.frame.size.width - (WIDTH_PADDING * 2), 20000.0f);
        UIFont* font =  [UIFont boldSystemFontOfSize: FONT_SIZE];
        int height = [text sizeWithFont: font
                      constrainedToSize: constraint
                          lineBreakMode: UILineBreakModeWordWrap].height;
        font = nil;
        return height + HEIGHT_PADDING * 2;
    } else {
        //Return the stored question height from the QRow
        return qRow.questionHeight;
    }
}

//When the webview finishes loading (should only happen for the original Answer)...
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    //Calculate the height and reload the cell in the TableView
    QRow* qRow = [qnas objectAtIndex: webView.tag];
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    int height = fittingSize.height + 3;
    
    qRow.questionHeight = height + 20;
    [table beginUpdates];
    [table endUpdates];
    
    webView.frame = CGRectMake(WIDTH_PADDING, HEIGHT_PADDING, webView.frame.size.width, height);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //We only toggle questions
    bool isQuestion = indexPath.row == 0;
    if (!isQuestion) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    //Toggle whether the question is extended
    QRow* qRow = [qnas objectAtIndex: indexPath.section];
    if (qRow.extended) {
        [self closeRow:indexPath.section];
    } else {
        [self openRow:indexPath.section];
    }
}

- (void) openRow: (int) row {
    QRow* qRow = [qnas objectAtIndex: row];
    if (!qRow.extended) {
        //The row is "1" because we're adding or removing an answer
        NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:row];
        NSArray* indices = [NSArray arrayWithObject: index];
        //Make the row extended and add a row to the TableView at the appropriate location
        qRow.extended = YES;
        [table insertRowsAtIndexPaths: indices withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void) closeRow: (int) row {
    QRow* qRow = [qnas objectAtIndex: row];
    if (qRow.extended) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:row];
        NSArray* indices = [NSArray arrayWithObject: index];
        qRow.extended = NO;
        [table deleteRowsAtIndexPaths: indices withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //Only load the request in the webview if it's the original data load
    NSString* url = request.URL.absoluteString;
    if ([url compare:@"about:blank"] == NSOrderedSame) {
        return YES;
    }
    
    //Otherwise either follow an internal link (to another question) or open it in a browser
    if ([url rangeOfString:@"record://"].location == 0) {
        [self internalLinkWithURL:url];
    } else {
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
    }
    return NO;
}

//Select a question that was linked to
- (void) openQuestion: (NSString*) anchor {
    for (int i = 0; i < header.questions.count; i++) {
        Question* question = [header.questions objectAtIndex:i];
        if (question.anchor != nil && [question.anchor caseInsensitiveCompare:anchor] == NSOrderedSame) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:i];
            [table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self openRow:i];
            
        }
    }
}

//Follow an internal link to another Question, Header or Section
- (void) internalLinkWithURL: (NSString*) url {
    //The URL looks like this: record://pathToRecord.titleOfHeader.anchorOfQuestion
    //Remove the record:// and parse the "." sections
    url = [url stringByReplacingOccurrencesOfString:@"record://" withString:@""];
    NSArray* sections = [url componentsSeparatedByString:@"."];
    
    //If we have at least one...
    if (sections.count > 0) {
        NSString* recordName = [sections objectAtIndex:0];
        
        if (sections.count == 1) {
            //If it's just a Record, go ahead and load it in a ViewController
            [self performSegueWithIdentifier:@"pushRecord" sender:recordName];
        } else {
            //If there's more, load the record
            Record* linkRecord = [RecordCache parseRecordWithPath:recordName];
            if (linkRecord != nil) {
                //Search for the Header in each Section of the Record
                NSString* headerName = [sections objectAtIndex:1];
                Header* linkHeader = nil;
                for (int i = 0; i < linkRecord.sections.count; i++) {
                    Section* s = [linkRecord.sections objectAtIndex:i];
                    for (int j = 0; j < s.headers.count; j++) {
                        Header* h = [s.headers objectAtIndex:j];
                        //Compare the title to our link without spaces or case
                        NSString* camelTitle = [h.title stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if ([camelTitle caseInsensitiveCompare:headerName] == NSOrderedSame) {
                            linkHeader = h;
                            break;
                        }
                    }
                    if (linkHeader != nil) break;
                }
                
                //If we found the right header...
                if (linkHeader != nil) {
                    
                    //There may be a specific question to load as well
                    questionAnchor = nil;
                    if (sections.count > 2) {
                        questionAnchor = [sections objectAtIndex:2];
                    }
                    
                    if (linkHeader == self.header) {
                        //If the header we're loading is this one, just go to the question
                        [self openQuestion:questionAnchor];
                    } else {
                        //Otherwise use our "phantom button" to load this ViewController again with the new header and questionAnchor
                        [self performSegueWithIdentifier:@"pushHeader" sender:linkHeader];
                    }
                } else {
                    NSLog(@"No header: %@", headerName);
                }
            } else {
                NSLog(@"No record: %@", recordName);
            }
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != nil) {
        if ([sender isKindOfClass:[NSString class]]) {
            //If we're loading with a string "sender", this is a Record we're loading
            [segue.destinationViewController setRecordName: sender];
        } else if ([sender isKindOfClass:[Header class]]) {
            //Otherwise it's a Header, and we pass it the questionAnchor if there is one
            [segue.destinationViewController setQuestionAnchor:questionAnchor];
            questionAnchor = nil;
            [segue.destinationViewController setHeader: sender];
        }
    }
}

@end
