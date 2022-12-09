# 适用于 Objective C 的 MSAL 身份验证提供程序
此客户端库是候选发布版本，并且仍处于预览状态；在我们对生产支持的库进行迭代时，请继续提供反馈。

此库提供了 MSAuthenticationProvider 的实施方案，因此可以使用[适用于 ObjC 的 Microsoft Graph SDK](https://github.com/microsoftgraph/msgraph-sdk-objc) 加快开发进程

注意：此库目前仅支持 iOS 平台。在未来版本中将提供 MacOS 支持。

## 安装

### 使用 CocoaPods

可使用 [CocoaPods](https://cocoapods.org/) 来保持最新版本。在配置文件中包含下列行：
  ``` 
   pod 'MSGraphMSALAuthProvider'
  ```


### 使用 Carthage


还可以选择使用 [Carthage](https://github.com/Carthage/Carthage) 管理程序包。



1. 使用网站中的下载内容或使用 Homebrew `brew install carthage` 将 Carthage 安装到 Mac 上。

2. 必须创建一个 `Cartfile`，用于在 Github 上列出此项目的 MSGraphMSALAuthProvider 库。



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. 运行 `carthage update`。此代码将把依赖项提取到 `Carthage/Checkouts` 文件夹，然后生成库。

4. 在应用程序目标的“常规”设置选项卡上的“链接的框架和库”部分，将磁盘上的 `Carthage/Build` 文件夹中的 `MSGraphMSALAuthProvider.framework` 拖放到此处。

5. 在应用程序目标的“生成阶段”设置选项卡上，单击“+”图标并选择“新建运行脚本阶段”。创建指定 Shell 的“运行脚本”（例如：`/bin/sh`），添加下列内容至 Shell 下方脚本区：



```sh

/usr/local/bin/carthage copy-frameworks

```



并添加路径至希望在 “Input Files” 下使用的框架，如：



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

此脚本解决通用二进制文件触发的 [App Store 提交 bug](http://www.openradar.me/radar?id=6409498411401216)，并保证存档时复制所需的位代码相关文件和 dSYMs。



调试信息复制至构建产品目录中时，无论何时在断点停止，都能同步堆栈跟踪。这将能够让你在调试程序中逐步完成第三方代码。



存档应用程序以提交至 App Store 或 TestFlight 时，Xcode 还将复制这些文件至 应用程序的 `.xcarchive` 捆绑包的 dSYMs 子目录中。

## 先决条件

此库有两个依赖项，它们都有各自的特定用途：

1. [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)：添加此依赖项的目的是应对所有特定于身份验证的场景。
    
2. [MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc)：添加此依赖项的目的是从 MSGraphClientSDK 选取 MSAuthenticationProvider 协议，以便 MSGraphClientSDK 能够与此库进行通信，从而获取所需令牌。
        
因此，为了使用此库，也必须在项目中添加上述两个框架。

## 如何使用

假设你已完成以上步骤并添加了所需的框架或 Pod，你的项目现在将具备所有必要条件。

因此，现在只需按照以下步骤操作：

1. 根据此处提供的说明 ([MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)) 创建 `MSALPublicClientApplication` 类的实例。请确保按照 MSAL 自述文件中提到的其他步骤来正确创建此实例。它可能如下所示：
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. 创建 `MSALAuthenticationProviderOptions` 的实例，如下所示：
```
MSALAuthenticationProviderOptions *authProviderOptions= [[MSALAuthenticationProviderOptions alloc] initWithScopes:<array-of-scopes-for-which-you-need-access-token>];
``` 

3. 使用前面步骤中创建的 `MSALPublicClientApplication` 和 `MSALAuthenticationProviderOptions ` 实例，按以下方式创建 `MSALAuthenticationProvider` 的实例：
```
 MSALAuthenticationProvider *authProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:publicClientApplication andOptions:authProviderOptions];
```
现在便有了一个实例，这个实例遵循 MSAuthenticationProvider 协议，并配置了 MSALPublicClientApplication 实例，可以应对多种身份验证场景。
 
 3. 现在，可以将此 authenticationProvider 与 MSGraphClientSDK 结合使用，从而对 Microsoft Graph 服务器进行经过身份验证的网络调用。请转到[如何使用 MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk) 了解具体使用方法。
 
现在，你已经万事俱备了。 
