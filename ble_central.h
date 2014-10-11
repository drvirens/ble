//
//  ble_central.h
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vNotificationMac__ble_central__
#define __vNotificationMac__ble_central__

#include "memory/ref/rc.h"

namespace ble
{

class IBLEFutureCallBack;

class ICentral : public vctl::CReference<ICentral>
    {
public:
    virtual ~ICentral() {}
    
    virtual void Open() = 0;
    virtual void Close() = 0;
    virtual void ScanDevices(IBLEFutureCallBack* aScanCallback) = 0;
    virtual void StopScan() = 0;
    virtual bool IsAdvertising() const = 0;
    };

} //namespace ble


#endif /* defined(__vNotificationMac__ble_central__) */
