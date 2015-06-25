//
//  MAConstants.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/21/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "MAConstants.h"

// Web App.
//NSString * const kMAWebAppBaseURL = @"https://opdm.kineticsfoundation.org/kinetics/rest/mainpoint/execute";
NSString * const kMAWebAppBaseURL = @"https://stage.kineticsfoundation.org/kinetics/rest/mainpoint/execute";

// Targets.
NSString * const kMAWebAppTargetAccountManager = @"AccountManager";
NSString * const kMAWebAppTargetExtensionManager = @"ExtensionManager";
NSString * const kMAWebAppTargetProjectManager = @"ProjectManager";
NSString * const kMAWebAppTargetTestSessionManager = @"TestSessionManager";

// Methods.
NSString * const kMAWebAppMethodAdd = @"add";
NSString * const kMAWebAppMethodAuthenticate = @"authenticate";
NSString * const kMAWebAppMethodConfirmCreate = @"confirmCreate";
NSString * const kMAWebAppMethodCreateUser = @"createUser";
NSString * const kMAWebAppMethodDelete = @"delete";
NSString * const kMAWebAppMethodGetAll = @"getAll";
NSString * const kMAWebAppMethodGetDetails = @"getDetails";
NSString * const kMAWebAppMethodGetProjectInfoList = @"getProjectInfoList";
NSString * const kMAWebAppMethodGetUserInfo = @"getUserInfo";
NSString * const kMAWebAppMethodLogin = @"login";
NSString * const kMAWebAppMethodLogout = @"logout";
NSString * const kMAWebAppMethodModifyStatus = @"modifyStatus";

// Parameter keys.
NSString * const kMAWebAppParameterArgumentsKey = @"arguments";
NSString * const kMAWebAppParameterCodeKey = @"code";
NSString * const kMAWebAppParameterCreationDateKey = @"creationDate";
NSString * const kMAWebAppParameterDataKey = @"data";
NSString * const kMAWebAppParameterDescriptionKey = @"description";
NSString * const kMAWebAppParameterEmailKey = @"email";
NSString * const kMAWebAppParameterExtensionKey = @"extension";
NSString * const kMAWebAppParameterErrorKey = @"error";
NSString * const kMAWebAppParameterFirstNameKey = @"firstName";
NSString * const kMAWebAppParameterFunctionKey = @"function";
NSString * const kMAWebAppParameterIDKey = @"id";
NSString * const kMAWebAppParameterIsValidKey = @"isValid";
NSString * const kMAWebAppParameterMessageKey = @"message";
NSString * const kMAWebAppParameterMethodKey = @"method";
NSString * const kMAWebAppParameterNameKey = @"name";
NSString * const kMAWebAppParameterProjectKey = @"project";
NSString * const kMAWebAppParameterRawDataKey = @"rawData";
NSString * const kMAWebAppParameterRequestKey = @"request";
NSString * const kMAWebAppParameterResponseKey = @"response";
NSString * const kMAWebAppParameterScoreKey = @"score";
NSString * const kMAWebAppParameterSecondNameKey = @"secondName";
NSString * const kMAWebAppParameterSessionTokenKey = @"sessionToken";
NSString * const kMAWebAppParameterStatusKey = @"status";
NSString * const kMAWebAppParameterTargetKey = @"target";
NSString * const kMAWebAppParameterTestSessionKey = @"testSession";
NSString * const kMAWebAppParameterTimestampKey = @"timestamp";
NSString * const kMAWebAppParameterTypeKey = @"type";
NSString * const kMAWebAppParameterValueKey = @"value";
NSString * const kMAWebAppParameterUIDKey = @"uid";
NSString * const kMAWebAppParameterUserKey = @"user";

