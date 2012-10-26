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

@interface HeaderViewController ()

@end

@implementation HeaderViewController

@synthesize header;
@synthesize table;


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navItem.title = header.title;
    self.table.dataSource = self;
    self.table.delegate = self;
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
    return header.title;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return header.questions.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int row = indexPath.row;
    NSString* text = [[header.questions objectAtIndex:row] question];
    cell.textLabel.font = [UIFont boldSystemFontOfSize: 17];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.textAlignment = 1;
    return cell;
}

-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    NSString* text = [[header.questions objectAtIndex:row] question];
    
    CGSize constraint = CGSizeMake(tableView.frame.size.width - (15 * 2), 20000.0f);
    
    UIFont* font =  [UIFont boldSystemFontOfSize: 17];
    int height = [text sizeWithFont: font
                  constrainedToSize: constraint
                      lineBreakMode: UILineBreakModeWordWrap].height;
    font = nil;
    
    return height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    
    Question* question = [header.questions objectAtIndex: row];
    
    [self performSegueWithIdentifier:@"push" sender:question];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //[segue.destinationViewController setQuestion: sender];
}

@end
