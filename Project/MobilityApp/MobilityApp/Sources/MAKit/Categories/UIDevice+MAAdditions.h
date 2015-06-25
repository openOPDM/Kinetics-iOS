//
//  UIDevice+MAAdditions.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/13/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (MAAdditions)

- (NSString *)ma_certifiedDevices;

- (BOOL)isMa_certified;

@end
