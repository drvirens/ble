//
//  ble_central_future_cb.h
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vNotificationMac__ble_central_future_cb__
#define __vNotificationMac__ble_central_future_cb__

#include "memory/ref/rc_thread_safe.h"

namespace ble
{

class IScanResponse;

class IBLEFutureCallBack : public vctl::CReferenceThreadSafe<IBLEFutureCallBack>
    {
public:
    virtual void Failed(int aError) = 0;
    virtual void Succeeded(IScanResponse* aResponse) = 0;
    virtual void Cancelled() = 0;
    
protected:
    virtual ~IBLEFutureCallBack() {}
    friend class vctl::CReferenceThreadSafe<IBLEFutureCallBack>;
    };

} //namespace vctl


#endif /* defined(__vNotificationMac__ble_central_future_cb__) */
