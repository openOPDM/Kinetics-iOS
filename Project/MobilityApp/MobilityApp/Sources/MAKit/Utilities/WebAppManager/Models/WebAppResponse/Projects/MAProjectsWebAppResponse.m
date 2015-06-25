//
//  MAProjectsWebAppResponse.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/6/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAProjectsWebAppResponse.h"

#import "MAConstants.h"

#import "MAProject.h"

@implementation MAProjectsWebAppResponse

#pragma mark
#pragma mark Object Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self != nil)
    {
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
        
        _projects = [projectsMutableArray copy];
    }
    
    return self;
}

@end
