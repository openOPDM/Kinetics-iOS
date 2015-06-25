//
//  MAUser.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAUser.h"

#import "MAConstants.h"

#import "MAKeychainManager.h"

#import "MAKeychainItem.h"

static MAUser *sMACurrentUser;

@implementation MAUser

#pragma mark -
#pragma mark Class Methods

+ (instancetype)currentUser
{
    if (sMACurrentUser == nil)
    {
        sMACurrentUser = [MAUser new];
        [sMACurrentUser load];
    }
    
    return sMACurrentUser;
}

+ (void)setCurrentUser:(MAUser *)user
{
    [sMACurrentUser delete];
    sMACurrentUser = user;
    [sMACurrentUser save];
}

#pragma mark -
#pragma mark Accessors

- (void)setIdentifier:(NSNumber *)identifier
{
    if (_identifier != identifier)
    {
        _identifier = identifier;
        
        [self setNeedsSave];
    }
}

- (void)setEmail:(NSString *)email
{
    if (_email != email)
    {
        _email = email;
        
        [self setNeedsSave];
    }
}

- (void)setFirstName:(NSString *)firstName
{
    if (_firstName != firstName)
    {
        _firstName = firstName;
        
        [self setNeedsSave];
    }
}

- (void)setSecondName:(NSString *)secondName
{
    if (_secondName != secondName)
    {
        _secondName = secondName;
        
        [self setNeedsSave];
    }
}

- (void)setStatus:(NSString *)status
{
    if (_status != status)
    {
        _status = status;
        
        [self setNeedsSave];
    }
}

- (void)setUID:(NSString *)UID
{
    if (_UID != UID)
    {
        _UID = UID;
        
        [self setNeedsSave];
    }
}

- (void)setPassword:(NSString *)password
{
    if (_password != password)
    {
        _password = password;
        
        [self setNeedsSave];
    }
}

- (void)setSessionToken:(NSString *)sessionToken
{
    if (_sessionToken != sessionToken)
    {
        _sessionToken = sessionToken;
        
        [self setNeedsSave];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)load
{
    if (self == sMACurrentUser)
    {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kMAUserDefaultsUserKey];
        _identifier = userInfo[kMAUserDefaultsIdentifierKey];
        _email = userInfo[kMAUserDefaultsEmailKey];
        _firstName = userInfo[kMAUserDefaultsFirstNameKey];
        _secondName = userInfo[kMAUserDefaultsSecondNameKey];
        _status = userInfo[kMAUserDefaultsStatusKey];
        _UID = userInfo[kMAUserDefaultsUIDKey];
        
        if (_UID != nil)
        {
            MAKeychainItem *item = [MAKeychainItem new];
            item.service = _UID;
            
            if ([MAKeychainManager loadItem:item])
            {
                _password = item.password;
                _sessionToken = item.generic;
            }
        }
    }
}

- (void)save
{
    if (self == sMACurrentUser)
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        
        if (_identifier != nil)
        {
            userInfo[kMAUserDefaultsIdentifierKey] = _identifier;
        }
        
        if (_email != nil)
        {
            userInfo[kMAUserDefaultsEmailKey] = _email;
        }
        
        if (_firstName != nil)
        {
            userInfo[kMAUserDefaultsFirstNameKey] = _firstName;
        }
        
        if (_secondName != nil)
        {
            userInfo[kMAUserDefaultsSecondNameKey] = _secondName;
        }
        
        if (_status != nil)
        {
            userInfo[kMAUserDefaultsStatusKey] = _status;
        }
        
        if (_UID != nil)
        {
            userInfo[kMAUserDefaultsUIDKey] = _UID;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kMAUserDefaultsUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_UID != nil && _password != nil && _sessionToken != nil)
        {
            MAKeychainItem *item = [MAKeychainItem new];
            item.service = _UID;
            item.account = _UID;
            item.password = _password;
            item.generic = _sessionToken;
            
            [MAKeychainManager saveItem:item];
        }
    }
}

- (void)delete
{
    if (self == sMACurrentUser)
    {
        if (_UID != nil)
        {
            MAKeychainItem *item = [MAKeychainItem new];
            item.service = _UID;
            
            if ([MAKeychainManager deleteItem:item])
            {
                _password = nil;
                _sessionToken = nil;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMAUserDefaultsUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _identifier = nil;
        _email = nil;
        _firstName = nil;
        _secondName = nil;
        _status = nil;
        _UID = nil;
    }
}

#pragma mark -
#pragma mark Helpers

- (void)setNeedsSave
{
    if (self == sMACurrentUser)
    {
        SEL selector = @selector(save);
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
        [self performSelector:selector withObject:nil afterDelay:0.25];
    }
}

@end
