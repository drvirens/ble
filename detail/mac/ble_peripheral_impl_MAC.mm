//
//  ble_peripheral_impl_IOS.cpp
//  vPeripheral
//
//  Created by Virendra Shakya on 5/24/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/detail/mac/ble_peripheral_impl_MAC.h"

namespace ble
{
namespace detail
{
namespace mac
{

CPeripheralImplMAC::~CPeripheralImplMAC()
    {
    }
    
void CPeripheralImplMAC::DoOpen()
    {
    }
    
void CPeripheralImplMAC::DoClose()
    {
    }
    
void CPeripheralImplMAC::DoStartAdvertising()
    {
//    [server startAdvertising];
    }
    
void CPeripheralImplMAC::DoStopAdvertising()
    {
    }
    
bool CPeripheralImplMAC::DoIsAdvertising() const
    {
    return false;
    }
    

} //namespace ios
} //namespace detail
} //namespace ble

