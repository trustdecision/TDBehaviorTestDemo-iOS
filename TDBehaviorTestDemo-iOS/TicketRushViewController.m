#import "TicketRushViewController.h"

@interface TicketRushViewController ()
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, copy) NSString *selectedAmount;
@property (nonatomic, strong) NSArray<UIButton *> *seatButtons;
@end

@implementation TicketRushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TDColor(0xF3F5F7);
    self.selectedAmount = @"¥102.00";
    [self buildUI];
    [self startCountdown];
}

- (UIView *)paddedCard {
    UIView *card = TDCard();
    card.layer.cornerRadius = 16;
    return card;
}

- (UIView *)routeColumn:(NSString *)primary place:(NSString *)place alignment:(NSTextAlignment)alignment {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 3;
    UILabel *primaryLabel = TDLabel(primary, 19, UIFontWeightBold, TDText());
    UILabel *placeLabel = TDLabel(place, 12, UIFontWeightRegular, TDMuted());
    primaryLabel.textAlignment = alignment;
    placeLabel.textAlignment = alignment;
    [stack addArrangedSubview:primaryLabel];
    [stack addArrangedSubview:placeLabel];
    return stack;
}

- (UIButton *)seatButton:(NSString *)title amount:(NSString *)amount {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TDText() forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = TDColor(0xFAFBFC);
    button.layer.cornerRadius = 12;
    button.layer.borderWidth = 1;
    button.layer.borderColor = TDColor(0xDDE2E8).CGColor;
    button.accessibilityValue = amount;
    [button addTarget:self action:@selector(seatTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buildUI {
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    UIStackView *content = [[UIStackView alloc] init];
    content.translatesAutoresizingMaskIntoConstraints = NO;
    content.axis = UILayoutConstraintAxisVertical;
    content.spacing = 8;
    [self.view addSubview:scroll];
    [scroll addSubview:content];

    UIView *header = [[UIView alloc] init];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    header.backgroundColor = TDTicketBlue();
    UIStackView *headerStack = [[UIStackView alloc] init];
    headerStack.translatesAutoresizingMaskIntoConstraints = NO;
    headerStack.axis = UILayoutConstraintAxisVertical;
    headerStack.spacing = 5;
    UIStackView *topRow = [[UIStackView alloc] init];
    topRow.axis = UILayoutConstraintAxisHorizontal;
    topRow.alignment = UIStackViewAlignmentCenter;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setTitle:@"‹" forState:UIControlStateNormal];
    [back setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:30];
    [back.widthAnchor constraintEqualToConstant:42].active = YES;
    [back addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    UILabel *headerTitle = TDLabel(@"Confirm Order", 19, UIFontWeightBold, UIColor.whiteColor);
    headerTitle.textAlignment = NSTextAlignmentCenter;
    UILabel *refund = TDLabel(@"Refund Policy", 12, UIFontWeightRegular, UIColor.whiteColor);
    refund.textAlignment = NSTextAlignmentRight;
    [refund.widthAnchor constraintEqualToConstant:82].active = YES;
    [topRow addArrangedSubview:back];
    [topRow addArrangedSubview:headerTitle];
    [topRow addArrangedSubview:refund];
    UIStackView *dateRow = [[UIStackView alloc] init];
    dateRow.axis = UILayoutConstraintAxisHorizontal;
    dateRow.distribution = UIStackViewDistributionEqualCentering;
    [dateRow addArrangedSubview:TDLabel(@"Previous day", 11, UIFontWeightRegular, UIColor.whiteColor)];
    UILabel *date = TDLabel(@"Nov 28 · Sat", 14, UIFontWeightBold, TDTicketBlue());
    date.backgroundColor = UIColor.whiteColor;
    date.textAlignment = NSTextAlignmentCenter;
    date.layer.cornerRadius = 8;
    date.clipsToBounds = YES;
    [date.widthAnchor constraintEqualToConstant:124].active = YES;
    [date.heightAnchor constraintEqualToConstant:34].active = YES;
    [dateRow addArrangedSubview:date];
    [dateRow addArrangedSubview:TDLabel(@"Next day", 11, UIFontWeightRegular, UIColor.whiteColor)];
    [headerStack addArrangedSubview:topRow];
    [headerStack addArrangedSubview:dateRow];
    [header addSubview:headerStack];
    [NSLayoutConstraint activateConstraints:@[
        [headerStack.topAnchor constraintEqualToAnchor:header.topAnchor constant:4],
        [headerStack.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:10],
        [headerStack.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant:-10],
        [headerStack.bottomAnchor constraintEqualToAnchor:header.bottomAnchor constant:-8]
    ]];
    [content addArrangedSubview:header];

    UIView *tripCard = [self paddedCard];
    UIStackView *tripStack = [[UIStackView alloc] init];
    tripStack.translatesAutoresizingMaskIntoConstraints = NO;
    tripStack.axis = UILayoutConstraintAxisVertical;
    tripStack.spacing = 8;
    UIStackView *service = [[UIStackView alloc] initWithArrangedSubviews:@[
        TDLabel(@"Service: Online seat selection", 11, UIFontWeightRegular, TDTicketBlue()),
        TDLabel(@"Details ▾", 11, UIFontWeightRegular, TDTicketBlue())
    ]];
    service.axis = UILayoutConstraintAxisHorizontal;
    service.distribution = UIStackViewDistributionEqualSpacing;
    UIStackView *route = [[UIStackView alloc] init];
    route.axis = UILayoutConstraintAxisHorizontal;
    route.distribution = UIStackViewDistributionFillEqually;
    [route addArrangedSubview:[self routeColumn:@"08:00" place:@"Hangzhou\nWenzhou" alignment:NSTextAlignmentLeft]];
    [route addArrangedSubview:[self routeColumn:@"G1050  ›" place:@"10h 17m" alignment:NSTextAlignmentCenter]];
    [route addArrangedSubview:[self routeColumn:@"18:17" place:@"Guoyang\nQingdao North" alignment:NSTextAlignmentRight]];
    UIStackView *seats = [[UIStackView alloc] init];
    seats.axis = UILayoutConstraintAxisHorizontal;
    seats.spacing = 8;
    seats.distribution = UIStackViewDistributionFillEqually;
    UIButton *second = [self seatButton:@"Second Class\n¥102\nAvailable" amount:@"¥102.00"];
    UIButton *first = [self seatButton:@"First Class\nFrom ¥178\nAvailable" amount:@"¥178.00"];
    UIButton *standing = [self seatButton:@"Standing\n¥102\nAvailable" amount:@"¥102.00"];
    self.seatButtons = @[second, first, standing];
    [seats addArrangedSubview:second];
    [seats addArrangedSubview:first];
    [seats addArrangedSubview:standing];
    [self selectSeatButton:second];
    [tripStack addArrangedSubview:service];
    [tripStack addArrangedSubview:route];
    [tripStack addArrangedSubview:seats];
    [tripCard addSubview:tripStack];
    [NSLayoutConstraint activateConstraints:@[
        [tripStack.topAnchor constraintEqualToAnchor:tripCard.topAnchor constant:10],
        [tripStack.leadingAnchor constraintEqualToAnchor:tripCard.leadingAnchor constant:10],
        [tripStack.trailingAnchor constraintEqualToAnchor:tripCard.trailingAnchor constant:-10],
        [tripStack.bottomAnchor constraintEqualToAnchor:tripCard.bottomAnchor constant:-10],
        [seats.heightAnchor constraintEqualToConstant:82]
    ]];
    [content addArrangedSubview:tripCard];

    UIView *passengerCard = [self paddedCard];
    UIStackView *passengerStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        TDLabel(@"Tom Cruise", 17, UIFontWeightBold, TDText()),
        TDLabel(@"Adult · Second Class", 12, UIFontWeightRegular, TDTicketBlue()),
        TDLabel(@"3412**********610", 12, UIFontWeightRegular, TDMuted())
    ]];
    passengerStack.translatesAutoresizingMaskIntoConstraints = NO;
    passengerStack.axis = UILayoutConstraintAxisVertical;
    passengerStack.spacing = 3;
    UILabel *addPassenger = TDLabel(@"＋ Add passenger", 13, UIFontWeightBold, TDColor(0xFF8A1F));
    addPassenger.textAlignment = NSTextAlignmentCenter;
    [passengerStack addArrangedSubview:addPassenger];
    [passengerCard addSubview:passengerStack];
    [NSLayoutConstraint activateConstraints:@[
        [passengerStack.topAnchor constraintEqualToAnchor:passengerCard.topAnchor constant:10],
        [passengerStack.leadingAnchor constraintEqualToAnchor:passengerCard.leadingAnchor constant:12],
        [passengerStack.trailingAnchor constraintEqualToAnchor:passengerCard.trailingAnchor constant:-12],
        [passengerStack.bottomAnchor constraintEqualToAnchor:passengerCard.bottomAnchor constant:-10]
    ]];
    [content addArrangedSubview:passengerCard];

    UILabel *agreement = TDLabel(@"By submitting, you agree to the Railway Passenger Transport Terms and Service Terms.", 10, UIFontWeightRegular, TDMuted());
    [content addArrangedSubview:agreement];
    self.submitButton = TDButton(@"Tickets available in 10s", TDBlue(), UIColor.whiteColor);
    self.submitButton.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:16
        weight:UIFontWeightSemibold];
    [self.submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];

    UIView *tipsCard = [self paddedCard];
    UIStackView *tips = [[UIStackView alloc] initWithArrangedSubviews:@[
        TDLabel(@"ⓘ  Warm Tips", 18, UIFontWeightBold, TDText()),
        TDLabel(@"1. A successfully issued ticket may be changed or refunded according to railway rules.\n\n2. Train schedules and seat assignments may change due to operating conditions.\n\n3. Keep your contact information valid so important updates can reach you.\n\n4. Seats are assigned according to actual availability when the ticket is issued.", 14, UIFontWeightRegular, TDMuted())
    ]];
    tips.translatesAutoresizingMaskIntoConstraints = NO;
    tips.axis = UILayoutConstraintAxisVertical;
    tips.spacing = 14;
    [tipsCard addSubview:tips];
    [NSLayoutConstraint activateConstraints:@[
        [tips.topAnchor constraintEqualToAnchor:tipsCard.topAnchor constant:18],
        [tips.leadingAnchor constraintEqualToAnchor:tipsCard.leadingAnchor constant:18],
        [tips.trailingAnchor constraintEqualToAnchor:tipsCard.trailingAnchor constant:-18],
        [tips.bottomAnchor constraintEqualToAnchor:tipsCard.bottomAnchor constant:-18]
    ]];
    [content addArrangedSubview:tipsCard];

    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.submitButton.topAnchor constant:-8],
        [content.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [content.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor constant:12],
        [content.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor constant:-12],
        [content.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor constant:-28],
        [content.widthAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor constant:-24],
        [self.submitButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:12],
        [self.submitButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12],
        [self.submitButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-8]
    ]];
    [content setCustomSpacing:8 afterView:header];
}

