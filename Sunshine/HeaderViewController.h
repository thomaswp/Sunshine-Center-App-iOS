//
//  HeaderViewController.h
//  Sunshine
//
//  Created by Thomason Price on 10/24/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface HeaderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Header* header;
@property (weak, nonatomic) IBOutlet UINavigationItem* navItem;
@property (weak, nonatomic) IBOutlet UITableView* table;

@end
