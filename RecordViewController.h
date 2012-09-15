//
//  ViewControllerRecord.h
//  Sunshine
//
//  Created by Thomason Price on 9/15/12.
//  Copyright (c) 2012 Sunshine Center or NC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController
@property (strong, nonatomic) NSString *recordName;
@property (weak, nonatomic) IBOutlet UINavigationItem* navItem;
@end
