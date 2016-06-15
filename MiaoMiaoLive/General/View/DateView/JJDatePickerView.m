//
//  JJDateView.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/12.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJDatePickerView.h"

@interface JJDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSString *currentYearString;
@property (nonatomic, strong) NSString *currentMonthString;
@property (nonatomic, strong) NSString *currentDateString;

@property (nonatomic, assign) NSInteger selectedYearRow;
@property (nonatomic, assign) NSInteger selectedMonthRow;
@property (nonatomic, assign) NSInteger selectedDayRow;

@property (nonatomic, assign) BOOL firstTimeLoad;

@property (nonatomic, strong) JJDatePickerViewDidSelectedBlock didSelectedBlock;

@end

@implementation JJDatePickerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.layer setCornerRadius:6];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowRadius = 6;
        
        CGSize size = frame.size;
        CGFloat topViewHeight = 44;
        
        _topView = [UIView new];
        _topView.frame = CGRectMake(0, 0, size.width, topViewHeight);
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topViewHeight, size.width, size.height - topViewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        
        [self addSubview:_topView];
        [self addSubview:_pickerView];
        
        
        [self initData];
        
        [self.topView addSubview:self.cancelButton];
        [self.topView addSubview:self.titleLabel];
        [self.topView addSubview:self.doneButton];
        _cancelButton.frame = CGRectMake(0, 0, topViewHeight, topViewHeight);
        _titleLabel.frame = CGRectMake(topViewHeight, 0, size.width - topViewHeight*2, topViewHeight);
        _doneButton.frame = CGRectMake(size.width - topViewHeight, 0, topViewHeight, topViewHeight);
    }
    return self;
}

- (void)initData
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *today = [formatter stringFromDate:date];
    _currentYearString = [today substringWithRange:NSMakeRange(0, 4)];
    _currentMonthString = [today substringWithRange:NSMakeRange(4, 2)];
    _currentDateString = [today substringWithRange:NSMakeRange(6, 2)];
    
    // 初始化年
    self.yearArray = [NSMutableArray array];
    for (int i = 1900; i <= 2050 ; i++)
    {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // 初始化月
    self.monthArray = [NSMutableArray arrayWithArray:@[ @"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12" ]];
    
    // 初始化日
    self.dayArray = [NSMutableArray array];
    for (int i = 1; i <= 31; i++)
    {
        [self.dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    [self.pickerView selectRow:[self.yearArray indexOfObject:_currentYearString] inComponent:0 animated:YES];
    
    [self.pickerView selectRow:[self.monthArray indexOfObject:_currentMonthString] inComponent:1 animated:YES];
    
    [self.pickerView selectRow:[self.dayArray indexOfObject:_currentDateString] inComponent:2 animated:YES];
    
}

#pragma mark - public

+ (void)showFromView:(UIView *)superView
               title:(NSString *)title
    didSelectedBlock:(JJDatePickerViewDidSelectedBlock)didSelectedBlock
{
    JJDatePickerView *dateView = [[JJDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    
    dateView.didSelectedBlock = didSelectedBlock;
    dateView.center = superView.center;
    dateView.titleLabel.text = title;
    
    dateView.alpha = 0;
    [superView addSubview:dateView];
    [UIView animateWithDuration:0.3 animations:^{
        dateView.alpha = 1;
    }];
}

#pragma mark - action

- (void)doneButtonAction:(UIButton *)sender
{
    if (_didSelectedBlock)
    {
        if (!_firstTimeLoad)
        {
            _selectedYearRow = [_pickerView selectedRowInComponent:0];
            _selectedMonthRow = [_pickerView selectedRowInComponent:1];
            _selectedDayRow = [_pickerView selectedRowInComponent:2];
        }
        
        _didSelectedBlock(_yearArray[_selectedYearRow], _monthArray[_selectedMonthRow], _dayArray[_selectedDayRow]);
    }
    [self removeSelf];
    
}

- (void)removeSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark - UIPickerView dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.yearArray count];
    }
    else if (component == 1)
    {
        return [self.monthArray count];
    }
    else if (component == 2)
    {
        if (self.firstTimeLoad) {
            NSInteger currentMonth = _currentMonthString.integerValue;
            if (currentMonth == 1 ||
                currentMonth == 3 ||
                currentMonth == 5 ||
                currentMonth == 7 ||
                currentMonth == 8 ||
                currentMonth == 10 ||
                currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow] intValue];
                if(((yearint%4 == 0) && (yearint%100 != 0)) || (yearint%400 == 0))
                {
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }else
        {
            if (_selectedMonthRow == 0 ||
                _selectedMonthRow == 2 ||
                _selectedMonthRow == 4 ||
                _selectedMonthRow == 6 ||
                _selectedMonthRow == 7 ||
                _selectedMonthRow == 9 ||
                _selectedMonthRow == 11)
            {
                return 31;
            }
            else if (self.selectedMonthRow == 1)
            {
                int yearint = [[self.yearArray objectAtIndex:_selectedYearRow] intValue];
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0))
                {
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
            
        }
        
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (nil == pickerLabel)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [pickerLabel setTextColor:[UIColor blackColor]];
    }
    if (component == 0)
    {
        pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [self.monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [self.dayArray objectAtIndex:row]; // Date
        
    }
    
    return pickerLabel;
}

#pragma mark - UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        _selectedYearRow =  row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        _selectedMonthRow = row;
        [self.pickerView reloadAllComponents];
    }
    else if (component == 2)
    {
        _selectedDayRow = row;
        [self.pickerView reloadAllComponents];
    }
    self.firstTimeLoad = NO;
}

#pragma mark - Lazy load

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton new];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请选择日期";
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
