//
//  ble_peripheral.h
//  vPeripheral
//
//  Created by Virendra Shakya on 5/24/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vPeripheral__ble_peripheral__
#define __vPeripheral__ble_peripheral__

#include "memory/ref/rc.h"

namespace ble
{
    
class IPeripheral : public vctl::CReference<IPeripheral>
    {
public:
    virtual ~IPeripheral() {}
    
    virtual void Open() = 0;
    virtual void Close() = 0;
    virtual void StartAdvertising() = 0;
    virtual void StopAdvertising() = 0;
    virtual bool IsAdvertising() const = 0;
    };

} //namespace ble


#endif /* defined(__vPeripheral__ble_peripheral__) */
