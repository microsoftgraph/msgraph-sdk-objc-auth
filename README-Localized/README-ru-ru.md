# Поставщик проверки подлинности MSAL для Objective-C
Эта клиентская библиотека является релиз-кандидатом и все еще доступна только в предварительной версии. Продолжайте оставлять отзывы, пока мы работаем над созданием версии для рабочей среды.

Эта библиотека предоставляет реализацию MSAuthenticationProvider, с помощью которой можно быстро приступить к разработке с использованием [пакета SDK Microsoft Graph для ObjC](https://github.com/microsoftgraph/msgraph-sdk-objc).

Примечание. В настоящее время эта библиотека поддерживает только платформу iOS. Поддержка MacOS появится в будущем выпуске.

## Установка

### Использование CocoaPods

Вы можете использовать [CocoaPods](https://cocoapods.org/), чтобы обеспечить актуальность установленной версии. Включите в свой профиль следующую строку:
  ``` 
   pod 'MSGraphMSALAuthProvider'
  ```


### Использование Carthage


Вы также можете использовать [Carthage](https://github.com/Carthage/Carthage) для управления пакетами.



1. Чтобы установить Carthage на компьютере Mac, скачайте программу с официального веб-сайта, а если используется Homebrew, выполните команду `brew install carthage`.

2. На сайте Github необходимо создать для этого проекта файл `Cartfile`, в котором указана библиотека MSGraphMSALAuthProvider.



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. Выполните команду `carthage update`. Эта команда извлечет зависимости в папку `Carthage/Checkouts`, а затем выполнит сборку библиотеки.

4. На вкладке настроек "Общие" для целевого приложения найдите раздел "Связанные платформы и библиотеки" и перетащите файл `MSGraphMSALAuthProvider.framework` из папки `Carthage/Build` на диске.

5. На вкладке настроек "Этапы сборки" для целевого приложения нажмите значок "+" и выберите команду "Новый этап сценария выполнения". Создайте сценарий запуска, в котором указана оболочка (пример: `/bin/sh`), и добавьте следующий текст в область сценария под оболочкой:



```sh

/usr/local/bin/carthage copy-frameworks

```



Затем добавьте пути к платформам, которые требуется использовать, в раздел "Входные файлы", например:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

Этот сценарий помогает избежать [ошибки отправки в App Store](http://www.openradar.me/radar?id=6409498411401216), которую вызывают универсальные двоичные файлы, и обеспечивает копирование необходимых файлов, связанных с Bitcode, и dSYM при архивации.



После копирования отладочной информации в каталог собранных продуктов Xcode сможет выражать символами трассировку стека при достижении точек останова. Это также даст вам возможность пошагового выполнения стороннего кода в отладчике.



При архивации приложения для отправки в App Store или TestFlight среда Xcode также скопирует эти файлы в подкаталог dSYMs пакета `.xcarchive` для вашего приложения.

## Необходимые компоненты

У этой библиотеки есть две зависимости, каждая из которых предназначена для определенной цели:

1. [MSAL.](https://github.com/AzureAD/microsoft-authentication-library-for-objc) Эта зависимость была добавлена для обработки всех сценариев, связанных с проверкой подлинности.
    
2. [MSGraphClientSDK.](https://github.com/microsoftgraph/msgraph-sdk-objc) Эта зависимость была добавлена для выбора протокола MSAuthenticationProvider из MSGraphClientSDK, чтобы пакет MSGraphClientSDK мог взаимодействовать с этой библиотекой для получения необходимого токена.
        
Таким образом, чтобы использовать библиотеку, вам также потребуется добавить в проект две вышеуказанные платформы.

## Применение

При условии, что вы прошли вышеуказанные этапы и добавили необходимые платформы или объекты pod, ваш проект теперь будет содержать все необходимое.

Теперь вам осталось только выполнить указанные ниже действия.

1. Создайте экземпляр класса `MSALPublicClientApplication` согласно инструкциям, представленным на странице [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc). Чтобы правильно создать этот экземпляр, следуйте инструкциям из файла Readme для MSAL. Он может выглядеть так:
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. Создайте экземпляр `MSALAuthenticationProviderOptions`, как показано ниже.
```
MSALAuthenticationProviderOptions *authProviderOptions= [[MSALAuthenticationProviderOptions alloc] initWithScopes:<array-of-scopes-for-which-you-need-access-token>];
``` 

3. Создайте экземпляр `MSALAuthenticationProvider`, как показано ниже, используя экземпляры `MSALPublicClientApplication` и `MSALAuthenticationProviderOptions`, созданные на предыдущих этапах.
```
 MSALAuthenticationProvider *authProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:publicClientApplication andOptions:authProviderOptions];
```
Теперь у вас есть экземпляр, использующий протокол MSAuthenticationProvider и настроенный с экземпляром MSALPublicClientApplication для обработки сценариев с проверкой подлинности.
 
 3. Теперь вы можете использовать этот объект authenticationProvider в сочетании с MSGraphClientSDK, чтобы отправлять сетевые вызовы с проверкой подлинности на сервер Microsoft Graph. Соответствующие инструкции представлены в статье [Как использовать MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk).
 
На данный момент у вас все настроено и готово к работе. 
