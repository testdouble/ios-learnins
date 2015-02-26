//
//  RedditPost.h
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditPost : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* url;
@property (nonatomic) NSInteger score;

+ (instancetype) postWithJSON:(NSDictionary*)post;

@end
