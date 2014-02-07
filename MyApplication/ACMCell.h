//
//  ACMCell.h
//  MyApplication
//
//  Created by Audrey Manzano on 2/3/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMFetcher.h"

@protocol ACMCellDelegate <NSObject>

@end

@interface ACMCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UILabel *time;
@property (nonatomic, weak) IBOutlet UILabel *caption;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet UIImageView *userPic;

@property (nonatomic, weak) id<ACMCellDelegate>delegate;

+ (CGFloat)heightForRowWithData:(NSDictionary *)data forType:(PageType)type;

@end
