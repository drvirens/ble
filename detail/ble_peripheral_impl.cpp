//
//  ble_peripheral_impl.cpp
//  vPeripheral
//
//  Created by Virendra Shakya on 5/24/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/detail/ble_peripheral_impl.h"
#include "logging/log_logger.h"

namespace ble
{
namespace detail
{
    
void CPeripheralImpl::Construct()
    {
    iNativePeripheralHandle = new CPeripheralNative();
    }

CPeripheralImpl::CPeripheralImpl()
    {
    }

CPeripheralImpl* CPeripheralImpl::New()
    {
    CPeripheralImpl* obj = new CPeripheralImpl();
    if( obj )
        {
        obj->Construct();
        }
    return obj;
    }
    
CPeripheralImpl::~CPeripheralImpl()
    {
    }
    
void CPeripheralImpl::Open()
    {
    LOG_INFO << "Open peripheral";
    iNativePeripheralHandle->DoOpen();
    }
    
void CPeripheralImpl::Close()
    {
    LOG_INFO << "Close peripheral";
    iNativePeripheralHandle->DoClose();
    }
    
void CPeripheralImpl::StartAdvertising()
    {
    LOG_INFO << "StartAdvertising for peripheral";
    iNativePeripheralHandle->DoStartAdvertising();
    }
    
void CPeripheralImpl::StopAdvertising()
    {
    LOG_INFO << "StopAdvertising for peripheral";
    iNativePeripheralHandle->DoStopAdvertising();
    }
    
bool CPeripheralImpl::IsAdvertising() const
    {
    return iNativePeripheralHandle->DoIsAdvertising();
    }
    

} //namespace detail
} //namespace ble
