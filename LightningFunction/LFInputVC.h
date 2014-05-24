//
//  LFInputVC.h
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LFFunctionScanner.h"
#import "LFFileScanner.h"

@interface LFInputVC : NSViewController <ScannerReceiver,FileScannerDelegate>

@end
