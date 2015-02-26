//
//  RedditService.h
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RedditRoom;

@interface RedditService : NSObject

-(void)getRooms:(void (^)(NSArray *))callback;
-(void)getPostsForRoom:(RedditRoom*)room callback:(void (^)(NSArray *))callback;

@end
