//
//  RedditServiceSpec.m
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import "Kiwi.h"
#import "OHHTTPStubs.h"
#import "RedditService.h"
#import "RedditPost.h"

SPEC_BEGIN(RedditServiceSpec)

describe(@"RedditService", ^{
    
    beforeEach(^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.host isEqualToString:@"reddit.com"];
            
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            NSDictionary* json = @{ @"data": @{ @"children": @[ @{ @"data": @{ @"title": @"a post!" } } ] } };
            return [OHHTTPStubsResponse responseWithJSONObject:json statusCode:200 headers:@{@"Content-Type":@"text/json"}];
        }];
    });

    it(@"gets a post", ^{
        RedditService* service = [[RedditService alloc] init];
        
        __block NSArray* posts;
        [service getPosts:^(NSArray* returnedPosts){
            posts = returnedPosts;
        }];
        
        [[expectFutureValue(((RedditPost*) posts.firstObject).title) shouldEventually] equal:@"a post!"];
    });
    
});

SPEC_END
