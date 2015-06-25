//
//  TestDataManager.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 1/22/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "TestDataManager.h"

#import "DBManager.h"
#import "MAWebAppManager.h"

#import "ExtensionMetadata.h"
#import "MAProject.h"
#import "MASessionTokenWebAppResponse.h"
#import "MAUser.h"
#import "TestData.h"

#import "MAWebAppManager+MAAccountManagerTasks.h"

@interface TestDataManager (){
    
    NSTimer* _timer;
    BOOL  _syncFromStorage;
}

@property (nonatomic) NSURLSessionTask *signInURLSessionTask;

@end

static TestDataManager * sharedInstance = nil;

@implementation TestDataManager

+ (TestDataManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TestDataManager alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    
    self=[super init];
    if (self) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [_dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    }
    
    return self;
}


-(void)storeTest:(NSDictionary*)aDict withTestState:(NSString*)aTestState forUser:(NSNumber*)theUser syncParam:(BOOL)aSchouldSync{
    
    TestData *theEntity = (TestData *)[[DBManager sharedDatabase] newObjectForEntityName:@"TestData"];
    theEntity.testID = aDict[kTestID];
    theEntity.isValid = aDict[kIsValid];
    theEntity.rawData =aDict[kRawData];
    theEntity.score = aDict[kScore];
    theEntity.type = aDict[kType];
    

    if ([aDict[kCreationDate] isKindOfClass:[NSNumber class]])
    {
        theEntity.creationDate = aDict[kCreationDate];
    }
    else if ([aDict[kCreationDate] isKindOfClass:[NSString class]])
    {
        NSDate *date = [self.dateFormatter dateFromString:aDict[kCreationDate]];
        theEntity.creationDate = @([date timeIntervalSince1970] * 1000);
    }
    

    theEntity.isSynchronised = aDict[kSynchronised]?aDict[kSynchronised]:@YES;
    theEntity.testState = aTestState;
    theEntity.userID = theUser;
    theEntity.notes = aDict[kNotes];
    theEntity.extension = [aDict[kExtension] isKindOfClass:[NSArray class]]?[self stringFromExtensions:aDict[kExtension]]:aDict[kExtension];
    
    [[DBManager sharedDatabase] updateEntity];
    
    if(aSchouldSync){
        _syncFromStorage = YES;
        self.delegate = nil;
        [self addTestRequestWithTest:theEntity];
    };
    
}

-(void)storeExtensionMeta:(NSDictionary*)aDict{
    
    ExtensionMetadata *theEntity = (ExtensionMetadata *)[[DBManager sharedDatabase] newObjectForEntityName:@"ExtensionMetadata"];
    theEntity.extensionID = aDict[kID];
    theEntity.extensionName = aDict[kName];
    theEntity.extensionType =aDict[kType];
    theEntity.entityname = aDict[kName];
    theEntity.extensionProperties = [aDict[kPropertiyes]componentsJoinedByString:@","];
    theEntity.extensionList = [aDict[kList]componentsJoinedByString:@","];
    theEntity.customer =aDict[kCustomer];
    
    [[DBManager sharedDatabase] updateEntity];
}

- (void)synchroniseData{
    
    if (![[MAWebAppManager sharedManager] isReachable])
    {
        [self.delegate syncFinished];
        return;
    }

    NSPredicate* theAddPredicate =  [NSPredicate predicateWithFormat:@"testState==%@",kTestAdded];
    DBManager* theDbManager = [DBManager sharedDatabase];
    NSArray* theAddArr = [theDbManager getAllDataForEntity:@"TestData" withPredicate:theAddPredicate];
    NSPredicate* theValidPredicate =  [NSPredicate predicateWithFormat:@"(testState==%@) AND (isValid==%@)",kTestUpdated,@YES];
    NSArray* theValidArr = [theDbManager getAllDataForEntity:@"TestData" withPredicate:theValidPredicate];
    NSPredicate* theFalsePredicate =  [NSPredicate predicateWithFormat:@"(testState==%@) AND (isValid==%@)",kTestUpdated,@NO];
    NSArray* theFalseArr = [theDbManager getAllDataForEntity:@"TestData" withPredicate:theFalsePredicate];
    NSPredicate* theDeletePredicate =  [NSPredicate predicateWithFormat:@"testState==%@",kTestDeleted];
    NSArray* theDeleteArr = [[DBManager sharedDatabase] getAllDataForEntity:@"TestData" withPredicate:theDeletePredicate];
    _syncFromStorage = NO;
    [[TestDataManager sharedInstance] getExtensionsRequest];

    if ([theAddArr count]>0 || [theValidArr count]>0 || [theFalseArr count]>0 || [theDeleteArr count]>0) {
        
        if ([theAddArr count]>0) {
            for (TestData* theTest in theAddArr) {
                [self addTestRequestWithTest:theTest];
            }
        }
        if ([theValidArr count]>0) {
            [self updateTestRequestforTests:theValidArr withValidState:@YES];
        }
        if ([theFalseArr count]>0) {
            [self updateTestRequestforTests:theFalseArr withValidState:@NO];
        }
        if ([theDeleteArr count]>0) {
            [self deleteTestRequestforTests:theDeleteArr];
        }
    }
    else{
        [self getAllRequest];
    }
    
}

