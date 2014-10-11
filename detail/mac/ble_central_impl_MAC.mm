//
//  ble_central_impl_MAC.cpp
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/detail/mac/ble_central_impl_MAC.h"

#import "ble/detail/mac/OCentralController.h"

namespace ble
{
namespace detail
{
namespace mac
{

static OCentralController* gOCentralController;

CCentralImplMAC::~CCentralImplMAC()
    {
    }
    
void CCentralImplMAC::DoOpen()
    {
    gOCentralController = [[OCentralController alloc] initWithDelegate:nil queue:nil];
    [gOCentralController scanForNotificationCenters];
    }
    
void CCentralImplMAC::DoClose()
    {
    }
    
void CCentralImplMAC::DoScanDevices(IBLEFutureCallBack* aScanCallback)
    {
    }
    
void CCentralImplMAC::DoStopScan()
    {
    }
    
bool CCentralImplMAC::DoIsAdvertising() const
    {
    return false;
    }
    
} //namespace mac
} //namespace detail
} //namespace ble
