//
//  AppMacro.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]


/** navi的背景色 */
#define NaviBgColor RGBColor(64, 64, 64)
/** navi的前景色 */
#define NaviFgColor RGBColor(0, 0, 0)
/** navi标题字体大小 */
#define NaviTitleFontSize 15
/** navi标题字体 */
#define NaviTitleFont [UIFont systemFontOfSize:NaviTitleFontSize]
/** naviItem字体大小 */
#define NaviItemFontSize 15
/** naviItem字体 */
#define NaviItemFont [UIFont systemFontOfSize:NaviItemFontSize]

/** View的背景色 */
#define ViewBgColor RGBColor(255, 255, 255)

/** Button正常情况下的背景色 */
#define BtnNormalBgColor NaviBgColor
/** Button正常情况下的前景色 */
#define BtnNormalFgColor [UIColor whiteColor]
/** Button的字体大小 */
#define BtnDefaultFontSize 15
/** Button的字体 */
#define BtnDefaultFont [UIFont systemFontOfSize:BtnNormalFontSize]


///---------------------------------------------------------------------------------------
/// 其他
///---------------------------------------------------------------------------------------

#define NoticDefaultCenter                  [NSNotificationCenter defaultCenter]
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define SelfNavBar                          self.navigationController.navigationBar
#define SelfTabBar                          self.tabBarController.tabBar
#define SelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define SelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenSize                          [[UIScreen mainScreen] bounds].size
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define SelfRect                            self.bounds
#define SelfSize                            self.bounds.size
#define SelfWidth                           self.bounds.size.width
#define SelfHeight                          self.bounds.size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define SelfViewWidth                      self.view.bounds.size.width
#define RectMaxX(f)                         CGRectGetMaxX(f)
#define RectMaxY(f)                         CGRectGetMaxY(f)
#define RectMinX(f)                         CGRectGetMinX(f)
#define RectMinY(f)                         CGRectGetMinY(f)
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define ISIOS7Later                         !(IOSVersion < 7.0)

#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)

#define TabBarHeight                        49.0f
#define NaviBarHeight                       (ScreenWidth < ScreenHeight ? 44.0f : 32.0f)
#define HeightFor4InchScreen                568.0f
#define HeightFor3p5InchScreen              480.0f

#define ViewCtrlTopBarHeight                (ISIOS7Later ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (ISIOS7Later ? YES : NO)

#define IsLandscapeMode                     (ScreenWidth > ScreenHeight ? YES : NO)

#define MaximumLeftDrawerWidth              250

/** 正式版本号 */
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** Build版本号 */
#define APPBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/** 屏幕的宽度是6Plus或者更宽 */
#define ScreenWidthIs_6Plus_OrWider [UIScreen mainScreen].bounds.size.width >= 414


// NSLog
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif


///---------------------------------------------------------------------------------------
/// 添加视图
///---------------------------------------------------------------------------------------

#define VCAddSubview(aView) [self.view addSubview:aView]
#define ViewAddSubview(aView) [self addSubview:aView]
#define CellAddSubview(aView) [self.contentView addSubview:aView]


///---------------------------------------------------------------------------------------
/// 属性
///---------------------------------------------------------------------------------------

// 声明属性
#define Strong_Property(type, name) @property (nonatomic, strong) type *name;
#define Copy_Property(type, name) @property (nonatomic, copy) type *name;
#define Weak_Property(type, name) @property (nonatomic, weak) type *name;
#define Assign_Property(type, name) @property (nonatomic, assign) type name;

#define UITableView_Property(name) @property (nonatomic, strong) UITableView *name;
#define UIButton_Property(name) @property (nonatomic, strong) UIButton *name;
#define UILabel_Property(name) @property (nonatomic, strong) UILabel *name;

#define NSString_Property(name) @property (nonatomic, copy) NSString *name;
#define NSInteger_Property(name) @property (nonatomic, assign) NSInteger name;
#define NSUInteger_Property(name) @property (nonatomic, assign) NSUInteger name;
#define BOOL_Property(name) @property (nonatomic, assign) BOOL name;
#define CGFloat_Property(name) @property (nonatomic, assign) CGFloat name;


// 初始化属性
#define InitNSArray(obj) obj = [NSArray array]
#define InitNSMutableArray(obj) obj = [NSMutableArray array]


/** 弱引用 */
#define WS __weak typeof(self) weakSelf = self
#define WeakObj(obj, name) __weak typeof(obj) name = obj
/** 强引用 */
#define SWS __weak typeof(weakSelf) strongSelf = weakSelf
#define StrongObj(obj, name) __strong typeof(obj) name = obj


/** 格式化字符串 */
#define FormatString( format, ... ) [NSString stringWithFormat:(format), ##__VA_ARGS__]

/** 判断字符串是否为空 */
#define kIsNull(exp) ((exp == nil || exp == NULL || ([exp isKindOfClass:[NSString class]] && [exp length] == 0))?1:0)

/** 是否是第一次运行程序 */
#define IsFirstRunning @"IsFirstRunning"
/** */
/** */
/** */


#endif /* AppMacro_h */
