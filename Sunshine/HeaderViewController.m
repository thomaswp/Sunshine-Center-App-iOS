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



@interface QRow : NSObject
@property(readonly) Question* question;
@property(readonly) NSString* text;
@property(readonly) BOOL isQuestion;
@property(assign) BOOL hasQuestion;

+ (id) rowWithQuestion: (Question*) question;
+ (id) rowWithParent: (QRow*) parent;

- (id) initWithQuestion:(Question*) question isQuestion: (BOOL) q;

@end

@implementation QRow

@synthesize question, isQuestion;

+ (id)rowWithQuestion:(Question *)q {
    return [[QRow alloc] initWithQuestion:q isQuestion:YES];
}

+ (id) rowWithParent:(QRow *)parent {
    return [[QRow alloc] initWithQuestion:parent.question isQuestion:NO];
}

- (id) initWithQuestion:(Question *)q isQuestion:(BOOL)isQ {
    question = q;
    isQuestion = isQ;
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
        QRow* row = [QRow rowWithQuestion: [header.questions objectAtIndex:i]];
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
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int row = indexPath.row;
    QRow* qRow = [qnas objectAtIndex:row];
    NSString* text = [qRow text];
    
    if ([qRow isQuestion]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 17];
        cell.textLabel.text = text;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.textAlignment = 0;
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize: 16];
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 300, 1)];
        webView.backgroundColor = table.backgroundColor;
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        webView.delegate = self;
        [webView loadHTMLString:qRow.text baseURL:nil];
        [cell.contentView addSubview:webView];
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    NSString* text = [[qnas objectAtIndex:row] text];
    
    CGSize constraint = CGSizeMake(tableView.frame.size.width - (15 * 2), 20000.0f);
    
    UIFont* font =  [UIFont boldSystemFontOfSize: 17];
    int height = [text sizeWithFont: font
                  constrainedToSize: constraint
                      lineBreakMode: UILineBreakModeWordWrap].height;
    font = nil;
    
    return height + 20;
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
    NSLog(url);
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

@end
