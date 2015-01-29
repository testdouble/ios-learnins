- Right click on the `RedditTests` folder and select `New File`
- For this project, we'll start with the service layer and work our way forward. Select the `iOS` category and then `Cocoa Touch Class` as your template.
- The name of our test will be `RedditServiceSpec`. It should be a subclass of `NSObject` and the language should still be `Objective-C`
- When you save the file, take the defaults, and note that only the `RedditTests` target is selected. This is important; we don't want our tests packaged up with our production app.
- This will create a header file and an implementation file. You can delete `RedditServiceSpec.h`, and modify `RedditServiceSpec.m` to look like the following:
```
#import "Kiwi.h"

SPEC_BEGIN(RedditServiceSpec)

describe(@"RedditService", ^{

});

SPEC_END
```

This should look familiar to jasmine or rspec users.
- Let's examine the file we just made.
- `#import "Kiwi.h"` requires the Kiwi header so that we can use it.
- `SPEC_BEGIN` and `SPEC_END` are Kiwi macros that allow us to use Kiwi's spec-style testing
- `describe` is what you might expect; the thing that we are testing. It takes a string argument and a block argument (the weird `^{}` thing). All of our specs will live inside that block. One thing to note is the `@`. `@` is used for all shorthand syntax in obj-c. In this case, @"" is the shorthand syntax to build a string. There is also @[] for NSArray, @{} for NSDictionary, and @2 for NSNumber.
- Now let's set up OHHTTPStubs to stub the request we'll be making. First, we'll need to `#import "OHHTTPStubs.h"` at the top of the file.
- Now we can use the following beforeEach function to have Kiwi run our OHHTTPStub setup before each spec:
```
beforeEach(^{
  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [request.URL.host isEqualToString:@"reddit.com"];

    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
      return [OHHTTPStubsResponse responseWithData:[@"{data: {children: [{data: {title: 'a post!'}}]}}" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:@{@"Content-Type":@"text/json"}];
    }];
});  
```

We are telling OHHTTPStubs that whenever a network is request to the host `reddit.com`, we should return this stub json that looks like a super simplified version of the json that reddit returns.
- Let's write a spec that expects our service to reach out to Reddit, get the results, and return us a new model object called RedditPost. First, `#import "RedditService.h"` and `#import "RedditPost.h"`. Then:
```
it(@"gets a post", ^{
  RedditService* service = [[RedditService alloc] init];

  __block NSArray* posts;
  [service getPosts:^(returnedPosts){
    posts = returnedPosts;
  }];

  RedditPost* expectedPost = [[RedditPost alloc] init];
  [expectedPost setTitle: @"a post!"];
  NSArray* expectedPosts = @[ expectedPost ];
  [[expectFutureValue(posts) shouldEventually] equal:expectedPosts];
});
```
Now, RedditService and RedditPost do not exist yet, so Xcode should be super red. That's fine. Let's take a look at that code we just added:
- `it` is what we use for each expectation. It is a function that takes a string to say what you are expecting and a block to make your expectations in.
- `RedditService* service = [[RedditService alloc] init];` Let's start with the *. Everything in objective-c is a pointer, unless it's a primitive type. So, we'll get a pointer to the RedditService we're making. `alloc` is the first message we'll send to the RedditService class, which literally allocates memory for it. `init` initializes it into a thing we can use. Also, everything in objective-c ends with a semi-colon.
- `__block NSArray* posts;` We're making a local varible called `posts` of type `NSArray`. Since it's not a primitive type, it will also need *. We're not initializing it to a value, so it's initial value is `nil`, which is an object that can be sent messages but will not respond to them. We're using `__block` (yup, two underscores) for scoping. Normally, a variable is not available for modification to lower scopes, so we must use that keyword to allow the variable to be modified in the following block.
- ```
[service getPosts:^(NSArray* returnedPosts){
  posts = returnedPosts;
}];
```
There's that funky block syntax again. Don't worry, it never gets better, it only gets worse. :D We'll be using an asynchronous library to get our reddit posts, so we need to pass a callback to the `getPosts:` message. The stuff in the parenthesis are the arguments we'll get back.
-
```
RedditPost* expectedPost = [[RedditPost alloc] init];
[expectedPost setTitle: @"a post!"];
NSArray* expectedPosts = @[ expectedPost ];
```
Using the shorthand syntax we talked about, we'll create an array of one RedditPost with the title we expect to get back, based on the data we stubbed into OHHTTPStubs.
- `[[expectFutureValue(posts) shouldEventually] equal:expectedPosts];` Using Kiwi's asynchoronous testing features, we're saying that at some point in the near future, `posts` will equal `expectedPosts`.
- We don't need to run our tests to know that they will not pass; there's red all over the place! So let's get the skeleton of RedditService in place.
- Right click on the `Reddit` folder and select `New File`
- Select the `iOS` category and then `Cocoa Touch Class` as your template.
- The name of our class will be `RedditService`. It should be a subclass of `NSObject` and the language should still be `Objective-C`
- When you save the file, take the defaults, and note that only the `Reddit` target is selected.
- This will create a header file and an implementation file.
- Follow the same steps to create the RedditPost class.
- If you go back to the Spec file, you should see that it is much less red, but still doesn't know what message selectors you're talking about. (A hint: using `Cmd+Shift+o` allows you to open a file)
- So let's add those message selector definitions to our header files:
- In `RedditService.h` between `@interface RedditService : NSObject` and `@end`:
```
-(void)getPosts:(void (^)(NSArray *))callback;
```
- In `RedditPost.h` between `@interface RedditPost : NSObject` and `@end`:
```
@property (strong, nonatomic) NSString* title;
```
- Let's peel those apart real quick. First things first, the inclusion of these definitions in the header file means these are publicly accessible.
- `-(void)getPosts:(void (^)(NSArray *))callback;` The dash means this is an instance method as opposed to a class method. If we wanted that, we could use `+` instead. But we don't. :D `(void)` is the return type of our selector. It doesn't return anything. `getPosts:` is our message selector. We will look at more complex ones later on, but this one only takes one parameter. `(void (^)(NSArray *))callback` is even more funky block syntax. Remember when I said it gets worse? This is two of four ways we have to remember to write block definitions. For a fun reference: [http://fuckingblocksyntax.com]. In a message selector, the type of a parameter always goes in parenthesis, and the name of that parameter comes after. So the name of this parameter is `callback`, and it is a block. That block returns nothing and takes an NSArray parameter. Fun, right?!
- `@property (strong, nonatomic) NSString* title;` `@property` means that `title` will be a property on the class. This means that it can be read or written using dot syntax (`post.title = @"stuff";`, `NSString *thinger = post.title;`) as well as with square brackets (`[post setTitle:@"stuff"];`, `NSString *thinger = [post title];`). `(strong, nonatomic)` means that RedditPost instances will have a strong reference to the title (it won't just disappear) and also that it is nonatomic (I don't remember what that means, lol). The rest of that line should make sense to you.
- Now, we need to implement the message selector for RedditService. In `RedditService.m`. Between `@implementation RedditService` and `@end`:
```
-(void)getPosts:(void (^)(NSArray *))callback {
}
```
It matches the definition in the header file, but has `{}` in place of `:`.
- If you head back to your spec file, you should see no more red! Yay! Run your specs with `Cmd+Shift+u`. You should see that the build succeeds and then the test fails. Good old Xcode. It's not technically wrong, but semantically, bleh.
- Commit your work (I know, even with a failing test) and let's move on to the next step.
