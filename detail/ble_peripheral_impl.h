//
//  ble_peripheral_impl.h
//  vPeripheral
//
//  Created by Virendra Shakya on 5/24/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vPeripheral__ble_peripheral_impl__
#define __vPeripheral__ble_peripheral_impl__

#include "ble/ble_peripheral.h"
#include "memory/smart_pointer/strong_pointer.h"

#include "build/build_config.h"

#if defined(V_PLATFORM_DARWIN)

#if defined(V_PLATFORM_IOS)

#include "ble/detail/ios/ble_peripheral_impl_IOS.h"
typedef ble::detail::ios::CPeripheralImplIOS CPeripheralNative;
#else //MAC

#include "ble/detail/mac/ble_peripheral_impl_MAC.h"
typedef ble::detail::mac::CPeripheralImplMAC CPeripheralNative;
#endif

#endif


namespace ble
{
namespace detail
{
    
class CPeripheralImpl: public IPeripheral
    {
public:
    virtual ~CPeripheralImpl();
    
    static CPeripheralImpl* New();
    
    virtual void Open();
    virtual void Close();
    virtual void StartAdvertising();
    virtual void StopAdvertising();
    virtual bool IsAdvertising() const;
    
protected:
    void Construct();
    CPeripheralImpl();

protected:
    vctl::TStrongPointer<CPeripheralNative> iNativePeripheralHandle;
    };

} //namespace detail
} //namespace ble



#endif /* defined(__vPeripheral__ble_peripheral_impl__) */
