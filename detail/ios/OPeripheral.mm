//
//  OPeripheral.m
//  vClientTemplateLib
//
//  Created by Virendra Shakya on 5/25/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#include <sys/sysctl.h>

#import "ble/detail/ios/OPeripheral.h"
#import "ble/common/ble_peripheral_common.h"

#include "logging/log_logger.h"

static const char* kDispatchQueueLabel = "com.tev.apps.chat.OPeripheral.iDispatchQueue";

@interface OPeripheral () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager* iCBPeripheralManager;
@property (nonatomic, strong) CBMutableService* iCBMutableService;
@property (nonatomic) dispatch_queue_t iDispatchQueue;
@property (nonatomic, assign, readwrite) CBPeripheralManagerState iCBPeripheralManagerState;
@property (nonatomic, assign) BOOL iShouldAdvertise;

@end

@implementation OPeripheral
    {
    BOOL iDidStartAdvertising;
    }

- (id) initWithUid:(NSString*) aUid
    {
    self = [super init];
    if( self )
        {
//        _iDispatchQueue = dispatch_queue_create(kDispatchQueueLabel, DISPATCH_QUEUE_SERIAL);
        _iDispatchQueue = nil;
        NSMutableDictionary* options = [@{CBPeripheralManagerOptionShowPowerAlertKey : @YES} mutableCopy];
        if( aUid.length )
            {
            options[CBPeripheralManagerOptionRestoreIdentifierKey] = aUid;
            }
        
        options = nil; //testing
        _iCBPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:_iDispatchQueue options:options];
        }
    return self;
    }
    
- (void) startAdvertising
    {
    LOG_INFO << "OPeripheral::startAdvertising";
    self.iShouldAdvertise = YES;
    if( CBCentralManagerStatePoweredOn == self.iCBPeripheralManager.state && !self.iIsAdvertising)
        {
        NSDictionary* d = @{CBAdvertisementDataServiceUUIDsKey: @[UUID_ANCS_SERVICE, UUID_IOS_DEVICE_SERVICE],
                            CBAdvertisementDataLocalNameKey : UIDevice.currentDevice.name};
        [self.iCBPeripheralManager startAdvertising:d];
        }
    }

- (void) stopAdvertising
    {
    self.iShouldAdvertise = NO;
    if(self.iCBPeripheralManager.isAdvertising)
        {
        [self.iCBPeripheralManager stopAdvertising];
        }
    }

- (BOOL) isAdvertising
    {
    return self.iCBPeripheralManager.isAdvertising;
    }

+ (NSData*) deviceName
    {
    return [UIDevice.currentDevice.name dataUsingEncoding:NSUTF8StringEncoding];
    }

+ (NSData*) deviceModel
    {
    size_t size = 20;
    char* model = (char*)malloc(size);
    int mib[] = {CTL_HW, HW_MACHINE};
    sysctl(mib, 2, model, &size, NULL, 0);
    NSData* data = [NSData dataWithBytes:model length:size - 1];
    free(model);
    return data;
    }

- (CBMutableService*) createMutableService
    {
    CBMutableService* service = [[CBMutableService alloc] initWithType:UUID_IOS_DEVICE_SERVICE primary:YES];
    NSData* name = self.class.deviceName;
    NSData* model = self.class.deviceModel;
    
    CBMutableCharacteristic* characteristic1 = [[CBMutableCharacteristic alloc]
                                                    initWithType:UUID_IOS_DEVICE_NAME
                                                    properties:CBCharacteristicPropertyRead
                                                    value:name permissions:CBAttributePermissionsReadable];
        
    CBMutableCharacteristic* characteristic2 = [[CBMutableCharacteristic alloc]
                                                initWithType:UUID_IOS_DEVICE_MODEL
                                                properties:CBCharacteristicPropertyRead
                                                value:model permissions:CBAttributePermissionsReadable];
        
    service.characteristics = @[characteristic1, characteristic2];
    
    return service;
    }

// CBPeripheralManagerDelegate
/*!
 *  @method peripheralManagerDidUpdateState:
 *
 *  @param peripheral   The peripheral manager whose state has changed.
 *
 *  @discussion         Invoked whenever the peripheral manager's state has been updated. Commands should only be issued when the state is 
 *                      <code>CBPeripheralManagerStatePoweredOn</code>. A state below <code>CBPeripheralManagerStatePoweredOn</code>
 *                      implies that advertisement has paused and any connected centrals have been disconnected. If the state moves below
 *                      <code>CBPeripheralManagerStatePoweredOff</code>, advertisement is stopped and must be explicitly restarted, and the
 *                      local database is cleared and all services must be re-added.
 *
 *  @see                state
 *
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
    {
    LOG_INFO << "peripheralManagerDidUpdateState";
    self.iCBPeripheralManagerState = peripheral.state;
    
    if(CBPeripheralManagerStatePoweredOn == self.iCBPeripheralManagerState)
        {
        LOG_INFO << "OKAY: CBPeripheralManagerStatePoweredOn";
        if(self.iCBMutableService == nil)
            {
            self.iCBMutableService = [self createMutableService];
            if(self.iCBMutableService != nil)
                {
                [self.iCBPeripheralManager addService:self.iCBMutableService];
                }
            }
        }
        else
            {
            /*
            CBPeripheralManagerStateUnknown = 0,
            CBPeripheralManagerStateResetting,
            CBPeripheralManagerStateUnsupported,
            CBPeripheralManagerStateUnauthorized,
            CBPeripheralManagerStatePoweredOff,
            */
            LOG_ERROR << "ERROR??: CBPeripheralManagerStatePoweredOn";
            [self stopAdvertising];
            }
    }

