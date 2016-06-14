//
//  UINavigationItem+DVVBackItem.m
//  MiaoMiaoRadio
//
//  Created by 大威 on 16/5/11.
//  Copyright © 2016年 iosdawei. All rights reserved.
//

#import "UINavigationItem+DVVBackItem.h"
#import <objc/runtime.h>

@implementation UINavigationItem (DVVBackItem)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originalBackBarButtonItemImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method swizzBackBarButtonItemImp = class_getInstanceMethod(self, @selector(dvv_backBarButtonItem));
        method_exchangeImplementations(originalBackBarButtonItemImp, swizzBackBarButtonItemImp);
    });
}

static char dvv_kBackBarButtonItem;

- (UIBarButtonItem *)dvv_backBarButtonItem
{
    UIBarButtonItem *item = [self dvv_backBarButtonItem];
    
    if (item) return item;
    
    item = objc_getAssociatedObject(self, &dvv_kBackBarButtonItem);
    if (!item)
    {
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor redColor];
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &dvv_kBackBarButtonItem, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

- (void)dealloc
{
    objc_removeAssociatedObjects(self);
}

@end
