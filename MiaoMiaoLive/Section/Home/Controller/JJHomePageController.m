//
//  JJHomePageController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomePageController.h"
#import "JJSideController.h"
#import "AppDelegate.h"
#import "JJSideBarController.h"
#import "JJHomePageCell.h"
#import "JJHomeClassifyCell.h"
#import "JJHomeBillTypeManagerController.h"
#import "JJHomeBillController.h"
#import "JJHomeBillModel.h"
#import "JJHomePageBillDetailController.h"
#import "JJlineChart.h"


#define TableHeadViewHeight ScreenWidth*0.5

@interface JJHomePageController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton * leftNavBtn;
@property (nonatomic, strong) JJSideBarController *sideBarVC;
@property (nonatomic, strong) UIView *backgroundHideView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) UIImageView *shadowView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataNameArray;
@property (nonatomic, strong) NSMutableArray *dataTypeArray;
@property (nonatomic, strong) NSMutableArray *dataMoneyArray;
@property (nonatomic, strong) NSMutableArray *dataTimeArray;

@property (nonatomic, strong) JJlineChart *lineChartView;
@property (nonatomic, strong) NSMutableArray *xLabelArray;
@property (nonatomic, strong) NSMutableArray *incomeArray; // 收入money
@property (nonatomic, strong) NSMutableArray *spendingArray; // 支出money

@end

