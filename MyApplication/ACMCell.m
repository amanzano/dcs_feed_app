//
//  ACMCell.m
//  MyApplication
//
//  Created by Audrey Manzano on 2/3/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import "ACMCell.h"
#import "SHK.h"

@implementation ACMCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)share:(id)sender
{
    NSString *text = @"Share";
    SHKItem *item = [SHKItem text:text];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    UIViewController *vc = (UIViewController *)self.delegate;
	[SHK setRootViewController:vc];
	[actionSheet showInView:vc.view];
}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.caption.autoresizingMask = UIViewAutoresizingNone;
//    self.caption.numberOfLines = 0;
//    CGRect cellFrame = self.caption.frame;
//    cellFrame.size = [self sizeOfLabel:self.caption withText:self.caption.text];
//    self.caption.frame =  cellFrame;
//}
//
//- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {
//    return [text boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:label.font} context: nil].size;
//}

+ (CGFloat)heightForRowWithData:(NSDictionary *)data forType:(PageType)type
{
    NSString *dataCaption, *urlString = @"";
    if (type == PageType_INSTAGRAM) {
        if (![[data objectForKey:@"caption"] isKindOfClass:[NSNull class]]) {
            dataCaption = [[data objectForKey:@"caption"] objectForKey:@"text"];
        }
        
        urlString = [[[data objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
    }
    else{
        if([data objectForKey:@"message"] != nil)
        {
            dataCaption = [data objectForKey:@"message"];
        }else if([data objectForKey:@"story"] != nil){
            dataCaption = [data objectForKey:@"story"];
        }else if([data objectForKey:@"name"] != nil){
            dataCaption = [data objectForKey:@"name"];
        }else{
            dataCaption = @"";
        }
        if ([data objectForKey:@"picture"] != nil) {
            urlString = [data objectForKey:@"picture"];
        }else{
            urlString = @"";
        }
    }
    
//    CGSize size = [dataCaption boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context: nil].size;

    CGSize size = [dataCaption sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)];
    CGFloat height = size.height + 450 - 21 ;
    if ([urlString isEqualToString:@""]) {
        height -= 280;
    }
    
    return height;
}

@end
