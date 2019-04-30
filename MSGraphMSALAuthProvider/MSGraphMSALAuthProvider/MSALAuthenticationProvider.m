//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSALAuthenticationProvider.h"

@interface MSALAuthenticationProvider()

@property(strong, nonatomic) MSALPublicClientApplication *publicClientApplication;

@property(strong, nonatomic) MSALAuthenticationProviderOptions *providerOptions;

@end

@implementation MSALAuthenticationProvider

- (id)initWithPublicClientApplication:(MSALPublicClientApplication *)publicClientApplication andOptions:(MSALAuthenticationProviderOptions *)providerOptions
{
    NSParameterAssert(publicClientApplication);
    NSParameterAssert(providerOptions);
    NSParameterAssert(providerOptions.scopesArray);

    self = [super init];
    if(self)
    {
        _publicClientApplication = publicClientApplication;
        _providerOptions = providerOptions;
    }
    return self;
}

- (void)getAccessTokenForProviderOptions:(id<MSAuthenticationProviderOptions>)authProviderOptions andCompletion:(void (^)(NSString *, NSError *))completion
{
    MSALAuthenticationProviderOptions *providerOptions = authProviderOptions;
    if(!providerOptions)
    {
        providerOptions = _providerOptions;
    }
    //Get the list of already logged in accounts.
    NSError *accountsAccessError;
    NSArray *accountsArray = [_publicClientApplication allAccounts:&accountsAccessError];
    if(accountsAccessError)
    {
        completion(nil, accountsAccessError);
        return;
    }

    //Check if there are any accounts available
    MSALAccount *firstAccount;
    if(accountsArray && accountsArray.count)
    {
        firstAccount = [accountsArray objectAtIndex:0];
    }

    if(firstAccount)
    {
        //If an account is available then silently acquire the token for the same and fire the completion
        [_publicClientApplication acquireTokenSilentForScopes:providerOptions.scopesArray
                                                      account:firstAccount
                                              completionBlock:^(MSALResult *result, NSError *error) {
                                                  if(!error)
                                                  {
                                                      completion(result.accessToken, nil);
                                                  }
                                                  else
                                                  {
                                                      if([error.domain isEqual:MSALErrorDomain] && error.code == MSALErrorInteractionRequired)
                                                      {
                                                          //MSALErrorInteractionRequired error indicates that a call to acquireTokenForScopes is required to take the user through interactive flow for getting the access token.
                                                          [self acquireTokenForProviderOptions:providerOptions withCompletion:completion];
                                                      }
                                                      else
                                                      {
                                                          completion(nil,error);
                                                      }
                                                  }
                                              }];
    }
    else
    {
        //If there aren't any accounts then need to acquire token interactively
        [self acquireTokenForProviderOptions:providerOptions withCompletion:completion];

    }
}

- (void)acquireTokenForProviderOptions:(MSALAuthenticationProviderOptions *)providerOptions withCompletion:(void (^)(NSString *, NSError *))completion
{
    [_publicClientApplication acquireTokenForScopes:providerOptions.scopesArray
                                    completionBlock:^(MSALResult *result, NSError *error) {
                                        if(!error)
                                        {
                                            completion(result.accessToken, nil);
                                        }
                                        else
                                        {
                                            completion(nil,error);
                                        }
                                    }];
}

@end
