//
//  JJPlayingGameController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/14.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJPlayingGameController.h"
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

#define kHighestScore @"kHighestScore1"
#define buttonWidth  (ScreenWidth/_row)

@interface JJPlayingGameController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UILabel        *scoreLabel;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSTimer        *timer;
@property (nonatomic, strong) AVAudioPlayer  *playerFaile;
@property (nonatomic, strong) AVAudioPlayer  *playerSuccess;
@property (nonatomic, strong) UIImageView    *imageView;
@property (nonatomic, assign) NSInteger black;
@property (nonatomic, assign) NSInteger highestScore;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) CGFloat pinLv;
@property (nonatomic, assign) NSInteger row;

@end

@implementation JJPlayingGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.edgesForExtendedLayout = NO;
    _btnArray = [NSMutableArray array];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.scoreLabel;
    
    NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"kakao" ofType:@"caf"];
    NSURL *sourceUrl = [NSURL URLWithString:sourcePath];
    _playerFaile = [[AVAudioPlayer alloc] initWithContentsOfURL:sourceUrl error:nil];
    [_playerFaile prepareToPlay];
    
    _pinLv = 0.05;
    _score = 0;
    _highestScore  = 0;
    _count = 0;
    
    _row = _level + 3;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:_pinLv target:self selector:@selector(beginGame) userInfo:nil repeats:YES];
    });
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self starsFlying];
//    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(starsFlying) userInfo:nil repeats:YES];
//    NSRunLoop * runLoop = [NSRunLoop currentRunLoop];
//    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}


- (void)beginGame
{
    self.view.userInteractionEnabled = YES;
    [self createBtn];
    [self moveBtn];
    [self.view bringSubviewToFront:self.imageView];
}