- (void)seatTapped:(UIButton *)button { [self selectSeatButton:button]; }
- (void)selectSeatButton:(UIButton *)selected {
    for (UIButton *button in self.seatButtons) {
        BOOL active = button == selected;
        button.backgroundColor = active ? TDColor(0xEFF6FF) : TDColor(0xFAFBFC);
        button.layer.borderColor = (active ? TDTicketBlue() : TDColor(0xDDE2E8)).CGColor;
        button.layer.borderWidth = active ? 2 : 1;
        [button setTitleColor:(active ? TDTicketBlue() : TDText()) forState:UIControlStateNormal];
    }
    self.selectedAmount = selected.accessibilityValue;
}

- (void)startCountdown {
    self.secondsRemaining = 10;
    self.submitButton.enabled = NO;
    self.submitButton.alpha = 0.45;
    [self updateCountdownTitle];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
        selector:@selector(countdownTick) userInfo:nil repeats:YES];
}
- (void)countdownTick {
    self.secondsRemaining--;
    if (self.secondsRemaining <= 0) {
        [self.countdownTimer invalidate]; self.countdownTimer = nil;
        [UIView performWithoutAnimation:^{
            [self.submitButton setTitle:@"Submit Order" forState:UIControlStateNormal];
            [self.submitButton setTitle:@"Submit Order" forState:UIControlStateDisabled];
            self.submitButton.enabled = YES;
            self.submitButton.alpha = 1;
            [self.submitButton layoutIfNeeded];
        }];
    } else { [self updateCountdownTitle]; }
}
- (void)updateCountdownTitle {
    NSString *title = [NSString stringWithFormat:@"Tickets available in %lds",
        (long)self.secondsRemaining];
    [UIView performWithoutAnimation:^{
        // 同时更新 normal/disabled 并禁用动画，避免 UIButton 状态回退造成一帧空白。
        [self.submitButton setTitle:title forState:UIControlStateNormal];
        [self.submitButton setTitle:title forState:UIControlStateDisabled];
        [self.submitButton layoutIfNeeded];
    }];
}
- (void)submitTapped {
    UIAlertController *processing = [UIAlertController alertControllerWithTitle:@"Please wait"
        message:@"Processing your order…" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:processing animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [processing dismissViewControllerAnimated:YES completion:^{ [self showPayment]; }];
    });
}
- (void)showPayment {
    UIAlertController *payment = [UIAlertController alertControllerWithTitle:@"Order Ready"
        message:[NSString stringWithFormat:@"Order amount\n\n%@", self.selectedAmount]
        preferredStyle:UIAlertControllerStyleAlert];
    [payment addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(self) weakSelf = self;
    [payment addAction:[UIAlertAction actionWithTitle:@"Pay Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf submitRiskWithTitle:@"Payment submitted · Risk result"];
    }]];
    [self presentViewController:payment animated:YES completion:nil];
}
- (void)backTapped { [self.navigationController popViewControllerAnimated:YES]; }
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}
- (void)dealloc { [self.countdownTimer invalidate]; }
@end

