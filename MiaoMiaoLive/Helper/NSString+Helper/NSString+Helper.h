//
//  NSString+Helper.h
//  NewProject
//
//  Created by 金晓浩 on 16/5/13.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString* XYNonEmptyString(id obj);
@interface NSString (Helper)

/** 判断是否已成年 */
+ (BOOL)isManhoodWithCertID:(NSString *)certID;



/** 判断是否是中文用户名 */
+ (BOOL)validateNickname:(NSString *)nickname;

/** 判断是否是正整数 */
+ (BOOL)isPositiveInteger:(NSString *)number;

/** 转换日期时间字符串格式 */
+ (NSString *)convertToDateWith:(NSString *)dateString separateStr:(NSString *)separateStr;

/** 字符串前面添加空格 */
+ (NSString *)addSpace:(NSString *)string count:(int)count;

/** 将金额字段转换为货币格式 */
+ (NSString *)convertToCurrencyWith:(NSString *)String;

/**
 *  判断是否为正确的邮箱
 *
 *  @return 返回YES为正确的邮箱，NO为不是邮箱
 */
- (BOOL)isValidateEmail;

/**
 *  判断是否为正确的手机号
 *
 *  @return 返回YES为手机号，NO为不是手机号
 */
- (BOOL)checkTel;

/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;

/**
 *  是否空字符串
 *
 *  @return 如果字符串为nil或者长度为0返回YES
 */
- (BOOL)isEmptyString;

/**
 *  返回沙盒中的文件路径
 *
 *  @return 返回当前字符串对应在沙盒中的完整文件路径
 */
+ (NSString *)stringWithDocumentsPath:(NSString *)path;

/**
 *  写入系统偏好
 *
 *  @param key 写入键值
 */
- (void)saveToNSDefaultsWithKey:(NSString *)key;

/**
 *  一串字符在固定宽度下，正常显示所需要的高度
 *
 *  @param string 文本内容
 *  @param width  每一行的宽度
 *  @param font   字体大小
 *
 *  @return 正常显示所需要的高度
 */
+ (CGFloat)autoHeightWithString:(NSString *)string
                          width:(CGFloat)width
                           font:(UIFont *)font;

/**
 *  一串字符在一行中正常显示所需要的宽度
 *
 *  @param string 文本内容
 *  @param font   字体大小
 *
 *  @return 正常显示所需要的宽度
 */
+ (CGFloat)autoWidthWithString:(NSString *)string
                          font:(UIFont *)font;


/**
 *  根据字符串获取 size
 *
 *  @param value
 *  @param fontSize
 *  @param width
 *
 *  @return
 */
+(CGSize) sizeForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;

/**
 *  获取设备类型
 *
 *  @return
 */
+ (NSInteger)getDeviceTypeInfo;

/**
 *  获取设备型号
 *
 *  @return
 */
+ (NSString*)deviceString;

/**
 *  获取版本
 *
 *  @return
 */
+ (NSString *)iosVersions;
/**
 *  获取当前时间
 *
 *  @param formatter
 *
 *  @return
 */
+(NSString *)timeNow:(NSString *)formatter;

/**
 *  MD5 加密
 *
 *  @param signString
 *
 *  @return
 */
+(NSString *)createMD5:(NSString *)signString;

/**
 *  计算字符串长度
 *
 *  @param text
 *
 *  @return
 */
+(NSUInteger) unicodeLengthOfString:(NSString*)text;

/**
 *  判断是否含汉字
 *
 *  @param str
 *
 *  @return
 */
+(BOOL) containsChinese:(NSString *)str;

+(BOOL)containEnglish:(NSString *)str;//包含字母

+(BOOL)containShuZi:(NSString *)str;//包含数字
/**
 * 返回URL编码字符串
 */
- (NSString*)urlEncoded;
//
- (CGSize)sizeWithFont:(UIFont *)font;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;


@end
