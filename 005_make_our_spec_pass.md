- The first thing we're going to do is modify the test class, because I did it wrong in the first place. It should look like this:
```
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
```
We have to change the expectation because I forgot that `equal:` does not do a deep compare. So we'll just grab the title and compare it. We've also switched OHHTTPStubs to use `responseWithJSONObject:statusCode:headers:` because the other one wasn't working for some reason.
- Now we can run the tests and see that they still fail. Great.
- Time to make our failing spec pass! That means it's time to fill in the body of our `getPosts:` selector in `RedditService.m`.
- Modify the `getPosts:` selector in `RedditService.md` to look like this:
```
-(void)getPosts:(void (^)(NSArray *))callback {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

  [manager GET:@"http://reddit.com/r/aww.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *posts = [responseObject valueForKeyPath:@"data.children"];
    __block NSArray *results = [NSArray array];

    [posts enumerateObjectsUsingBlock:^(NSDictionary *post, NSUInteger idx, BOOL *stop) {
      RedditPost *redditPost = [[RedditPost alloc] init];
      redditPost.title = [post valueForKeyPath:@"data.title"];
      results = [results arrayByAddingObject:redditPost];
    }];

    callback(results);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
    }];
}
```

We're using AFNetworking's operation manager to send a request to reddit.com, and then doing the work in the success callback to transform the resulting json into RedditPosts.
- We haven't written any failure tests, but we can just log it to see if something weird happens.
- Commit what we've done and let's move on to the next step.
