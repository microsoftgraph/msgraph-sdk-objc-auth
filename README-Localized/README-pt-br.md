# Provedor de autenticação MSAL para Objective-C
Essa biblioteca de clientes é uma candidata a versão e ainda está no status de versão prévia. Continue a fornecer comentários enquanto iteramos a fim de fornecer uma biblioteca com suporte para produção.

Esta biblioteca fornece a implementação de MSAuthenticationProvider que podem ser usado para começar a desenvolver com o [SDK do Microsoft Graph para ObjC](https://github.com/microsoftgraph/msgraph-sdk-objc)

Observação: no momento, esta biblioteca tem suporte apenas para a plataforma iOS. O suporte para MacOS será fornecido em futuras versões.

## Instalação

### Usando o CocoaPods

Você pode usar o [CocoaPods](https://cocoapods.org/) para se manter atualizado com a versão mais recente. Inclua a seguinte linha no seu podfile:
  ``` 
   pod 'MSGraphMSALAuthProvider'
  ```


### Usando o Carthage


Você também pode optar por usar o [Carthage](https://github.com/Carthage/Carthage) no gerenciamento de pacotes.



1. Instale o Carthage no Mac baixando do site ou, se estiver usando o Homebrew, use `brew install carthage`.

2. Você deve criar um `Cartfile` que lista a biblioteca MSGraphMSALAuthProvider desse projeto no Github.



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. Execute `carthage update`. Este comando busca dependências na pasta `Carthage/Checkouts` e cria a biblioteca.

4. Na guia das configurações "Gerais" do destino do aplicativo, na seção "Estruturas e Bibliotecas Vinculadas", arraste e solte o `MSGraphMSALAuthProvider.framework` da pasta `Carthage/Build` no disco.

5. Na guia de configurações "Fases do Build" do destino do aplicativo, clique no ícone "+" e escolha "Nova Fase de Script de Execução". Crie um Script de Execução no qual você especifica o shell (por exemplo, `/bin/sh`); adicione o seguinte conteúdo à área de script abaixo do shell:



```sh

/usr/local/bin/carthage copy-frameworks

```



e adicione os caminhos para as estruturas que você deseja usar em "arquivos de entrada", como, por exemplo:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

Este script funciona em torno de um [Bug de envio da App Store](http://www.openradar.me/radar?id=6409498411401216) acionado por binários universais e garante que os arquivos necessários relacionados a BitCode e dSYMs sejam copiados durante o arquivamento.



Com as informações de depuração copiadas no diretório de produtos criados, o Xcode poderá simbolizar o rastreamento da pilha sempre que você parar em um ponto de interrupção. Isso também permitirá que você percorra o código de terceiros no depurador.



Ao arquivar o aplicativo para envio para a App Store ou TestFlight, o Xcode também copia esses arquivos no subdiretório dSYMs do pacote `.xcarchive` do aplicativo.

## Pré-requisitos

Essa biblioteca tem duas dependências que atendem às suas finalidades específicas:

1. [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) Essa dependência foi adicionada para lidar com todos os cenários específicos de autenticação.
    
2. [MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc) Essa dependência foi adicionada para selecionar o protocolo MSAuthenticationProvider do MSGraphClientSDK para que o MSGraphClientSDK possa se comunicar com essa biblioteca para obter o token necessário.
        
Portanto, para usar essa biblioteca, você também terá que adicionar as duas estruturas acima ao seu projeto.

## Como usar

Supondo que você tenha acompanhado as etapas acima e adicionado as estruturas ou pods necessários, agora seu projeto terá tudo que precisa.

Agora você só precisa seguir as etapas abaixo:

1. Crie uma instância da classe `MSALPublicClientApplication` de acordo as instruções fornecidas aqui [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc). Execute as outras etapas mencionadas no Leiame do MSAL para criar corretamente essa instância. Ela deve se parecer com o seguinte:
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. Crie uma instância de `MSALAuthenticationProviderOptions` como abaixo:
```
MSALAuthenticationProviderOptions *authProviderOptions= [[MSALAuthenticationProviderOptions alloc] initWithScopes:<array-of-scopes-for-which-you-need-access-token>];
``` 

3. Crie uma instância de `MSALAuthenticationProvider` na forma abaixo usando as instâncias `MSALPublicClientApplication` e `MSALAuthenticationProviderOptions` que você criou nas etapas anteriores:
```
 MSALAuthenticationProvider *authProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:publicClientApplication andOptions:authProviderOptions];
```
Agora você tem uma instância que segue o protocolo MSAuthenticationProvider e está configurada com uma instância MSALPublicClientApplication para gerenciar cenários de autenticação.
 
 3. Agora você pode usar esse authenticationProvider em conjunto com o MSGraphClientSDK para fazer chamadas de rede autenticadas para o servidor do Microsoft Graph. Confira como você pode usá-lo em [Como usar o MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk).
 
Agora tudo já deve estar em funcionamento. 
