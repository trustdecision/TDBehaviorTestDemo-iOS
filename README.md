# **Android**

**测试demo:** https://github.com/trustdecision/TDBehaviorTestDemo-Android

运行前参考 行为采集文档 https://en-doc.trustdecision.com/en/sdk/behavior-android-1 将 demo 中 app/src/main/java/com/example/tdbehaviortestdemo_android/DemoConfig.kt 参数修改为您自己的参数

```
const val PARTNER = ""
const val PARTNER_KEY = ""
const val APP_KEY = ""
const val COUNTRY = ""
```

**测试手机:** Xiaomi MI 9,Android 11，非Root

| 群控工具                                                     | 风险标签    | 是否能触发                                                   | 测试步骤                                                     | 复现视频                                                     | 结果                                                         | 覆盖场景                                 |
| ------------------------------------------------------------ | ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------- |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | rapid_input | ✅                                                            | 打开贝利点击器的录制功能；从桌面点击 "TDBehaviorTestDemo-Android" app;在登录界面快速输入（以最终查询的text_input_rage_actions_count >= 3.0 为标准）账号:任意超过11位的字符串, 密码:任意超过11位的字符串；同意"隐私协议"；点击"Log in"按钮；点击贝利点击器结束录制按钮，保存录制完成的记录；将手机放置在桌面上，杀死"TDBehaviorTestDemo-Android" app，点击贝利点击器的重放按钮，重放刚才录制的记录，贝利点击器自动化点击"Log in"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了rapid_input； |                                                              | 触发了rapid_input![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a60709c486a81f6b44b7e10fbd0293cedd589135e9650e8332e04ee75556326e750bf3613102012b43ff7a5ceae74ac74?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具快速文字输入的场景； |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | rapid_touch | ✅ | 打开贝利点击器的录制功能；从桌面点击 "TDBehaviorTestDemo-Android" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在 底部"Tickets available in"倒计时按钮快结束时，添加连续点击50次待支付弹窗弹出后，点击"Pay Now"按钮；点击贝利点击器结束录制按钮，保存录制完成的记录；将手机放置在桌面上，杀死"TDBehaviorTestDemo-Android" app，点击贝利点击器的重放按钮，重放刚才录制的记录，贝利点击器自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了rapid_touch； |  | 触发了 rapid_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a473a1bc8310192c0d86c57844c452f10993433c642766107d707f561a1f4f862fb53f711b6656d33f0bc8d246b8430c8?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具抢票的场景 |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | repeat_touch | ✅ | 打开贝利点击器的录制功能；从桌面点击 "TDBehaviorTestDemo-Android" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在 底部"Tickets available in"倒计时按钮快结束时，添加连续点击50次待支付弹窗弹出后，点击"Pay Now"按钮；点击贝利点击器结束录制按钮，保存录制完成的记录；将手机放置在桌面上，杀死"TDBehaviorTestDemo-Android" app，点击贝利点击器的重放按钮，重放刚才录制的记录，贝利点击器自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了repeat_touch； |  | 触发了 repeat_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a473a1bc8310192c0d86c57844c452f10993433c642766107d707f561a1f4f862fb53f711b6656d33f0bc8d246b8430c8?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具做固定任务路径的场景 |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | same_touch | ✅ | 打开贝利点击器的录制功能；从桌面点击 "TDBehaviorTestDemo-Android" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在 底部"Tickets available in"倒计时按钮快结束时，添加连续点击50次待支付弹窗弹出后，点击"Pay Now"按钮；点击贝利点击器结束录制按钮，保存录制完成的记录；将手机放置在桌面上，杀死"TDBehaviorTestDemo-Android" app，点击贝利点击器的重放按钮，重放刚才录制的记录，贝利点击器自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了same_touch； |  | 触发了 same_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a473a1bc8310192c0d86c57844c452f10993433c642766107d707f561a1f4f862fb53f711b6656d33f0bc8d246b8430c8?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具连续点击的场景 |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | center_touch | ✅ | 打开贝利点击器的录制功能；从桌面点击 "TDBehaviorTestDemo-Android" app;在登录界面使用贝利点击器"识别按钮并点击"功能点击"Ticket Rush Scene" 按钮，进入抢票界面；在抢票界面使用贝利点击器"识别按钮并点击"功能依次点击"Submit Order"、"Pay Now" 按钮；点击贝利点击器结束录制按钮，保存录制完成的记录；点击贝利点击器的重放按钮，重放刚才录制的记录，贝利点击器自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了center_touch； |  | 触发了 center_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a473a1bc8310192c0d86c57844c452f10993433c642766107d707f561a1f4f862fb53f711b6656d33f0bc8d246b8430c8?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用通用自动化脚本群控不同类型设备的场景 |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | straight_scroll | ❌ |  |  |  |  |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | rhythm_input | ❌ |  |  |  |  |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | abnormal_touch | ✅ | 打开贝利点击器的录制功能；从桌面点击 "TDBehaviorTestDemo-Android" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在抢票界面依次点击"Submit Order"、"Pay Now" 按钮；点击贝利点击器结束录制按钮，保存录制完成的记录；点击贝利点击器的重放按钮，重放刚才录制的记录，贝利点击器自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了abnormal_touch； |  | 触发了 center_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a822951806323f89634398d008a5a0f6b028a425338cca89a1d2aca1110ebe85699c579af2d41b79e6608d594c0464422?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用本工具的所有场景 |
| **贝利点击器**version:v2.19.13下载地址：https://www.32r.com/app/51544.html | stationary_face | ❌ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | rapid_input | ✅                                                            |                                                              |                                                              |                                                              |                                          |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | rapid_touch | ✅ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | repeat_touch | ✅ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | same_touch | ✅ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | center_touch | ✅ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | straight_scroll | ❌ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | rhythm_input | ❌ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | abnormal_touch | ✅ |  |  |  |  |
| **按键精灵**version:v5.1.0下载地址：[https://download.myanjian.com](https://download.myanjian.com/) | stationary_face | ❌ |  |  |  |  |



# **iOS**

**测试demo:** https://github.com/trustdecision/TDBehaviorTestDemo-iOS

运行前参考 行为采集文档 https://en-doc.trustdecision.com/en/sdk/ios 将 demo 中 TDBehaviorTestDemo-iOS/DemoConfig.h 参数修改为您自己的参数

```
#define PARTNER @""
#define PARTNER_KEY @""
#define APP_KEY @""
#define COUNTRY @""
```

**测试手机:** iPhone6s，iOS15.7.3，越狱

| 群控工具                                                     | 风险标签    | 是否能触发                                                   | 测试步骤                                                     | 复现视频                                                     | 结果                                                         | 覆盖场景                                 |
| ------------------------------------------------------------ | ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------- |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | rapid_input | ✅                                                            | 打开AutoTouch的录制功能；从桌面点击 "TDBehaviorTestDemo-iOS" app;在登录界面快速输入（以最终查询的text_input_rage_actions_count >= 3.0 为标准）账号:任意超过11位的字符串, 密码:任意超过11位的字符串；同意"隐私协议"；点击"Log in"按钮；点击AutoTouch结束录制按钮，保存录制完成的记录；将手机放置在桌面上，杀死"TDBehaviorTestDemo-iOS" app，点击AutoTouch的重放按钮，重放刚才录制的记录，AutoTouch自动化点击"Log in"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了rapid_input； |                                                              | 触发了rapid_input![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a0d50ecb3f30f832ef8aa46e73cbc406f6cd380b0a913dbefaf1393a96b4929f2480595dae66834f2cb929d81f94680b7?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具快速文字输入的场景； |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | rapid_touch | ✅ | 打开AutoTouch的录制功能；从桌面点击 "TDBehaviorTestDemo-iOS" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在 底部"Tickets available in"倒计时按钮快结束时，编辑录制的脚本，执行连续点击50次待支付弹窗弹出后，点击"Pay Now"按钮；点击AutoTouch结束录制按钮，保存录制完成的记录 ，保存的脚本为 ；将手机放置在桌面上，杀死"TDBehaviorTestDemo-iOS" app，点击AutoTouch的重放按钮，重放刚才录制的记录，AutoTouch自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了rapid_touch； |  | 触发了 rapid_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a358e919a3f95be9aadae2b8a5fc3b7fc830e7be6d7630b60fee58fbd0bc3d1eafb9d61cfa1886e2a69f1b472adb1d5f6?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具抢票的场景 |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | repeat_touch | ✅ | 打开AutoTouch的录制功能；从桌面点击 "TDBehaviorTestDemo-iOS" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在 底部"Tickets available in"倒计时按钮快结束时，编辑录制的脚本，执行连续点击50次待支付弹窗弹出后，点击"Pay Now"按钮；点击AutoTouch结束录制按钮，保存录制完成的记录 ，保存的脚本为 ；将手机放置在桌面上，杀死"TDBehaviorTestDemo-iOS" app，点击AutoTouch的重放按钮，重放刚才录制的记录，AutoTouch自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了repeat_touch； |  | 触发了 repeat_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a358e919a3f95be9aadae2b8a5fc3b7fc830e7be6d7630b60fee58fbd0bc3d1eafb9d61cfa1886e2a69f1b472adb1d5f6?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具抢票的场景 |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | same_touch | ✅ | 打开AutoTouch的录制功能；从桌面点击 "TDBehaviorTestDemo-iOS" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在 底部"Tickets available in"倒计时按钮快结束时，编辑录制的脚本，执行连续点击50次待支付弹窗弹出后，点击"Pay Now"按钮；点击AutoTouch结束录制按钮，保存录制完成的记录 ，保存的脚本为 ；将手机放置在桌面上，杀死"TDBehaviorTestDemo-iOS" app，点击AutoTouch的重放按钮，重放刚才录制的记录，AutoTouch自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了same_touch； |  | 触发了 same_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a358e919a3f95be9aadae2b8a5fc3b7fc830e7be6d7630b60fee58fbd0bc3d1eafb9d61cfa1886e2a69f1b472adb1d5f6?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用自动化工具抢票的场景 |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | center_touch | ❌ |  |  |  |  |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | straight_scroll | ❌ |  |  |  |  |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | rhythm_input | ❌ |  |  |  |  |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | abnormal_touch | ✅ | 打开AutoTouch的录制功能；从桌面点击 "TDBehaviorTestDemo-iOS" app;在登录界面点击"Ticket Rush Scene" 按钮，进入抢票界面；在抢票界面依次点击"Submit Order"、"Pay Now" 按钮；点击AutoTouch结束录制按钮，保存录制完成的记录；点击AutoTouch的重放按钮，重放刚才录制的记录，AutoTouch自动化点击"Pay Now"按钮后，弹出的风险查询结果中 behavior_risk_label 触发了abnormal_touch； |  | 触发了 center_touch![img](https://alidocs.dingtalk.com/core/api/resources/img/5eecdaf48460cde513c0eb6e8d12a6014f419e889e68153a75b8339e1c4c2483ae8b6c4ee714dcdd8d68742cd653602a8169d9d9ddf3b83f6812104a319af97949488a437fbd065eebce3bff69325e0992525b8ef8cd188930d7e28614dd32d6?tmpCode=1f3b1793-4149-4e5e-b053-cba058ce8674) | 1.黑产使用本工具的所有场景 |
| **AutoTouch**version:v8.6.3下载地址：[https://apt.autotouch.net](https://apt.autotouch.net/)越狱源 | stationary_face | ❌ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | rapid_input | ✅                                                            |                                                              |                                                              |                                                              |                                          |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | rapid_touch | ✅ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | repeat_touch | ✅ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | same_touch | ✅ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | center_touch | ❌ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | straight_scroll | ❌ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | rhythm_input | ❌ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | abnormal_touch | ✅ |  |  |  |  |
| **触动精灵**version:下载地址：[https://apt.touchsprite.com](https://apt.touchsprite.com/) 越狱源 | stationary_face | ❌ |  |  |  |  |
