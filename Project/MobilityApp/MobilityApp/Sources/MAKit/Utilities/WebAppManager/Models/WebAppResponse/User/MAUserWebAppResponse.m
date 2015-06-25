//
//  MAUserWebAppResponse.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/8/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAUserWebAppResponse.h"

#import "MAConstants.h"

#import "MAProject.h"
#import "MAUser.h"

@implementation MAUserWebAppResponse

#pragma mark
#pragma mark Object Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self != nil)
    {
        NSDictionary *userDictionary = [MAWebAppResponse ma_object:self.data[kMAWebAppParameterUserKey] validatingUsingClass:[NSDictionary class]];
        
        if (userDictionary != nil)
        {
            _user = [MAUser new];
            _user.identifier = [MAWebAppResponse ma_object:userDictionary[kMAWebAppParameterIDKey] validatingUsingClass:[NSNumber class]];
            _user.email = [MAWebAppResponse ma_object:userDictionary[kMAWebAppParameterEmailKey] validatingUsingClass:[NSString class]];
            _user.firstName = [MAWebAppResponse ma_object:userDictionary[kMAWebAppParameterFirstNameKey] validatingUsingClass:[NSString class]];
            _user.secondName = [MAWebAppResponse ma_object:userDictionary[kMAWebAppParameterSecondNameKey] validatingUsingClass:[NSString class]];
            _user.status = [MAWebAppResponse ma_object:userDictionary[kMAWebAppParameterStatusKey] validatingUsingClass:[NSString class]];
            _user.UID = [MAWebAppResponse ma_object:userDictionary[kMAWebAppParameterUIDKey] validatingUsingClass:[NSString class]];
            
            NSArray *projectsArray = [MAWebAppResponse ma_object:self.data[kMAWebAppParameterProjectKey] validatingUsingClass:[NSArray class]];
            NSMutableArray *projectsMutableArray = [NSMutableArray arrayWithCapacity:[projectsArray count]];
            
            for (NSDictionary *projectDictionary in projectsArray)
            {
                MAProject *project = [MAProject new];
                project.identifier = [MAWebAppResponse ma_object:projectDictionary[kMAWebAppParameterIDKey] validatingUsingClass:[NSNumber class]];
                project.name = [MAWebAppResponse ma_object:projectDictionary[kMAWebAppParameterNameKey] validatingUsingClass:[NSString class]];
                project.status = [MAWebAppResponse ma_object:projectDictionary[kMAWebAppParameterStatusKey] validatingUsingClass:[NSString class]];
                
                [projectsMutableArray addObject:project];
            }
            
            _user.projects = [projectsMutableArray copy];
        }
    }
    
    return self;
}

@end
