//
//  ACMFetcher.m
//  MyApplication
//
//  Created by Audrey Manzano on 2/3/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import "ACMFetcher.h"
#import "JSONKit.h"

#define ACCESS_TOKEN @"669574756438254|FOAjI8bIBoTrSRFD6v1yzGuUfZk"
#define PAGE_ID @"upacm"
#define TYPE @"posts" // @"feed"

@implementation ACMFetcher


//@"https://graph.facebook.com/oauth/access_token?grant_type=client_credentials&client_id=669574756438254&client_secret=f4c1691e456a61863be6a40b07adebb3"
//@"https://graph.facebook.com/upacm/posts?access_token=366776056749185%7CgAmZThOf1KrW6RzqxSWe4ObHdUw"
//https://www.facebook.com/dialog/oauth?client_id=YOUR_APP_ID&redirect_uri=URL&scope=user_status,offline_access

+ (NSDictionary *)executeFetch:(PageType)type
{
    NSString *query;
    if (type == PageType_NEWSFEED) {
        query = @"https://graph.facebook.com/upacm/posts?access_token=366776056749185%7CgAmZThOf1KrW6RzqxSWe4ObHdUw";
    }
    else{
        query = @"https://api.instagram.com/v1/media/popular?client_id=43ef0360afe146e396483bf460f0b392";
    }
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
//    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSDictionary *results = [jsonData objectFromJSONData];
    return results;
}

@end
