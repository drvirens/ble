//
//  ble_central_impl.h
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vNotificationMac__ble_central_impl__
#define __vNotificationMac__ble_central_impl__


#include "ble/ble_central.h"
#include "memory/smart_pointer/strong_pointer.h"

#include "build/build_config.h"

#if defined(V_PLATFORM_DARWIN)

#if defined(V_PLATFORM_IOS)

#include "ble/detail/ios/ble_central_impl_IOS.h"
typedef ble::detail::ios::CCentralImplIOS CCentralNative;

#else //MAC

#include "ble/detail/mac/ble_central_impl_MAC.h"
typedef ble::detail::mac::CCentralImplMAC CCentralNative;
#endif

#endif


namespace ble
{
namespace detail
{
    
class CCentralImpl: public ICentral
    {
public:
    virtual ~CCentralImpl();
    
    static CCentralImpl* New();
    
    virtual void Open();
    virtual void Close();
    virtual void ScanDevices(IBLEFutureCallBack* aScanCallback);
    virtual void StopScan();
    virtual bool IsAdvertising() const;
    
protected:
    void Construct();
    CCentralImpl();

protected:
    vctl::TStrongPointer<CCentralNative> iNativeCentralHandle;
    };

} //namespace detail
} //namespace ble


#endif /* defined(__vNotificationMac__ble_central_impl__) */
