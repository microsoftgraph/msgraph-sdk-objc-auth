//
//  MSALAuthenticationProviderOptions.m
//  MSGraphMSALAuthProvider
//
//  Created by Vikas Dadheech on 25/04/19.
//  Copyright © 2019 Microsoft. All rights reserved.
//

#import "MSALAuthenticationProviderOptions.h"

@implementation MSALAuthenticationProviderOptions

@synthesize scopesArray;

- (instancetype)initWithScopes:(NSArray<NSString *> *)scopeArray {
    self = [super init];
    if(self)
    {
        scopesArray = scopeArray?[scopeArray copy]:[NSArray new];
    }
    return self;
}

@end
