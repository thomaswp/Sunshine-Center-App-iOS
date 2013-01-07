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
@property(readonly) NSString* text;
@property(readonly) BOOL isQuestion;
@property(assign) BOOL hasQuestion;
@property(assign) int questionHeight;
@property(readonly) int index;

+ (id) rowWithQuestion: (Question*) question andIndex: (int) index;
+ (id) rowWithParent: (QRow*) parent;

- (id) initWithQuestion:(Question*) question andIndex: (int) index isQuestion: (BOOL) q;

@end

@implementation QRow

@synthesize question, isQuestion, index, questionHeight;

+ (id)rowWithQuestion:(Question *)q andIndex: (int) index {
    return [[QRow alloc] initWithQuestion:q andIndex: index isQuestion:YES];
}

+ (id) rowWithParent:(QRow *)parent {
    return [[QRow alloc] initWithQuestion:parent.question andIndex: parent.index isQuestion:NO];
}

- (id) initWithQuestion:(Question *)q andIndex: (int) idx isQuestion:(BOOL)isQ {
    question = q;
    index = idx;
    isQuestion = isQ;
    questionHeight = 50;
    return self;
}

- (NSString*) text {
    return isQuestion ? question.question : question.answer;
}
@end


@interface HeaderViewController ()

@end

@implementation HeaderViewController

@synthesize header;
@synthesize table;


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
        [qnas addObject: row];
        //[qnas addObject: [QRow rowWithParent:row]];
        //row.hasQuestion = YES;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;//header.title;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [qnas count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    QRow* qRow = [qnas objectAtIndex:row];
    NSString* text = [qRow text];
    
    NSString* resuseId = qRow.isQuestion ? @"Question" : @"Answer";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuseId];
    UIWebView* webView;
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseId];
        
        if ([qRow isQuestion]) {
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
    
    if ([qRow isQuestion]) {
        cell.textLabel.text = text;
    } else {
        if (webView == nil) {
            webView = [cell.contentView.subviews objectAtIndex:0];
        }
        webView.tag = row;
        NSString* html = [NSString stringWithFormat:@"%@ %@", [RecordCache getStyle], qRow.text];
        [webView loadHTMLString:html baseURL:nil];
    }
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    //NSLog(@"Height: %d", row);
    QRow* qRow = [qnas objectAtIndex:row];
    
    if (qRow.isQuestion) {
        NSString* text = [qRow text];
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
    
    int row = indexPath.row;
    QRow* qRow = [qnas objectAtIndex:row];
    if (qRow.isQuestion) {
        NSArray* index = [NSArray arrayWithObject:
                          [NSIndexPath indexPathForRow:row + 1 inSection:0]];
        if (qRow.hasQuestion) {
            [qnas removeObjectAtIndex:row + 1];
            [tableView deleteRowsAtIndexPaths: index withRowAnimation:UITableViewRowAnimationRight];
            qRow.hasQuestion = NO;
        } else {
            QRow* answer = [QRow rowWithParent:qRow];
            [qnas insertObject:answer atIndex:row + 1];
            [tableView insertRowsAtIndexPaths:index withRowAnimation:UITableViewRowAnimationLeft];
            qRow.hasQuestion = YES;
        }
    }
    
    
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* url = request.URL.absoluteString;
    //NSLog(url);
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
    
//    CGRect frame = webView.frame;
//    frame.size.height = 1;
//    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    webView.frame = frame;
    
    int height = fittingSize.height + 3;
    
    qRow.questionHeight = height + 20;
    NSLog(@"Row #%d: %f", webView.tag, fittingSize.height);
    [table beginUpdates];
    [table endUpdates];
    
    webView.frame = CGRectMake(10, 10, 300, height);
}

@end
