//
//  ble_peripheral_factory.h
//  vClientTemplateLib
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vClientTemplateLib__ble_peripheral_factory__
#define __vClientTemplateLib__ble_peripheral_factory__

#include "memory/smart_pointer/strong_pointer.h"
#include "ble/ble_peripheral.h"

namespace ble
{
    
class TPeripheralFactory
    {
public:
    ~TPeripheralFactory() {}
    
    vctl::TStrongPointer<IPeripheral> CreatePeripheral();
    
    };

} //namespace ble

#endif /* defined(__vClientTemplateLib__ble_peripheral_factory__) */
