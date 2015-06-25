//
//  AFMobilityClient.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/7/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

/*
static NSString * const kLogoutMethod = @"logout";
static NSString * const kAddTestMethod = @"add";
static NSString * const kGetAllMethod = @"getAll";
static NSString * const kModifyStatusMethod = @"modifyStatus";
static NSString * const kGetUserInfoMethod = @"getUserInfo";
static NSString * const kCreateUserMethod = @"createUser";
static NSString * const kConfirmCreateMethod = @"confirmCreate";
static NSString * const kGetUserInfoListMethod = @"getUserInfoList";
static NSString * const kGetAllForUserMethod = @"getAllForUser";
static NSString * const kGetDetailsMethod = @"getDetails";
static NSString * const kGetCustomerInfoList = @"getCustomerInfoList";
static NSString * const kGetExtensionsByEntity = @"getExtensionsByEntity";
static NSString * const kDeleteTestMethod = @"delete";
static NSString * const kAuthenticateMethod = @"authenticate";
static NSString * const kGetProjectInfoList = @"getProjectInfoList";

static NSString * const kTestSessionManager = @"TestSessionManager";
static NSString * const kProjectManager = @"ProjectManager";
static NSString * const kExtensionManager = @"ExtensionManager";


NSString * const kSessionToken = @"kSsessionToken";

#import "AFMobilityClient.h"

#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "TestDataManager.h"
#import "AnalystDataManager.h"
#import "UserInfo.h"
#import "ErrorManager.h"
#import "Reachability.h"
#import "CustomerManager.h"


//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://kinetics-ci.od5.lohika.com:8080/kinetics/rest/mainpoint/execute";

static NSString * const kAFAppDotNetAPIBaseURLString = @"https://opdm.kineticsfoundation.org/kinetics/rest/mainpoint/execute";

//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://kinetics-ci.od5.lohika.com:8080/kinetics/rest/mainpoint/execute ";

//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://kinetics-ci.od5.lohika.com:8080/kinetics2/rest/mainpoint/execute";
//static NSString * const kAFAppDotNetAPIBaseURLString = @"https://opdm.kineticsfoundation.org/kinetics/rest/mainpoint/execute";
//static NSString * const kAFAppDotNetAPIBaseURLString = @"https://avanir.kineticsfoundation.org/kinetics/rest/mainpoint/execute";

//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://172.23.65.35:8080/kinetics/rest/mainpoint/execute";
static dispatch_queue_t _requestQueue;

@implementation AFMobilityClient

+ (AFMobilityClient *)sharedClient {
    static AFMobilityClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFMobilityClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sessionToken= [defaults objectForKey:kSessionToken];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    self.parameterEncoding = AFJSONParameterEncoding;
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    
    return self;
}

- (dispatch_queue_t)requestQueue{
    
    if (!_requestQueue) {
        _requestQueue = dispatch_queue_create("requestQueue", NULL);
    }
    
    return _requestQueue;
}

- (BOOL)checkNetwork{
    
    BOOL theRet = YES;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable) {
        if (self.networkCount==0) {
            self.networkCount=1;
            [self cancelAllHTTPOperationsWithMethod:@"POST" path:@"kAFAppDotNetAPIBaseURLString"];
            [self.operationQueue cancelAllOperations];

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        theRet = NO;
    }else{
        self.networkCount=0;
    }
    
    return theRet;
   
}

- (void)sendRequestWithParams:(NSDictionary*)aParams success:(void (^)(AFHTTPRequestOperation *operation, id JSON))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (![self checkNetwork]) {
        return;
    }
    
    NSURLRequest *request = [self requestWithMethod:@"POST" path:kAFAppDotNetAPIBaseURLString parameters:aParams];
    
//    NSString* newStr = [[NSString alloc] initWithData:request.HTTPBody
//                                              encoding:NSUTF8StringEncoding];
//    NSLog(@"request %@",newStr);
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                               success:success
                                                               failure:failure];
    operation.successCallbackQueue = [self requestQueue];
    operation.failureCallbackQueue = [self requestQueue];

    [operation start];
    
}

- (void)projectInfoRequest{
    
    void (^projectSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];
        
        if (![theErrDict isKindOfClass:[NSNull class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleServerError:theErrDict];
            });
        }
        else{
            
            NSArray* theArr = [[[[JSON valueForKeyPath:@"response"] valueForKey:@"function"]valueForKey:@"data"]valueForKey:@"project"];
            [[CustomerManager sharedInstance]setDefaultsProjs:theArr];
            
        }
        
    };
    
    void (^projectFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
        });
        
    };
    
    NSDictionary *parameters = [self getProjectInfoParams];
    [self sendRequestWithParams:parameters success:projectSuccessBlock failure:projectFailBlock];
    
}

- (void)authenticateRequest{
    
    if ([[ErrorManager sharedClient]validateEmail:[[UserInfo sharedInstance] email]]) {
        
        NSDictionary *parameters = [[AFMobilityClient sharedClient] getAuthenticationParams];
        
        void (^authSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];
            
            if (![theErrDict isKindOfClass:[NSNull class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ErrorManager sharedClient]handleServerError:theErrDict];
                });
            }
            else{
                
                NSArray* theArr = [[[[JSON valueForKeyPath:@"response"] valueForKey:@"function"]valueForKey:@"data"]valueForKey:@"project"];
                [[CustomerManager sharedInstance]setDefaultsProjs:theArr];                
                if ([[CustomerManager sharedInstance].projects count]==1)
                {
                    [self loginRequest];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate authenticationSuccessed];
                    });
                }
            }
        };
        
        void (^authFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
            });
            
        };
        
        [self sendRequestWithParams:parameters success:authSuccessBlock failure:authFailBlock];
    }
    
}

- (void)loginRequest{
    
    if ([[ErrorManager sharedClient]validateEmail:[[UserInfo sharedInstance] email]]) {
        
        NSDictionary *parameters = [[AFMobilityClient sharedClient] loginParams];
        
        void (^loginSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            self.sessionToken = [[[[JSON valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"sessionToken"];            
            NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];
            
            if (![theErrDict isKindOfClass:[NSNull class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ErrorManager sharedClient]handleServerError:theErrDict];
                    if ([[theErrDict objectForKey:@"code"] integerValue]==803) {
                        [self.delegate loginFailedWithNotConfirmedAccount];
                    }

                });
            }
            else if (self.sessionToken) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[AFMobilityClient sharedClient].sessionToken forKey:kSessionToken];
                [[UserInfo sharedInstance]setValid:YES];
                
                [self getUserInfoRequest];
                self.isAuthorized = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate loginSuccessed];
                });
                
            }
            
            
        };
        
        void (^loginFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
            });


            
        };

        [self sendRequestWithParams:parameters success:loginSuccessBlock failure:loginFailBlock];
    }
    
    
}


- (void)logoutRequest{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelAllHTTPOperationsWithMethod:@"POST" path:@"kAFAppDotNetAPIBaseURLString"];
        [self.operationQueue cancelAllOperations];
    });

    void (^logoutSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [[UserInfo sharedInstance]setValid:NO];
        [UserInfo sharedInstance].password = @"";
        self.isAuthorized = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate logoutSucceed];
            [[DBManager sharedDatabase]deleteAllDataForEntity:@"PatientData" withPredicate:nil];
            [[DBManager sharedDatabase]deleteAllDataForEntity:@"TestData" withPredicate:nil];
            [[TestDataManager sharedInstance]stopTimer];
            [[AnalystDataManager sharedInstance]stopTimer];
            
        });
        
        
    };
    
    void (^logoutFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
        });

        
    };
    
    NSDictionary *parameters = [self logoutParams];  
    [self sendRequestWithParams:parameters success:logoutSuccessBlock failure:logoutFailBlock];
    
}

- (void)createAccountRequest{
    
    void (^createSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];
        
        if (![theErrDict isKindOfClass:[NSNull class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleServerError:theErrDict];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate accountCreated];
            });
            
        }
           
    };
    
    void (^createFailBlock)(AFHTTPRequestOperation *operation, id JSON)= ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
        });

        
    };
    
    NSDictionary *parameters = [self getCreateAccountParams];
    [self sendRequestWithParams:parameters success:createSuccessBlock failure:createFailBlock];
    
}

- (void)confirmAccountRequest{
    
    void (^confirmSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];
        
        if (![theErrDict isKindOfClass:[NSNull class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleServerError:theErrDict];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.delegate accountConfirmed];
            });
        }
        
    };
    
    void (^confirmFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
        });

        
    };
    
    NSDictionary *parameters = [self getConfirmAccountParams];
    [self sendRequestWithParams:parameters success:confirmSuccessBlock failure:confirmFailBlock];
    
}

- (void)getUserInfoRequest{
    
    void (^userInfoSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];
         [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        if (![theErrDict isKindOfClass:[NSNull class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleServerError:theErrDict];
            });
        }
        else{
            NSString* theFname = [[[[[JSON valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"user"] valueForKey:@"firstName"];
            NSString* theSname = [[[[[JSON valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"user"] valueForKey:@"secondName"];
            NSNumber* theID = [[[[[JSON valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"user"] valueForKey:@"id"];
             NSNumber* theUID = [[[[[JSON valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"user"] valueForKey:@"uid"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UserInfo sharedInstance]setFirstName:theFname];
                [[UserInfo sharedInstance]setSecondName:theSname];
                [[UserInfo sharedInstance]setID:theID];
                [[UserInfo sharedInstance]setUID:theUID];
            });
        }
        
        
    };
    
    void (^userInfoFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
        });
        
    };
    
    NSDictionary *parameters = [self getUserInfoParams];
    [self sendRequestWithParams:parameters success:userInfoSuccessBlock failure:userInfoFailBlock];
    
}

- (void)getTestDetailsRequestForTest:(NSNumber*)aTest{
    
    void (^userInfoSuccessBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        
         [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSDictionary* theErrDict = [[JSON valueForKeyPath:@"response"] valueForKey:@"error"];

        if (![theErrDict isKindOfClass:[NSNull class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ErrorManager sharedClient]handleServerError:theErrDict];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate testDetailsRetrieved:[[[[JSON valueForKeyPath:@"response"]valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"testSession"]];
            });
        }
        
    };
    
    void (^userInfoFailBlock)(AFHTTPRequestOperation *operation, id JSON) = ^(AFHTTPRequestOperation *operation, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ErrorManager sharedClient]handleHTTPError:[NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]];
        });

    };
    
    NSDictionary *parameters = [self getDetailsParamsForTest:aTest];
    [self sendRequestWithParams:parameters success:userInfoSuccessBlock failure:userInfoFailBlock];
    
}


#pragma mark - 
#pragma mark Creaating parameters for requests

- (NSDictionary*)paramsForMethod:(NSString*)aMethod manager:(NSString*)aTarget arguments:(NSArray*)anArguments{
    
    NSDictionary* theFunction = [NSDictionary dictionaryWithObjectsAndKeys:aMethod,@"method",[NSNumber numberWithInteger:NULL],@"timestamp",aTarget,@"target",anArguments,@"arguments", nil];
    
    NSDictionary* theRequest = [NSDictionary dictionaryWithObjectsAndKeys:theFunction,@"function", nil];
    
    NSDictionary* retRequest = [NSDictionary dictionaryWithObjectsAndKeys:theRequest,@"request", nil];
    
    return retRequest;
    
}

- (NSDictionary*)tokenDictionary{
    
    NSDictionary* theTokenArg = [NSDictionary dictionaryWithObjectsAndKeys:@"sessionToken",@"name",self.sessionToken,@"value", nil];
    return theTokenArg;
}

- (NSDictionary*)loginParams{
    
    NSDictionary* theEmailArg = [NSDictionary dictionaryWithObjectsAndKeys:@"email",@"name",[UserInfo sharedInstance].email,@"value", nil];
    NSDictionary* thePassArg = [NSDictionary dictionaryWithObjectsAndKeys:@"passHash",@"name",[UserInfo sharedInstance].password,@"value", nil];
    NSDictionary* theCustArg = [NSDictionary dictionaryWithObjectsAndKeys:@"project",@"name",[CustomerManager sharedInstance].selectedCID,@"value", nil];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theEmailArg,thePassArg,theCustArg, nil];
    
    NSDictionary* theParams = [self paramsForMethod:kLoginMethod manager:kAccountManager arguments:theArgsArr];
    
    return theParams;
    
}

- (NSDictionary*)logoutParams{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, nil];
    
    NSDictionary* theParams = [self paramsForMethod:kLogoutMethod manager:kAccountManager arguments:theArgsArr];
    
    return theParams;
    
}

- (NSDictionary*)addTestParamsWithValue:(NSDictionary*)aValue{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSDictionary* theTestArg = [NSDictionary dictionaryWithObjectsAndKeys:@"testSession",@"name",aValue,@"value", nil];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, theTestArg, nil];
    
    NSDictionary* theParams = [self paramsForMethod:kAddTestMethod manager:kTestSessionManager arguments:theArgsArr];
    return theParams;
    
}

- (NSDictionary*)getAllTestsParams{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, nil];
    NSDictionary* theParams = [self paramsForMethod:kGetAllMethod manager:kTestSessionManager arguments:theArgsArr];
    
    return theParams;
    
}

- (NSDictionary*)modifyStatusTestParamsWithValue:(NSNumber*)aStatus forTests:(NSArray*)aTests{
    
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSMutableArray* theIDs = [[NSMutableArray alloc]init];
    for (TestData* theData in aTests) {
        NSNumber* theNumber = [NSNumber numberWithInt:[theData.testID intValue]];
        [theIDs addObject:theNumber];
    }
    
    NSDictionary* theValidArg = [NSDictionary dictionaryWithObjectsAndKeys:@"valid",@"name",aStatus,@"value", nil];
    NSDictionary* theIDsArg = [NSDictionary dictionaryWithObjectsAndKeys:@"ids",@"name",theIDs,@"value", nil];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theValidArg,theIDsArg,theTokenDict, nil];
    
    NSDictionary* theParams = [self paramsForMethod:kModifyStatusMethod manager:kTestSessionManager arguments:theArgsArr];
    
    return theParams;
    
}

- (NSDictionary*)getUserInfoParams{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, nil];
    NSDictionary* theParams = [self paramsForMethod:kGetUserInfoMethod manager:kAccountManager arguments:theArgsArr];
    return theParams;
    
}

- (NSDictionary*)getUserInfoListParams{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, nil];
    NSDictionary* theParams = [self paramsForMethod:kGetUserInfoListMethod manager:kAccountManager arguments:theArgsArr];
    return theParams;
    
}

- (NSDictionary*)getCreateAccountParams{
    
    UserInfo* theUser = [UserInfo sharedInstance];
    NSDictionary* thefName = [self createArgsForName:@"firstName" andValue:[theUser firstName]];
    NSDictionary* theSName = [self createArgsForName:@"secondName" andValue:[theUser secondName]];
    NSDictionary* theEmail = [self createArgsForName:@"email" andValue:[theUser email]];
    NSDictionary* thePassword = [self createArgsForName:@"passHash" andValue:[theUser password]];
     NSDictionary* theCustArg = [NSDictionary dictionaryWithObjectsAndKeys:@"project",@"name",[CustomerManager sharedInstance].selectedPojectsValues,@"value", nil];
    
    NSArray* theArgsArr = [NSArray arrayWithObjects:thefName,theSName,theEmail,thePassword,theCustArg, nil];
    NSDictionary* theParams = [self paramsForMethod:kCreateUserMethod manager:kAccountManager arguments:theArgsArr];
    
    return theParams;
}

- (NSDictionary*)getConfirmAccountParams{
    
    UserInfo* theUser = [UserInfo sharedInstance];
    NSDictionary* theEmail = [self createArgsForName:@"email" andValue:[theUser email]];
    NSDictionary* theSecure = [self createArgsForName:@"confirmationCode" andValue:[theUser secure]];
    
    NSArray* theArgsArr = [NSArray arrayWithObjects:theEmail,theSecure, nil];
    NSDictionary* theParams = [self paramsForMethod:kConfirmCreateMethod manager:kAccountManager arguments:theArgsArr];

    return theParams;
}

- (NSDictionary*)getHistoryParamsForUser:(NSNumber*)theUserID{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSDictionary* theID = [self createArgsForName:@"id" andValue:theUserID];
    
    NSArray* theArgsArr = [NSArray arrayWithObjects:theID,theTokenDict, nil];
    NSDictionary* theParams = [self paramsForMethod:kGetAllForUserMethod manager:kTestSessionManager arguments:theArgsArr];

    return theParams;
    
}

- (NSDictionary*)getDetailsParamsForTest:(NSNumber*)theTestID{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSDictionary* theID = [self createArgsForName:@"id" andValue:theTestID];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theID,theTokenDict, nil];
    NSDictionary* theParams = [self paramsForMethod:kGetDetailsMethod manager:kTestSessionManager arguments:theArgsArr];

    return theParams;

}

- (NSDictionary*)getExtensionParams{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSDictionary* theEntity = [self createArgsForName:@"entity" andValue:@"TEST_SESSION"];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theEntity,theTokenDict, nil];
    NSDictionary* theParams = [self paramsForMethod:kGetExtensionsByEntity manager:kExtensionManager arguments:theArgsArr];
    return theParams;
    
}

- (NSDictionary*)getDeleteParamsForTests:(NSArray*)aTests{
    
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSMutableArray* theIDs = [[NSMutableArray alloc]init];
    for (TestData* theData in aTests) {
        NSNumber* theNumber = [NSNumber numberWithInt:[theData.testID intValue]];
        [theIDs addObject:theNumber];
    }
    
    NSDictionary* theIDsArg = [self createArgsForName:@"ids" andValue:theIDs];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict,theIDsArg, nil];
    NSDictionary* theParams = [self paramsForMethod:kDeleteTestMethod manager:kTestSessionManager arguments:theArgsArr];

    return theParams;
}

- (NSDictionary*)getAuthenticationParams{
    
    NSDictionary* theEmailArg = [NSDictionary dictionaryWithObjectsAndKeys:@"email",@"name",[UserInfo sharedInstance].email,@"value", nil];
    NSDictionary* thePassArg = [NSDictionary dictionaryWithObjectsAndKeys:@"passHash",@"name",[UserInfo sharedInstance].password,@"value", nil];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theEmailArg,thePassArg, nil];
    
    NSDictionary* theParams = [self paramsForMethod:kAuthenticateMethod manager:kAccountManager arguments:theArgsArr];
    
    return theParams;
}

- (NSDictionary*)getProjectInfoParams{
    
    NSArray* theArgsArr = [NSArray arrayWithObjects:nil];
    NSDictionary* theParams = [self paramsForMethod:kGetProjectInfoList manager:kProjectManager arguments:theArgsArr];
    
    return theParams;
}
- (NSDictionary*)createArgsForName:(NSString*)aName andValue:(NSObject*)aValue{
    
    NSDictionary* theDict = [NSDictionary dictionaryWithObjectsAndKeys:aName,@"name",aValue,@"value", nil];
    return theDict;
}

@end
 */
