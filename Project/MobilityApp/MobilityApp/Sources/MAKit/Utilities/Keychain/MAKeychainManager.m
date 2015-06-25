//
//  MAKeychainManager.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAKeychainManager.h"

#import "MAKeychainItem.h"

@implementation MAKeychainManager

#pragma mark -
#pragma mark Methods

+ (BOOL)loadItem:(MAKeychainItem *)item
{
    NSString *account = nil;
    NSString *password = nil;
    NSString *generic = nil;
    
    BOOL success = [self loadItemWithService:item.service account:&account password:&password generic:&generic];
    
    if (success)
    {
        item.account = account;
        item.password = password;
        item.generic = generic;
    }
    
    return success;
}

+ (BOOL)saveItem:(MAKeychainItem *)item
{
    return [self saveItemWithService:item.service account:item.account password:item.password generic:item.generic];
}

+ (BOOL)deleteItem:(MAKeychainItem *)item
{
    return [self deleteItemWithService:item.service];
}

#pragma mark -
#pragma mark Private Methods

+ (BOOL)loadItemWithService:(NSString *)service account:(NSString **)account password:(NSString **)password generic:(NSString **)generic
{
    CFMutableDictionaryRef searchQuery = [self searchQueryWithService:service needLoadData:YES];
    
    if (searchQuery == NULL)
    {
        return NO;
    }
    
    CFDictionarySetValue(searchQuery, kSecMatchLimit, kSecMatchLimitOne);
    
    BOOL success = NO;
    CFDictionaryRef itemData = NULL;
    
	OSStatus status = SecItemCopyMatching(searchQuery, (CFTypeRef *)&itemData);
    
    NSAssert(status == errSecSuccess || status == errSecItemNotFound, @"Couldn't load the Keychain Item.");
    
    if (status == errSecSuccess && itemData != NULL)
    {
        *account = (__bridge NSString *)CFDictionaryGetValue(itemData, kSecAttrAccount);
        *generic = (__bridge NSString *)CFDictionaryGetValue(itemData, kSecAttrGeneric);
        
        NSData *passwordData = (__bridge NSData *)CFDictionaryGetValue(itemData, kSecValueData);
        
        if (passwordData != nil)
        {
            *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        }
        
        CFRelease(itemData);
        success = (status == errSecSuccess);
    }
    
    return success;
}

+ (BOOL)saveItemWithService:(NSString *)service account:(NSString *)account password:(NSString *)password generic:(NSString *)generic
{
    CFMutableDictionaryRef searchQuery = [self searchQueryWithService:service needLoadData:NO];
    
    if (searchQuery == NULL)
    {
        return NO;
    }
    
    CFDictionarySetValue(searchQuery, kSecMatchLimit, kSecMatchLimitOne);
    
    CFDictionaryRef attributesToUpdate = (__bridge CFDictionaryRef)@{(__bridge id)kSecValueData: [password dataUsingEncoding:NSUTF8StringEncoding],
                                                                     (__bridge id)kSecAttrAccount: account,
                                                                     (__bridge id)kSecAttrGeneric: generic};
    
    BOOL success = NO;
    
	OSStatus status = SecItemCopyMatching(searchQuery, NULL);
    
    if (status == errSecSuccess)
    {
        CFDictionaryRemoveValue(searchQuery, kSecMatchLimit);
        status = SecItemUpdate(searchQuery, attributesToUpdate);
        
		NSAssert(status == errSecSuccess, @"Couldn't update the Keychain Item.");
        
        success = (status == errSecSuccess);
    }
    else
    {
        // No previous item found - add the new one.
        [(__bridge NSMutableDictionary *)searchQuery addEntriesFromDictionary:(__bridge NSDictionary *)attributesToUpdate];
        [(__bridge NSMutableDictionary *)searchQuery removeObjectForKey:(__bridge id)kSecMatchLimit];
        
        status = SecItemAdd(searchQuery, NULL);
        
		NSAssert(status == errSecSuccess, @"Couldn't add the Keychain Item.");
        
        success = (status == errSecSuccess);
    }
    
    return success;
}

+ (BOOL)deleteItemWithService:(NSString *)service
{
    CFMutableDictionaryRef searchQuery = [self searchQueryWithService:service needLoadData:NO];
    
    if (searchQuery == NULL)
    {
        return NO;
    }
    
    OSStatus status = SecItemDelete(searchQuery);
    
    NSAssert(status == errSecSuccess || status == errSecItemNotFound, @"Couldn't delete the Keychain Item.");
    
    return (status == errSecSuccess || status == errSecItemNotFound);
}

+ (CFMutableDictionaryRef)searchQueryWithService:(NSString *)service needLoadData:(BOOL)loadData
{
    if (service == nil)
    {
        return NULL;
    }
    
    CFMutableDictionaryRef searchQuery = (__bridge CFMutableDictionaryRef)[NSMutableDictionary dictionary];
    
    // Use generic password class with unique service key attribute as identifier.
    CFDictionarySetValue(searchQuery, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(searchQuery, kSecAttrService, (__bridge const void *)service);
    
    if (loadData)
    {
        CFDictionarySetValue(searchQuery, kSecReturnData, kCFBooleanTrue);
        CFDictionarySetValue(searchQuery, kSecReturnAttributes, kCFBooleanTrue);
    }
    
    return searchQuery;
}

@end
