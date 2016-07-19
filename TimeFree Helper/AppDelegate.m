//
//  AppDelegate.m
//  TimeFree Helper
//
//  Created by Oleksii Naboichenko on 7/18/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
    NSString *path = [NSString pathWithComponents:pathComponents];
    [[NSWorkspace sharedWorkspace] launchApplication:path];
    [NSApp terminate:nil];
}

//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    // Insert code here to initialize your application
//}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
