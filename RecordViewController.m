//
//  ViewControllerRecord.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCache.h"
#import "Record.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    Record* record = [RecordCache parseRecordWithPath:self.recordName];
    self.navItem.title = record.name;
    NSLog(@"-:%@", record.name);
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

@end
