//
//  LFFileScanner.h
//  LightningFunction
//
//  Created by CAwesome on 2014-05-22.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileScannerDelegate

-(void)gotStringFromFile:(NSString*)contentsOfFile;

@end

@interface LFFileScanner : NSObject

@property (weak) id<FileScannerDelegate> delegate;


-(void)startScanning;

@end
