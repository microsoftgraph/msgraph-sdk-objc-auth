# Objective C 用 MSAL 認証プロバイダ
このクライアント ライブラリはリリース候補であり、まだプレビューの状態にあります。運用環境でサポートされるライブラリを目標としておりますので、引き続きフィードバックをご提供ください。

このライブラリは、[ObjC 用 Microsoft Graph SDK](https://github.com/microsoftgraph/msgraph-sdk-objc) で開発を開始するために使用可能な MSAuthenticationProvider の実装を提供します

注:このライブラリは現在、iOS プラットフォームのみをサポートしています。MacOS サポートは将来のリリースで提供される予定です。

## インストール

### CocoaPods を使う

[CocoaPods](https://cocoapods.org/) を使用すれば、最新バージョンを使用して最新の状態に保つことができます。ポッドファイルに次の行を含めます:
  ``` 
   pod 'MSGraphMSALAuthProvider'
  ```


### Carthage を使う


パッケージ管理に [Carthage](https://github.com/Carthage/Carthage) を使用することもできます。



1. Mac に Carthage をインストールするには、Web サイトからダウンロードするか、Homebrew を使用している場合には `brew install carthage` を使用します。

2. Github でこのプロジェクトの MSGraphMSALAuthProvider ライブラリを一覧表示する `Cartfile` を作成する必要があります。



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. `carthage update` を実行します。このコマンドは依存性を取り出して `Carthage/Checkouts` フォルダーに入れ、ライブラリをビルドします。

4. アプリケーション ターゲットの \[全般] 設定タブの \[リンクされたフレームワークとライブラリ] セクションで、`MSGraphMSALAuthProvider.framework` をディスク上の `Carthage/Build` フォルダーからドラッグアンドドロップします。

5. アプリケーション ターゲットの \[ビルド フェーズ] 設定タブで、\[+] アイコンをクリックして \[新規スクリプト実行フェーズ] を選択します。シェル (例: `/bin/sh`) を指定して実行スクリプトを作成し、シェルの下のスクリプト領域に次のコンテンツを追加します。



```sh

/usr/local/bin/carthage copy-frameworks

```



使用するフレームワークへのパスを “入力ファイル” の下に追加します。例:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

このスクリプトは、ユニバーサル バイナリによってトリガーされる [App Store 提出バグ](http://www.openradar.me/radar?id=6409498411401216)を回避し、必要なビットコード関連ファイルおよび dSYM がアーカイブ時に確実にコピーされるようにします。



デバッグ情報が構築された製品ディレクトリにコピーされると、Xcode はブレークポイントで停止するたびにスタック トレースを記号化できます。これにより、デバッガーでサードパーティのコードをステップ実行することもできます。



App Store または TestFlight に提出するためにアプリケーションをアーカイブする場合、Xcode はこれらのファイルをアプリケーションの `.xcarchive` バンドルの dSYMs サブディレクトリにもコピーします。

## 前提条件

このライブラリには 2 つの依存関係があり、両方ともそれぞれの具体的な目的を果たします。

1. [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) この依存関係は、すべての認証固有のシナリオを処理するために追加されました。
    
2. [MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc) この依存関係は、MSGraphClientSDK がこのライブラリと通信して必要なトークンを取得できるように、MSGraphClientSDK から MSAuthenticationProvider プロトコルを選択するために追加されました。
        
したがって、このライブラリを使用するには、上記 2 つのフレームワークもプロジェクトに追加する必要があります。

## 使用方法

上記の手順を完了し、必要なフレームワークまたは Pod を追加したと仮定すると、プロジェクトには必要なものがすべて揃っているはずです。

そのため、次の手順に従う必要があります。

1. こちら [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) で提供されている手順に従って、`MSALPublicClientApplication` クラスのインスタンスを作成します。このインスタンスを適切に作成するには、MSAL の Readme に記載されているその他の手順に従っていることを確認してください。以下のようになります。
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. 以下のような `MSALAuthenticationProviderOptions` のインスタンスを作成します。
```
MSALAuthenticationProviderOptions *authProviderOptions= [[MSALAuthenticationProviderOptions alloc] initWithScopes:<array-of-scopes-for-which-you-need-access-token>];
``` 

3. 前の手順で作成した `MSALPublicClientApplication` および `MSALAuthenticationProviderOptions` インスタンスを使用して、以下の方法で `MSALAuthenticationProvider` のインスタンスを作成します。
```
 MSALAuthenticationProvider *authProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:publicClientApplication andOptions:authProviderOptions];
```
これで、MSAuthenticationProvider プロトコルに従い、認証シナリオを処理するために MSALPublicClientApplication インスタンスで構成されるインスタンスが作成されました。
 
 3. これで、この authenticationProvider を MSGraphClientSDK と併用して、Microsoft Graph サーバーへの認証済みネットワークの呼び出しを行うことができます。「[How to use MSGraphClientSDK (MSGraphClientSDK の使用方法)](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk)」に進み、使用方法を確認してください。
 
ここまでで、すべての準備および実行が完了しているはずです。 
