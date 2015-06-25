//
//  ExtensionSectionManager.h
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/23/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExtensionMetadata;

@interface ExtensionManager : NSObject

@property(nonatomic, retain) NSIndexPath* selectedExtension;
@property(nonatomic, copy) NSString* extensionSt;

+ (ExtensionManager *)sharedInstance;
- (NSUInteger)getExtensionNum;
- (UITableViewCell*)getCellForTable:(UITableView*)aTable forIndex:(NSIndexPath*)anIndex;
- (void)reset;
- (void)modifyExtensionForTag:(NSUInteger)aTag WithValue:(NSString*)aValue;
- (void)modifySelecteExtensionWithValue:(NSString*)aValue;
- (NSArray*)extensionListForSelected;
- (NSString*)extensionValueForTag:(NSUInteger)aTag;
- (NSString*)selectedExtensionValue;
- (NSString*)resultExtension;
- (BOOL)validateAllFields;

@end
