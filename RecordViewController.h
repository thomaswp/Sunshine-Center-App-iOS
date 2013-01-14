//
//  ViewControllerRecord.h
//  Sunshine
//
//  Created by Thomason Price of 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface RecordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    Record* record;
}

@property (strong, nonatomic) NSString *recordName;
@property (weak, nonatomic) IBOutlet UINavigationItem* navItem;
@property (weak, nonatomic) IBOutlet UITableView* table;
@property (weak, nonatomic) IBOutlet UITableViewCell* dummyCell;
@end
