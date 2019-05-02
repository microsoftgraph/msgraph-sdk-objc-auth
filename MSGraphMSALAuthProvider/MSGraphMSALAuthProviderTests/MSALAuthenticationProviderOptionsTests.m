//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSALAuthenticationProviderOptions.h"

@interface MSALAuthenticationProviderOptionsTests : XCTestCase

@end

@implementation MSALAuthenticationProviderOptionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    MSALAuthenticationProviderOptions *options = [[MSALAuthenticationProviderOptions alloc] initWithScopes:@[@"mail.send",@"user.readWrite"]];
    XCTAssertEqual(options.scopesArray[0],@"mail.send");

    MSALAuthenticationProviderOptions *optionsEmpty = [[MSALAuthenticationProviderOptions alloc] initWithScopes:nil];
    XCTAssertNotNil(optionsEmpty.scopesArray);
}

@end
