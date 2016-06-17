//
//  NSString+Helper.m
//  NewProject
//
//  Created by 金晓浩 on 16/5/13.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "NSString+Helper.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>

NSString* XYNonEmptyString(id obj){
    if (obj == nil || obj == [NSNull null] ||
        ([obj isKindOfClass:[NSString class]] && [obj length] == 0)) {
        return @" ";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return XYNonEmptyString([obj stringValue]);
    }
    return obj;
}
@implementation NSString (Helper)

#pragma mark - 判断是否是中文用户名
+ (BOOL)validateNickname:(NSString *)nickname

{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [passWordPredicate evaluateWithObject:nickname];
}

#pragma mark - 判断是否已成年
+ (BOOL)isManhoodWithCertID:(NSString *)certID
{
    NSRange range = NSMakeRange(6, 8);
    certID = [certID substringWithRange:range];
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = @"yyyyMMdd";
    
    //出生日期
    NSDate *burnDate = [dateF dateFromString:certID];
    
    //当前日期
    NSDate *dateNow = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:burnDate
                                                 toDate:dateNow
                                                options:0];
    if (components.year >= 18) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 判断是否为正整数
+ (BOOL)isPositiveInteger:(NSString *)number
{
    NSString *Regex = @"^[1-9]\\d*$";
    
    NSPredicate *PositiveIntegerPridi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    return [PositiveIntegerPridi evaluateWithObject:number];
}

#pragma mark - 转换日期时间字符串格式
+ (NSString *)convertToDateWith:(NSString *)dateString separateStr:(NSString *)separateStr
{
    if (dateString.length > 8) {
        NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [dateString substringWithRange:NSMakeRange(year.length, 2)];
        NSString *day = [dateString substringWithRange:NSMakeRange(year.length + month.length, 2)];
        NSString *hour = [dateString substringWithRange:NSMakeRange(year.length + month.length + day.length, 2)];
        NSString *minute = [dateString substringWithRange:NSMakeRange(year.length + month.length + day.length + hour.length, 2)];
        NSString *second = [dateString substringWithRange:NSMakeRange(year.length + month.length + day.length + hour.length + minute.length, 2)];
        return [NSString stringWithFormat:@"%@%@%@%@%@ %@:%@:%@", year, separateStr, month, separateStr, day, hour, minute, second];
    } else {
        if (dateString.length == 8) {
            NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
            NSString *month = [dateString substringWithRange:NSMakeRange(year.length, 2)];
            NSString *day = [dateString substringWithRange:NSMakeRange(year.length + month.length, 2)];
            return [NSString stringWithFormat:@"%@%@%@%@%@", year, separateStr, month, separateStr, day];
        } else if (dateString.length == 6){
            NSString *hour = [dateString substringWithRange:NSMakeRange(0, 2)];
            NSString *minute = [dateString substringWithRange:NSMakeRange(hour.length, 2)];
            NSString *second = [dateString substringWithRange:NSMakeRange(hour.length + minute.length, 2)];
            return [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
        } else {
            return dateString;
        }
    }
}

#pragma mark - 字符串前面添加空格
+ (NSString *)addSpace:(NSString *)string count:(int)count
{
    for (int i=0; i<count; i++) {
        string = [NSString stringWithFormat:@" %@", string];
    }
    return string;
}

#pragma mark - 将金额字段转换为货币格式
+ (NSString *)convertToCurrencyWith:(NSString *)String
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *currencyStr = [formatter stringFromNumber:[NSNumber numberWithDouble:[String doubleValue]]];
    currencyStr = [currencyStr stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
    return currencyStr;
}



#pragma mark 是否空字符串
- (BOOL)isEmptyString {
    if (![self isKindOfClass:[NSString class]]) {
        return TRUE;
    }else if (self==nil) {
        return TRUE;
    }else if(!self) {
        // null object
        return TRUE;
    } else if(self==NULL) {
        // null object
        return TRUE;
    } else if([self isEqualToString:@"NULL"]) {
        // null object
        return TRUE;
    }else if([self isEqualToString:@"(null)"]){
        
        return TRUE;
    }else{
        //  使用whitespaceAndNewlineCharacterSet删除周围的空白字符串
        //  然后在判断首位字符串是否为空
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return TRUE;
        } else {
            // is neither empty nor null
            return FALSE;
        }
    }
}

