//
//  MATestSession.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/16/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MATestSessionRawData;

@interface MATestSession : NSObject

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *creationDate;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSNumber *isValid;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSArray *extension;

@property (nonatomic) MATestSessionRawData *rawData;

@end
