//
//  NSString+MD5.h
//  华尔金服
//
//  Created by chen z on 15/11/2.
//  Copyright (c) 2015年 dfhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

//把字符串加密成32位小写md5字符串
+ (NSString*)md532BitLower:(NSString *)inPutText;

//把字符串加密成32位大写md5字符串
+ (NSString*)md532BitUpper:(NSString*)inPutText;


@end
