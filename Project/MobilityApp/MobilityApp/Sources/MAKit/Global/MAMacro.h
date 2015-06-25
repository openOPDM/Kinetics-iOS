//
//  MAMacro.h
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/5/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#ifndef MobilityApp_MAMacro_h
#define MobilityApp_MAMacro_h

// Syntesizing a singleton.
#define MA_SINGLETON_SYNTHESIZE(ma_className, ma_methodName)    \
+ (ma_className *)ma_methodName                                 \
{                                                               \
    static ma_className *sharedInstance = nil;                  \
    static dispatch_once_t onceToken;                           \
    dispatch_once(&onceToken, ^(void)                           \
    {                                                           \
        if (sharedInstance == nil)                              \
        {                                                       \
            sharedInstance = [[super allocWithZone:NULL] init]; \
        }                                                       \
    });                                                         \
                                                                \
    return sharedInstance;                                      \
}                                                               \
                                                                \
+ (id)allocWithZone:(NSZone *)zone                              \
{                                                               \
    return [self ma_methodName];                                \
}

#endif
