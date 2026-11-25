#import "DemoSupport.h"
#import "DemoConfig.h"
#import <WebKit/WebKit.h>
#import <TDMobRisk/TDMobRisk.h>

static NSString *TDJSONIndent(NSUInteger depth) {
    return [@"  " stringByPaddingToLength:depth * 2 withString:@"  " startingAtIndex:0];
}

static NSString *TDJSONStringWithBehaviorDetailFirst(id value, NSUInteger depth) {
    if ([value isKindOfClass:NSDictionary.class]) {
        NSDictionary *dictionary = value;
        NSMutableArray *keys = [dictionary.allKeys mutableCopy];
        [keys sortUsingComparator:^NSComparisonResult(id left, id right) {
            return [[left description] compare:[right description]];
        }];
        if ([keys containsObject:@"behavior_detail"]) {
            [keys removeObject:@"behavior_detail"];
            [keys insertObject:@"behavior_detail" atIndex:0];
        }

        NSMutableArray<NSString *> *entries = [NSMutableArray arrayWithCapacity:keys.count];
        for (id key in keys) {
            NSData *keyData = [NSJSONSerialization dataWithJSONObject:[key description]
                options:NSJSONWritingFragmentsAllowed error:nil];
            NSString *keyString = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
            NSString *entry = [NSString stringWithFormat:@"%@%@ : %@",
                TDJSONIndent(depth + 1), keyString,
                TDJSONStringWithBehaviorDetailFirst(dictionary[key], depth + 1)];
            [entries addObject:entry];
        }
        if (entries.count == 0) return @"{}";
        return [NSString stringWithFormat:@"{\n%@\n%@}",
            [entries componentsJoinedByString:@",\n"], TDJSONIndent(depth)];
    }

    if ([value isKindOfClass:NSArray.class]) {
        NSArray *array = value;
        NSMutableArray<NSString *> *entries = [NSMutableArray arrayWithCapacity:array.count];
        for (id item in array) {
            [entries addObject:[NSString stringWithFormat:@"%@%@",
                TDJSONIndent(depth + 1), TDJSONStringWithBehaviorDetailFirst(item, depth + 1)]];
        }
        if (entries.count == 0) return @"[]";
        return [NSString stringWithFormat:@"[\n%@\n%@]",
            [entries componentsJoinedByString:@",\n"], TDJSONIndent(depth)];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:value ?: NSNull.null
        options:NSJSONWritingFragmentsAllowed error:nil];
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"null";
}

UIColor *TDColor(NSInteger hex) {
    return [UIColor colorWithRed:((hex >> 16) & 0xff) / 255.0
                           green:((hex >> 8) & 0xff) / 255.0
                            blue:(hex & 0xff) / 255.0 alpha:1.0];
}
UIColor *TDBlue(void) { return TDColor(0x175CD3); }
UIColor *TDTicketBlue(void) { return TDColor(0x4098F7); }
UIColor *TDText(void) { return TDColor(0x172B4D); }
UIColor *TDMuted(void) { return TDColor(0x667085); }
UIColor *TDBackground(void) { return TDColor(0xF5F8FC); }

UILabel *TDLabel(NSString *text, CGFloat size, UIFontWeight weight, UIColor *color) {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

UIButton *TDButton(NSString *title, UIColor *background, UIColor *foreground) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:foreground forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    button.backgroundColor = background;
    button.layer.cornerRadius = 12;
    button.clipsToBounds = YES;
    [button.heightAnchor constraintEqualToConstant:52].active = YES;
    return button;
}

UIView *TDCard(void) {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = UIColor.whiteColor;
    card.layer.cornerRadius = 20;
    card.layer.borderWidth = 1;
    card.layer.borderColor = TDColor(0xE4E7EC).CGColor;
    return card;
}

UITextField *TDTextField(NSString *placeholder, BOOL secure) {
    UITextField *field = [[UITextField alloc] init];
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.placeholder = placeholder;
    field.secureTextEntry = secure;
    field.backgroundColor = TDColor(0xF8FAFC);
    field.textColor = TDText();
    field.layer.borderWidth = 1;
    field.layer.borderColor = TDColor(0xD0D5DD).CGColor;
    field.layer.cornerRadius = 10;
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 1)];
    field.leftViewMode = UITextFieldViewModeAlways;
    [field.heightAnchor constraintEqualToConstant:56].active = YES;
    return field;
}

