//
//  ACMFeedViewController.m
//  MyApplication
//
//  Created by Audrey Manzano on 2/5/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import "ACMFeedViewController.h"

#import "UIImageView+AFNetworking.h"

#define NUM_SECTIONS 1

@interface ACMFeedViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation ACMFeedViewController

- (id)initWithType:(PageType)type
{
    self = [super init];
    if (self) {
        _type = type;
        if (type == PageType_INSTAGRAM) {
            self.title = @"Instagram Feed";
            self.tabBarItem.image = [UIImage imageNamed:@"instagram"];
        }
        else{
            self.title = @"UP ACM Posts";
            self.tabBarItem.image = [UIImage imageNamed:@"acm"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
    [indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.0), ^{
        NSDictionary *dictionary = [ACMFetcher executeFetch:_type];
        self.items = [dictionary objectForKey:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [indicator stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.items objectAtIndex:indexPath.row];
    CGFloat height = [ACMCell heightForRowWithData:dictionary forType:_type];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellReuseID";
    ACMCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ACMCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = [self.items objectAtIndex:indexPath.row];
    if (_type == PageType_INSTAGRAM) {
        cell.username.text = [[dictionary objectForKey:@"user"] objectForKey:@"full_name"];
        NSString *urlString = [[dictionary objectForKey:@"user"] objectForKey:@"profile_picture"];
        NSURL *url = [NSURL URLWithString:urlString];
        //    cell.userPic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [cell.userPic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dp_placeholder"]];
        NSString *thumbnailUrlString = [[[dictionary objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
        NSURL *thumbnailUrl = [NSURL URLWithString:thumbnailUrlString];
        //    cell.photoView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailUrl]];
        [cell.photoView setImageWithURL:thumbnailUrl placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        if(![[dictionary objectForKey:@"caption"] isKindOfClass:[NSNull class]])
        {
            cell.caption.text = [[dictionary objectForKey:@"caption"] objectForKey:@"text"];
        }else{
            cell.caption.text = @"";
        }
    }
    else{
        cell.username.text = [[dictionary objectForKey:@"from"] objectForKey:@"name"];
        [cell.userPic setImage:[UIImage imageNamed:@"acm"]];
        if ([dictionary objectForKey:@"picture"] != nil) {
            NSString *thumbnailUrlString = [dictionary objectForKey:@"picture"];
            NSURL *thumbnailUrl = [NSURL URLWithString:thumbnailUrlString];
            //    cell.photoView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailUrl]];
            [cell.photoView setImageWithURL:thumbnailUrl placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
            cell.photoView.hidden = NO;
        }else{
            cell.photoView.hidden = YES;
        }
        
        if([dictionary objectForKey:@"message"] != nil)
        {
            cell.caption.text = [dictionary objectForKey:@"message"] ;
        }else if([dictionary objectForKey:@"story"] != nil){
            cell.caption.text = [dictionary objectForKey:@"story"] ;
        }else if([dictionary objectForKey:@"name"] != nil){
            cell.caption.text = [dictionary objectForKey:@"name"] ;
        }else{
            cell.caption.text = @"";
        }
    }
    
    cell.delegate = self;
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACMCell *cell = (ACMCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@ %f, %f, %f, %f, %@, %@", cell, cell.caption.frame.origin.x, cell.caption.frame.origin.y, cell.caption.frame.size.width, cell.caption.frame.size.height, cell.caption.text, cell.caption);
}

@end
