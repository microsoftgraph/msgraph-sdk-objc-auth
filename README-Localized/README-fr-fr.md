# Fournisseur d’authentification MSAL pour Objective C
Cette bibliothèque cliente est une version finale et se présente encore en état aperçu. Nous vous invitons à nous envoyer vos commentaires au fur et à mesure de l'itération vers une bibliothèque prise en charge par la production.

Cette bibliothèque fournit une implémentation de MSAuthenticationProvider qui peut être utilisé pour démarrer le développement avec le [Kit de développement logiciel (SDK) Microsoft Graph pour ObjC](https://github.com/microsoftgraph/msgraph-sdk-objc)

Remarque : Cette bibliothèque prend actuellement en charge la plateforme iOS uniquement. La prise en charge de MacOS sera fournie dans une version ultérieure.

## Installation

### Utilisation de CocoaPods

Vous pouvez utiliser [CocoaPods](https://cocoapods.org/) pour rester informé sur la dernière version. Incluez la ligne suivante dans votre podfile :
  ``` 
   pod 'MSGraphMSALAuthProvider'
  ```


### Utilisation de Carthage


Vous pouvez également choisir de recourir à [Carthage](https://github.com/Carthage/Carthage) pour la gestion des packages.



1. Installez Carthage sur votre Mac à l’aide d’un téléchargement à partir de leur site web, ou si vous utilisez Homebrew `brew install Carthage`.

2. Vous devez créer un `cartfile` qui répertorie la bibliothèque MSGraphMSALAuthProvider pour ce projet sur GitHub.



```

github "microsoftgraph/msgraph-sdk-objc-auth" "tags/<latest_release_tag>"

```



3. Exécutez la `mise à jour carthage`. Elle récupère les dépendances dans un dossier `Carthage/Checkouts`, puis génère la bibliothèque.

4. Sous l’onglet de Paramètres « Général » de votre cible d'application, dans la section « Bibliothèques et infrastructures liées », faites glisser et déposez le `MSGraphMSALAuthProvider.framework` à partir du dossier `Carthage/Build` sur le disque.

5. Dans l’onglet de Paramètres « Phases de Build » de la cible d'application, cliquez sur l’icône « + », puis sélectionnez « Nouvelle phase d'exécution du script ». Créez un Script d'exécution dans lequel vous spécifiez votre interpréteur de commandes (par exemple, `/bin/sh`), ajoutez le contenu suivant à la zone de script sous l’interpréteur :



```sh

/usr/local/bin/carthage copy-frameworks

```



et ajoutez les chemins d’accès aux infrastructures que vous voulez utiliser sous « Fichiers d’entrée », par ex. :



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphMSALAuthProvider.framework

```

Ce script se consacre au [bogue de soumission App Store,](http://www.openradar.me/radar?id=6409498411401216) déclenché par des fichiers binaires universels et vous permet de vous assurer que les fichiers liés au bitcode et les dSYMs nécessaires sont copiés lors de l’archivage.



Une fois les informations de débogage copiées dans l’annuaire des produits built, Xcode pourra générer des symboles d'arborescence des appels de procédure chaque fois que vous vous arrêtez à un point d’arrêt. Cela vous permet également de parcourir le code tiers dans le débogueur.



Lors de l’archivage de votre application à des fins de soumission vers l’App Store ou le TestFlight, Xcode copiera également ces fichiers dans le sous-répertoire dSYMs du groupe `.xcarchive` de l'application.

## Conditions préalables

Cette bibliothèque a deux dépendances ayant une finalité spécifique :

1. [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) cette dépendance a été ajoutée pour gérer tous les scénarios propres à l’Authentification.
    
2. [MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc) cette dépendance a été ajoutée pour sélectionner le protocole MSAuthenticationProvider de MSGraphClientSDK de sorte que MSGraphClientSDK puisse communiquer avec cette bibliothèque pour obtenir le jeton nécessaire.
        
Pour pouvoir utiliser cette bibliothèque, vous devez donc également ajouter au-dessus deux infrastructures dans votre projet.

## Utilisation

En supposant que vous avez suivi les étapes ci-dessus et ajouté les infrastructures ou pods requis, votre projet dispose désormais des informations nécessaires.

Il vous suffit de suivre maintenantn les étapes ci-dessous :

1. Créez une instance de classe `MSALPublicClientApplication` conforme aux instructions fournies ici [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc). Assurez-vous de suivre les autres étapes décrites dans MSAL Readme pour créer correctement cette instance. Elle peut ressembler à ceci :
```
NSError *error = nil;
MSALPublicClientApplication *application =
[[MSALPublicClientApplication alloc] initWithClientId:@"<your-client-id-here>"
error:&error];
```
2. Créez une instance de `MSALAuthenticationProviderOptions` comme suit :
```
MSALAuthenticationProviderOptions *authProviderOptions= [[MSALAuthenticationProviderOptions alloc] initWithScopes:<array-of-scopes-for-which-you-need-access-token>];
``` 

3. Créez une instance de `MSALAuthenticationProvider` comme décrite ci-dessous à l’aide des instances `MSALPublicClientApplication` et `MSALAuthenticationProviderOptions` que vous avez créées dans les étapes précédentes :
```
 MSALAuthenticationProvider *authProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:publicClientApplication andOptions:authProviderOptions];
```
Vous disposez à présent d’une instance qui suit le protocole MSAuthenticationProvider et qui est configurée avec une instance MSALPublicClientApplication pour gérer les scénarios d’authentification.
 
 3. Vous pouvez désormais utiliser ce authenticationProvider conjointement avec MSGraphClientSDK pour établir des appels réseau authentifiés vers Microsoft Graph Server. Consultez la rubrique [Utiliser MSGraphClientSDK](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk) pour voir comment vous pouvez l’utiliser.
 
À ce stade, tout est prêt pour bien commencer. 
