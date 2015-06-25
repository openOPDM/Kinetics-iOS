//
//  MAUser.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAProject;

@interface MAUser : NSObject

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *secondName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *UID;

@property (nonatomic, copy) NSArray *projects; // Array of MAProject objects.

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *sessionToken;
@property (nonatomic) MAProject *currentProject;

+ (instancetype)currentUser;
+ (void)setCurrentUser:(MAUser *)user;

@end
