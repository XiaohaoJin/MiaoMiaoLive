//
//  JJHomeBillController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/29.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomeBillController.h"
#import "JJHomeBillTypeManagerCell.h"
#import "JJHomeBillTypeModel.h"
#import "JJHomeBillModel.h"
#import "JJDatePickerView.h"

static NSString *cellID = @"JJHomeBillControllerCellID";

@interface JJHomeBillController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel * showTitleLabel;
@property (nonatomic, strong) UITextField * moneyText;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *keyBoardArray;
@property (nonatomic, assign) CGFloat NumOne;
@property (nonatomic, assign) CGFloat NumTwo;
@property (nonatomic, strong) NSString *currentNumber;
@property (nonatomic, strong) UIButton * dateButton;

@end

@implementation JJHomeBillController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
    [self.view addSubview:self.collectionView];
    self.navigationItem.titleView = self.segment;
    
    VCAddSubview(self.showTitleLabel);
    VCAddSubview(self.moneyText);
    VCAddSubview(self.dateButton);
    
    _dataArray = [NSMutableArray array];
    [self queryData];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    _keyBoardArray = [NSMutableArray array];
    
    [self createNumKeyBoard];
}

- (void)queryData
{
    [_dataArray removeAllObjects];

    NSString *sqlStr = FormatString(@"where type = '%li'", (long)self.segment.selectedSegmentIndex);
    NSMutableArray *marr = [JJHomeBillTypeModel findByCriteria:sqlStr];
    for (JJHomeBillTypeModel * model in marr)
    {
        [_dataArray addObject:model.typeName];
    }
    if (_dataArray.count>0)
    {
        self.showTitleLabel.text = _dataArray[0];
    }

    [self.collectionView reloadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _collectionView.frame = CGRectMake(0, 30, ScreenWidth, ScreenHeight - 180 - 30);
    _showTitleLabel.frame = CGRectMake(0, 0, 100, 30);
    _moneyText.frame = CGRectMake(100, 0, ScreenWidth-100, 30);
    _dateButton.frame = CGRectMake(10, ScreenHeight - 180 - 40, 100, 30);

}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg
{
    NSInteger index = Seg.selectedSegmentIndex;
    [self queryData];
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
   [cell setShowSelectedBlock:^(JJHomeBillTypeManagerCell *aCell) {
       [weakSelf showTitleLabelText:weakSelf.dataArray[aCell.tag]];
   }];
    
    cell.titleLabel.text = _dataArray[indexPath.row];
    if (self.segment.selectedSegmentIndex == 0)
    {
        cell.iconImg.image = [UIImage imageNamed:@"ic_record"];
    }
    else
    {
        cell.iconImg.image = [UIImage imageNamed:@"ic_tab_shop"];
    }
    
    cell.tag = indexPath.row;
    return cell;
}

- (void)showTitleLabelText: (NSString *)str
{
    self.showTitleLabel.text = str;
}

- (void)dateButtonAction
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    [JJDatePickerView showFromView:self.view.window title:dateTime didSelectedBlock:^(NSString *yearString, NSString *monthStrig, NSString *dayString) {
        NSString *dateStr = [NSString stringWithFormat:@"%@.%@.%@",yearString,monthStrig,dayString];
        [_dateButton setTitle:dateStr forState:UIControlStateNormal];
    }];
}

- (void)createNumKeyBoard
{
    NSArray * titleArray = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",@".",@"0",@"OK"].copy;
    for (int i = 0; i < titleArray.count; i ++)
    {
        NSInteger col = i/3;
        NSInteger rol = i%3;
        
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(rol*ScreenWidth/3.0, ScreenHeight-120 - 65+col*30, ScreenWidth/3.0, 30);
        
        btn.backgroundColor = [UIColor blackColor];
        btn.alpha = 0.9;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(keyBoardClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [_keyBoardArray addObject:btn];
    }
    
    
}
- (void)keyBoardClickAction: (UIButton *)sender
{
    
    NSString *currentButtonTitle = sender.titleLabel.text;
    if (![currentButtonTitle isEqualToString:@"OK"])
    {
        _moneyText.text =[_moneyText.text stringByAppendingString:FormatString(@"%@",currentButtonTitle)];
        self.currentNumber = _moneyText.text;
    }
    
    if ([currentButtonTitle isEqualToString:@"OK"])
    {
        if ([_showTitleLabel.text isEqualToString:@" "] || _showTitleLabel.text.length == 0)
        {
            return;
        }
        WS;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableArray *array = [NSMutableArray array];
            JJHomeBillModel * model = [[JJHomeBillModel alloc] init];
            model.typeName = _showTitleLabel.text;
            model.type = FormatString(@"%zi", weakSelf.segment.selectedSegmentIndex);
            if (kIsNull(self.currentNumber)) {
                return ;
            }
            model.money = self.currentNumber;
            model.currentTime = _dateButton.titleLabel.text;
            
            [array addObject:model];
            
            
            [JJHomeBillModel saveObjects:array];
            
        });
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
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
        _collectionView.layer.shadowColor =[UIColor blackColor].CGColor;
        _collectionView.layer.shadowRadius = 1;
        _collectionView.layer.shadowOffset = CGSizeMake(2, 2);
        _collectionView.layer.shadowOpacity = 0.5;
        _collectionView.backgroundColor = ViewBgColor;
    }
    return _collectionView;
}

- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[ @"收入", @"支出"]];
        _segment.frame = CGRectMake(100, 100, 100, 30);
         _segment.tintColor = [UIColor whiteColor];
        [_segment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
    }
    return _segment;
}

- (UILabel *)showTitleLabel
{
    if (!_showTitleLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _showTitleLabel = label;
    }
    return _showTitleLabel;
}

- (UITextField *)moneyText
{
    if (!_moneyText)
    {
        _moneyText = [UITextField new];
        _moneyText.placeholder = @"0.00";
        _moneyText.textAlignment = NSTextAlignmentRight;
        _moneyText.userInteractionEnabled = NO;
    }
    return _moneyText;
}

- (UIButton *)dateButton
{
    if (!_dateButton)
    {
        _dateButton = [UIButton new];
        _dateButton.layer.borderColor = [UIColor blackColor].CGColor;
        _dateButton.layer.borderWidth = 1;
        _dateButton.layer.cornerRadius = 10;
        [_dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        [_dateButton setTitle:dateTime forState:UIControlStateNormal];
        _dateButton.userInteractionEnabled = YES;
        [_dateButton addTarget:self action:@selector(dateButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _dateButton;
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
