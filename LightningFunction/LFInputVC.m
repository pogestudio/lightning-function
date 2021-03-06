//
//  LFInputVC.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFInputVC.h"
#import "LFFunction+helperMethod.h"
#import "LFCDManager.h"
#import "LFSearchWC.h"


@interface LFInputVC ()

@property (strong) IBOutlet NSTextView *theCode;
@property (strong) IBOutlet NSTextField *statusText;
@property (strong) IBOutlet NSTextField *amtFuncs;
@property (strong) LFFunctionScanner *functionScanner;
@property (strong) LFFileScanner *fileScanner;

@property (strong) LFSearchWC *searchWindow;

@end

@implementation LFInputVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

-(IBAction)parseCode:(id)sender
{
    
    self.functionScanner = [[LFFunctionScanner alloc] init];
    self.functionScanner.delegate = self;
    
    self.fileScanner = [[LFFileScanner alloc] init];
    self.fileScanner.delegate = self;
    [self.fileScanner startScanning];
}

-(IBAction)openSearch:(id)sender
{
    self.searchWindow = [[LFSearchWC alloc] initWithWindowNibName:@"LFSearchWC"];
    [self.searchWindow showWindow:self];

}
-(IBAction)clearDatabase:(id)sender
{
    [[LFCDManager sharedManager] deleteAllFunctions];
    [self updateHUD];
}

-(void)prepareScreenForLoading
{
    [self.statusText setStringValue:@"Scaaaaannning..."];
}

#pragma mark - FILE READ PROTOCOL
-(void)gotStringFromFile:(NSString *)contentsOfFile
{
    [self.functionScanner startScanningText:contentsOfFile];
}

#pragma  mark - SCANNING PROTOTCOL
-(void)scannedFunctionWithData:(NSDictionary *)data
{
//    NSString *body = data[@"body"];
//    NSString *title = data[@"title"];
//    NSLog(@"Received function withTitle:\n%@\nBody:\n%@",title,body);

    NSString *labelTxt = [NSString stringWithFormat:@"Scaaaaannning...\nFuncs: %ld",(long)self.functionScanner.amtOfFunctionsScanned];
    [self.statusText setStringValue:labelTxt];
    LFFunction *func = [[LFCDManager sharedManager] newFunctionFromMasterWithData:data];

}

-(void)scanningIsComplete
{
    NSString *labelTxt = [NSString stringWithFormat:@"Compleshion!\nFuncs: %ld",(long)self.functionScanner.amtOfFunctionsScanned];
    [self.statusText setStringValue:labelTxt];
    [[LFCDManager sharedManager] saveMasterContext];
    [self updateHUD];
    
}

-(void)updateHUD
{
    NSInteger amtOfFuncs = [[[LFCDManager sharedManager] allFunctions] count];
    NSString *labelTxt = [NSString stringWithFormat:@"Stored funcs: %ld",amtOfFuncs];
    [self.amtFuncs setStringValue:labelTxt];
}


@end
