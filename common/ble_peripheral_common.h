//
//  ble_peripheral_common.h
//  vClientTemplateLib
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

//#ifndef vClientTemplateLib_ble_peripheral_common_h
//#define vClientTemplateLib_ble_peripheral_common_h

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

NS_INLINE CBUUID* BluetoothUuid(NSString* aUuid)
    {
    return [CBUUID UUIDWithString: aUuid];
    }

#define UUID_ANCS_SERVICE                       BluetoothUuid(@"7905F431-B5CE-4E99-A40F-4B1E122D00D0")
#define UUID_ANCS_NOTIFICATION_SOURCE           BluetoothUuid(@"9FBF120D-6301-42D9-8C58-25E699A21DBD")
#define UUID_ANCS_CONTROL_POINT                 BluetoothUuid(@"69D1D8F3-45E1-49A8-9821-9BBDFDAAD9D9")
#define UUID_ANCS_DATA_SOURCE                   BluetoothUuid(@"22EAC6E9-24D6-4BB5-BE44-B36ACE7C7BFB")

#define UUID_IOS_DEVICE_SERVICE                 BluetoothUuid(@"86F7E51E-85B7-4F1D-9884-D0DD9265AE17")
#define UUID_IOS_DEVICE_NAME                    BluetoothUuid(@"9E088FB9-A252-4030-B241-530907731254")
#define UUID_IOS_DEVICE_MODEL                   BluetoothUuid(@"EF0AEE3C-BC66-40C7-AC10-3A060F53FDA9")


//#endif
