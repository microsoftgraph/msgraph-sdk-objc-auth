# MSAL Authentication Provider for Objective C
This client library is a release candidate and is still in preview status - please continue to provide feedback as we iterate towards a production supported library.

This library provides implementation of MSAuthenticationProvider that can be used to jump-start development with the [Microsoft Graph SDK for ObjC](https://github.com/microsoftgraph/msgraph-sdk-objc)

## Installation


### Using Carthage



We use [Carthage](https://github.com/Carthage/Carthage) for package management during the preview period. This package manager integrates very nicely with XCode while maintaining our ability to make changes to the library.



1. Install Carthage on your Mac using a download from their website or if using Homebrew `brew install carthage`.

2. You must create a `Cartfile` that lists the MSGraphMSALAuthProvider library for this project on Github.



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. Run `carthage update`. This will fetch dependencies into a `Carthage/Checkouts` folder, then build the MSGraphCoreSDK library.

4. On your application target's “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop the `MSGraphMSALAuthProvider.framework` from the `Carthage/Build` folder on disk.

5. On your application target's “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script in which you specify your shell (ex: `/bin/sh`), add the following contents to the script area below the shell:



```sh

/usr/local/bin/carthage copy-frameworks

```



and add the paths to the frameworks you want to use under “Input Files”, e.g.:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

This script works around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) triggered by universal binaries and ensures that necessary bitcode-related files and dSYMs are copied when archiving.



With the debug information copied into the built products directory, Xcode will be able to symbolicate the stack trace whenever you stop at a breakpoint. This will also enable you to step through third-party code in the debugger.



When archiving your application for submission to the App Store or TestFlight, Xcode will also copy these files into the dSYMs subdirectory of your application’s `.xcarchive` bundle.

## Prerequisites

This library has two submodules both serving their own specific purpose:

1. [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)
        This submodule has been added to handle all the Authentication specific scenarios.
    
2. [MSGraphCoreSDK](https://github.com/microsoftgraph/msgraph-sdk-objc)
        This submodule has been added to pick the MSAuthenticationProvider protocol from MSGraphCoreSDK so that MSGraphCoreSDK can communicate with this library to get the required token.
        
So in order to use this library, you will have to add above two frameworks as well in your project.

## How to use

Assuming you have gone through above steps and added the required frameworks, your project will now have all the three frameworks integrated in it.

So now you just need to follow below steps:

1. Create an instance of MSALPublicClientApplication class as per the instructions provided here [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc). Make sure you follow other steps mentioned in MSAL readme in order to properly create this instance.It might look like below:
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. Create an instance of MSALAuthenticationProvider in below fashion:
```
MSALAuthenticationProvider *authenticationProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:application andScopes:<array-of-scopes-for-which-you-need-access-token>];
```
  You now have an instance which follows MSAuthenticationProvider protocol and is configured with an MSALPublicClientApplication instance to handle authentication scenarios.
 
 3. Now you can use this authenticationProvider in conjunction with MSGraphCoreSDK to make authenticated network calls to Microsoft Graph server. Head over to [How to use MSGraphCoreSDK](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk) to see how you can use this.
 
By now, you will have everything up and running. 