@implementation JJHomePageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
    _dataMoneyArray = [NSMutableArray array];
    _dataNameArray = [NSMutableArray array];
    _dataTypeArray = [NSMutableArray array];
    _dataTimeArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    // 设置导航栏按钮
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    self.navigationItem.leftBarButtonItem = barBtnItem;
    [self.leftNavBtn addTarget:self action:@selector(leftNavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [_tableHeadView addSubview:self.lineChartView];

    [self configChartView];
    self.edgesForExtendedLayout = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    self.shadowView.frame = CGRectMake(0, 0, 10, ScreenHeight);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 每次显示都刷新下数据
    [self queryData];
}

- (void)queryData
{
    [_dataNameArray removeAllObjects];
    [_dataTypeArray removeAllObjects];
    [_dataMoneyArray removeAllObjects];
    [_dataTimeArray removeAllObjects];
    
    for (JJHomeBillModel * model in [JJHomeBillModel findAll])
    {
        [_dataNameArray insertObject:model.typeName atIndex:0];
        [_dataTypeArray insertObject:model.type atIndex:0];
        [_dataMoneyArray insertObject:model.money atIndex:0];
        [_dataTimeArray insertObject:model.currentTime atIndex:0];
        [self.dataArray insertObject:model atIndex:0];
    }
    [self configChartView];
    [self.tableView reloadData];
}

- (void)configChartView
{
    _incomeArray = [NSMutableArray array];
    _spendingArray = [NSMutableArray array];
    _xLabelArray = [NSMutableArray array];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 获取年和月
    [formatter setDateFormat:@"yyyy.MM"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange daysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
    
    for (int i = 1; i <= daysRange.length; i++)
    {
        //收入
        NSString *dateStr = [NSString stringWithFormat:@"%@.%02d", dateTime, i];
        [_xLabelArray addObject:dateStr];
        NSArray *modelIncomeArray = [JJHomeBillModel findByCriteria:[NSString stringWithFormat:@"where currentTime = '%@' and type = '0' ", dateStr]];
        
        CGFloat sumIncome = 0;
        for (JJHomeBillModel * model in modelIncomeArray)
        {
            sumIncome += [model.money floatValue];
        }
        [_incomeArray addObject:[NSString stringWithFormat:@"%2f",sumIncome]];
        
        // 支出
        NSArray *modelSpengingArray = [JJHomeBillModel findByCriteria:[NSString stringWithFormat:@"where currentTime = '%@' and type = '1' ",dateStr]];
        CGFloat sumSpending = 0;
        for (JJHomeBillModel * model in modelSpengingArray)
        {
            sumSpending += [model.money floatValue];
        }
        [_spendingArray addObject:[NSString stringWithFormat:@"%2f",sumSpending]];
       
    }
    
//    // 这个字典存储收入（key: 日期  value: 金额）
//    NSMutableDictionary *incomeDic = [NSMutableDictionary dictionary];
//    // 这个字典存储支出（key: 日期  value: 金额）
//    NSMutableDictionary *spendingDic = [NSMutableDictionary dictionary];
//    
//    // 把当月所有的日期都存入字典里
//    for (int i = 1; i <= daysRange.length; i++)
//    {
//        [incomeDic setObject:@"" forKey:[NSString stringWithFormat:@"%@.%d", dateTime, i]];
//        [incomeDic setObject:@"" forKey:[NSString stringWithFormat:@"%@.%d", dateTime, i]];
//    }
//    
//    // 获取数据库中的所有收入数据
//    for (JJHomeBillModel * model in [JJHomeBillModel findByCriteria:@"where type = '0'"])
//    {
//        // 获取日期
//        NSString *dateStr = [model.currentTime substringToIndex:10];
//        // 获取已有的日期
//        NSArray *incomeDateArr = incomeDic.allKeys;
//        // 用这个flage判断日期是否已经在数组中
//        BOOL flage = NO;
//        // 循环已有的日期，用于判断模型中的日期是否已经存在字典中
//        for (NSString *itemDataStr in incomeDateArr)
//        {
//            if ([itemDataStr isEqualToString:dateStr])
//            {
//                // 获取已有的值
//                NSString *tmpMoney = incomeDic[dateStr];
//                // 相加
//                CGFloat tmpSumMoney = [model.money floatValue] + [tmpMoney floatValue];
//                // 然后再存进去
//                incomeDic[dateStr] = [NSString stringWithFormat:@"%.2f", tmpSumMoney];
//                flage = YES;
//                // 跳出循环
//                break;
//            }
//        }
//        // 如果循环过后，日期中没有，则添加进去
//        if (!flage)
//        {
//            incomeDic[dateStr] = model.money;
//        }
//    }
//    
////    DLog(@"%@", incomeDic);
//    
//    for (JJHomeBillModel * model in [JJHomeBillModel findByCriteria:@"where type = '1'"])
//    {
//        // 获取日期
//        NSString *dateStr = [model.currentTime substringToIndex:10];
//        // 获取已有的日期
//        NSArray *spendingDateArr = spendingDic.allKeys;
//        // 用这个flage判断日期是否已经在数组中
//        BOOL flage = NO;
//        // 循环已有的日期，用于判断模型中的日期是否已经存在字典中
//        for (NSString *itemDataStr in spendingDateArr)
//        {
//            if ([itemDataStr isEqualToString:dateStr])
//            {
//                // 获取已有的值
//                NSString *tmpMoney = incomeDic[dateStr];
//                // 相加
//                CGFloat tmpSumMoney = [model.money floatValue] + [tmpMoney floatValue];
//                // 然后再存进去
//                spendingDic[dateStr] = [NSString stringWithFormat:@"%.2f", tmpSumMoney];
//                flage = YES;
//                // 跳出循环
//                break;
//            }
//        }
//        // 如果循环过后，日期中没有，则添加进去
//        if (!flage)
//        {
//            spendingDic[dateStr] = model.money;
//        }
//    }
//    
////    DLog(@"%@", spendingDic);
//    
//    if (incomeDic.allKeys.count > spendingDic.allKeys.count)
//    {
//        _xLabelArray = incomeDic.allKeys.mutableCopy;
//    }
//    else
//    {
//        _xLabelArray = spendingDic.allKeys.mutableCopy;
//    }
//    _incomeArray = incomeDic.allValues.mutableCopy;
//    _spendingArray = spendingDic.allValues.mutableCopy;
    
    self.lineChartView.xTitleArray = _xLabelArray;
    self.lineChartView.valueArray = @[ _incomeArray, _spendingArray ];
    self.lineChartView.colorArray = @[ [UIColor greenColor], [UIColor orangeColor] ];
    self.lineChartView.xLabelWidth = 80;
    self.lineChartView.yTitleWidth =  40;
    [self.lineChartView refreshData];
    

}

#pragma mark - tableView
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /*此处处理自己的代码，如删除数据*/
        /*删除tableView中的一行*/
        NSUInteger row = indexPath.row - 1;
        [JJHomeBillModel deleteObjectsByCriteria:FormatString(@" WHERE typeName = '%@' and type = '%@' and money = '%@' and currentTime = '%@'",self.dataNameArray[row],self.dataTypeArray[row],self.dataMoneyArray[row],self.dataTimeArray[row])];
        
        [self queryData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        JJHomePageBillDetailController *detailVC = [[JJHomePageBillDetailController alloc] init];
        detailVC.type = _dataTypeArray[indexPath.row - 1];
        detailVC.money = _dataMoneyArray[indexPath.row - 1];
        detailVC.typeName = _dataNameArray[indexPath.row - 1];
        detailVC.dateTime = _dataTimeArray[indexPath.row - 1];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.dataModel = self.dataArray[indexPath.row - 1];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataTypeArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return ScreenWidth/2.0;
    }
    else
    {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JJHomeClassifyCell * classifyCell = [[JJHomeClassifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classfyCellID"];
    
    if (0 == indexPath.row)
    {
        classifyCell.dataArray = @[@"类别管理",@"记账"].mutableCopy;
        classifyCell.backgroundColor = [UIColor magentaColor];
        
        WS;
        WeakObj(classifyCell, weakClassifyCell);
//        __weak typeof(classifyCell) weakClassixfyCell = classifyCell;
        [classifyCell setBlock:^(NSInteger selectIndex) {
            
            JJHomeBillTypeManagerController *billType = [[JJHomeBillTypeManagerController alloc] init];
            JJHomeBillController *billVC = [[JJHomeBillController alloc] init];
            
            switch (selectIndex)
            {
                case 0:
                    billType.navigationItem.title = weakClassifyCell.dataArray[selectIndex];
                    billType.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:billType animated:YES];
                    break;
                case 1:
                    billVC.navigationItem.title = weakClassifyCell.dataArray[selectIndex];
                    billVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:billVC animated:YES];
                    break;
                    
                default:
                    break;
            }
        }];
        return classifyCell;
    }
    else
    {
       static NSString *cellID = @"NomalCellID";
        JJHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[JJHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor cyanColor];
        }
        if ([_dataTypeArray[indexPath.row-1] isEqualToString:@"0"])
        {
            [cell.typeImg setImage:[UIImage imageNamed:@"ic_record"]];
        }
        else
        {
           [cell.typeImg setImage:[UIImage imageNamed:@"ic_tab_shop"]];
        }
        cell.nameLabel.text = _dataNameArray[indexPath.row-1];
        cell.moneyLabel.text = _dataMoneyArray[indexPath.row-1];
        return cell;
        
    }
}

// 获取根视图
- (UIViewController *)getRootController
{
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

#pragma mark - 设置侧边栏

- (void)leftNavBtnAction
{
    _sideBarVC = [[JJSideBarController alloc] init];
    _sideBarVC.view.backgroundColor = [UIColor redColor];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = [self getRootController];
    _sideBarVC.view.alpha = 0;
    [keyWindow insertSubview:_sideBarVC.view belowSubview:vc.view];
    
    [UIView animateWithDuration:0.7 animations:^{
        _sideBarVC.view.alpha = 1;
        vc.view.frame = CGRectMake(ScreenWidth - 60, 0, ScreenWidth, ScreenHeight);
        self.shadowView.frame = CGRectMake(ScreenWidth - 70, 0, 10, ScreenHeight);
    } completion:^(BOOL finished) {
         [keyWindow addSubview:self.backgroundHideView];
    }];
}

- (void)hideJJSideRemoveSupView
{
    UIViewController * vc = [self getRootController];
    [self.backgroundHideView removeFromSuperview];
    
    [UIView animateWithDuration:0.7 animations:^{
        self.sideBarVC.view.alpha = 0;
        vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.shadowView.frame = CGRectMake(-10, 0, 10, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.sideBarVC.view removeFromSuperview];
        self.sideBarVC = nil;
    }];

}

- (UIButton *)leftNavBtn
{
    if (!_leftNavBtn)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NaviItemFontSize * 2, 44)];
        [button setTitle:@"侧栏" forState:UIControlStateNormal];
        button.titleLabel.font = NaviItemFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor cyanColor];
        button.userInteractionEnabled = YES;
        _leftNavBtn = button;
    }
    return _leftNavBtn;
}

- (UIView *)backgroundHideView
{
    if (!_backgroundHideView)
    {
        _backgroundHideView = [UIView new];
        _backgroundHideView.frame = CGRectMake(ScreenWidth - 60, 0, 60, ScreenHeight);
        _backgroundHideView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideJJSideRemoveSupView)];
        [_backgroundHideView addGestureRecognizer:tap];
    }
    return _backgroundHideView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = self.tableHeadView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView)
    {
        _tableHeadView = [UIView new];
        _tableHeadView.frame = CGRectMake(0, 0, ScreenWidth, TableHeadViewHeight);

    }
    return _tableHeadView;
}

- (UIImageView *)shadowView
{
    if (!_shadowView)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"img_sideShadow"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.alpha = 0.5;
        _shadowView = imageView;
    }
    return _shadowView;
}

- (JJlineChart *)lineChartView
{
    if (!_lineChartView)
    {
        _lineChartView =[[JJlineChart alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TableHeadViewHeight)];
    }
    return _lineChartView;
}



- (void)didReceiveMemoryWarning
{
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