BOOL TDNonEmpty(NSString *value) {
    return [value stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet].length > 0;
}

void TDShowMessage(UIViewController *controller, NSString *message) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:message
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SDK client

@implementation TDDemoSDKClient

+ (NSDictionary *)options {
    return @{ @"partner": PARTNER, @"partnerKey": PARTNER_KEY,
        @"appKey": APP_KEY,
        @"dataCenter": COUNTRY.lowercaseString,
        @"behaviorHost": BEHAVIOR_HOST,
        @"behaviorConfigUrl": BEHAVIOR_CONFIG_URL,
        @"behaviorUploadUrl": BEHAVIOR_UPLOAD_URL,
        @"behaviorHttpTimeOut": @(BEHAVIOR_HTTP_TIMEOUT_SECONDS),
        @"behaviorCollectTimeOut": @(BEHAVIOR_COLLECT_TIMEOUT_SECONDS),
        @"behaviorKeepNaviInfo": @(BEHAVIOR_KEEP_NAVI_INFO) };
}

+ (void)initializeAndStart {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *options = [self options];
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        manager->initWithOptions(options);
        manager->start();
    });
}

+ (NSString *)statusText {
    TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
    return [NSString stringWithFormat:@"Behavior SDK 1.6.0 · Device Risk %@",
        manager->getSDKVersion()];
}

+ (NSError *)error:(NSString *)message {
    return [NSError errorWithDomain:@"TDBehaviorTestDemo" code:1
        userInfo:@{NSLocalizedDescriptionKey: message ?: @"Unknown error"}];
}

+ (void)finish:(void (^)(NSString *, NSError *))completion result:(NSString *)result error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{ if (completion) completion(result, error); });
}

