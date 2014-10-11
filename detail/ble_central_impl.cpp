//
//  ble_central_impl.cpp
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/detail/ble_central_impl.h"

namespace ble
{
namespace detail
{

CCentralImpl::~CCentralImpl()
    {
    }
    
CCentralImpl* CCentralImpl::New()
    {
    CCentralImpl* obj = new CCentralImpl();
    if( obj )
        {
        obj->Construct();
        }
    return obj;
    }
    
void CCentralImpl::Open()
    {
    iNativeCentralHandle->DoOpen();
    }
    
void CCentralImpl::Close()
    {
    }
    
void CCentralImpl::ScanDevices(IBLEFutureCallBack* aScanCallback)
    {
    iNativeCentralHandle->DoScanDevices(aScanCallback);
    }
    
void CCentralImpl::StopScan()
    {
    }
    
bool CCentralImpl::IsAdvertising() const
    {
    return false;
    }
    
void CCentralImpl::Construct()
    {
    iNativeCentralHandle = new mac::CCentralImplMAC();
    }
    
CCentralImpl::CCentralImpl() : iNativeCentralHandle(0)
    {
    }
    

} //namespace detail
} //namespace ble
