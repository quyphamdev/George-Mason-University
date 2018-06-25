//
//  BluetoothECGAppDelegate.h
//  BluetoothECG
//
//  Created by Quy Pham on 2/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BTInquiryViewController.h"
#import "ECGSketch.h"

@interface BluetoothECGAppDelegate : NSObject <UIApplicationDelegate,BTInquiryDelegate> {
    
    UIWindow *window;
	BTInquiryViewController *inqViewControl;
//	UINavigationController *navControl;

	NSMutableData *receivedData;

}

- (void)uploadData: (char *)data;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BTInquiryViewController *inqViewControl;
//@property (nonatomic, retain) UINavigationController *navControl;


@end

