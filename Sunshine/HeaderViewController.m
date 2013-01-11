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

@interface QRow : NSObject

@property(readonly) Question* question;
@property(assign) BOOL extended;
@property(assign) int questionHeight;
@property(readonly) int index;
@property(readonly) NSMutableString* mQuestion;
@property(readonly) NSMutableString* mAnswer;

+ (id) rowWithQuestion: (Question*) question andIndex: (int) index;

- (id) initWithQuestion:(Question*) question andIndex: (int) index;
- (void) applySearchString:(NSString*) searchString;

@end

@implementation QRow

@synthesize question, index, questionHeight, mQuestion, mAnswer;


+ (id)rowWithQuestion:(Question *)q andIndex: (int) index {
    return [[QRow alloc] initWithQuestion:q andIndex: index];
}


- (id) initWithQuestion:(Question *)q andIndex: (int) idx {
    question = q;
    index = idx;
    questionHeight = 50;
    mQuestion = [NSMutableString stringWithString:question.question];
    mAnswer = [NSMutableString stringWithString:question.answer];
    return self;
}

- (void) applySearchString:(NSString *)searchString {
    NSRegularExpression* pattern = [NSRegularExpression
                                    regularExpressionWithPattern:searchString
                                                         options:NSRegularExpressionCaseInsensitive
                                                           error:nil];
    
    //[pattern replaceMatchesInString:mQuestion options:0 range:NSMakeRange(0, mQuestion.length) withTemplate:@"<b>$0</b>"];
    [pattern replaceMatchesInString:mAnswer options:0 range:NSMakeRange(0, mAnswer.length) withTemplate:@"<b>$0</b>"];
    
    
}

@end


@interface HeaderViewController ()

@end

@implementation HeaderViewController

@synthesize header;
@synthesize table;
@synthesize searchString;

NSMutableArray* qnas;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navItem.title = header.title;
    self.table.dataSource = self;
    self.table.delegate = self;
    
    qnas = [NSMutableArray arrayWithCapacity:header.questions.count * 2];
    for (int i = 0; i < header.questions.count; i++) {
        QRow* row = [QRow rowWithQuestion: [header.questions objectAtIndex:i] andIndex:i];
        if (searchString != nil) {
            [row applySearchString: searchString];
        }
        [qnas addObject: row];
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
    return header.questions.count;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (searchString == nil) return nil;
    QRow* qRow = [qnas objectAtIndex:section];
    NSString* title = qRow.question.parent.title;
    if (section == 0) return title;
    QRow* previous = [qnas objectAtIndex:section - 1];
    if (previous.question.parent != qRow.question.parent) return title;
    return nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QRow* qRow = [qnas objectAtIndex:section];
    return qRow.extended ? 2 : 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRow* qRow = [qnas objectAtIndex: indexPath.section];
    
    bool isQuestion = indexPath.row == 0;
    NSString* text = isQuestion ? qRow.mQuestion : qRow.mAnswer;
    
    NSString* resuseId = isQuestion ? @"Question" : @"Answer";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuseId];
    UIWebView* webView = nil;
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseId];
        
        if (isQuestion) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 17];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.textAlignment = 0;
            
        } else {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 300, 1)];
            webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            webView.delegate = self;
            webView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            webView.opaque = NO;
            [cell.contentView addSubview:webView];
        
            UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            bgview.opaque = YES;
            bgview.backgroundColor = [UIColor colorWithRed:253/255.0f green:249/255.0f blue:227/255.0f alpha:1];
            [cell setBackgroundView:bgview];
        }
    }
    
    if (isQuestion) {
        cell.textLabel.text = text;
        
    } else {
        if (webView == nil) {
            webView = [cell.contentView.subviews objectAtIndex:0];
        }
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
        NSString* text = qRow.mQuestion;
        CGSize constraint = CGSizeMake(tableView.frame.size.width - (15 * 2), 20000.0f);
        UIFont* font =  [UIFont boldSystemFontOfSize: 17];
        int height = [text sizeWithFont: font
                      constrainedToSize: constraint
                          lineBreakMode: UILineBreakModeWordWrap].height;
        font = nil;
        return height + 20;
    } else {
        return qRow.questionHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QRow* qRow = [qnas objectAtIndex: indexPath.section];
    
    bool isQuestion = indexPath.row == 0;
    
    if (isQuestion) {
        
        NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        NSArray* indices = [NSArray arrayWithObject: index];
        bool extended = qRow.extended;
        qRow.extended = !extended;
        if (extended) {
            [tableView deleteRowsAtIndexPaths: indices withRowAnimation:UITableViewRowAnimationRight];
        } else {
            [tableView insertRowsAtIndexPaths: indices withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* url = request.URL.absoluteString;
    if ([url compare:@"about:blank"] == NSOrderedSame) {
        return YES;
    }
    if ([url rangeOfString:@"record://"].location == 0) {
        //internal link
    } else {
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
    }
    return NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    QRow* qRow = [qnas objectAtIndex: webView.tag];
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    int height = fittingSize.height + 3;
    
    qRow.questionHeight = height + 20;
    [table beginUpdates];
    [table endUpdates];
    
    webView.frame = CGRectMake(10, 10, 300, height);
}

@end
