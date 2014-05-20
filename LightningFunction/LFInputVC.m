//
//  LFInputVC.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFInputVC.h"

@interface LFInputVC ()

@property (strong) IBOutlet NSTextView *theCode;
@property (strong) LFFunctionScanner *theScanner;

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
    //clear previous
        //fuck that atm
    self.theScanner = [[LFFunctionScanner alloc] init];
    self.theScanner.delegate = self;
    [self.theScanner startScanningText:self.theCode.string];
    
    //show LOADING
    //start to add code
    //show DONE
    
}

-(void)prepareScreenForLoading
{
    
}

-(void)scannedFunctionWithData:(NSDictionary *)data
{
    NSString *body = data[@"body"];
        NSString *title = data[@"title"];
    NSLog(@"Received function withTitle:\n%@\nBody:\n%@",title,body);

}



@end
