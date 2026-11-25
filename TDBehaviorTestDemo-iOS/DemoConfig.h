#import <Foundation/Foundation.h>

// Customer-facing demo configuration. Change environment parameters only here.
#define PARTNER @""
#define PARTNER_KEY @""
#define APP_KEY @""
#define COUNTRY @""

#define BEHAVIOR_HOST @""
#define BEHAVIOR_CONFIG_URL @""
#define BEHAVIOR_UPLOAD_URL @""
#define BEHAVIOR_HTTP_TIMEOUT_SECONDS 15.0
#define BEHAVIOR_COLLECT_TIMEOUT_SECONDS 0.5
#define BEHAVIOR_KEEP_NAVI_INFO NO

#define PRIVACY_POLICY_URL @"https://trustdecision.com/privacy-policy"
#define HTTP_TIMEOUT_SECONDS 15.0

NS_INLINE NSString *TDDemoRiskURL(void) {
    return [NSString stringWithFormat:@"https://%@.apitd.net/device/v3", COUNTRY];
}
