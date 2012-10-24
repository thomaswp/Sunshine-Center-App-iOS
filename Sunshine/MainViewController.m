//
//  ViewControllerMain.m
//  Sunshine
//
//  Created by Thomason Price of 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import "MainViewController.h"
#import "RecordViewController.h"

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString* file = nil;
    switch ([sender tag]) {
        case 0: file = @"seekers"; break;
        case 1: file = @"holders"; break;
        case 2: file = @"laws"; break;
    }
    if (file != nil) {
        [segue.destinationViewController setRecordName: file];
    }
}

@end