+ (void)collectAndQuery:(void (^)(NSString *, NSError *))completion {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        TDBehaviorResultStruct collected = manager->collect();
        if (collected.code != 0) {
            NSString *msg = collected.msg ? [NSString stringWithUTF8String:collected.msg] : @"Unknown error";
            [self finish:completion result:nil error:[self error:
                [NSString stringWithFormat:@"Collection failed (%ld): %@", (long)collected.code, msg]]];
            return;
        }
        NSString *behavior = collected.payload ? [NSString stringWithUTF8String:collected.payload] : nil;
        if (behavior.length == 0) {
            [self finish:completion result:nil error:[self error:@"The collection result does not contain behavior data."]];
            return;
        }

        // 5.3.4 官方建议优先异步获取，并要求在回调内立即把 C 字符串复制为 NSString。
        dispatch_semaphore_t deviceSemaphore = dispatch_semaphore_create(0);
        __block NSString *blackBox = nil;
        __block NSString *deviceMessage = nil;
        __block int deviceCode = -1;
        manager->getDeviceInfo(^(TDDeviceResponse deviceResponse) {
            blackBox = [NSString stringWithUTF8String:deviceResponse.blackBox ?: ""];
            deviceMessage = [NSString stringWithUTF8String:deviceResponse.apiStatus.message ?: ""];
            deviceCode = deviceResponse.apiStatus.code;
            dispatch_semaphore_signal(deviceSemaphore);
        });
        long deviceWaitResult = dispatch_semaphore_wait(deviceSemaphore,
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HTTP_TIMEOUT_SECONDS * NSEC_PER_SEC)));
        if (deviceWaitResult != 0) {
            [self finish:completion result:nil error:[self error:@"Device fingerprint collection timed out."]];
            return;
        }
        if (deviceCode != 0 || blackBox.length == 0) {
            NSString *message = deviceMessage.length > 0 ? deviceMessage : @"Unknown error";
            [self finish:completion result:nil error:[self error:
                [NSString stringWithFormat:@"Device fingerprint collection failed (%d): %@", deviceCode, message]]];
            return;
        }
        NSURLComponents *components = [NSURLComponents componentsWithString:TDDemoRiskURL()];
        components.queryItems = @[
            [NSURLQueryItem queryItemWithName:@"partner_code" value:PARTNER],
            [NSURLQueryItem queryItemWithName:@"partner_key" value:PARTNER_KEY]
        ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
        request.HTTPMethod = @"POST";
        request.timeoutInterval = HTTP_TIMEOUT_SECONDS;
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{
            @"black_box": blackBox, @"behavior": behavior
        } options:0 error:nil];

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block NSData *data = nil;
        __block NSHTTPURLResponse *response = nil;
        __block NSError *networkError = nil;
        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration;
        configuration.timeoutIntervalForRequest = HTTP_TIMEOUT_SECONDS;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
            ^(NSData *responseData, NSURLResponse *urlResponse, NSError *error) {
                data = responseData;
                response = (NSHTTPURLResponse *)urlResponse;
                networkError = error;
                dispatch_semaphore_signal(semaphore);
            }];
        [task resume];
        long waitResult = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW,
            (int64_t)((HTTP_TIMEOUT_SECONDS + 1) * NSEC_PER_SEC)));
        if (waitResult != 0) {
            [task cancel];
            [session invalidateAndCancel];
            [self finish:completion result:nil error:[self error:@"The risk query timed out."]];
            return;
        }
        [session finishTasksAndInvalidate];
        if (networkError) { [self finish:completion result:nil error:networkError]; return; }
        NSString *raw = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"";
        if (response.statusCode < 200 || response.statusCode >= 300) {
            [self finish:completion result:nil error:[self error:
                [NSString stringWithFormat:@"Risk service returned HTTP %ld.\n%@", (long)response.statusCode, raw]]];
            return;
        }
        NSError *jsonError = nil;
        id json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] : nil;
        if (!json) { [self finish:completion result:nil error:jsonError ?: [self error:@"Invalid risk response."]]; return; }
        NSString *pretty = TDJSONStringWithBehaviorDetailFirst(json, 0) ?: raw;
        if ([json isKindOfClass:NSDictionary.class]) {
            NSString *code = [NSString stringWithFormat:@"%@", ((NSDictionary *)json)[@"code"] ?: @""];
            if (![code isEqualToString:@"200"] && ![code isEqualToString:@"000"]) {
                NSString *message = ((NSDictionary *)json)[@"message"] ?: @"Unknown error";
                [self finish:completion result:nil error:[self error:
                    [NSString stringWithFormat:@"Risk query failed: %@\n%@", message, pretty]]];
                return;
            }
        }
        [self finish:completion result:pretty error:jsonError];
    });
}
@end

#pragma mark - Result and privacy controllers

@interface TDResultViewController : UIViewController
@property (nonatomic, copy) NSString *resultTitle;
@property (nonatomic, copy) NSString *content;
@end


@implementation TDResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.48];
    UIView *card = TDCard();
    UILabel *title = TDLabel(self.resultTitle, 20, UIFontWeightBold, TDText());
    UITextView *text = [[UITextView alloc] init];
    text.translatesAutoresizingMaskIntoConstraints = NO;
    text.text = self.content;
    text.editable = NO;
    text.selectable = YES;
    text.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
    text.backgroundColor = TDColor(0xF8FAFC);
    text.layer.cornerRadius = 10;
    UIButton *done = TDButton(@"Done", TDBlue(), UIColor.whiteColor);
    [done addTarget:self action:@selector(doneTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:card]; [card addSubview:title]; [card addSubview:text]; [card addSubview:done];
    [NSLayoutConstraint activateConstraints:@[
        [card.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [card.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [card.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [card.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.72],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:24],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:24],
        [title.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-24],
        [text.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:16],
        [text.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:20],
        [text.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-20],
        [done.topAnchor constraintEqualToAnchor:text.bottomAnchor constant:16],
        [done.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:20],
        [done.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-20],
        [done.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-20]
    ]];
}
- (void)doneTapped { [self dismissViewControllerAnimated:YES completion:nil]; }
@end

@interface TDPrivacyViewController : UIViewController <WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, copy) void (^agreementHandler)(void);
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, assign) BOOL pageLoaded;
@property (nonatomic, assign) BOOL pageLoadFailed;
@end

