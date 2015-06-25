//
//  PatientData.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/14/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PatientData : NSManagedObject

@property (nonatomic, retain) NSString * secondName;
@property (nonatomic, retain) NSNumber * patientID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * creationDate;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * birthday;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * testState;

@end
