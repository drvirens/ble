//
//  ble_central_impl_MAC.h
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vNotificationMac__ble_central_impl_MAC__
#define __vNotificationMac__ble_central_impl_MAC__

#include "memory/ref/rc_thread_safe.h"

namespace ble
{
class IBLEFutureCallBack;

namespace detail
{
namespace mac
{

class CCentralImplMAC : public vctl::CReferenceThreadSafe<CCentralImplMAC>
    {
public:
    ~CCentralImplMAC();
    
    void DoOpen();
    void DoClose();
    void DoScanDevices(IBLEFutureCallBack* aScanCallback);
    void DoStopScan();
    bool DoIsAdvertising() const;

protected:
    
    };

} //namespace mac
} //namespace detail
} //namespace ble


#endif /* defined(__vNotificationMac__ble_central_impl_MAC__) */
