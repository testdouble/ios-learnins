- Open Podfile and add the following to the bottom of the file:
```
target :RedditTests do
  pod 'Kiwi'
  pod 'OHHTTPStubs'
end
```
- `Kiwi` is the spec-style testing library we'll be using.
- `OHHTTPStubs` is network request stubbing library, similar to webmock in ruby.
- The target bit tells cocoapods to only install those dependencies for your test target
- Head to your command line, making sure you're in the `Reddit` directory, and do `pod install`
- This tells cocoapods to go get your dependencies and install them. Sometimes Xcode gets confused and you need to close the project and reopen it, but it usually handles it just fine these days.
- Yay, we have some testing libraries! Let's commit that and move on to the next step.
