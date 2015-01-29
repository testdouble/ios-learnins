//
//  RedditPost.m
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import "RedditPost.h"

@implementation RedditPost

+ (RedditPost*) withData:(NSDictionary*)post {
  RedditPost *redditPost = [[RedditPost alloc] init];
  redditPost.title = [post valueForKeyPath:@"data.title"];
  redditPost.url = [post valueForKeyPath:@"data.url"];
  return redditPost;
}
@end
