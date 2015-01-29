- Open Xcode, select `Create a new project`
- Choose `Single View Application` under iOS -> Application
- Fill in a Product Name, without spaces. For this exercise let's just use `Reddit`
- Your organization name is probably filled in as your name, but if not, just put it there
- Your organization identifier is used for namespacing and code signing. It takes the form of `com.blah` or `org.thing` and makes your bundle identifier `com.blah.Reddit` or `org.thing.Reddit`
- For this exercise, we'll use objective-c, so make sure that's set as the language before continuing
- Xcode automatically made you a git repo and folder with the name of Reddit wherever you chose to save it. It aslo added two targets; one for  your app and one for the tests of your app. It also comes with a test file which uses XCTest called `RedditTests.m`. You can go ahead and delete that test file it made for you.
- On the command line or in your favorite editor, make a file called `Podfile` at the root of your project directory
- In your new Podfile, paste the following:
```
platform :ios, '8.1'
```
And save it.
- Head out to your command line and change into the `Reddit` directory
- You will probably need to install cocoapods, so on your command line, type `gem install cocoapods`
- Once it is installed, you'll need to run `pod setup`
- Once that completes successfully, you can type `pod install`. This will have cocoapods make you a Reddit.xcworkspace file that knows how to use cocoapods dependencies.
- Close the Reddit project in Xcode, and open `Reddit.xcworkspace`
- Run your blank app by selecting `Cmd+r`. This should launch the simulator with a splash screen that says "Reddit".
- Congrats, you have a template with cocoapods to move forward with!
- Before we commit, let's create a .gitignore file that looks like this:
```
.DS_Store
Pods
Podfile.lock
xcuserdata/
```
- Now let's add all the things to our git staging area, commit, and move to the next step.
