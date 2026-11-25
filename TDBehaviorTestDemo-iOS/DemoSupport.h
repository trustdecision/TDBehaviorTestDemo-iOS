#import <UIKit/UIKit.h>

UIColor *TDColor(NSInteger hex);
UIColor *TDBlue(void);
UIColor *TDTicketBlue(void);
UIColor *TDText(void);
UIColor *TDMuted(void);
UIColor *TDBackground(void);
UILabel *TDLabel(NSString *text, CGFloat size, UIFontWeight weight, UIColor *color);
UIButton *TDButton(NSString *title, UIColor *background, UIColor *foreground);
UIView *TDCard(void);
UITextField *TDTextField(NSString *placeholder, BOOL secure);
BOOL TDNonEmpty(NSString *value);
void TDShowMessage(UIViewController *controller, NSString *message);

@interface TDDemoSDKClient : NSObject
+ (void)initializeAndStart;
+ (NSString *)statusText;
+ (void)collectAndQuery:(void (^)(NSString *result, NSError *error))completion;
@end

@interface TDBaseViewController : UIViewController
- (void)presentPrivacyWithCompletion:(void (^)(void))completion;
- (void)submitRiskWithTitle:(NSString *)title;
@end
