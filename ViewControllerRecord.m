//
//  ViewControllerRecord.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "ViewControllerRecord.h"
#import "RecordCache.h"

@interface ViewControllerRecord ()

@end

@implementation ViewControllerRecord

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RecordCache parseRecordWithPath:self.recordName];
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
