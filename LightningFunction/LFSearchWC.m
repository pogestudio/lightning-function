//
//  LFSearchWC.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFSearchWC.h"
#import "LFFunction.h"
#import "LFCDManager.h"

@interface LFSearchWC ()

@property (retain) IBOutlet NSTextField *input;
@property (retain) IBOutlet NSTableView *suggestions;
@property (retain) IBOutlet NSTextView *selectedFunction;
@property (retain) IBOutlet NSTableView *tableView;

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

- (void)windowWillLoad
{
    [super windowWillLoad];
    
    //    [self searchForText:@"-"];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark -
- (void)controlTextDidChange:(NSNotification *)notification
{
    if([notification object] == self.input)
    {
        [self searchForTextAtInput];
    }
}

#pragma mark NSTABLEVIEWDELEGATES
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    NSAssert([[self.allResults objectAtIndex:row] isKindOfClass:[LFFunction class]], @"wrong class for tableview");
    LFFunction *func = (LFFunction*)[self.allResults objectAtIndex:row];

    NSDictionary *attributes = @{NSFontAttributeName: [self fontForTitleCell]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    
    NSSize rect = [func.title sizeWithAttributes:attributes];
    
    CGFloat height = [self heightForString:func.title withFont:[self fontForTitleCell] andWith:self.tableView.frame.size.width];
    
    

    return height;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger count = [self.allResults count];
    return count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSString *identifier = @"Titles";
    // Get an existing cell with the MyView identifier if it exists
    NSTextField *result = [tableView makeViewWithIdentifier:identifier owner:self];
    
    // There is no existing cell to reuse so create a new one
    if (result == nil) {
        
        // Create the new NSTextField with a frame of the {0,0} with the width of the table.
        // Note that the height of the frame is not really relevant, because the row height will modify the height.

        CGFloat xFrame = 0;
        CGFloat yFrame = 0;
        CGFloat widthFrame = [tableColumn width];
        CGFloat heightFrame = 200;
        CGRect newFrame = CGRectMake(xFrame, yFrame, widthFrame, heightFrame);
        result = [[NSTextField alloc] initWithFrame:newFrame];
        result.font = [self fontForTitleCell];
        
        // The identifier of the NSTextField instance is set to MyView.
        // This allows the cell to be reused.
        result.identifier = identifier;
        
    }
    
    // result is now guaranteed to be valid, either as a reused cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    NSAssert([[self.allResults objectAtIndex:row] isKindOfClass:[LFFunction class]], @"wrong class for tableview");
    LFFunction *func = (LFFunction*)[self.allResults objectAtIndex:row];
    result.stringValue = func.title;
    return result;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    
    [self updateTextViewWithSelectedRow];
}

#pragma mark TEXT
-(void)updateTextViewWithSelectedRow
{
    NSInteger row = [self.tableView selectedRow];
    NSAssert([[self.allResults objectAtIndex:row] isKindOfClass:[LFFunction class]], @"wrong class for tableview");
    LFFunction *func = (LFFunction*)[self.allResults objectAtIndex:row];
    [self.selectedFunction setString:func.body];
}

#pragma mark SEARCH
-(void)searchForTextAtInput
{
    [self searchForText:self.input.stringValue];
}

-(void)searchForText:(NSString*)inputText
{
    NSFetchRequest *req = [[LFCDManager sharedManager] fetchRequestForFunctionFromMaster];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)",inputText];
    [req setPredicate:predicate];
    
    NSArray *results = [[LFCDManager sharedManager] performFetch:req];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                               ascending:YES
                                                              comparator:^NSComparisonResult(id obj1, id obj2) {
                                                                  NSInteger len1 = [obj1 length];
                                                                  NSInteger len2 = [obj2 length];
                                                                  if (len1 < len2) return NSOrderedAscending;
                                                                  if (len1 > len2) return NSOrderedDescending;
                                                                  return NSOrderedSame;
                                                              }];
    NSArray *sorted = [results sortedArrayUsingDescriptors:@[sortDesc]];
    [self reloadDataInTableViewToArray:sorted];
}

-(void)reloadDataInTableViewToArray:(NSArray*)newData
{
//    [self.tableView beginUpdates];
//    NSUInteger maxCount = [self.allResults count] > 0 ? [self.allResults count] : 0;
//    NSRange allCurrentRows = NSMakeRange(0, maxCount);
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:allCurrentRows];
//    [self.tableView removeRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectNone];
//
    self.allResults = newData;
//
//    maxCount = [self.allResults count] > 0 ? [self.allResults count] : 0;
//    allCurrentRows = NSMakeRange(0, maxCount);
//    indexSet = [NSIndexSet indexSetWithIndexesInRange:allCurrentRows];
//    [self.tableView insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectNone];
//    
//    [self.tableView endUpdates];
    
    [self.tableView reloadData];
}

#pragma mark - FETCH

NSFont *_staticFont;
-(NSFont*)fontForTitleCell
{
    if (!_staticFont) {
        _staticFont = [NSFont fontWithName:@"HelveticaNeue" size:14];
    }
    return _staticFont;
}

-(CGFloat)heightForString:(NSString*)myString withFont:(NSFont *)myFont andWith:(CGFloat)myWidth
{
    NSTextStorage *textStorage = [[NSTextStorage alloc]
                                   initWithString:myString];
    NSTextContainer *textContainer = [[NSTextContainer alloc]
                                      initWithContainerSize: NSMakeSize(myWidth, FLT_MAX)] ;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager
            usedRectForTextContainer:textContainer].size.height;
}

#pragma mark


@end
