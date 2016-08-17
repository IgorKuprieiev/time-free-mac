//
//  VirtualMouse.h
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/15/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualMouse : NSObject

- (instancetype)init;
- (BOOL)movePointerToX:(UInt32)x y:(UInt32)y;

@end
