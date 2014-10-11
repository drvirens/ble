//
//  ble_central_factory.h
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#ifndef __vNotificationMac__ble_central_factory__
#define __vNotificationMac__ble_central_factory__

#include "memory/smart_pointer/strong_pointer.h"
#include "ble/ble_central.h"

namespace ble
{
    
class TCentralFactory
    {
public:
    ~TCentralFactory() {}
    
    vctl::TStrongPointer<ICentral> CreateCentral();
    
    };

} //namespace ble

#endif /* defined(__vNotificationMac__ble_central_factory__) */
