//
//  ble_central_factory.cpp
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//


#include "ble/ble_central_factory.h"
#include "ble/detail/ble_central_impl.h"

namespace ble
{
    
vctl::TStrongPointer<ICentral> TCentralFactory::CreateCentral()
    {
    vctl::TStrongPointer<ICentral> p = detail::CCentralImpl::New();
    return p;
    }
    
} //namespace ble