- (void)addTestRequestWithTest:(TestData*)aTest
{
    NSDateFormatter *dateFormatter = [[TestDataManager sharedInstance] dateFormatter];
    NSString *creationDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([aTest.creationDate doubleValue] / 1000)]];
    
    NSDictionary *theDict = @{kType: aTest.type,
                              kRawData: aTest.rawData,
                              kScore: aTest.score,
                              kIsValid: aTest.isValid,
                              kCreationDate: creationDateStr,
                              kNotes:aTest.notes};
    
    if ([self extensionsForTest:aTest])
    {
        NSMutableDictionary *theMutableDict = [theDict mutableCopy];
        theMutableDict[kExtension] = [self extensionsForTest:aTest];
        
        theDict = [theMutableDict copy];
    }
   
    NSDictionary *parameters = [self addTestParamsWithValue:theDict];
    [[MAWebAppManager sharedManager] sendRequestWithParameters:parameters completionHandler:^(NSDictionary *response, NSError *error)
    {
        if (response != nil)
        {
            NSDictionary* theErrDict = [[response valueForKeyPath:@"response"] valueForKey:@"error"];
            if (![theErrDict isKindOfClass:[NSNull class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
//                    [[ErrorManager sharedClient]handleWebAppError:nil]; // Vitaly.Yurchenko: TODO.
                    MAWebAppResponse *webAppResponse = [MAWebAppResponse responseWithDictionary:response];
                    [self handleWebAppError:webAppResponse.error];
                });
            }
            else
            {
                aTest.isSynchronised = @YES;
                aTest.testState = kTestSynced;
                aTest.testID = [[[[response valueForKeyPath:@"response"] valueForKey:@"function"] valueForKey:@"data"]valueForKey:@"id"];
                [[DBManager sharedDatabase] updateEntity];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate syncFinished];
                });
                if (!self->_syncFromStorage)
                {
                    [self getAllRequest];
                }
            }
        }
        else if (error != nil)
        {
            [self getAllRequest];
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
//                [[ErrorManager sharedClient]handleHTTPError:error]; // Vitaly.Yurchenko: TODO.
            });
        }
    }];
}

- (NSArray*)extensionsForTest:(TestData*)aTest{
    
    NSMutableArray* theRes = [[NSMutableArray alloc]init];
    NSArray* theArr = [aTest.extension componentsSeparatedByString:@";"];
    for (NSString* theSt in theArr) {
        
        NSArray* theComponents = [theSt componentsSeparatedByString:@","];
        if ([theComponents count]>2) {
            NSString* theName = theComponents[0];
            NSString* theValue = theComponents[2];
            NSString* theID = theComponents[1];
            NSDictionary* theDict = [NSDictionary dictionaryWithObjectsAndKeys:theName, @"name", theValue, @"value", theID, @"metaId", nil];
            [theRes addObject:theDict];
        }
        else{
            return NULL;
        }
    
    }
    
    return theRes;
}

- (NSString*)stringFromExtensions:(NSArray*)anArr{
    
    NSString* resStr=@"";
    for (NSDictionary* theDict in anArr) {
        resStr = [NSString stringWithFormat:@"%@;%@,%@,%@",resStr,theDict[@"name"],theDict[@"metaId"],theDict[@"value"]];
    }
    
    return resStr;
}

