//
//  ExtensionSectionManager.m
//  MobilityApp
//
//  Created by Dima Vlasenko on 5/23/13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#import "ExtensionManager.h"
#import "ExtensionMetadata.h"
#import "DBManager.h"
#import "ExtensionListCell.h"
#import "ExtensionNonListCell.h"
#import "ExtensionData.h"

static  NSString* kNumType = @"NUMERIC";
static  NSString* kListType = @"LIST";
static  NSString* kTextType = @"TEXT";

static NSInteger extensionTag = 10;

static ExtensionManager * sharedInstance = nil;

@interface ExtensionManager(){
    
    NSArray* extensionsMeta;
    NSMutableDictionary* extensionKeys;
    NSMutableDictionary* extensions;
    NSMutableArray* requieredExtensions;
}

- (NSString*)cellTypeForExtensionType:(NSString*)aType;
- (ExtensionMetadata*)getExtensionForIndex:(NSUInteger)anIndex;
- (NSArray*)extensionListForIndex:(NSUInteger)anIndex;

@end

@implementation ExtensionManager

+ (ExtensionManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ExtensionManager alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    
    if (self=[super init]) {
        extensionKeys = [[NSMutableDictionary alloc]init];
        extensions = [[NSMutableDictionary alloc]init];
        requieredExtensions = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (NSString*)cellTypeForExtensionType:(NSString*)aType{
    
    NSString* retString;
    
    if ([aType isEqualToString:kListType]) {
        retString = @"kListExtensionCell";
    }
    else if ([aType isEqualToString:kNumType]){
        retString = @"kNumExtensionCell";
    }
    else if ([aType isEqualToString:kTextType]){
        retString = @"kTextExtensionCell";
    }
    
    return retString;
    
}

- (NSString*)extensionKeyForTag:(NSUInteger)aTag{
    
    return [extensionKeys objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)aTag]];
}

- (NSUInteger)getExtensionNum{

    extensionsMeta = [[DBManager sharedDatabase]getAllDataForEntity:@"ExtensionMetadata" withPredicate:nil];
    for (ExtensionMetadata* theExt in extensionsMeta) {
        NSString* theProperty = [theExt.extensionProperties componentsSeparatedByString:@","][0];
        if ([theProperty isEqualToString:@"REQUIRED"]) {
            [requieredExtensions addObject:theExt];
        }
    }
    
    return [extensionsMeta count];
}


- (ExtensionMetadata*)getExtensionForIndex:(NSUInteger)anIndex{
    
    ExtensionMetadata* theExt = nil;
    if (anIndex<[extensionsMeta count]) {
        theExt = [extensionsMeta objectAtIndex:anIndex];
    }
    
    return theExt;
}


- (UITableViewCell*)getCellForTable:(UITableView*)aTable forIndex:(NSIndexPath*)anIndex{
    
    ExtensionMetadata* theExt = [self getExtensionForIndex:anIndex.row];
    NSString* theCellType = [self cellTypeForExtensionType:theExt.extensionType];
    UITableViewCell* theCell;
    extensionTag = anIndex.section+anIndex.row;
    NSString* theKey = [NSString stringWithFormat:@"%@,%@",theExt.extensionName,[theExt.extensionID stringValue]];
    [extensionKeys setValue:theKey forKey:[NSString stringWithFormat:@"%ld",(long)extensionTag]];

    if ([theExt.extensionType isEqualToString:kListType])
    {
        theCell = (ExtensionListCell*)[aTable dequeueReusableCellWithIdentifier:theCellType];
        theCell.textLabel.text = theExt.extensionName;
        if ([[self extensionValueForTag:extensionTag]length]==0) {
             NSArray* theArr = [theExt.extensionList componentsSeparatedByString:@","];
            [self modifyExtensionForTag:extensionTag WithValue:theArr[0]];
        }
        theCell.detailTextLabel.text = [self extensionValueForTag:extensionTag];
    }
    else
    {
        theCell = (ExtensionNonListCell*)[aTable dequeueReusableCellWithIdentifier:theCellType];
        [(ExtensionNonListCell*)theCell extName].text = theExt.extensionName;
        [(ExtensionNonListCell*)theCell extField].tag = extensionTag;
        [(ExtensionNonListCell*)theCell extField].text =  [self extensionValueForTag:extensionTag];;
    }
    theCell.tag = extensionTag;
    //extensionTag++;
    
    return theCell;

}

- (NSArray*)extensionListForIndex:(NSUInteger)anIndex{
    
    ExtensionMetadata* theExt = [self getExtensionForIndex:anIndex];
    NSArray* retValue = [theExt.extensionList componentsSeparatedByString:@","];
    return retValue;
}

- (NSArray*)extensionListForSelected{
   
    return [self extensionListForIndex:self.selectedExtension.row];
}

- (void)modifyExtensionForTag:(NSUInteger)aTag WithValue:(NSString*)aValue{
    
    [extensions removeObjectForKey:[self extensionKeyForTag:aTag]];
    [extensions setValue:aValue forKey:[self extensionKeyForTag:aTag]];
    
}

- (void)modifySelecteExtensionWithValue:(NSString*)aValue{
    
    NSUInteger theTag = self.selectedExtension.row+self.selectedExtension.section;
    [self modifyExtensionForTag:theTag WithValue:aValue];
}

- (NSString*)extensionValueForTag:(NSUInteger)aTag{
    
    return [extensions valueForKey:[self extensionKeyForTag:aTag]];
}

- (NSString*)selectedExtensionValue{
    
    NSUInteger theTag = self.selectedExtension.row+self.selectedExtension.section;
    return [self extensionValueForTag:theTag];
}

- (BOOL)validateAllFields{
    
    BOOL retValue = YES;    
    for (ExtensionMetadata* theExt in requieredExtensions) {
         NSString* theKey = [NSString stringWithFormat:@"%@,%@",theExt.extensionName,[theExt.extensionID stringValue]];
        if (![extensions valueForKey:theKey]) {
            NSString* theMessage = [NSString stringWithFormat:@"%@ is required",theExt.extensionName];
            UIAlertView* theAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:theMessage delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [theAlert show];
            retValue = NO;
            break;
        }
    }
    
    return retValue;

}

- (NSString*)resultExtension{
    
    NSMutableArray* theArr = [[NSMutableArray alloc]init];
    for (NSString* theKey in [extensions allKeys]) {
        [theArr addObject:[NSString stringWithFormat:@"%@,%@",theKey,[extensions valueForKey:theKey]]];
    }
    NSString* theRes = [theArr componentsJoinedByString:@";"];

    return theRes;
}

- (void)reset{
    
    extensionTag=0;
    [extensions removeAllObjects];
    [requieredExtensions removeAllObjects];
}

@end
