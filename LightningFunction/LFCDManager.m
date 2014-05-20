//
//  LFCDManager.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFCDManager.h"
#import "LFFunction.h"

static LFCDManager *_sharedManager;

@implementation LFCDManager

+(LFCDManager*)sharedManager
{
    if (!_sharedManager) {
        _sharedManager = [[LFCDManager alloc] init];
    }
    return _sharedManager;
}

-(id)newFunctionFromBackground
{
    LFFunction *function = [self CDObjectFromEntityName:@"LFFunction" inMOC:self.backgroundManagedObjectContext];
    NSAssert([function isKindOfClass:[LFFunction class]], @"wrong class from CD Factory");
    return function;
}

-(NSFetchRequest*) functionFetchFromBackground
{
    NSManagedObjectContext *moc = self.backgroundManagedObjectContext;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"LFFunction" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    return request;
}

-(NSArray*)allFunctions
{
    NSFetchRequest *request = [self functionFetchFromBackground];
    NSArray *results = [self performFetch:request];
    
    return results;
}

-(void)listAllFunctions
{
    NSArray *allFunc = [self allFunctions];
    NSLog(@"Found %lu sessions!",(unsigned long)[allFunc count]);
    for (LFFunction *func in allFunc) {
        NSLog(@"Title: %@\nBody:%@", func.title, func.body);
    }
}

@end