/*!
 *  @method peripheralManager:didAddService:error:
 *
 *  @param peripheral   The peripheral manager providing this information.
 *  @param service      The service that was added to the local database.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method returns the result of an @link addService: @/link call. If the service could
 *                      not be published to the local database, the cause will be detailed in the <i>error</i> parameter.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
    {
    LOG_INFO << "peripheralManager:didAddService";
    if(self.iShouldAdvertise)
        {
        [self startAdvertising];
        }
    }


/*!
 *  @method peripheralManagerDidStartAdvertising:error:
 *
 *  @param peripheral   The peripheral manager providing this information.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method returns the result of a @link startAdvertising: @/link call. If advertisement could
 *                      not be started, the cause will be detailed in the <i>error</i> parameter.
 *
 */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
    {
    LOG_INFO << "peripheralManagerDidStartAdvertising";
    if(iDidStartAdvertising)
        {
        dispatch_async(dispatch_get_main_queue(),
                        ^
                            {
                            LOG_INFO << "notify delegates here todo";
                            }
                      );
        }
    }


/*!
 *  @method peripheralManager:willRestoreState:
 *
 *  @param peripheral	The peripheral manager providing this information.
 *  @param dict			A dictionary containing information about <i>peripheral</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion			For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *						the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *						Bluetooth system.
 *
 *  @seealso            CBPeripheralManagerRestoredStateServicesKey;
 *  @seealso            CBPeripheralManagerRestoredStateAdvertisementDataKey;
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict
    {
    LOG_INFO << "peripheralManager:willRestoreState";
    }


/*!
 *  @method peripheralManager:central:didSubscribeToCharacteristic:
 *
 *  @param peripheral       The peripheral manager providing this update.
 *  @param central          The central that issued the command.
 *  @param characteristic   The characteristic on which notifications or indications were enabled.
 *
 *  @discussion             This method is invoked when a central configures <i>characteristic</i> to notify or indicate.
 *                          It should be used as a cue to start sending updates as the characteristic value changes.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central
    didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
    {
    LOG_INFO << "peripheralManager:central:didSubscribeToCharacteristic";
    }


/*!
 *  @method peripheralManager:central:didUnsubscribeFromCharacteristic:
 *
 *  @param peripheral       The peripheral manager providing this update.
 *  @param central          The central that issued the command.
 *  @param characteristic   The characteristic on which notifications or indications were disabled.
 *
 *  @discussion             This method is invoked when a central removes notifications/indications from <i>characteristic</i>.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central
    didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
    {
    LOG_INFO << "peripheralManager:central:didUnsubscribeFromCharacteristic";
    }


/*!
 *  @method peripheralManager:didReceiveReadRequest:
 *
 *  @param peripheral   The peripheral manager requesting this information.
 *  @param request      A <code>CBATTRequest</code> object.
 *
 *  @discussion         This method is invoked when <i>peripheral</i> receives an ATT request for a characteristic with a dynamic value.
 *                      For every invocation of this method, @link respondToRequest:withResult: @/link must be called.
 *
 *  @see                CBATTRequest
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
    {
    LOG_INFO << "peripheralManager didReceiveReadRequest";
    }


/*!
 *  @method peripheralManager:didReceiveWriteRequests:
 *
 *  @param peripheral   The peripheral manager requesting this information.
 *  @param requests     A list of one or more <code>CBATTRequest</code> objects.
 *
 *  @discussion         This method is invoked when <i>peripheral</i> receives an ATT request or command for one or more characteristics with a dynamic value.
 *                      For every invocation of this method, @link respondToRequest:withResult: @/link should be called exactly once. If <i>requests</i> contains
 *                      multiple requests, they must be treated as an atomic unit. If the execution of one of the requests would cause a failure, the request
 *                      and error reason should be provided to <code>respondToRequest:withResult:</code> and none of the requests should be executed.
 *
 *  @see                CBATTRequest
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
    {
    LOG_INFO << "peripheralManager didReceiveWriteRequests";
    }


/*!
 *  @method peripheralManagerIsReadyToUpdateSubscribers:
 *
 *  @param peripheral   The peripheral manager providing this update.
 *
 *  @discussion         This method is invoked after a failed call to @link updateValue:forCharacteristic:onSubscribedCentrals: @/link, when <i>peripheral</i> is again
 *                      ready to send characteristic value updates.
 *
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
    {
    LOG_INFO << "peripheralManagerIsReadyToUpdateSubscribers";
    }


@end
