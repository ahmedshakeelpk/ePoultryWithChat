#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Sinch/SINExport.h>
#import <Sinch/SINAPSEnvironment.h>
#import <Sinch/Sinch.h>

@interface SINUIViewController : UIViewController

@property (nonatomic, readonly, assign) BOOL isAppearing;
@property (nonatomic, readonly, assign) BOOL isDisappearing;

- (void)dismiss;
- (id<SINNotificationResult>)handleRemoteNotificationResultManual: (NSDictionary*)userInfo CallClientID:(id<SINClient>)client;
@end


SIN_EXPORT SIN_EXTERN NSString *const SINPushTypeVoIP NS_AVAILABLE_IOS(8_0);
