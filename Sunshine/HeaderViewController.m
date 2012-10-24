//
//  HeaderViewController.m
//  Sunshine
//
//  Created by Thomason Price on 10/24/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "HeaderViewController.h"

@interface HeaderViewController ()

@end

@implementation HeaderViewController

@synthesize header;

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
    
	self.navItem.title = header.title;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
