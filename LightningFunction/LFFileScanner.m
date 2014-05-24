//
//  LFFileScanner.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-22.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFFileScanner.h"

#define BASE_PATH @"/Users/ca/Desktop/FILESFORLIGHTNINGFUNCTION"


@implementation LFFileScanner

-(void)startScanning{
    
    NSString *file = @"PathHelper.m";
    //NSString *fullPath = [NSString stringWithFormat:@"%@/%@",BASE_PATH,file];
    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *directoryURL = [NSURL URLWithString:BASE_PATH]; // URL pointing to the directory you want to browse
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             NSLog(@"got error when reading: %@",error.description);
                                             return YES;
                                         }];
    
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            // handle error
            
        }
        else if (! [isDirectory boolValue]) {
            NSString *content = [self contentsOfPath:url];
            [self gotContentsOfFile:content];

        }
    }
    
    
    
    
}

-(void)gotContentsOfFile:(NSString*)contents
{
    [self.delegate gotStringFromFile:contents];
}

-(NSString*)contentsOfPath:(NSURL*)fullPath
{
    NSError *error = nil;
    NSString* fileContents = [NSString stringWithContentsOfURL:fullPath encoding:NSUTF8StringEncoding error:&error];
    //    NSString* fileContents = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Got error: %@",error.description);
    }
    return fileContents;
}

@end
