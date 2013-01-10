//
//  ViewControllerMain.m
//  Sunshine
//
//  Created by Thomason Price of 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "MainViewController.h"
#import "RecordViewController.h"
#import "RecordCache.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    OHAttributedLabel* label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    label.attributedText = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:@"Hello <b>you</b>!"];
//    label.centerVertically = YES;
//    [window addSubview:label];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction) phoneButtonPressed:(id)sender {
    NSString *phoneNumber = @"tel://1-336-278-5506";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(IBAction) emailButtonPressed:(id)sender {
    NSString* email = @"ncopengov@elon.edu";
    NSString* subject = [@"Question for the Sunshine Center" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* body = [@"Hello,\n\nI am contacting the Sunshine Center of NC because..."
                      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", email, subject, body];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(IBAction) facebookButtonPressed:(id)sender {
    NSString *url = @"http://www.facebook.com/pages/Sunshine-Center-of-North-Carolina-Open-Government-Coalition/10150100833975217";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(IBAction) twitterButtonPressed:(id)sender {
    NSString *url = @"http://twitter.com/NCOpenGov";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(IBAction) sunshineButtonPressed:(id)sender {
    NSString *url = @"http://www.elon.edu/e-web/academics/communications/ncopengov/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int tag = [sender tag];
    
    if ([sender tag] < NUM_RECORDS) {
        NSString* file = [NSString stringWithString: RECORDS[tag]];
        [segue.destinationViewController setRecordName: file];
    }
}

@end
