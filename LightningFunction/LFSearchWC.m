//
//  LFSearchWC.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFSearchWC.h"
#import "LFFunction.h"

@interface LFSearchWC ()

@property (retain) IBOutlet NSTextField *input;
@property (retain) IBOutlet NSTableView *suggestions;
@property (retain) IBOutlet NSTextView *selectedFunction;

@property (retain) NSArray *allResults;

@end

@implementation LFSearchWC

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark -
- (void)controlTextDidChange:(NSNotification *)notification
{
    if([notification object] == self.input)
    {
        NSLog(@"The contents of the text field changed");
    }
}

#pragma mark NSTABLEVIEWDELEGATES
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.allResults count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSAssert([[self.allResults objectAtIndex:rowIndex] isKindOfClass:[LFFunction class]], @"wrong class for tableview");
    LFFunction *func = (LFFunction*)[self.allResults objectAtIndex:rowIndex];
    return func.title;
}


#pragma mark - FETCH

@end
