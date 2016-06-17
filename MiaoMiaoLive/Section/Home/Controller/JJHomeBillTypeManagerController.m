//
//  JJHomeBillTypeManagerController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomeBillTypeManagerController.h"
#import "JJHomeBillTypeManagerCell.h"
#import "JJHomeBillTypeAddController.h"
#import "JJHomeBillTypeModel.h"
#import <sqlite3.h>


static NSString *cellID = @"JJHomeBillTypeManagerCollectionCellID";

@interface JJHomeBillTypeManagerController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (assign, nonatomic) BOOL wobble; // 摇摆
@property (nonatomic, copy) NSString *isFirstRunning;

@end

@implementation JJHomeBillTypeManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.edgesForExtendedLayout = NO;
    self.navigationItem.titleView = self.segment;
    VCAddSubview(self.collectionView);
    VCAddSubview(self.addButton);
    _dataArray = [NSMutableArray array];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [defaults objectForKey:IsFirstRunning];
    _isFirstRunning = [NSString stringWithFormat:@"%@",data];
    if (![_isFirstRunning isEqualToString:@"YES"]) {
        
        [self initData];
        _isFirstRunning = @"YES";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_isFirstRunning forKey:IsFirstRunning];
        [defaults synchronize];
    }
    [self queryData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 180);
    _addButton.frame = CGRectMake(ScreenWidth/2.0-20, ScreenHeight-130, 40, 20);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryData];

}

- (void)queryData
{
    [_dataArray removeAllObjects];
    for (JJHomeBillTypeModel * model in [JJHomeBillTypeModel findByCriteria:FormatString(@"where type = '%li'", (long)self.segment.selectedSegmentIndex)])
    {
        [_dataArray addObject:model.typeName];
    }
    [self.collectionView reloadData];
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg
{
    
    NSInteger index = Seg.selectedSegmentIndex;
    [self queryData];

}

- (void)wobbleAction: (BOOL)isWobble
{
    if (isWobble)
    {
        self.wobble = NO;
        
    }
    else
    {
        self.wobble = YES;
    }
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     JJHomeBillTypeManagerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

     WS;
    [cell setWobbleBlock:^(BOOL isWobble) {
        [weakSelf wobbleAction:isWobble];
    }];
    [cell setDeleteBlock:^(JJHomeBillTypeManagerCell *cellM) {
        [weakSelf.collectionView reloadData];
         [JJHomeBillTypeModel deleteObjectsByCriteria:FormatString(@" WHERE typeName = '%@' and type = '%ld'",weakSelf.dataArray[cellM.tag],(long)weakSelf.segment.selectedSegmentIndex)];
        [weakSelf.dataArray removeObjectAtIndex:cellM.tag];
    }];

    if (self.wobble)
    {
        [cell beginWobble];
    }
    else
    {
        [cell cancelWobble];
    }
  
    if (self.segment.selectedSegmentIndex == 0)
    {
        cell.iconImg.image = [UIImage imageNamed:@"ic_record"];
    }
    else
    {
        cell.iconImg.image = [UIImage imageNamed:@"ic_tab_shop"];
    }
        
  
    cell.titleLabel.text = _dataArray[indexPath.row];
    
    cell.tag = indexPath.row;
    return cell;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerClass:[JJHomeBillTypeManagerCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ViewBgColor;
        
    }
    return _collectionView;
}

- (void)initData
{
    NSArray *incomeTypeArray = @[@"工资",@"奖金",@"兼职",@"投资",@"红包"];
    NSMutableArray *incomeArray = [NSMutableArray array];
    for (int i = 0; i < incomeTypeArray.count; i++)
    {
        JJHomeBillTypeModel *model = [[JJHomeBillTypeModel alloc] init];
        model.typeName = incomeTypeArray[i];
        model.type = @"0";
        [incomeArray addObject:model];
    }
    
    NSArray *spendingTypeArray = @[@"吃喝",@"早餐",@"午餐",@"晚餐",@"夜宵",@"零食水果",@"买菜",@"烟酒",@"化妆护肤",@"服饰"];
    NSMutableArray *spendingArray = [NSMutableArray array];
    for (int i = 0; i < spendingTypeArray.count; i++)
    {
        JJHomeBillTypeModel *model = [[JJHomeBillTypeModel alloc] init];
        model.typeName = spendingTypeArray[i];
        model.type = @"1";
        [spendingArray addObject:model];
    }

    [JJHomeBillTypeModel saveObjects:incomeArray];
    [JJHomeBillTypeModel saveObjects:spendingArray];
    
    
}

- (void)addDataToTabelAction
{
    
    JJHomeBillTypeAddController * addVC = [[JJHomeBillTypeAddController alloc] init];
    WS;
    [addVC setDoneBlock:^(NSString *content) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableArray *array = [NSMutableArray array];
            
            JJHomeBillTypeModel * model = [[JJHomeBillTypeModel alloc] init];
            
            model.typeName = content;
            
            model.type = FormatString(@"%zi", weakSelf.segment.selectedSegmentIndex);
            
            [array addObject:model];
            
            [JJHomeBillTypeModel saveObjects:array];
            
        });
    }];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (UIButton *)addButton
{
    if (!_addButton)
    {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addDataToTabelAction) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"ic_add_tab"] forState:UIControlStateNormal];
        
        _addButton = button;
    }
    return _addButton;
}

- (UISegmentedControl *)segment
{
    if (!_segment)
    {
        _segment = [[UISegmentedControl alloc] initWithItems:@[ @"收入", @"支出"]];
        _segment.frame = CGRectMake(100, 100, 100, 30);
//        _segment.tintColor = [UIColor blackColor];
        [_segment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
    }
    return _segment;
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
