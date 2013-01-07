//
//  SearchViewController.h
//  Sunshine
//
//  Created by Thomason Price on 1/7/13.
//  Copyright (c) 2013 Sunshine Center or NC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISwitch* switchQuestions;
@property (weak, nonatomic) IBOutlet UISwitch* switchAnswers;

@end
