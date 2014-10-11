//
//  ble_peripheral_impl_IOS.cpp
//  vPeripheral
//
//  Created by Virendra Shakya on 5/24/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/detail/ios/ble_peripheral_impl_IOS.h"
#import "ble/detail/ios/OPeripheral.h"

namespace ble
{
namespace detail
{
namespace ios
{

static OPeripheral* gOPeripheral;

CPeripheralImplIOS::~CPeripheralImplIOS()
    {
    }
    
void CPeripheralImplIOS::DoOpen()
    {
    gOPeripheral = [[OPeripheral alloc] initWithUid:@"3096"];
    [gOPeripheral startAdvertising];
    }
    
void CPeripheralImplIOS::DoClose()
    {
    }
    
void CPeripheralImplIOS::DoStartAdvertising()
    {
//    [server startAdvertising];
    }
    
void CPeripheralImplIOS::DoStopAdvertising()
    {
    }
    
bool CPeripheralImplIOS::DoIsAdvertising() const
    {
    return false;
    }
    

} //namespace ios
} //namespace detail
} //namespace ble

