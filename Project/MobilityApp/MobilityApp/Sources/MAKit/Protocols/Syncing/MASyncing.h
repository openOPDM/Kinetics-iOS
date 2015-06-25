//
//  MASyncing.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 2/21/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MASyncing <NSObject>

@optional
- (void)reloadViewContent;
- (void)syncFinished;

@end