// Parameter values.
NSString * const kMAWebAppParameterConfirmationCodeValue = @"confirmationCode";
NSString * const kMAWebAppParameterEmailValue = @"email";
NSString * const kMAWebAppParameterFirstNameValue = @"firstName";
NSString * const kMAWebAppParameterIDValue = @"id";
NSString * const kMAWebAppParameterPassHashValue = @"passHash";
NSString * const kMAWebAppParameterProjectValue = @"project";
NSString * const kMAWebAppParameterPSTValue = @"PST";
NSString * const kMAWebAppParameterTestSessionValue = @"testSession";
NSString * const kMAWebAppParameterTUGValue = @"TUG";
NSString * const kMAWebAppParameterSecondNameValue = @"secondName";
NSString * const kMAWebAppParameterSessionTokenValue = @"sessionToken";

// Response parameter values.
NSString * const kMAWebAppResponseParameterActiveValue = @"ACTIVE";
NSString * const kMAWebAppResponseParameterOKValue = @"OK";

// Response error codes.
const NSInteger kMAWebAppResponseErrorCodeInvalidSessionToken = 716;
const NSInteger kMAWebAppResponseErrorCodeSessionTokenIsExpired = 717;
const NSInteger kMAWebAppResponseErrorCodeUserNotActive = 803;

// NSURLSessionConfiguration.
const NSTimeInterval kMATimeoutIntervalForRequest = 10.0;

// NSError domains.
NSString * const kMAWebAppErrorDomain = @"MAWebAppErrorDomain";

// NSUserDefaults keys.
NSString * const kMAUserDefaultsPSTAREACalibrationValueKey = @"MAPSTAREACalibrationValue";
NSString * const kMAUserDefaultsPSTJERKCalibrationValueKey = @"MAPSTJERKCalibrationValue";
NSString * const kMAUserDefaultsPSTRMSCalibrationValueKey = @"MAPSTRMSCalibrationValue";
NSString * const kMAUserDefaultsEmailKey = @"MAEmail";
NSString * const kMAUserDefaultsFirstNameKey = @"MAFirstName";
NSString * const kMAUserDefaultsIdentifierKey = @"MAIdentifier";
NSString * const kMAUserDefaultsSecondNameKey = @"MASecondName";
NSString * const kMAUserDefaultsStatusKey = @"MAStatus";
NSString * const kMAUserDefaultsSyncRateKey = @"MASyncRate";
NSString * const kMAUserDefaultsUpdateRateKey = @"MAUpdateRate";
NSString * const kMAUserDefaultsUIDKey = @"MAUID";
NSString * const kMAUserDefaultsUserKey = @"MAUser";
NSString * const kMAUserDefaultsUserSettingsKey = @"MAUserSettings";
NSString * const kMAUserDefaultsVibrateKey = @"MAVibrate";

// PST Reference values.
const double kMAPSTReferenceAREAValue = 0.008;
const double kMAPSTReferenceJERKValue = 0.0230;
const double kMAPSTReferenceRMSValue = 0.0500;



NSString* const kTestID = @"id";
NSString* const kCreationDate = @"creationDate";
NSString* const kIsValid = @"isValid";
NSString* const kRawData = @"rawData";
NSString* const kScore = @"score";
NSString* const kType = @"type";
NSString* const kSynchronised = @"isSynchronised";
NSString* const kTestState = @"testState";
NSString* const kFirstName = @"firstName";
NSString* const kSecondName = @"secondName";
NSString* const kEmail = @"email";
NSString* const kTimestamp = @"timestamp";
NSString* const kStatus = @"status";
NSString* const kNotes = @"notes";
NSString* const kUid = @"uid";
NSString* const kExtension = @"extension";


NSString* const kTestSynced = @"synchronised";
NSString* const kTestUpdated = @"updated";
NSString* const kTestAdded = @"added";
NSString* const kTestDeleted = @"deleted";
NSString* const kTestMarked = @"markedToDelete";


NSString* const kCustomerID = @"id";
NSString* const kCustomerName = @"name";
NSString* const kCustomerStatus = @"status";
NSString* const kIsSelected = @"isSelected";

NSString* const kName = @"name";
NSString* const kID = @"id";
NSString* const kList = @"list";
NSString* const kEntity = @"entity";
NSString* const kPropertiyes = @"properties";
NSString* const kCustomer = @"customer";




