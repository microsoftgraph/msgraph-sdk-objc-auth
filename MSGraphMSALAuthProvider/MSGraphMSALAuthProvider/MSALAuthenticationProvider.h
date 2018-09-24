//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//
#import <Foundation/Foundation.h>
#import <MSAL/MSAL.h>
#import <MSGraphCoreSDK/MSGraphCoreSDK.h>

@interface MSALAuthenticationProvider : NSObject<MSAuthenticationProvider>

-(id)initWithPublicClientApplication:(MSALPublicClientApplication *)publicClientApplication andScopes:(NSArray *)scopes;

@end
