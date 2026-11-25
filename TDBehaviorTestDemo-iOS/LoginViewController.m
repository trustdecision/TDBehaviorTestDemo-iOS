#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "TicketRushViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *privacyButton;
@property (nonatomic, assign) BOOL privacyAgreed;
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [TDDemoSDKClient initializeAndStart]; self.view.backgroundColor = TDBackground(); [self buildUI];
}
- (void)buildUI {
    UIScrollView *scroll = [[UIScrollView alloc] init]; scroll.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *content = [[UIView alloc] init]; content.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scroll]; [scroll addSubview:content];
    UILabel *brand = TDLabel(@"TrustDecision", 30, UIFontWeightBold, TDBlue()); brand.textAlignment = NSTextAlignmentCenter;
    UILabel *subtitle = TDLabel(@"BEHAVIOR RISK INTELLIGENCE", 12, UIFontWeightMedium, TDMuted()); subtitle.textAlignment = NSTextAlignmentCenter;
    UIView *card = TDCard();
    UILabel *title = TDLabel(@"Welcome back", 26, UIFontWeightBold, TDText());
    UILabel *desc = TDLabel(@"Sign in to securely continue", 14, UIFontWeightRegular, TDMuted());
    self.accountField = TDTextField(@"Account", NO); self.accountField.textContentType = UITextContentTypeUsername;
    self.passwordField = TDTextField(@"Password", YES); self.passwordField.textContentType = UITextContentTypePassword;
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeSystem]; self.privacyButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; self.privacyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self updatePrivacy]; [self.privacyButton addTarget:self action:@selector(privacyTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem]; registerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [registerButton setTitle:@"Register" forState:UIControlStateNormal]; registerButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [registerButton addTarget:self action:@selector(registerTapped) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *privacyRow = [[UIStackView alloc] initWithArrangedSubviews:@[self.privacyButton, registerButton]];
    privacyRow.axis = UILayoutConstraintAxisHorizontal; privacyRow.alignment = UIStackViewAlignmentCenter;
    UIButton *login = TDButton(@"Log in", TDBlue(), UIColor.whiteColor); [login addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *ticket = TDButton(@"Ticket Rush Scene", UIColor.whiteColor, TDBlue()); ticket.layer.borderWidth = 1; ticket.layer.borderColor = TDBlue().CGColor;
    [ticket addTarget:self action:@selector(ticketTapped) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[title, desc, self.accountField, self.passwordField, privacyRow, login, ticket]];
    stack.translatesAutoresizingMaskIntoConstraints = NO; stack.axis = UILayoutConstraintAxisVertical; stack.spacing = 14; [card addSubview:stack];
    UILabel *status = TDLabel([TDDemoSDKClient statusText], 12, UIFontWeightRegular, TDMuted()); status.textAlignment = NSTextAlignmentCenter;
    [content addSubview:brand]; [content addSubview:subtitle]; [content addSubview:card]; [content addSubview:status];
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:safe.topAnchor], [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor], [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [content.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor], [content.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor],
        [content.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor], [content.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [content.widthAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor],
        [brand.topAnchor constraintEqualToAnchor:content.topAnchor constant:52], [brand.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24],
        [brand.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-24], [subtitle.topAnchor constraintEqualToAnchor:brand.bottomAnchor constant:5],
        [subtitle.leadingAnchor constraintEqualToAnchor:brand.leadingAnchor], [subtitle.trailingAnchor constraintEqualToAnchor:brand.trailingAnchor],
        [card.topAnchor constraintEqualToAnchor:subtitle.bottomAnchor constant:38], [card.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24],
        [card.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-24], [stack.topAnchor constraintEqualToAnchor:card.topAnchor constant:28],
        [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:24], [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-24],
        [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-28], [status.topAnchor constraintEqualToAnchor:card.bottomAnchor constant:24],
        [status.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24], [status.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-24],
        [status.bottomAnchor constraintEqualToAnchor:content.bottomAnchor constant:-32]
    ]];
}
- (void)updatePrivacy {
    [self.privacyButton setTitle:(self.privacyAgreed ? @"☑  I agree to the Privacy Policy" : @"☐  I agree to the Privacy Policy") forState:UIControlStateNormal];
    [self.privacyButton setTitleColor:(self.privacyAgreed ? TDBlue() : TDText()) forState:UIControlStateNormal];
}
- (void)privacyTapped {
    if (self.privacyAgreed) { self.privacyAgreed = NO; [self updatePrivacy]; return; }
    __weak typeof(self) weakSelf = self;
    [self presentPrivacyWithCompletion:^{ weakSelf.privacyAgreed = YES; [weakSelf updatePrivacy]; }];
}
- (void)loginTapped {
    if (!TDNonEmpty(self.accountField.text)) { TDShowMessage(self, @"Enter your account."); return; }
    if (!TDNonEmpty(self.passwordField.text)) { TDShowMessage(self, @"Enter your password."); return; }
    if (!self.privacyAgreed) { TDShowMessage(self, @"Read and agree to the Privacy Policy first."); return; }
    [self submitRiskWithTitle:@"Login successful · Risk result"];
}
- (void)registerTapped {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)ticketTapped {
    TicketRushViewController *vc = [[TicketRushViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

