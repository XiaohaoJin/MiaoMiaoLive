//
//  JJHomePageBillDetailController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/3.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomePageBillDetailController.h"
#import "JJHomePageBillDetailCell.h"
#import "JJHomeBillModel.h"

@interface JJHomePageBillDetailController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray * detailArray;
@property (nonatomic, strong) UIButton * updateButton;
@property (nonatomic, strong) UITextField *myTextFiled;

@end

@implementation JJHomePageBillDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.updateButton];
    _titleArray = @[@"类型",@"分类",@"时间",@"金额"];
    NSString * typeStr = nil;
    if ([self.typeName isEqualToString:@"1"])
    {
        typeStr = @"支出";
    }
    else
    {
        typeStr = @"收入";
    }
    _detailArray = @[typeStr,self.typeName,self.dateTime,self.money];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 10, ScreenWidth, 200);
    self.updateButton.frame = CGRectMake(10, ScreenHeight - 60- 40, ScreenWidth - 20, 30);
}

// 隐藏键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.myTextFiled isExclusiveTouch])
    {
        [self.myTextFiled resignFirstResponder];
    }
}
// called when 'return' key pressed. return NO to ignore. 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)updateButtonAction
{
    [self.dataModel update];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"detailCellID";
    JJHomePageBillDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[JJHomePageBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.detailText.text = _detailArray[indexPath.row];
    if (indexPath.row == 3)
    {
        self.myTextFiled = cell.detailText;
        self.myTextFiled.delegate = self;
        cell.detailText.enabled = YES;
        _money = cell.detailText.text;
        [cell.detailText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return cell;
}

- (void)textChange:(UITextField *)textField
{
    self.dataModel.money = textField.text;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 50;
        tableView.bounces = NO;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIButton *)updateButton
{
    if (!_updateButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"修改" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor cyanColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(updateButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _updateButton = button;
    }
    return _updateButton;
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