- (void)updateTestRequestforTests:(NSArray*)aTests withValidState:(NSNumber*)aValidState{
    
    MAWebAppManager* theMClient = [MAWebAppManager sharedManager];
    
    NSDictionary * parameters = [self modifyStatusTestParamsWithValue:aValidState forTests:aTests];
    [theMClient sendRequestWithParameters:parameters completionHandler:^(NSDictionary *response, NSError *error)
    {
        if (response != nil)
        {
            NSDictionary* theErrDict = [[response valueForKeyPath:@"response"] valueForKey:@"error"];
            if (![theErrDict isKindOfClass:[NSNull class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
//                    [[ErrorManager sharedClient]handleWebAppError:nil]; // Vitaly.Yurchenko: TODO.
                    MAWebAppResponse *webAppResponse = [MAWebAppResponse responseWithDictionary:response];
                    [self handleWebAppError:webAppResponse.error];
                });
            }
            else
            {
//            if ([[AFNetworkActivityIndicatorManager sharedManager] activityCount]==0)
                [self getAllRequest];
                for (TestData* theTest in aTests) {
                    theTest.testState=kTestSynced;
                    [[DBManager sharedDatabase] updateEntity];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
//                if ([[AFNetworkActivityIndicatorManager sharedManager] activityCount]==0) // Vitaly.Yurchenko: TODO.
                    [self.delegate syncFinished];
                });
            }
        }
        else if (error != nil)
        {
//        if ([[AFNetworkActivityIndicatorManager sharedManager] activityCount]==0)
            [self getAllRequest];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[ErrorManager sharedClient]handleHTTPError:error]; // Vitaly.Yurchenko: TODO.
            });
        }
    }];

}
- (void)getAllRequest
{
    MAWebAppManager* theMClient = [MAWebAppManager sharedManager];
    NSDictionary *parameters = [self getAllTestsParams];
    [theMClient sendRequestWithParameters:parameters completionHandler:^(NSDictionary *response, NSError *error)
    {
        if (response != nil)
        {
            NSDictionary* theErrDict = [[response valueForKeyPath:@"response"] valueForKey:@"error"];
            if (![theErrDict isKindOfClass:[NSNull class]]) {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
//                    [[ErrorManager sharedClient]handleWebAppError:nil]; // Vitaly.Yurchenko: TODO.
                    MAWebAppResponse *webAppResponse = [MAWebAppResponse responseWithDictionary:response];
                    [self handleWebAppError:webAppResponse.error];
                });
            }
            else
            {
                NSArray *theTests = [[[[response valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"testSession"];
                if ([theTests count]>0) {
                    
                    //-- mark all tests to delete
                    NSArray* theArr = [[DBManager sharedDatabase]getAllDataForEntity:@"TestData" withPredicate:nil];
                    for (TestData* theTest in theArr) {
                        theTest.testState = kTestDeleted;
                    }
                    [[DBManager sharedDatabase] updateEntity];
                    //--
                    
                    for (NSDictionary* theDict in theTests) {
                        
                        NSPredicate* thePredicate = [NSPredicate predicateWithFormat:@"testID==%@",theDict[kTestID]];
                        theArr = [[DBManager sharedDatabase]getAllDataForEntity:@"TestData" withPredicate:thePredicate];
                        if ([theArr count]==0) {
                            [self storeTest:theDict withTestState:kTestSynced forUser:[MAUser currentUser].identifier syncParam:NO];
                        }
                        else{
                            [(TestData*)theArr[0] setTestState:kTestSynced];
                            [[DBManager sharedDatabase] updateEntity];
                        }
                    }
                    
                }
                
                [[DBManager sharedDatabase] updateEntity];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate reloadViewContent];
                });
                
            }
        }
        else if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[ErrorManager sharedClient]handleHTTPError:error]; // Vitaly.Yurchenko: TODO.
                [self.delegate reloadViewContent];
            });
        }
    }];
    
}

