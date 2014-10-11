//
//  OCentralController.m
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

//we need to run this central-controller on iPad as well
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#endif

#import "ble/detail/mac/OCentralController.h"
#import "ble/common/ble_peripheral_common.h"

static const NSInteger kExpectedServiceCount = 2;

@interface OCentralController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager* iCentralManager;
@property (nonatomic, strong) dispatch_queue_t iBluetoothQueue;
@property (nonatomic, strong) CBPeripheral* iPeripheral;

@end

@implementation OCentralController

- (id)initWithDelegate:(id<OCentralControllerDelegate>)aDelegate
    queue:(dispatch_queue_t)aDispatchQueue
    {
    self = [super init];
    if( self )
        {
        if( !aDispatchQueue )
            {
            aDispatchQueue = dispatch_get_main_queue();
            }
            
        _iDelegate = aDelegate;
        
        }
    return self;
    }

- (void)scanForNotificationCenters
    {
    _iCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_iBluetoothQueue options:nil];
    }

- (void)stopScanning
    {
    }

// @protocol CBCentralManagerDelegate <NSObject>
// @required methods
/*!
 *  @method centralManagerDidUpdateState:
 *
 *  @param central  The central manager whose state has changed.
 *
 *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
 *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
 *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
 *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
 *                  manager become invalid and must be retrieved or discovered again.
 *
 *  @see            state
 *
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
    {
    NSLog(@"centralManagerDidUpdateState");
    
    switch(central.state)
        {
    case CBCentralManagerStateUnknown:
        {
        NSLog(@"CBCentralManagerStateUnknown");
        } break;
	case CBCentralManagerStateResetting:
        {
        NSLog(@"CBCentralManagerStateResetting");
        } break;
	case CBCentralManagerStateUnsupported:
        {
        NSLog(@"CBCentralManagerStateUnsupported");
        } break;
	case CBCentralManagerStateUnauthorized:
        {
        NSLog(@"CBCentralManagerStateUnauthorized");
        } break;
	case CBCentralManagerStatePoweredOff:
        {
        NSLog(@"CBCentralManagerStatePoweredOff");
        } break;
	case CBCentralManagerStatePoweredOn:
        {
        NSLog(@"CBCentralManagerStatePoweredOn");
        
        [_iCentralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
        //next breakpoint should be in didDiscoverPeripheral if SUCCESS
        } break;
        }
    }

/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *								was not available.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
 *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
    {
    NSLog(@"didDiscoverPeripheral");
    
    _iPeripheral = peripheral;
    [_iCentralManager connectPeripheral:_iPeripheral options:nil];
    }

/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
 *
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
    {
    NSLog(@"didConnectPeripheral");
    
    if(_iPeripheral == peripheral)
        {
        NSLog(@"connect peripheral : SAME");
        }
    else
        {
        NSLog(@"connect peripheral : DIFFERENT");
        }
    [peripheral setDelegate:self];
    [peripheral discoverServices:@[UUID_ANCS_SERVICE, UUID_IOS_DEVICE_SERVICE] ];
    }

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral
    error:(NSError *)error
    {
    NSLog(@"didFailToConnectPeripheral");
    }


/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
 *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
    error:(NSError *)error
    {
    NSLog(@"didDisconnectPeripheral");
    }




/*!
 *  @method centralManager:willRestoreState:
 *
 *  @param central      The central manager providing this information.
 *  @param dict            
 *
 *  @discussion
 *
 */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
    {
    NSLog(@"willRestoreState");
    }

/*!
 *  @method centralManager:didRetrievePeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects.
 *
 *  @discussion         This method returns the result of a {@link retrievePeripherals} call, with the peripheral(s) that the central manager was
 *                      able to match to the provided UUID(s).
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
    {
    NSLog(@"didRetrievePeripherals");
    }

/*!
 *  @method centralManager:didRetrieveConnectedPeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects representing all peripherals currently connected to the system.
 *
 *  @discussion         This method returns the result of a {@link retrieveConnectedPeripherals} call.
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
    {
    NSLog(@"didRetrieveConnectedPeripherals");
    }


//@protocol CBPeripheralDelegate <NSObject>
/*!
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link name @/link of <i>peripheral</i> changes.
 */
//- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(10_9, 6_0);


