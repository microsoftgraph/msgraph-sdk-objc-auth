//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MSALAuthenticationProvider.h"

@interface MSALAuthenticationProviderTests : XCTestCase

@end

NSString * const kScopes = @"https://graph.microsoft.com/User.Read, https://graph.microsoft.com/User.ReadWrite, https://graph.microsoft.com/Mail.Send, https://graph.microsoft.com/Calendars.ReadWrite, https://graph.microsoft.com/Mail.ReadWrite,https://graph.microsoft.com/Files.ReadWrite";

@implementation MSALAuthenticationProviderTests {
    MSALAuthenticationProvider *authenticationProvider;
    MSALPublicClientApplication *mockPublicClientApplication;

    BOOL bCompletionBlockInvoked;
    NSString *testClientId;

}

- (void)setUp {
    [super setUp];
    testClientId = @"abcd1234";
    NSError *error;

    // Set up the class to mock `alloc` and `init...`
    id mockApplication = OCMClassMock([MSALPublicClientApplication class]);
    OCMStub([mockApplication alloc]).andReturn(mockApplication);
    OCMStub([mockApplication initWithClientId:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(mockApplication);
    mockPublicClientApplication = [[MSALPublicClientApplication alloc] initWithClientId:testClientId error:&error];
    authenticationProvider = [[MSALAuthenticationProvider alloc] initWithPublicClientApplication:mockPublicClientApplication andScopes:[kScopes componentsSeparatedByString:@","]];
    NSLog(@"");
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    XCTAssertThrows([[MSALAuthenticationProvider alloc] initWithPublicClientApplication:nil andScopes:[NSArray new]]);
    XCTAssertThrows([[MSALAuthenticationProvider alloc] initWithPublicClientApplication:mockPublicClientApplication andScopes:nil]);
}

- (void)testAccountsAccessError {
    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, @"MSALErrorDomain");
        [testExpectation fulfill];
    };

    NSError *error = [NSError errorWithDomain:MSALErrorDomain code:0 userInfo:nil];
    OCMStub([mockPublicClientApplication allAccounts:[OCMArg setTo:error]]).andReturn(nil);
    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}

- (void)testGetAccessTokenWithInteractiveAuthSuccess {

    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNil(error);
        [testExpectation fulfill];
    };
    OCMStub([mockPublicClientApplication acquireTokenForScopes:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler ([MSALResult new],nil);

    });
    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}

- (void)testGetAccessTokenWithInteractiveAuthFailure {

    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNotNil(error);
        [testExpectation fulfill];
    };
    OCMStub([mockPublicClientApplication acquireTokenForScopes:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler (nil,[NSError new]);

    });
    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}

- (void)testGetAccessTokenWithSilentCallSuccess {

    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNil(error);
        [testExpectation fulfill];
    };

     MSALAccount *account = [MSALAccount new];

    OCMStub([mockPublicClientApplication allAccounts:[OCMArg anyObjectRef]]).andReturn(@[account]);

    OCMStub([mockPublicClientApplication acquireTokenSilentForScopes:[OCMArg any] account:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:4];
        completionHandler ([MSALResult new],nil);
    });

    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}

- (void)testGetAccessTokenWithSilentCallFail {

    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNotNil(error);
        [testExpectation fulfill];
    };

    MSALAccount *account = [MSALAccount new];

    OCMStub([mockPublicClientApplication allAccounts:[OCMArg anyObjectRef]]).andReturn(@[account]);

    OCMStub([mockPublicClientApplication acquireTokenSilentForScopes:[OCMArg any] account:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:4];
        completionHandler (nil,[NSError new]);
    });

    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}

- (void)testGetAccessTokenWithSilentCallSuccessWithInterationRequiredError {

    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNil(error);
        [testExpectation fulfill];
    };

    MSALAccount *account = [MSALAccount new];

    OCMStub([mockPublicClientApplication allAccounts:[OCMArg anyObjectRef]]).andReturn(@[account]);

    OCMStub([mockPublicClientApplication acquireTokenSilentForScopes:[OCMArg any] account:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:4];
        completionHandler (nil,[[NSError alloc] initWithDomain:MSALErrorDomain code:MSALErrorInteractionRequired userInfo:nil]);
    });

    OCMStub([mockPublicClientApplication acquireTokenForScopes:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler ([MSALResult new],nil);

    });

    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}

- (void)testGetAccessTokenWithSilentCallFailWithInterationRequiredError {

    void (^completionHandler)(NSString *accessToken, NSError *error);

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for the completion of acquire token call."];

    completionHandler = ^(NSString *accessToken, NSError *error){
        self->bCompletionBlockInvoked = TRUE;
        XCTAssertNotNil(error);
        [testExpectation fulfill];
    };

    MSALAccount *account = [MSALAccount new];

    OCMStub([mockPublicClientApplication allAccounts:[OCMArg anyObjectRef]]).andReturn(@[account]);

    OCMStub([mockPublicClientApplication acquireTokenSilentForScopes:[OCMArg any] account:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:4];
        completionHandler (nil,[[NSError alloc] initWithDomain:MSALErrorDomain code:MSALErrorInteractionRequired userInfo:nil]);
    });

    OCMStub([mockPublicClientApplication acquireTokenForScopes:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionHandler)(MSALResult *result, NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler (nil,[NSError new]);

    });

    [authenticationProvider getAccessTokenWithCompletion:completionHandler];


    [self waitForExpectations:@[testExpectation] timeout:5.0];
    XCTAssertTrue(bCompletionBlockInvoked);
}
@end
