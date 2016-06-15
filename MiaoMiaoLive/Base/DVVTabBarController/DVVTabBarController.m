//
//  DVVTabBarController.m
//  DVVTabBarController
//
//  Created by 大威 on 15/12/4.
//  Copyright © 2015年 DaWei. All rights reserved.
//

#import "DVVTabBarController.h"
#import "DVVDockItem.h"

@interface DVVTabBarController ()

@property (nonatomic, assign) BOOL loaded;

// 所有项的图片名字（正常）
@property (nonatomic, strong) NSArray *iconNormalArray;
// 所有项的图片名字（选中）
@property (nonatomic, strong) NSArray *iconSelectedArray;

@property (nonatomic, strong) NSArray *itemBackgroundNormalArray;
@property (nonatomic, strong) NSArray *itembackgroundSelectedArray;

// 所有项的名字
@property (nonatomic, strong) NSArray *titleArray;
// 正常情况下的颜色
@property (nonatomic, strong) UIColor *titleNormalColor;
// 选中时的颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundColor;

// 定义一个UIView添加到TabBar上
// 在这个视图上添加每一项
// 每一项都用一个UIButton代替
@property(nonatomic, strong) UIView *coverView;

@property(nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation DVVTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialProperty];
    }
    return self;
}

#pragma mark - 初始化属性 method
- (void)initialProperty {
    
    _titleNormalColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_loaded) {
        return;
    }
    
//    self.backgroundImage = [UIImage imageNamed:@"tabBar_background"];
    
    self.iconNormalArray = @[ @"ic_tab_home", @"ic_tab_home", @"ic_tab_voice" ];
    
    self.iconSelectedArray = @[ @"ic_tab_home", @"ic_tab_home", @"ic_tab_voice" ];
    
    self.itemBackgroundNormalArray = @[ @"", @"", @"" ];
    
    self.itembackgroundSelectedArray = @[ @"", @"", @"" ];
    
    self.titleArray = @[ @"首页", @"Notepad",@"语音" ];
    
    CGRect rect = self.tabBar.bounds;
    // 高度需要+1，否则会出现底部tabBar的白色背景（会显示出来一条白线）
    rect.size.height += 1;
    
    _coverView = [UIView new];
    _coverView.frame = rect;
    _coverView.backgroundColor = [UIColor clearColor];
    // 添加背景图片
    if (_backgroundImage) {
        _coverView.backgroundColor = [UIColor clearColor];
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.image = _backgroundImage;
        _backgroundImageView.frame = rect;
        [self.tabBar addSubview:_backgroundImageView];
    }
    
    [self.tabBar addSubview:_coverView];
    
    
    //添加所有的子项
    for (int i = 0; i<_titleArray.count; i++) {
        
        [self addOneItemWithTitle:_titleArray[i] tag:i];
    }
    
    _loaded = true;
}

#pragma mark - 选中一项 method
- (void)itemButtonSelected:(UIButton *)sender {
    
    //取消上次选中的状态
    for (UIButton *itemBtn in _coverView.subviews) {
        
        if ([itemBtn isKindOfClass:[UIButton class]] && itemBtn.tag == self.selectedIndex) {
            
            itemBtn.selected = NO;
        }
    }
    
    //打开选中的窗体
    self.selectedIndex = sender.tag;
    
    sender.selected = YES;
}

#pragma mark - 重新布局 coverView 中的子控件 method
- (void)reconfigureCoverViewSubviewsFrame {
    
    //得到一个按钮的宽度
    CGFloat btnWidth = _coverView.bounds.size.width / _coverView.subviews.count;
    for (UIButton *itemBtn in _coverView.subviews) {
        
        CGRect frameRect;
        //调整width,height
        frameRect.size.width = btnWidth;
        frameRect.size.height = _coverView.bounds.size.height - 2;
        //调整minX,ninY
        frameRect.origin.x = itemBtn.tag * btnWidth;
        frameRect.origin.y = 2;
        
        //赋值坐标
        itemBtn.frame = frameRect;
    }
    
}


#pragma mark - 向视图中添加一项 method

- (void)addOneItemWithTitle:(NSString *)newTitle tag:(NSInteger)tag {
    
    DVVDockItem *itemBtn = [DVVDockItem new];
    //设置tag值
    itemBtn.tag = tag;
    itemBtn.backgroundColor = [UIColor clearColor];
//    if (tag == 0) {
//        itemBtn.backgroundColor = [UIColor redColor];
//    }
//    if (tag == 1) {
//        itemBtn.backgroundColor = [UIColor greenColor];
//    }
//    if (tag == 2) {
//        itemBtn.backgroundColor = [UIColor orangeColor];
//    }
    //取消高亮效果
    itemBtn.adjustsImageWhenHighlighted = NO;
    //设置图片
    [itemBtn setImage:[UIImage imageNamed:[_iconNormalArray objectAtIndex:tag]] forState:UIControlStateNormal];
    itemBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [itemBtn setImage:[UIImage imageNamed:[_iconSelectedArray objectAtIndex:tag]] forState:UIControlStateSelected];
    
    [itemBtn setBackgroundImage:[UIImage imageNamed:[_itemBackgroundNormalArray objectAtIndex:tag]] forState:UIControlStateNormal];
    [itemBtn setBackgroundImage:[UIImage imageNamed:[_itembackgroundSelectedArray objectAtIndex:tag]] forState:UIControlStateSelected];
    
    //设置标题
    [itemBtn setTitle:newTitle forState:UIControlStateNormal];
    [itemBtn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
    
    //添加点击事件
    [itemBtn addTarget:self action:@selector(itemButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加
    [_coverView addSubview:itemBtn];
    //重新布局
    [self reconfigureCoverViewSubviewsFrame];
    
    if (itemBtn.tag == 0) {
        
        [self itemButtonSelected:itemBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
