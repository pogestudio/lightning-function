//
//  LFCDManager.h
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDManagerSuperclass.h"

@interface LFCDManager : CDManagerSuperclass

+(LFCDManager*)sharedManager;

-(id)newFunctionFromBackground;

-(NSFetchRequest *) functionFetchFromBackground;
-(NSArray*)allFunctions;

-(void)listAllFunctions;


@end