- (void)createBtn
{
    
    if (_count % 60 == 0)
    {
        // 每行分4块 黑块随机占一个
        _black = arc4random() % _row;
        for (int i = 0; i < _row; i++)
        {
            UIButton *btn = [UIButton new];
            // btn 在屏幕上面就开始创建
            btn.frame = CGRectMake(i * buttonWidth, - buttonWidth, buttonWidth, buttonWidth);
            //            btn.layer.borderWidth = 1;
            //            btn.layer.borderColor = [[UIColor grayColor] CGColor];
            
            if (i == _black)
            {
                [btn setBackgroundColor:[UIColor blackColor]];
                [btn setBackgroundImage:[UIImage imageNamed:@"02"] forState:UIControlStateNormal];
                
                [btn addTarget:self action:@selector(blackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setBackgroundImage:[UIImage imageNamed:@"01"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(whiteBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
            [_btnArray addObject:btn];
        }
    }
    _count++;
    [self.view bringSubviewToFront:self.scoreLabel];
    
}

- (void)moveBtn

{
    static int speedY = 2;
    static int newY = 0;
    for (int i = 0; i < _btnArray.count; i++)
    {
        UIButton *btn = (UIButton *)[_btnArray objectAtIndex:i];
        newY = btn.frame.origin.y + speedY;
        btn.frame = CGRectMake(btn.frame.origin.x, newY, buttonWidth, buttonWidth);
        
        if (btn.frame.origin.y > self.view.frame.size.height)
        {
            if (btn.backgroundColor == [UIColor blackColor])
            {
                if (_score > _highestScore)
                {
                    _highestScore = _score;
                }
                [_playerFaile play];
                NSString *str = [NSString stringWithFormat:@"游戏结束,当前得分 %ld 分，历史最高分是%ld。", (long)_score,(long)_highestScore];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重新开始", nil];
                [alert show];
                [_timer invalidate];
                _timer = nil;
                self.view.userInteractionEnabled = NO;
            }
            [_btnArray removeObject:btn];
            [btn removeFromSuperview];
        }
    }
}

- (void)removeBtn
{
    for (int i = 0; i < _btnArray.count; i++)
    {
        UIButton *btn = (UIButton *)[_btnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }
}

- (void)speedUp
{
    if (_score)
    {
        [_timer invalidate]; // 取消定时器
        _timer = nil;
        
        _pinLv -= 0.0001;
        if (_pinLv < 0.005)
        {
            _pinLv = 0.005;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:_pinLv target:self selector:@selector(beginGame) userInfo:nil repeats:YES];
    }
}

- (void)blackBtnPress:(UIButton *)btn
{
    [self shakeToShow:btn];
    // 点中分数加1
    _score += 1;
    [self speedUp];
    self.scoreLabel.text = [NSString stringWithFormat:@"当前得分：%ld",(long)_score];
    
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setBackgroundImage:[UIImage imageNamed:@"03"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
}

- (void)whiteBtnPress:(UIButton *)btn
{
    
    [_playerFaile play];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _highestScore = [[defaults objectForKey:kHighestScore] integerValue];
    
    if (_score > _highestScore)
    {
        _highestScore = _score;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(_highestScore) forKey:kHighestScore];
        [defaults synchronize]; // 立即同步
    }
    NSString *str = [NSString stringWithFormat:@"游戏结束,当前得分 %ld 分，历史最高分是%ld。", (long)_score,(long)_highestScore];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重新开始", nil];
    [alert show];
    
    self.view.userInteractionEnabled = NO;
    [_timer invalidate];
    _timer = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (buttonIndex == 1)
    {
        for (UIButton *item in _btnArray)
        {
            [item removeFromSuperview];
        }
        
        [_btnArray removeAllObjects];
        
        _pinLv = 0.05;
        _scoreLabel.text = @"当前得分：0";
        _score = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_pinLv target:self selector:@selector(beginGame) userInfo:nil repeats:YES];
    }
}

- (void)shakeToShow:(UIView*)aView
{    
    // keyFrameAnimation 上面加CATransform3DMakeScale
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)starsFlying
{
    CGPoint viewOrigin = CGPointMake(100, 100);
    UIWindow *containerView = [UIApplication sharedApplication].keyWindow;
    
    SKView *skView = [[SKView alloc] initWithFrame:containerView.frame];
    skView.allowsTransparency = YES;
    skView.userInteractionEnabled = NO;
    [containerView addSubview:skView];
    
    SKScene *skScene = [SKScene sceneWithSize:skView.frame.size];
    skScene.scaleMode = SKSceneScaleModeFill;
    skScene.backgroundColor = [UIColor clearColor];
    
    SKSpriteNode *starSprite = [SKSpriteNode spriteNodeWithImageNamed:@"filled_star"];
    [starSprite setScale:0.6];
    starSprite.position = viewOrigin;
    [skScene addChild:starSprite];
    
    SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"StarParticle" ofType:@"sks"]];
    SKEmitterNode *dotEmitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"AsteriskParticle" ofType:@"sks"]];
    
    [dotEmitter setParticlePosition:CGPointMake(0, -starSprite.size.height)];
    [emitter setParticlePosition:CGPointMake(0, -starSprite.size.height)];
    
    emitter.targetNode = skScene;
    dotEmitter.targetNode = skScene;
    
    [starSprite addChild:emitter];
    [starSprite addChild:dotEmitter];
    
    [skView presentScene:skScene];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, viewOrigin.x, viewOrigin.y);
    
    CGPoint endPoint = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height + 100);
    UIBezierPath *bp = [UIBezierPath new];
    [bp moveToPoint:viewOrigin];
    
    [bp addCurveToPoint:endPoint controlPoint1:CGPointMake(viewOrigin.x + 500, viewOrigin.y + 275) controlPoint2:CGPointMake(-200, skView.frame.size.height - 250)];
    
    __weak typeof(containerView) weakView = containerView;
    SKAction *followline = [SKAction followPath:bp.CGPath asOffset:YES orientToPath:YES duration:3.0];
    
    SKAction *done = [SKAction runBlock:^{
        int64_t delayInSeconds = 2.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakView removeFromSuperview];
        });
    }];
    
    [starSprite runAction:[SKAction sequence:@[followline, done]]];
    
    
}


- (UILabel *)scoreLabel
{
    if (!_scoreLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, 100, 20);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"当前得分：0";
        _scoreLabel = label;
    }
    return _scoreLabel;
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
