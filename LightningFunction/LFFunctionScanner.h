//
//  LFFunctionScanner.h
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScannerReceiver

/*
 contains strings with keys of
 title
 body
 */
-(void)scannedFunctionWithData:(NSDictionary*)data;

@end

@interface LFFunctionScanner : NSObject

@property (weak) id<ScannerReceiver> delegate;

-(void)startScanningText:(NSString*)completeString;


@end
