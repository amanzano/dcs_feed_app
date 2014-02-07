//
//  ACMFetcher.h
//  MyApplication
//
//  Created by Audrey Manzano on 2/3/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PageType_NEWSFEED=0,
    PageType_INSTAGRAM
} PageType;

@interface ACMFetcher : NSObject

+ (NSDictionary *)executeFetch:(PageType)type;

@end
