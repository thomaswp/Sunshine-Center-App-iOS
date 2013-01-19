//
//  RecordViewController.m
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCache.h"
#import "Record.h"
#import "HeaderViewController.h"

//ViewController for displaying Records and their various Sections and Headers
@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize table;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Must be passed a recordName with the segue
    record = [RecordCache parseRecordWithPath:self.recordName];
    
    if (record == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    self.navItem.title = record.name;
    self.table.dataSource = self;
    self.table.delegate = self;
    
    //Fix for iPad to make background the desired color
    if ([table respondsToSelector:@selector(backgroundView)]) {
        table.backgroundView = nil;
        table.backgroundView = [[UIView alloc] init];
    }
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
    //Each Section object has a section in the TableView
    return record.sections.count;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[record.sections objectAtIndex:section] title];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Each Section has an item for Header in the Section
    return [[record.sections objectAtIndex:section] headers].count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int section = indexPath.section;
    int row = indexPath.row;
    
    //Get the title of the given Header in the given Section
    NSString* text = [[[[record.sections objectAtIndex:section] headers] objectAtIndex:row] title];
    
    //Create the textLabel appropriately, with word wrap, etc
    cell.textLabel.font = [UIFont boldSystemFontOfSize: FONT_SIZE];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.textAlignment = 1;
    return cell;
}

-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    
    //Get the title of the given Header in the given Section
    NSString* text = [[[[record.sections objectAtIndex:section] headers] objectAtIndex:row] title];

    //Create a size constraint to measure the text height
    CGSize constraint = CGSizeMake(tableView.frame.size.width - (WIDTH_PADDING * 2), 20000.0f);
    
    UIFont* font =  [UIFont boldSystemFontOfSize: FONT_SIZE];
    int height = [text sizeWithFont: font
                  constrainedToSize: constraint
                      lineBreakMode: UILineBreakModeWordWrap].height;
    font = nil;
    
    return height + HEIGHT_PADDING * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    
    //Get the header they selected
    Header* selectedHeader = [[[record.sections objectAtIndex:section] headers] objectAtIndex:row];
    
    //Perform the custom segue "push" and send the header along to pass to the ViewController
    [self performSegueWithIdentifier:@"push" sender:selectedHeader];
    
    //deselect when we're done
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Pass the "sender" - actually a Header object - to the destination view controller
    [segue.destinationViewController setHeader: sender];
}

@end
