//
//  ACMFeedViewController.h
//  MyApplication
//
//  Created by Audrey Manzano on 2/5/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMCell.h"
#import "ACMFetcher.h"

@interface ACMFeedViewController : UIViewController <ACMCellDelegate, UITableViewDataSource, UITableViewDelegate>
{
    PageType _type;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (id)initWithType:(PageType)type;

@end