/*!
 *  @method peripheral:didModifyServices:
 *
 *  @param peripheral	The peripheral providing this update.
 *  @param services		The services that have been invalidated
 *
 *  @discussion			This method is invoked when the @link services @/link of <i>peripheral</i> have been changed.
 *						At this point, the designated <code>CBService</code> objects have been invalidated.
 *						Services can be re-discovered via @link discoverServices: @/link.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices NS_AVAILABLE(10_9, 7_0);

/*!
 *  @method peripheralDidUpdateRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
    {
    NSLog(@"peripheralDidUpdateRSSI");
    }

/*!
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral	The peripheral providing this information.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *						<i>peripheral</i>'s @link services @/link property.
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    {
    NSLog(@"didDiscoverServices");
    
    if(error)
        {
        //TODO: Upcall to UI here
        NSLog(@"ERROR: didDiscoverServices");
        return;
        }
        
    NSArray* discoveredservices = peripheral.services;
    NSMutableArray* foundservices = [NSMutableArray arrayWithCapacity:kExpectedServiceCount];
    if(discoveredservices.count < kExpectedServiceCount)
        {
        NSLog(@"ERROR: discoveredservices count is less than kExpectedServiceCount");
        return;
        }
        
    for(CBService* service in discoveredservices)
        {
        BOOL addservice = NO;
        NSArray* characteristics = nil;
        if([service.UUID isEqual:UUID_ANCS_SERVICE])
            {
            addservice = YES;
            characteristics = @[    UUID_ANCS_CONTROL_POINT,
                                    UUID_ANCS_DATA_SOURCE,
                                    UUID_ANCS_NOTIFICATION_SOURCE
                               ];
            }
        else if([service.UUID isEqual:UUID_IOS_DEVICE_SERVICE])
            {
            addservice = YES;
            characteristics = @[
                                    UUID_IOS_DEVICE_NAME,
                                    UUID_IOS_DEVICE_MODEL
                               ];
            }
        else
            {
            addservice = NO;
            characteristics = nil;
            }
        
        if(addservice && nil != characteristics)
            {
            [foundservices addObject:service];
            [peripheral discoverCharacteristics:characteristics forService:service];
            }
        } //end for
        
    }

/*!
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the characteristic(s).
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully, 
 *						they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral
                didDiscoverCharacteristicsForService:(CBService *)service
                error:(NSError *)error
    {
    NSLog(@"didDiscoverCharacteristicsForService");
    
    if(error)
        {
        //TODO: Upcall to UI here
        NSLog(@"ERROR: didDiscoverCharacteristicsForService");
        return;
        }
        
    NSArray* characteristics = service.characteristics;
    CBUUID* serviceuuid = service.UUID;
    
    if([serviceuuid isEqual:UUID_ANCS_SERVICE])
        {
        for(CBCharacteristic* c in characteristics)
            {
            BOOL notify = NO;
            CBUUID* u = c.UUID;
            if([u isEqual:UUID_ANCS_CONTROL_POINT])
                {
                }
            else if([u isEqual:UUID_ANCS_DATA_SOURCE])
                {
                notify = YES;
                }
            else if([u isEqual:UUID_ANCS_NOTIFICATION_SOURCE])
                {
                notify = YES;
                }
            else
                {
                }
            
            if(notify)
                {
                [peripheral setNotifyValue:YES forCharacteristic:c];
                //will call peripheral:didUpdateValueForCharacteristic:error
                }
            } //end for
        }
    else if([serviceuuid isEqual:UUID_IOS_DEVICE_SERVICE])
        {
        for(CBCharacteristic* c in characteristics)
            {
            CBUUID* u = c.UUID;
            if([u isEqual:UUID_IOS_DEVICE_NAME])
                {
                }
            else if([u isEqual:UUID_IOS_DEVICE_MODEL])
                {
                }
            else
                {
                }
            
            //for testing
            [peripheral readValueForCharacteristic:c];
            //will call peripheral:didUpdateValueForCharacteristic:error
            
            } //end for
        }
    else
        {
        }
    }

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral
            didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
            error:(NSError *)error
    {
    NSLog(@"didUpdateValueForCharacteristic");
    
    if(error)
        {
        //TODO: Upcall to UI here
        NSLog(@"ERROR: didUpdateValueForCharacteristic");
        return;
        }
    
    if([characteristic.UUID isEqual:UUID_ANCS_NOTIFICATION_SOURCE])
        {
        NSLog(@"-----> NotificationSource");
        }
    else if([characteristic.UUID isEqual:UUID_ANCS_DATA_SOURCE])
        {
        NSLog(@"-----> DataSource");
        }
    else
        {
        }
    
    }


/*!
 *  @method peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the included services.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully, 
 *						they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service
    error:(NSError *)error
    {
    NSLog(@"didDiscoverIncludedServicesForService");
    }


/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */
 - (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
 error:(NSError *)error
    {
    NSLog(@"didWriteValueForCharacteristic");
    }

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call. 
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
    error:(NSError *)error
    {
    NSLog(@"didUpdateNotificationStateForCharacteristic");
    }

/*!
 *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully, 
 *							they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
    error:(NSError *)error
    {
    NSLog(@"didDiscoverDescriptorsForCharacteristic");
    }

/*!
 *  @method peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link readValueForDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor
    error:(NSError *)error
    {
    NSLog(@"didUpdateValueForDescriptor");
    }

/*!
 *  @method peripheral:didWriteValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor
    error:(NSError *)error
    {
    NSLog(@"didWriteValueForDescriptor");
    }


@end
