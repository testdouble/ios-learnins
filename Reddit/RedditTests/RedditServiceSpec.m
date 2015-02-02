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
            NSDictionary* json = @{
              @"data": @{
                @"children": @[
                  @{
                    @"data": @{
                      @"title": @"a post!",
                      @"url": @"https://reddit.com/r/a-post/post123",
                      @"score": @42
                    }
                  }
                ]
              }
            };
            return [OHHTTPStubsResponse responseWithJSONObject:json statusCode:200 headers:@{@"Content-Type":@"text/json"}];
        }];
    });

    describe(@"posts", ^{
      __block NSArray *posts;

      beforeEach(^{
        RedditService* service = [[RedditService alloc] init];

        [service getPosts:^(NSArray* returnedPosts){
          posts = returnedPosts;
        }];
      });

      it(@"gets a post title", ^{
        [[expectFutureValue(((RedditPost*) posts.firstObject).title) shouldEventually] equal:@"a post!"];
      });

      it(@"gets a post url", ^{
        [[expectFutureValue(((RedditPost*) posts.firstObject).url) shouldEventually]
         equal:@"https://reddit.com/r/a-post/post123"];
      });

      it(@"gets a post score", ^{
        [[expectFutureValue(theValue(((RedditPost*) posts.firstObject).score)) shouldEventually]
         equal:theValue(42)];
      });
    });
});

SPEC_END
