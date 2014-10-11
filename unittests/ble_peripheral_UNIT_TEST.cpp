//
//  ble_peripheral_UNIT_TEST.cpp
//  vClientTemplateLib
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include "ble/ble_peripheral_factory.h"
#include "3p/google/gtest/include/gtest/gtest.h"

namespace ble
{

vctl::TStrongPointer<IPeripheral> p;
TEST(UT_IPeripheral, Trivial)
    {
    TPeripheralFactory f;
    p = f.CreatePeripheral();
    EXPECT_TRUE(p.Get() != NULL);
    
    p->Open();
    
    p->StartAdvertising();
    }

} //namespace ble