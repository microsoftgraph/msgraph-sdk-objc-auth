# Proveedor de autenticación de MSAL para Objetive-C
Esta biblioteca cliente es una versión candidata para lanzamiento y todavía está en estado de versión preliminar. Siga proporcionando comentarios a medida que iteramos hacia una biblioteca compatible con la producción.

Esta biblioteca proporciona la implementación de MSAuthenticationProvider que puede usarse para iniciar el desarrollo con el [SDK de Microsoft Graph para ObjC](https://github.com/microsoftgraph/msgraph-sdk-objc)

Nota: Actualmente, esta biblioteca solo es compatible con la plataforma iOS. La compatibilidad con MacOS se proporcionará en una versión futura.

## Instalación

### Usar CocoaPods

Puede usar [CocoaPods](https://cocoapods.org/) para mantenerse actualizado con la versión más reciente. Incluya la siguiente línea en su podfile:
  ``` 
   pod 'MSGraphMSALAuthProvider'
  ```


### Usar Carthage


También puede optar por usar [Carthage](https://github.com/Carthage/Carthage) para administrar paquetes.



1. Instale Carthage en su Mac con una descarga desde el sitio web o si usa el Homebrew `brew install carthage`.

2. Debe crear un `Cartfile` que enumere la biblioteca MSGraphMSALAuthProvider para este proyecto en Github.



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. Ejecute `carthage update`. Esto recuperará las dependencias en una carpeta `Carthage/Checkouts` y después, compilará la biblioteca.

4. En la pestaña de configuración "General" de destino de la aplicación, en la sección "Marcos y bibliotecas vinculadas", arrastre y coloque el `MSGraphMSALAuthProvider.framework` desde la carpeta `Carthage/Build` en el disco.

5. En la pestaña de configuración "Fases de compilación" de destino de la aplicación, haga clic en el icono "+" y elija "Nueva fase de ejecución de script". Cree un Script de ejecución en el que especifique el shell (ej.: `/bin/sh`), agregue el siguiente contenido en el área de script debajo del shell:



```sh

/usr/local/bin/carthage copy-frameworks

```



y agregue las rutas de acceso a los marcos que desea usar en "Archivos de entrada", por ejemplo:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

Este script funciona alrededor de un [Error de envío de la App Store](http://www.openradar.me/radar?id=6409498411401216) desencadenado por archivos binarios universales y garantiza que los archivos relacionados con bitcode y los dSYMs necesarios se copien al archivar.



Con la información de depuración copiada en el directorio de productos compilados, Xcode podrá resolver símbolos en el seguimiento de pila cuando se detenga en un punto de interrupción. Esto también le permite desplazarse por el código de terceros en el depurador.



Al archivar la aplicación para enviarla a la App Store o TestFlight, Xcode también copiará estos archivos en el subdirectorio dSYMs del paquete `.xcarchive` de la aplicación.

## Requisitos previos

Esta biblioteca tiene dos dependencias que sirven a su propio propósito específico:

1. [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)Esta dependencia se ha agregado para administrar todos los Escenarios específicos de autenticación.
    
2. [MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc) Esta dependencia se ha agregado para seleccionar el protocolo MSAuthenticationProvider desde MSGraphClientSDK para que MSGraphClientSDK pueda comunicarse con esta biblioteca para obtener el token necesario.
        
Por lo tanto, para usar esta biblioteca, también tendrá que agregar los dos marcos anteriores en su proyecto.

## Cómo se usa

Suponiendo que ha seguido los pasos anteriores y ha agregado los marcos de trabajo o pods requeridos, el proyecto ahora tendrá todo lo que necesita.

Así que, ahora solo debe seguir los pasos que se indican a continuación:

1. Cree una instancia de clase `MSALPublicClientApplication` según las instrucciones proporcionadas aquí [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc). Asegúrese de seguir otros pasos descritos en el archivo readme de MSAL para crear correctamente esta instancia. Podría ser parecido al siguiente ejemplo:
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. Cree una instancia de `MSALAuthenticationProviderOptions` como se muestra a continuación:
```
MSALAuthenticationProviderOptions *authProviderOptions= [[MSALAuthenticationProviderOptions alloc] initWithScopes:<array-of-scopes-for-which-you-need-access-token>];
``` 

3. Cree una instancia de `MSALAuthenticationProvider` de la siguiente forma, mediante las instancias`MSALPublicClientApplication` y `MSALAuthenticationProviderOptions` que creó en los pasos anteriores:
```
 MSALAuthenticationProvider *authProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:publicClientApplication andOptions:authProviderOptions];
```
Ahora tiene una instancia que sigue el protocolo de MSAuthenticationProvider y está configurada con una instancia MSALPublicClientApplication para administrar escenarios de autenticación.
 
 3. Ahora puede usar este authenticationProvider junto con MSGraphClientSDK para realizar llamadas de red autenticadas al servidor de Microsoft Graph. Vaya a [Cómo usar MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk) para obtener información sobre cómo puede usar esto.
 
Por ahora, tendrá todo en funcionamiento. 