- (void)getExtensionsRequest
{
    MAWebAppManager* theMClient = [MAWebAppManager sharedManager];
    NSDictionary *parameters = [self getExtensionParams];
    [theMClient sendRequestWithParameters:parameters completionHandler:^(NSDictionary *response, NSError *error)
    {
        if (response != nil)
        {
            NSDictionary* theErrDict = [[response valueForKeyPath:@"response"] valueForKey:@"error"];
            
            if (![theErrDict isKindOfClass:[NSNull class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
//                    [[ErrorManager sharedClient]handleWebAppError:nil]; // Vitaly.Yurchenko: TODO.
                    MAWebAppResponse *webAppResponse = [MAWebAppResponse responseWithDictionary:response];
                    [self handleWebAppError:webAppResponse.error];
                });
            }
            else{
                
                [[DBManager sharedDatabase]deleteAllDataForEntity:@"ExtensionMetadata" withPredicate:nil];
                NSDictionary *theExtensions = [[[[response valueForKeyPath:@"response"] valueForKeyPath:@"function"]valueForKeyPath:@"data"] valueForKeyPath:@"extension"];
                
                for (NSDictionary* theDict in theExtensions) {
                    [self storeExtensionMeta:theDict];
                }
            }
        }
        else if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[ErrorManager sharedClient]handleHTTPError:error]; // Vitaly.Yurchenko: TODO.
            });
        }
    }];
    
}

- (void)deleteTestRequestforTests:(NSArray*)aTests{
    
    MAWebAppManager* theMClient = [MAWebAppManager sharedManager];
    
    NSDictionary * parameters = [self getDeleteParamsForTests:aTests];
    [theMClient sendRequestWithParameters:parameters completionHandler:^(NSDictionary *response, NSError *error)
    {
        if (response != nil)
        {
            NSDictionary* theErrDict = [[response valueForKeyPath:@"response"] valueForKey:@"error"];
            if (![theErrDict isKindOfClass:[NSNull class]])
            {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
//                    [[ErrorManager sharedClient]handleWebAppError:error]; // Vitaly.Yurchenko: TODO.
                    MAWebAppResponse *webAppResponse = [MAWebAppResponse responseWithDictionary:response];
                    [self handleWebAppError:webAppResponse.error];
                });
            }
            else
            {
                
//                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount]; // Vitaly.Yurchenko: TODO.
                NSPredicate* theDeletePredicate =  [NSPredicate predicateWithFormat:@"testState==%@",kTestDeleted];
                [[DBManager sharedDatabase]deleteAllDataForEntity:@"TestData" withPredicate:theDeletePredicate];
                dispatch_async(dispatch_get_main_queue(), ^{
//                if ([[AFNetworkActivityIndicatorManager sharedManager] activityCount]==0) // Vitaly.Yurchenko: TODO.
                    [self.delegate syncFinished];
                });
            }
        }
        else if (error != nil)
        {
//        if ([[AFNetworkActivityIndicatorManager sharedManager] activityCount]==0)
            [self getAllRequest];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[ErrorManager sharedClient]handleHTTPError:error]; // Vitaly.Yurchenko: TODO.
            });
        }
    }];
    
}

- (void)syncWithTimer:(NSTimeInterval)aPeriod{

    _timer=[NSTimer scheduledTimerWithTimeInterval:aPeriod*3600 target:self selector:@selector(synchronise) userInfo:nil repeats:YES];
}

- (void)synchronise{
    
    [self performSelectorInBackground:@selector(synchroniseData) withObject:nil];
}

- (void)stopTimer{
    
    [_timer invalidate];
}




- (NSDictionary *)tokenDictionary
{
    NSDictionary* theTokenArg = [NSDictionary dictionaryWithObjectsAndKeys:@"sessionToken", @"name", [MAUser currentUser].sessionToken, @"value", nil];
    return theTokenArg;
}

- (NSDictionary*)createArgsForName:(NSString*)aName andValue:(NSObject*)aValue{
    
    NSDictionary* theDict = [NSDictionary dictionaryWithObjectsAndKeys:aName,@"name",aValue,@"value", nil];
    return theDict;
}

