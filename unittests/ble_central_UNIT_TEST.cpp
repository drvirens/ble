//
//  ble_central_UNIT_TEST.c
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/ble_central_factory.h"
#include "ble/ble_central_future_cb.h"
#include "3p/google/gtest/include/gtest/gtest.h"

namespace ble
{

//mock
class MyIBLEFutureCallBack : public IBLEFutureCallBack
    {
public:
    virtual void Failed(int aError)
        {
        }
        
    virtual void Succeeded(IScanResponse* aResponse)
        {
        }
        
    virtual void Cancelled()
        {
        }
    };

vctl::TStrongPointer<ICentral> central;
TEST(UT_ICentral, Trivial)
    {
    TCentralFactory f;
    central = f.CreateCentral();
    
    EXPECT_TRUE(central.Get() != NULL);
    
    central->Open();
    
    IBLEFutureCallBack* scannedCB = new MyIBLEFutureCallBack();
    central->ScanDevices(scannedCB);
    
    //when everything is finished, call:
    //central->Close();
    //central = NULL; //delete
    }

} //namespace ble

