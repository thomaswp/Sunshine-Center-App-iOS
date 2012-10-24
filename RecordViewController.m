//
//  ViewControllerRecord.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCache.h"
#import "Record.h"
#import "HeaderViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

Record* record;

- (void)viewDidLoad
{
    [super viewDidLoad];
    record = [RecordCache parseRecordWithPath:self.recordName];
    self.navItem.title = record.name;
    self.table.dataSource = self;
    self.table.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    record = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return record.sections.count;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[record.sections objectAtIndex:section] title];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[record.sections objectAtIndex:section] headers].count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int section = indexPath.section;
    int row = indexPath.row;
    cell.textLabel.text = [[[[record.sections objectAtIndex:section] headers] objectAtIndex:row] title];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.textAlignment = 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    Header* selectedHeader = [[[record.sections objectAtIndex:section] headers] objectAtIndex:row];
    
    [self performSegueWithIdentifier:@"push" sender:selectedHeader];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setHeader: sender];
}

@end
