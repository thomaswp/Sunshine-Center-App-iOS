//
//  ViewControllerRecord.h
//  Sunshine
//
//  Created by Thomason Price of 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *recordName;
@property (weak, nonatomic) IBOutlet UINavigationItem* navItem;
@property (weak, nonatomic) IBOutlet UITableView* table;
@property (weak, nonatomic) IBOutlet UITableViewCell* dummyCell;
@end
