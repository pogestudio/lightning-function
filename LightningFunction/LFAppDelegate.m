//
//  LFAppDelegate.m
//  LightningFunction
//
//  Created by CAwesome on 2014-05-20.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "LFAppDelegate.h"
#import "LFInputVC.h"

@interface LFAppDelegate()

@property (nonatomic,strong) LFInputVC *masterViewController;

@end

@implementation LFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    // 1. Create the master View Controller
    self.masterViewController = [[LFInputVC alloc] initWithNibName:@"LFInputVC" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.window.contentView).bounds;
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.pogestudio.LightningFunction" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.pogestudio.LightningFunction"];
}


@end
