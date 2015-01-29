//
//  RedditService.m
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import "RedditService.h"
#import "RedditPost.h"
#import "AFNetworking.h"

@implementation RedditService

-(void)getPosts:(void (^)(NSArray *))callback {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://reddit.com/r/aww.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *posts = [responseObject valueForKeyPath:@"data.children"];
        __block NSArray *results = [NSArray array];
        
        [posts enumerateObjectsUsingBlock:^(NSDictionary *post, NSUInteger idx, BOOL *stop) {
            RedditPost *redditPost = [[RedditPost alloc] init];
            redditPost.title = [post valueForKeyPath:@"data.title"];
            redditPost.url = [post valueForKeyPath:@"data.url"];
            results = [results arrayByAddingObject:redditPost];
        }];
        
        callback(results);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
