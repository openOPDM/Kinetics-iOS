//
//  MAConstants.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/21/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

/*
 * Web App.
 */

// Base URL.
extern NSString * const kMAWebAppBaseURL;

// Targets.
extern NSString * const kMAWebAppTargetAccountManager;
extern NSString * const kMAWebAppTargetExtensionManager;
extern NSString * const kMAWebAppTargetProjectManager;
extern NSString * const kMAWebAppTargetTestSessionManager;

// Methods.
extern NSString * const kMAWebAppMethodAdd;
extern NSString * const kMAWebAppMethodAuthenticate;
extern NSString * const kMAWebAppMethodConfirmCreate;
extern NSString * const kMAWebAppMethodCreateUser;
extern NSString * const kMAWebAppMethodDelete;
extern NSString * const kMAWebAppMethodGetAll;
extern NSString * const kMAWebAppMethodGetDetails;
extern NSString * const kMAWebAppMethodGetProjectInfoList;
extern NSString * const kMAWebAppMethodGetUserInfo;
extern NSString * const kMAWebAppMethodLogin;
extern NSString * const kMAWebAppMethodLogout;
extern NSString * const kMAWebAppMethodModifyStatus;

// Parameter keys.
extern NSString * const kMAWebAppParameterArgumentsKey;
extern NSString * const kMAWebAppParameterCodeKey;
extern NSString * const kMAWebAppParameterCreationDateKey;
extern NSString * const kMAWebAppParameterDataKey;
extern NSString * const kMAWebAppParameterDescriptionKey;
extern NSString * const kMAWebAppParameterEmailKey;
extern NSString * const kMAWebAppParameterExtensionKey;
extern NSString * const kMAWebAppParameterErrorKey;
extern NSString * const kMAWebAppParameterFirstNameKey;
extern NSString * const kMAWebAppParameterFunctionKey;
extern NSString * const kMAWebAppParameterIDKey;
extern NSString * const kMAWebAppParameterIsValidKey;
extern NSString * const kMAWebAppParameterMessageKey;
extern NSString * const kMAWebAppParameterMethodKey;
extern NSString * const kMAWebAppParameterNameKey;
extern NSString * const kMAWebAppParameterProjectKey;
extern NSString * const kMAWebAppParameterRawDataKey;
extern NSString * const kMAWebAppParameterRequestKey;
extern NSString * const kMAWebAppParameterResponseKey;
extern NSString * const kMAWebAppParameterScoreKey;
extern NSString * const kMAWebAppParameterSecondNameKey;
extern NSString * const kMAWebAppParameterSessionTokenKey;
extern NSString * const kMAWebAppParameterStatusKey;
extern NSString * const kMAWebAppParameterTargetKey;
extern NSString * const kMAWebAppParameterTestSessionKey;
extern NSString * const kMAWebAppParameterTimestampKey;
extern NSString * const kMAWebAppParameterTypeKey;
extern NSString * const kMAWebAppParameterValueKey;
extern NSString * const kMAWebAppParameterUIDKey;
extern NSString * const kMAWebAppParameterUserKey;

// Parameter values.
extern NSString * const kMAWebAppParameterConfirmationCodeValue;
extern NSString * const kMAWebAppParameterEmailValue;
extern NSString * const kMAWebAppParameterFirstNameValue;
extern NSString * const kMAWebAppParameterIDValue;
extern NSString * const kMAWebAppParameterPassHashValue;
extern NSString * const kMAWebAppParameterProjectValue;
extern NSString * const kMAWebAppParameterPSTValue;
extern NSString * const kMAWebAppParameterTestSessionValue;
extern NSString * const kMAWebAppParameterTUGValue;
extern NSString * const kMAWebAppParameterSecondNameValue;
extern NSString * const kMAWebAppParameterSessionTokenValue;

// Response parameter values.
extern NSString * const kMAWebAppResponseParameterActiveValue;
extern NSString * const kMAWebAppResponseParameterOKValue;

// Response error codes.
extern const NSInteger kMAWebAppResponseErrorCodeInvalidSessionToken;
extern const NSInteger kMAWebAppResponseErrorCodeSessionTokenIsExpired;
extern const NSInteger kMAWebAppResponseErrorCodeUserNotActive;

// NSURLSessionConfiguration.
extern const NSTimeInterval kMATimeoutIntervalForRequest;

// NSError domains.
extern NSString * const kMAWebAppErrorDomain;

// NSUserDefaults keys.
extern NSString * const kMAUserDefaultsPSTAREACalibrationValueKey;
extern NSString * const kMAUserDefaultsPSTJERKCalibrationValueKey;
extern NSString * const kMAUserDefaultsPSTRMSCalibrationValueKey;
extern NSString * const kMAUserDefaultsEmailKey;
extern NSString * const kMAUserDefaultsFirstNameKey;
extern NSString * const kMAUserDefaultsIdentifierKey;
extern NSString * const kMAUserDefaultsSecondNameKey;
extern NSString * const kMAUserDefaultsStatusKey;
extern NSString * const kMAUserDefaultsSyncRateKey;
extern NSString * const kMAUserDefaultsUpdateRateKey;
extern NSString * const kMAUserDefaultsUIDKey;
extern NSString * const kMAUserDefaultsUserKey;
extern NSString * const kMAUserDefaultsUserSettingsKey;
extern NSString * const kMAUserDefaultsVibrateKey;

// PST Reference values.
extern const double kMAPSTReferenceAREAValue;
extern const double kMAPSTReferenceJERKValue;
extern const double kMAPSTReferenceRMSValue;






extern NSString* const kTestID;
extern NSString* const kCreationDate;
extern NSString* const kIsValid;
extern NSString* const kRawData;
extern NSString* const kScore;
extern NSString* const kType;
extern NSString* const kSynchronised;
extern NSString* const kSecondName;
extern NSString* const kFirstName;
extern NSString* const kEmail;
extern NSString* const kTimestamp;
extern NSString* const kStatus;
extern NSString* const kBirthday;
extern NSString* const kGender;
extern NSString* const kNotes;
extern NSString* const kUid;
extern NSString* const kExtension;


extern NSString* const kTestState;

extern NSString* const kTestSynced;
extern NSString* const kTestUpdated;
extern NSString* const kTestAdded;
extern NSString* const kTestDeleted;
extern NSString* const kTestMarked;


extern NSString* const kCustomerID;
extern NSString* const kCustomerName;
extern NSString* const kCustomerStatus;
extern NSString* const kIsSelected;


extern NSString* const kName;
extern NSString* const kID;
extern NSString* const kList;
extern NSString* const kEntity;
extern NSString* const kPropertiyes;
extern NSString* const kCustomer;




