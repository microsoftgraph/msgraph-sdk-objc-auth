//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import <MSGraphClientSDK/MSGraphClientSDK.h>

/*
 This class provides concrete implementation for MSAuthenticationProviderOptions protocol and options mechanism to control the behaviour of Authentication Provider.
 */

@interface MSALAuthenticationProviderOptions : NSObject<MSAuthenticationProviderOptions>

/*
 This method creates and returns an instance of MSALAuthenticationProviderOptions
 @param scopeArray The scopes for which the token will be acquired.
 */
- (instancetype)initWithScopes:(NSArray<NSString *> *)scopeArray;

@end
