//
//  RedditService.m
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import "RedditService.h"
#import "RedditPost.h"
#import "RedditRoom.h"
#import "AFNetworking.h"

@implementation RedditService

-(void)getRooms:(void (^)(NSArray *))callback {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:@"http://reddit.com/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rooms = [responseObject valueForKeyPath:@"data.children"];
        __block NSArray *results = [NSArray array];

        [rooms enumerateObjectsUsingBlock:^(NSDictionary *room, NSUInteger idx, BOOL *stop) {
            RedditRoom *redditRoom = [RedditRoom roomWithJSON:room];
            results = [results arrayByAddingObject:redditRoom];
        }];

        callback(results);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)getPostsForRoom:(RedditRoom *)room callback:(void (^)(NSArray *))callback {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:room.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *posts = [responseObject valueForKeyPath:@"data.children"];
        __block NSArray *results = [NSArray array];
        
        [posts enumerateObjectsUsingBlock:^(NSDictionary *post, NSUInteger idx, BOOL *stop) {
          RedditPost *redditPost = [RedditPost postWithJSON:post];
          results = [results arrayByAddingObject:redditPost];
        }];
        
        callback(results);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
