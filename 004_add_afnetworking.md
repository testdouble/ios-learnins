- This is an easy one. Head over to your Podfile and make it look like this:
```
platform :ios, '8.1'

pod 'AFNetworking'

target :RedditTests do
  pod 'Kiwi'
  pod 'OHHTTPStubs'
end
```
- `pod install` on the command line, and you'll have AFNetworking, @mattt's fabulous networking library.
- Commit your progress and let's move on to the next step.
