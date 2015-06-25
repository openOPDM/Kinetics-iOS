//
//  AFMobilityClient.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/7/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "AFHTTPClient.h"
//
//extern NSString * const kSessionToken;
//
//@protocol SuppAction <NSObject>
//
//@optional
//- (void)authenticationSuccessed;
//- (void)loginSuccessed;
//- (void)logoutSucceed;
//- (void)loginFailedWithNotConfirmedAccount;
//- (void)accountCreated;
//- (void)accountConfirmed;
//- (void)testDetailsRetrieved:(NSDictionary*)aTestDetails;
//
//@end
//
//@interface AFMobilityClient : AFHTTPClient
//
//@property(nonatomic, retain) NSString* sessionToken;
//@property(nonatomic, retain) id<SuppAction> delegate;
//@property(nonatomic, assign) int networkCount;
//@property(nonatomic, assign) BOOL isAuthorized;
//
//+ (AFMobilityClient *)sharedClient;
//
//- (void)projectInfoRequest;
//- (void)authenticateRequest;
//- (void)loginRequest;
//- (void)logoutRequest;
//- (void)createAccountRequest;
//- (void)confirmAccountRequest;
//- (void)getUserInfoRequest;
//- (void)getTestDetailsRequestForTest:(NSNumber*)aTest;
//- (BOOL)checkNetwork;
//
//- (NSDictionary*)addTestParamsWithValue:(NSDictionary*)aValue;
//- (NSDictionary*)getAllTestsParams;
//- (NSDictionary*)modifyStatusTestParamsWithValue:(NSNumber*)aStatus forTests:(NSArray*)anIDs;
//- (NSDictionary*)getUserInfoParams;
//- (NSDictionary*)loginParams;
//- (NSDictionary*)getUserInfoListParams;
//- (NSDictionary*)getHistoryParamsForUser:(NSNumber*)theUserID;
//- (NSDictionary*)getDetailsParamsForTest:(NSNumber*)theTestID;
//- (NSDictionary*)getExtensionParams;
//- (NSDictionary*)getDeleteParamsForTests:(NSArray*)aTests;
//
//- (void)sendRequestWithParams:(NSDictionary*)aParams success:(void (^)(AFHTTPRequestOperation *operation, id JSON))success
//                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//@end