@implementation TDPrivacyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIView *header = [[UIView alloc] init]; header.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *title = TDLabel(@"Privacy Policy", 22, UIFontWeightBold, TDText());
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem]; close.translatesAutoresizingMaskIntoConstraints = NO;
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:title]; [header addSubview:close];
    self.statusLabel = TDLabel(@"Loading Privacy Policy…", 13, UIFontWeightRegular, TDMuted());
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc] init]];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self; self.webView.scrollView.delegate = self;
    self.agreeButton = TDButton(@"Agree", TDBlue(), UIColor.whiteColor);
    self.agreeButton.enabled = NO; self.agreeButton.alpha = 0.45;
    [self.agreeButton addTarget:self action:@selector(agreeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:header]; [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.webView]; [self.view addSubview:self.agreeButton];
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [header.topAnchor constraintEqualToAnchor:safe.topAnchor], [header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor], [header.heightAnchor constraintEqualToConstant:58],
        [close.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:18], [close.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [title.centerXAnchor constraintEqualToAnchor:header.centerXAnchor], [title.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [self.statusLabel.topAnchor constraintEqualToAnchor:header.bottomAnchor constant:6],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.webView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:6],
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor], [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.agreeButton.topAnchor constraintEqualToAnchor:self.webView.bottomAnchor constant:12],
        [self.agreeButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.agreeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.agreeButton.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-12]
    ]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PRIVACY_POLICY_URL]]];
}
- (void)checkBottom {
    if (!self.pageLoaded || self.pageLoadFailed) return;
    UIScrollView *s = self.webView.scrollView;
    if (s.contentOffset.y + CGRectGetHeight(s.bounds) >= s.contentSize.height - 8) {
        self.statusLabel.text = @"You reached the end of the Privacy Policy.";
        self.agreeButton.enabled = YES; self.agreeButton.alpha = 1;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView { [self checkBottom]; }
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.pageLoadFailed) return;
    self.pageLoaded = YES; self.statusLabel.text = @"Scroll to the bottom to enable Agree.";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self checkBottom]; });
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error { [self loadFailed:error]; }
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error { [self loadFailed:error]; }
- (void)loadFailed:(NSError *)error {
    self.pageLoadFailed = YES; self.pageLoaded = NO;
    self.statusLabel.text = [NSString stringWithFormat:@"Unable to load the Privacy Policy: %@", error.localizedDescription];
    self.agreeButton.enabled = NO; self.agreeButton.alpha = 0.45;
}
- (void)closeTapped { [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)agreeTapped { if (self.agreementHandler) self.agreementHandler(); [self dismissViewControllerAnimated:YES completion:nil]; }
@end

#pragma mark - Base controller

@interface TDBaseViewController () <UIGestureRecognizerDelegate>
@end

@implementation TDBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    tap.cancelsTouchesInView = NO; tap.delegate = self; [self.view addGestureRecognizer:tap];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    for (UIView *view = touch.view; view; view = view.superview) {
        // 输入控件和按钮由它们自己的 UIControl 事件处理；背景手势只负责空白区域收起键盘。
        // 避免它与 SDK 挂在 UIWindow 上的点击手势竞争，造成按钮执行但 SDK 点击未回调。
        if ([view isKindOfClass:UIControl.class] || [view isKindOfClass:UITextView.class]) return NO;
    }
    return YES;
}
- (void)backgroundTapped { [self.view endEditing:YES]; }
- (void)presentPrivacyWithCompletion:(void (^)(void))completion {
    TDPrivacyViewController *vc = [[TDPrivacyViewController alloc] init];
    vc.agreementHandler = completion; vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)submitRiskWithTitle:(NSString *)title {
    UIAlertController *progress = [UIAlertController alertControllerWithTitle:@"Checking risk…"
        message:@"Collecting behavior and querying risk." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:progress animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [TDDemoSDKClient collectAndQuery:^(NSString *result, NSError *error) {
        __strong typeof(weakSelf) self = weakSelf; if (!self) return;
        [progress dismissViewControllerAnimated:YES completion:^{
            TDResultViewController *vc = [[TDResultViewController alloc] init];
            vc.resultTitle = error ? @"Unable to complete risk check" : title;
            vc.content = error.localizedDescription ?: result;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }];
}
@end

