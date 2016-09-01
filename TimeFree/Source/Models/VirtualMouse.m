//
//  VirtualMouse.m
//  TimeFree
//
//  Created by Oleksii Naboichenko on 8/15/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

#import "VirtualMouse.h"

unsigned char fooHidMouseReportDescriptor[] = {
    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x02,                    // USAGE (Mouse)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x09, 0x01,                    //   USAGE (Pointer)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x05, 0x09,                    //     USAGE_PAGE (Button)
    0x19, 0x01,                    //     USAGE_MINIMUM (Button 1)
    0x29, 0x03,                    //     USAGE_MAXIMUM (Button 3)
    0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
    0x95, 0x03,                    //     REPORT_COUNT (3)
    0x75, 0x01,                    //     REPORT_SIZE (1)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0x95, 0x01,                    //     REPORT_COUNT (1)
    0x75, 0x05,                    //     REPORT_SIZE (5)
    0x81, 0x03,                    //     INPUT (Cnst,Var,Abs)
    0x05, 0x01,                    //     USAGE_PAGE (Generic Desktop)
    0x09, 0x30,                    //     USAGE (X)
    0x09, 0x31,                    //     USAGE (Y)
    0x15, 0x81,                    //     LOGICAL_MINIMUM (-127)
    0x25, 0x7f,                    //     LOGICAL_MAXIMUM (127)
    0x75, 0x08,                    //     REPORT_SIZE (8)
    0x95, 0x02,                    //     REPORT_COUNT (2)
    0x81, 0x06,                    //     INPUT (Data,Var,Rel)
    0xc0,                          //   END_COLLECTION
    0xc0                           // END_COLLECTION
};

struct FooHidMouse {
    uint8_t buttons;
    int8_t x;
    int8_t y;
};

typedef NS_ENUM(NSInteger, FooHidAction) {
    FooHidActionCreate = 0,
    FooHidActionSend = 2
};

static const char * virtualMouseServiceName = "it_unbit_foohid";
static NSString * const virtualMouseDefaultDeviceName = @"Foohid Virtual Mouse";
static NSString * const virtualMouseDefaultDeviceSerialNumber = @"SN 123456";

@interface VirtualMouse()

@property (nonatomic, assign) io_connect_t connection;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceSerialNumber;

@end

@implementation VirtualMouse


- (instancetype)init {
    return [self initWithDeviceName:virtualMouseDefaultDeviceName deviceSerialNumber:virtualMouseDefaultDeviceSerialNumber];
}

- (instancetype)initWithDeviceName:(NSString *)deviceName deviceSerialNumber:(NSString *)deviceSerialNumber {
    self = [super init];
    if (self) {
        self.deviceName = deviceName;
        self.deviceSerialNumber = deviceSerialNumber;
        
        // Get a reference to the IOService
        io_iterator_t matchingServices = 0;
        
        if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching(virtualMouseServiceName), &matchingServices) != KERN_SUCCESS) {
            printf("Unable to access IOService.\n");
            return nil;
        }
        
        // Iterate till success
        bool isConnected = NO;
        while (isConnected != YES) {
            io_service_t service = IOIteratorNext(matchingServices);
            if (service == IO_OBJECT_NULL) {
                break;
            }
            if (IOServiceOpen(service, mach_task_self(), 0, &_connection) == KERN_SUCCESS) {
                isConnected = YES;
                break;
            }
            IOObjectRelease(service);
        }
        IOObjectRelease(matchingServices);
        
        if (isConnected == NO) {
            printf("Unable to open IOService.\n");
            return nil;
        }

        // Fill up the input arguments.
        uint32_t inputCount = 8;
        uint64_t input[inputCount];
        input[0] = (uint64_t)strdup(self.deviceName.UTF8String);  // device name
        input[1] = strlen((char *)input[0]);    // name length
        input[2] = (uint64_t)fooHidMouseReportDescriptor;   // report descriptor
        input[3] = sizeof(fooHidMouseReportDescriptor);     // report descriptor len
        input[4] = (uint64_t) strdup(self.deviceSerialNumber.UTF8String);   // serial number
        input[5] = strlen((char *)input[4]);    // serial number len
        input[6] = (uint64_t)2;     // vendor ID
        input[7] = (uint64_t)3;     // device ID
        if (IOConnectCallScalarMethod(self.connection, FooHidActionCreate, input, inputCount, NULL, 0) != KERN_SUCCESS) {
            printf("Unable to create HID device. May be fine if created previously.\n");
        }
    }
    return self;
}

- (void)dealloc {
    IOServiceClose(self.connection);
}

- (BOOL)movePointerToX:(UInt32)x y:(UInt32)y {
    // Arguments to be passed through the HID message.
    struct FooHidMouse mouse;
    mouse.x = x;
    mouse.y = y;
    mouse.buttons = 0;
    
    uint32_t inputCount = 4;
    uint64_t input[inputCount];
    input[0] = (uint64_t)strdup(self.deviceName.UTF8String);  // device name
    input[1] = strlen((char *)input[0]);  // name length
    input[2] = (uint64_t)&mouse;    // mouse struct
    input[3] = sizeof(struct FooHidMouse);  // mouse struct len
    
    if (IOConnectCallScalarMethod(self.connection, FooHidActionSend, input, inputCount, NULL, 0) != KERN_SUCCESS) {
        printf("Unable to send message to HID device.\n");
        return NO;
    }
    return YES;
}

@end
