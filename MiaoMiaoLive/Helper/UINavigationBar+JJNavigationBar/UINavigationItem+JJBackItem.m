//
//  UINavigationItem+JJBackItem.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/19.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "UINavigationItem+JJBackItem.h"
#import <objc/runtime.h>

@implementation UINavigationItem (JJBackItem)

#if 1
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         *
         *   class_getInstanceMethod   得到类的实例方法
         *   class_getClassMethod      得到类的类方法
         *
         *   method_exchangeImplementations 在程序运行期间动态的给两个方法互换实现
         */
        Method originalBackBarButtonItemImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method swizzBackBarButtonItemImp = class_getInstanceMethod(self, @selector(jj_backBarButtonItem));
        method_exchangeImplementations(originalBackBarButtonItemImp, swizzBackBarButtonItemImp);
    });
}

static char dvv_kBackBarButtonItem;

- (UIBarButtonItem *)jj_backBarButtonItem
{
    UIBarButtonItem *item = [self jj_backBarButtonItem];
    
    if (item) return item;
    
    item = objc_getAssociatedObject(self, &dvv_kBackBarButtonItem);
    if (!item)
    {
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        /**
         *  objc_setAssociatedObject 一个对象对另一个对象关联
         */
        objc_setAssociatedObject(self, &dvv_kBackBarButtonItem, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

- (void)dealloc
{
    objc_removeAssociatedObjects(self);
}

#endif
/**
 ＊  NSString * associatedObject = (NSString *)objc_getAssociatedObject(array, &oveviewKey);获取关联对象
 *  objc_setAssociatedObject(array, &overviewKey, nil, OBJC_ASSOCIATION_ASSIGN); 断开关联，关联对象为nil
 */


@end
