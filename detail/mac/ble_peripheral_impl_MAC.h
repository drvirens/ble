//
//  ble_peripheral_impl_IOS.h
//  vPeripheral
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vPeripheral__ble_peripheral_impl_MAC__
#define __vPeripheral__ble_peripheral_impl_MAC__

#include "memory/ref/rc_thread_safe.h"

namespace ble
{
namespace detail
{
namespace mac
{
    
class CPeripheralImplMAC : public vctl::CReferenceThreadSafe<CPeripheralImplMAC>
    {
public:
    virtual ~CPeripheralImplMAC();
    
    virtual void DoOpen();
    virtual void DoClose();
    virtual void DoStartAdvertising();
    virtual void DoStopAdvertising();
    virtual bool DoIsAdvertising() const;

protected:
    
    };

} //namespace mac
} //namespace detail
} //namespace ble



#endif /* defined(__vPeripheral__ble_peripheral_impl_IOS__) */