- (NSDictionary*)addTestParamsWithValue:(NSDictionary*)aValue
{
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSDictionary* theTestArg = [NSDictionary dictionaryWithObjectsAndKeys:@"testSession",@"name",aValue,@"value", nil];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, theTestArg, nil];
    NSDictionary* theParams = [[MAWebAppManager sharedManager] requestParametersWithTarget:kMAWebAppTargetTestSessionManager
                                                                                    method:kMAWebAppMethodAdd
                                                                                 arguments:theArgsArr];
    return theParams;
}

- (NSDictionary*)modifyStatusTestParamsWithValue:(NSNumber*)aStatus forTests:(NSArray*)aTests
{
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSMutableArray* theIDs = [[NSMutableArray alloc]init];
    for (TestData* theData in aTests) {
        NSNumber* theNumber = [NSNumber numberWithInt:[theData.testID intValue]];
        [theIDs addObject:theNumber];
    }
    
    NSDictionary* theValidArg = [NSDictionary dictionaryWithObjectsAndKeys:@"valid",@"name",aStatus,@"value", nil];
    NSDictionary* theIDsArg = [NSDictionary dictionaryWithObjectsAndKeys:@"ids",@"name",theIDs,@"value", nil];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theValidArg,theIDsArg,theTokenDict, nil];
    NSDictionary* theParams = [[MAWebAppManager sharedManager] requestParametersWithTarget:kMAWebAppTargetTestSessionManager
                                                                                    method:kMAWebAppMethodModifyStatus
                                                                                 arguments:theArgsArr];
    
    return theParams;
}

- (NSDictionary*)getAllTestsParams
{
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict, nil];
    NSDictionary* theParams = [[MAWebAppManager sharedManager] requestParametersWithTarget:kMAWebAppTargetTestSessionManager
                                                                                    method:kMAWebAppMethodGetAll
                                                                                 arguments:theArgsArr];
    
    return theParams;
}

- (NSDictionary*)getExtensionParams
{
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSDictionary* theEntity = [self createArgsForName:@"entity" andValue:@"TEST_SESSION"];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theEntity,theTokenDict, nil];
    NSDictionary* theParams = [[MAWebAppManager sharedManager] requestParametersWithTarget:kMAWebAppTargetExtensionManager
                                                                                    method:@"getExtensionsByEntity"
                                                                                 arguments:theArgsArr];
    return theParams;
}

- (NSDictionary*)getDeleteParamsForTests:(NSArray*)aTests
{
    NSDictionary* theTokenDict = [self tokenDictionary];
    NSMutableArray* theIDs = [[NSMutableArray alloc]init];
    for (TestData* theData in aTests) {
        NSNumber* theNumber = [NSNumber numberWithInt:[theData.testID intValue]];
        [theIDs addObject:theNumber];
    }
    
    NSDictionary* theIDsArg = [self createArgsForName:@"ids" andValue:theIDs];
    NSArray* theArgsArr = [NSArray arrayWithObjects:theTokenDict,theIDsArg, nil];
    NSDictionary* theParams = [[MAWebAppManager sharedManager] requestParametersWithTarget:kMAWebAppTargetTestSessionManager
                                                                                    method:kMAWebAppMethodDelete
                                                                                 arguments:theArgsArr];
    
    return theParams;
}

#pragma mark -
#pragma mark Working with WebApp

- (void)login
{
    [self.signInURLSessionTask cancel];
    
    __weak __typeof(self) weakSelf = self;
    
    void(^completionHandler)(MASessionTokenWebAppResponse *, NSError *) = ^(MASessionTokenWebAppResponse *response, NSError *error)
    {
        if (error == nil && response != nil && response.error == nil)
        {
            MAUser *user = [MAUser currentUser];
            user.sessionToken = response.sessionToken;
            
            [weakSelf synchronise];
        }
    };
    
    MAUser *user = [MAUser currentUser];
    
    self.signInURLSessionTask = [[MAWebAppManager sharedManager] loginWithEmail:user.email
                                                                       passHash:user.password
                                                                        project:user.currentProject.identifier
                                                              completionHandler:completionHandler];
}

- (void)handleWebAppError:(NSError *)error
{
    if ([[error domain] isEqualToString:kMAWebAppErrorDomain])
    {
        if ([error code] == kMAWebAppResponseErrorCodeInvalidSessionToken || [error code] == kMAWebAppResponseErrorCodeSessionTokenIsExpired)
        {
            [self login];
        }
    }
}

@end
