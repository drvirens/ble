//
//  OCentralController.h
//  vNotificationMac
//
//  Created by Virendra Shakya on 5/26/14.
//  Copyright (c) 2014 Virendra Shakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCentralControllerDelegate;

@interface OCentralController : NSObject

- (id)initWithDelegate:(id<OCentralControllerDelegate>)aDelegate
    queue:(dispatch_queue_t)aDispatchQueue;

- (void)scanForNotificationCenters;
- (void)stopScanning;

@property (nonatomic, weak) id<OCentralControllerDelegate> iDelegate;
@property (nonatomic, readonly, getter = isScanning) BOOL iScanning;

@end


// ---------- OCentralControllerDelegate

@protocol OCentralControllerDelegate <NSObject>

- (void) controller:(OCentralController*)aController startedScan:(void*)aController;

@end
