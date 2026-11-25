#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmField;
@property (nonatomic, strong) UIButton *privacyButton;
@property (nonatomic, assign) BOOL privacyAgreed;
@end

@implementation RegisterViewController
- (void)viewDidLoad { [super viewDidLoad]; self.view.backgroundColor = TDBackground(); [self buildUI]; }
- (void)buildUI {
    UIScrollView *scroll = [[UIScrollView alloc] init]; scroll.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *content = [[UIView alloc] init]; content.translatesAutoresizingMaskIntoConstraints = NO; [self.view addSubview:scroll]; [scroll addSubview:content];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem]; back.translatesAutoresizingMaskIntoConstraints = NO;
    [back setTitle:@"Back to login" forState:UIControlStateNormal]; [back addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    UILabel *brand = TDLabel(@"TrustDecision", 28, UIFontWeightBold, TDBlue()); brand.textAlignment = NSTextAlignmentCenter;
    UIView *card = TDCard(); UILabel *title = TDLabel(@"Create account", 26, UIFontWeightBold, TDText());
    UILabel *desc = TDLabel(@"Register to explore behavior risk detection", 14, UIFontWeightRegular, TDMuted());
    self.accountField = TDTextField(@"Account", NO); self.passwordField = TDTextField(@"Password", YES); self.confirmField = TDTextField(@"Confirm password", YES);
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeSystem]; self.privacyButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; self.privacyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self updatePrivacy]; [self.privacyButton addTarget:self action:@selector(privacyTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *registerButton = TDButton(@"Register", TDBlue(), UIColor.whiteColor); [registerButton addTarget:self action:@selector(registerTapped) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[title, desc, self.accountField, self.passwordField, self.confirmField, self.privacyButton, registerButton]];
    stack.translatesAutoresizingMaskIntoConstraints = NO; stack.axis = UILayoutConstraintAxisVertical; stack.spacing = 14; [card addSubview:stack];
    UILabel *status = TDLabel([TDDemoSDKClient statusText], 12, UIFontWeightRegular, TDMuted()); status.textAlignment = NSTextAlignmentCenter;
    [content addSubview:back]; [content addSubview:brand]; [content addSubview:card]; [content addSubview:status];
    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor], [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor], [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [content.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor], [content.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor],
        [content.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor], [content.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [content.widthAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor], [back.topAnchor constraintEqualToAnchor:content.topAnchor constant:18],
        [back.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24], [brand.topAnchor constraintEqualToAnchor:back.bottomAnchor constant:8],
        [brand.centerXAnchor constraintEqualToAnchor:content.centerXAnchor], [card.topAnchor constraintEqualToAnchor:brand.bottomAnchor constant:26],
        [card.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24], [card.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-24],
        [stack.topAnchor constraintEqualToAnchor:card.topAnchor constant:28], [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:24],
        [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-24], [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-28],
        [status.topAnchor constraintEqualToAnchor:card.bottomAnchor constant:24], [status.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24],
        [status.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-24], [status.bottomAnchor constraintEqualToAnchor:content.bottomAnchor constant:-32]
    ]];
}
- (void)updatePrivacy {
    [self.privacyButton setTitle:(self.privacyAgreed ? @"☑  I agree to the Privacy Policy" : @"☐  I agree to the Privacy Policy") forState:UIControlStateNormal];
    [self.privacyButton setTitleColor:(self.privacyAgreed ? TDBlue() : TDText()) forState:UIControlStateNormal];
}
- (void)privacyTapped {
    if (self.privacyAgreed) { self.privacyAgreed = NO; [self updatePrivacy]; return; }
    __weak typeof(self) weakSelf = self; [self presentPrivacyWithCompletion:^{ weakSelf.privacyAgreed = YES; [weakSelf updatePrivacy]; }];
}
- (void)registerTapped {
    if (!TDNonEmpty(self.accountField.text)) { TDShowMessage(self, @"Enter your account."); return; }
    if (!TDNonEmpty(self.passwordField.text)) { TDShowMessage(self, @"Enter your password."); return; }
    if (!TDNonEmpty(self.confirmField.text)) { TDShowMessage(self, @"Confirm your password."); return; }
    if (![self.passwordField.text isEqualToString:self.confirmField.text]) { TDShowMessage(self, @"Passwords do not match."); return; }
    if (!self.privacyAgreed) { TDShowMessage(self, @"Read and agree to the Privacy Policy first."); return; }
    [self submitRiskWithTitle:@"Registration successful · Risk result"];
}
- (void)backTapped { [self.navigationController popViewControllerAnimated:YES]; }
@end

