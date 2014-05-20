//
//  LFFunctionScanner.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFFunctionScanner.h"

@interface LFFunctionScanner()
{
    NSString *_lastScannedFunctionTitle;
    NSString *_curScanTitle;
    NSString *_curScanBody;
}



@end

@implementation LFFunctionScanner


-(id)init
{
    if (self = [super init]) {
        _lastScannedFunctionTitle = @"";
        _curScanTitle = @"";
        _curScanBody = @"";
    }
    
    return self;
}

-(void)startScanningText:(NSString *)completeString
{
    self.amtOfFunctionsScanned = 0;
    NSUInteger len = [completeString length];
    unichar buffer[len+1];
    
    [completeString getCharacters:buffer range:NSMakeRange(0, len)];
    
    unichar prevChar = 0;
    unichar currentChar = 0;
    
    BOOL isCurrentlyReadingBody = NO;
    BOOL isCurrentlyReadingTitle = NO;
    
    NSInteger startReadingChar = 0;
    
    for(NSInteger currentPos = 0; currentPos < len; currentPos++) {
        prevChar = currentChar;
        currentChar = buffer[currentPos];
        //        NSLog(@"%C - %d", currentChar, (int)currentChar);
        
        
        if(isCurrentlyReadingTitle)
        {
            if (currentChar == '{') {
                isCurrentlyReadingTitle = NO;
                NSInteger posToReadFrom = currentPos - 1; //go back one, since we should skip the body decl
                [self saveTitleFrom:buffer betweenPos:startReadingChar andPos:posToReadFrom];
                isCurrentlyReadingBody = YES;
                startReadingChar = currentPos;
            } else {
                //should skip, since we just want the pos when title ends
                continue;
            }
        }
        
        //make sure to check if end of string, so that the last function can be saved.
        BOOL haveReachedEndOfDocument = currentPos == len-1;
        if ([self isBeginningOfNewFunctionWithFirstLetter:prevChar secondLetter:currentChar] || haveReachedEndOfDocument) {
            
            
            if(isCurrentlyReadingBody)
            {
                isCurrentlyReadingBody = NO;
                NSInteger posToReadTo = haveReachedEndOfDocument ? currentPos : currentPos - 2; //go back two if we are not at the end of string. If then, we should skip the function declaration
                [self saveBodyFrom:buffer betweenPos:startReadingChar andPos:posToReadTo];
                
            }
            startReadingChar = currentPos - 1; //start from the last one
            isCurrentlyReadingTitle = YES;
        }
        
    }
    
    
    
    
    
    //if it was + or -, and current is (
    
    //store the title
    //start a new string
    //then store the {
    //store everything
    //mark as CONTINUING_FROM_PREVIOUS_FUNC = YES
    //until you hit +( or -( again
    
    //store the last letter
    
    [self.delegate scanningIsComplete];
}

-(void)saveBodyFrom:(unichar*)bufferArray betweenPos:(NSInteger)start andPos:(NSInteger)end
{
    NSAssert(_lastScannedFunctionTitle, @"Title is nil when saving body");
    NSString *body =[self stringFrom:bufferArray betweenPos:start andPos:end];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:_lastScannedFunctionTitle, @"title",body, @"body", nil];
    self.amtOfFunctionsScanned++;
    [self.delegate scannedFunctionWithData:data];
}
-(void)saveTitleFrom:(unichar*)incomingBuffer betweenPos:(NSInteger)start andPos:(NSInteger)end
{
    
    _lastScannedFunctionTitle = [self stringFrom:incomingBuffer betweenPos:start andPos:end];
}

-(NSString*)stringFrom:(unichar*)incomingArray betweenPos:(NSInteger)start andPos:(NSInteger)end
{
    NSInteger length = end - start;
    unichar newBuffer[length];
    for(NSInteger currentPos = 0; currentPos <= length; currentPos++) {
        newBuffer[currentPos] = incomingArray[currentPos + start];
        //NSLog(@"copying character: %C",incomingArray[currentPos + start]);
    }
    
    NSString *copiedString = [NSString stringWithCharacters:newBuffer length:length];
    return copiedString;
}

-(BOOL)isBeginningOfNewFunctionWithFirstLetter:(unichar)firstLetter secondLetter:(unichar)secondLetter
{
    unichar acceptableBeginning1 = '-';
    unichar acceptableBeginning2 = '+';
    unichar acceptableSecondLetter = '(';
    
    BOOL isAFunc = NO;
    if ((firstLetter == acceptableBeginning1 || firstLetter == acceptableBeginning2) && acceptableSecondLetter == secondLetter) {
        isAFunc = YES;
    }
    
    return isAFunc;
}

@end
