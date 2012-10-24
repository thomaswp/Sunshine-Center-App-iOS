//
//  TestViewController.h
//  Sunshine
//
//  Created by Thomason Price on 10/24/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView* table;
@end
