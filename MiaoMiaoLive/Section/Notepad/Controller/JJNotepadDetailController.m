//
//  JJNotepadDetailController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/17.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJNotepadDetailController.h"

@interface JJNotepadDetailController ()

@property (nonatomic, strong) UIImageView *signImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation JJNotepadDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
    self.navigationItem.title = @"事件详情";
    
    VCAddSubview(self.signImage);
    VCAddSubview(self.titleLabel);
    VCAddSubview(self.dateLabel);
    VCAddSubview(self.contentLabel);
}

- (void)setModel:(JJEditContentModel *)model
{
    self.contentHeight = [NSString autoHeightWithString:model.content width:ScreenWidth-20 font:[UIFont systemFontOfSize:12]]+10;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.dateLabel.text = model.dateTime;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _signImage.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(40);
    _signImage.layer.cornerRadius = 20;
    
    _titleLabel.sd_layout
    .topEqualToView(_signImage)
    .leftSpaceToView(_signImage,10)
    .rightSpaceToView(self.view,10)
    .heightIs(20);
    
    _dateLabel.sd_layout
    .topSpaceToView(_titleLabel, 5)
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(15);
    
    _contentLabel.sd_layout
    .topSpaceToView(_signImage,15)
    .leftEqualToView(_signImage)
    .rightEqualToView(_titleLabel)
    .heightIs(self.contentHeight);

}

- (UIImageView *)signImage
{
    if (!_signImage)
    {
        _signImage = [[UIImageView alloc] init];
        _signImage.layer.borderWidth = 1;
        _signImage.layer.borderColor = ViewBgColor.CGColor;
    }
    return _signImage;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:5];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.textColor = [UIColor grayColor];
    }
    return _dateLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [_contentLabel setTextColor:[UIColor blackColor]];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
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
