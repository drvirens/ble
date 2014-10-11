//
//  OPeripheral.h
//  vClientTemplateLib
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol OPeripheralDelegate;

@interface OPeripheral : NSObject

@property (nonatomic, assign, readonly) CBPeripheralManagerState iCBPeripheralManagerState;
@property (nonatomic, assign, readonly, getter = isAdvertising) BOOL iIsAdvertising;
@property (nonatomic, assign) id<OPeripheralDelegate> iOPeripheralDelegate;

- (id) initWithUid:(NSString*) aUid;
- (void) startAdvertising;
- (void) stopAdvertising;

@end


//
// ------- OPeripheralDelegate
//
@protocol OPeripheralDelegate <NSObject>

- (void) peripheral:(OPeripheral*)aOPeripheral didStartAdvertisingWithError:(NSError*) aError;

@end
