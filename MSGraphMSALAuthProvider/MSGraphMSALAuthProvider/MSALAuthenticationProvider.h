//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//
#import <Foundation/Foundation.h>
#import <MSAL/MSAL.h>
#import <MSGraphClientSDK/MSGraphClientSDK.h>
#import "MSALAuthenticationProviderOptions.h"

/*
 This class provides concrete implementation for MSAuthenticationProvider protocol defined in MSGraphClientSDK and handles subsequent authentication token fetching via MSAL.
 */

@interface MSALAuthenticationProvider : NSObject<MSAuthenticationProvider>

/*
 This method creates and returns an instance of MSALAuthenticationProvider with provided parameters.
 @param publicClientApplication An MSALPublicClientApplication instance from MSAL.
 @param providerOptions An MSALAuthenticationProviderOptions instance containing required options for MSALAuthentictionProvider.
 @return An instance of MSALAuthenticationProvider with provided values.
 */
- (instancetype)initWithPublicClientApplication:(MSALPublicClientApplication *)publicClientApplication andOptions:(MSALAuthenticationProviderOptions *)providerOptions;

@end
