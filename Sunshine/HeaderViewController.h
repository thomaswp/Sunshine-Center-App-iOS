//
//  HeaderViewController.h
//  Sunshine
//
//  Created by Thomason Price on 10/24/12.
//  Copyright (c) 2012 Sunshine Center of NC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface HeaderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    NSMutableArray* qnas;
}

@property (strong, nonatomic) Header* header;
@property (strong, nonatomic) NSString* searchString;
@property (strong, nonatomic) NSString* questionAnchor;
@property (weak, nonatomic) IBOutlet UINavigationItem* navItem;
@property (weak, nonatomic) IBOutlet UITableView* table;
@property (weak, nonatomic) IBOutlet UIButton* reloadButton;


//Padding for table cells
#define WIDTH_PADDING 15
#define HEIGHT_PADDING 10
//Font size for table cells
#define FONT_SIZE 17

@end
