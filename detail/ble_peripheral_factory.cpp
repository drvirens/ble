//
//  ble_peripheral_factory.cpp
//  vClientTemplateLib
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/ble_peripheral_factory.h"
#include "ble/detail/ble_peripheral_impl.h"

namespace ble
{
    
vctl::TStrongPointer<IPeripheral> TPeripheralFactory::CreatePeripheral()
    {
    vctl::TStrongPointer<IPeripheral> p = detail::CPeripheralImpl::New();
    return p;
    }
    
} //namespace ble