#pragma mark 判断是否是手机号
- (BOOL)checkTel {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

#pragma mark 判断是否是邮箱
- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 返回沙盒中的文件路径
+ (NSString *)stringWithDocumentsPath:(NSString *)path {
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [file stringByAppendingPathComponent:path];
}

#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 一串字符在固定宽度下，正常显示所需要的高度
+ (CGFloat)autoHeightWithString:(NSString *)string
                          width:(CGFloat)width
                           font:(UIFont *)font {
    
    // 大小
    CGSize boundRectSize = CGSizeMake(width, MAXFLOAT);
    // 绘制属性（字典）
    NSDictionary *fontDict = @{ NSFontAttributeName: font };
    // 调用方法,得到高度
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:fontDict context:nil].size.height;
    return newFloat;
}

#pragma mark 一串字符在一行中正常显示所需要的宽度
+ (CGFloat)autoWidthWithString:(NSString *)string
                          font:(UIFont *)font {
    
    // 大小
    CGSize boundRectSize = CGSizeMake(MAXFLOAT, font.lineHeight);
    // 绘制属性（字典）
    NSDictionary *fontDict = @{ NSFontAttributeName: font };
    // 调用方法,得到高度
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:fontDict context:nil].size.width;
    return newFloat;
}


#pragma mark - 根据 字体大小 宽度 返回 高度
+ (CGSize) sizeForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit;
}
#pragma mark -- 设备型号
+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    //    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    //    deviceString = [NSString stringWithFormat:@"%@-%@",deviceString,[NSString isJailbroken]];
    return deviceString;
}


#pragma mark -- 获得设备类型
+ (NSInteger)getDeviceTypeInfo
{
    //    NSLog(@"[self deviceString]=%@",[self deviceString]);
    if ([[self deviceString] isEqualToString:@"Verizon iPhone 4"]) {
        return 4;
    }else if([[self deviceString] isEqualToString:@"iPhone 4"]){
        return 4;
    }else if([[self deviceString] isEqualToString:@"iPhone 4S"]){
        return 4;
    }else if([[self deviceString] isEqualToString:@"iPhone 5"]){
        return 5;
    }else if([[self deviceString] isEqualToString:@"iPod Touch 4G"]){
        return 4;
    }else if([[self deviceString] isEqualToString:@"iPod Touch 5G"]){
        return 5;
    }
    
    return 0;
}

#pragma mark -- ios版本
+ (NSString *)iosVersions
{
    NSString* strVersion = [[UIDevice currentDevice] systemVersion];
    
    //    float version = [strVersion floatValue];
    NSLog(@"version:%@", strVersion);
    return strVersion;
}

#pragma mark 获取当前时间
+(NSString *)timeNow:(NSString *)formatter{
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    format.dateFormat=formatter;
    NSString *str=[format stringFromDate:[NSDate date]];
    return str;
}
#pragma mark -- MD5加密
+(NSString *)createMD5:(NSString *)signString
{
    /*
     const char*cStr =[signString UTF8String];
     unsigned char result[16];
     CC_MD5(cStr, strlen(cStr), result);
     return[NSString stringWithFormat:
     @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
     result[0], result[1], result[2], result[3],
     result[4], result[5], result[6], result[7],
     result[8], result[9], result[10], result[11],
     result[12], result[13], result[14], result[15]
     ];
     */
    return nil;
}
#pragma mark 中英文混合计算字符长度
+(NSUInteger) unicodeLengthOfString:(NSString*)text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i=0; i<text.length; i++) {
        unichar uc = [text characterAtIndex:i];
        
        asciiLength += isascii(uc)?1:2;
    }
    return asciiLength;
}
#pragma mark 判断字符串是否含汉字
+(BOOL) containsChinese:(NSString *)str {
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return TRUE;
    }
    return FALSE;
}
+(BOOL)containEnglish:(NSString *)str{
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( (a >= 0x41 && a <= 0x5a)||(a >= 0x61 && a <= 0x7a))
            return TRUE;
    }
    return FALSE;
}
+(BOOL)containShuZi:(NSString *)str{
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a >= 0x30 && a <= 0x39)
            return TRUE;
    }
    return FALSE;
}
- (NSString*)urlEncoded
{
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}


- (CGSize)sizeWithFont:(UIFont *)font{
    if (ISIOS7Later) {
        NSDictionary *attribute=@{NSFontAttributeName:font};
        return [self sizeWithAttributes:attribute];
    }else{
        return [self sizeWithFont:font];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (ISIOS7Later) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSLineBreakByWordWrapping;
        NSDictionary *attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraph};
        
        return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
}
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    if (ISIOS7Later) {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        
        return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        return [self sizeWithFont:font constrainedToSize:size];
    }
}

@end
