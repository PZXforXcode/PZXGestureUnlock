//
//  GesViewController.m
//  手势解锁学习
//
//  Created by 彭祖鑫 on 2017/8/7.
//  Copyright © 2017年 PZX. All rights reserved.
//


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "PZXGesViewController.h"
#import "PZXGestureUnlockIndicator.h"

@interface PZXGesViewController ()

@property (nonatomic,strong)NSMutableArray *buttonArr;//全部手势按键的数组
@property (nonatomic,strong)NSMutableArray *selectorArr;//选中手势按键的数组
@property (nonatomic,assign)CGPoint startPoint;//记录开始选中的按键坐标
@property (nonatomic,assign)CGPoint endPoint;//记录结束时的手势坐标
@property (nonatomic,strong)UIImageView *imageView;//画图所需
@property (nonatomic,assign)BOOL startDraw;//优化显示

@property (nonatomic,strong)NSMutableString *gesturePwd;//手势密码
@property (nonatomic,strong)NSMutableString *lastGesturePwd;//上一次手势密码

@property (nonatomic,strong)UILabel *tipsLabel;//提示Label
@property (strong, nonatomic)  PZXGestureUnlockIndicator *gesturesUnlockIndicator;

@end

@implementation PZXGesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _startDraw = NO;
    _gesturePwd = [NSMutableString string];
    _lastGesturePwd = [NSMutableString string];

    if (!_buttonArr) {
        _buttonArr = [[NSMutableArray alloc]initWithCapacity:9];
    }
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    //双循环
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            CGFloat xedge = 20;
            CGFloat yedge = 20;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];//12 3
            btn.frame = CGRectMake((ScreenWidth/12+xedge)+(ScreenWidth/3 - xedge)*j, (ScreenHeight/3)+(ScreenWidth/3 - yedge)*i  - 120, ScreenWidth/6, ScreenWidth/6);
            [btn setImage:[UIImage imageNamed:@"gesture_normal@2x"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gesture_selected@2x"] forState:UIControlStateHighlighted];
            [btn setTag:j+(i*3)+1000];
            btn.userInteractionEnabled = NO;
            [self.buttonArr addObject:btn];
            [self.imageView addSubview:btn];
        }
        
    }
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(ScreenWidth/2 - 25, ScreenHeight - 100, 50, 30);
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    back.userInteractionEnabled = YES;
    
    [self.imageView addSubview:back];
    
    
    _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 100, CGRectGetMinY(back.frame) - 40, 200, 30)];
    _tipsLabel.font = [UIFont systemFontOfSize:12.f];
    _tipsLabel.text = @"";
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor orangeColor];
    [self.imageView addSubview:_tipsLabel];

    self.gesturesUnlockIndicator = [[PZXGestureUnlockIndicator alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 40, CGRectGetMinY(_tipsLabel.frame) - 120, 80, 80)];
    self.gesturesUnlockIndicator.hidden = NO;
    [self.imageView addSubview:_gesturesUnlockIndicator];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonPressed:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(UIImage *)drawLine{
    UIImage *image = nil;
    
    UIColor *col = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    UIGraphicsBeginImageContext(self.imageView.frame.size);//设置画图的大小为imageview的大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10);//设置线宽度
    CGContextSetStrokeColorWithColor(context, col.CGColor);//设置线颜色
    
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);//设置画线起点
    
    //从起点画线到选中的按键中心，并切换画线的起点
    for (UIButton *btn in self.selectorArr) {
        CGPoint btnPo = btn.center;
        CGContextAddLineToPoint(context, btnPo.x, btnPo.y);
        CGContextMoveToPoint(context, btnPo.x, btnPo.y);
    }
    //画移动中的最后一条线
    CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();//画图输出
    UIGraphicsEndImageContext();//结束画线
    return image;
}
-(NSMutableArray *)selectorArr
{
    if (!_selectorArr) {
        _selectorArr = [[NSMutableArray alloc]init];
    }
    return _selectorArr;
}

//开始手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        
        _gesturePwd = [NSMutableString string];
//        [self.gesturesUnlockIndicator setGesturesPassword:_gesturePwd];

        for (UIButton *btn in self.buttonArr) {
            
            CGPoint po = [touch locationInView:btn];//记录按键坐标
            
            if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的开始按键
                
                [self.selectorArr addObject:btn];
                btn.highlighted = YES;
                [_gesturePwd appendFormat:@"%ld",btn.tag-1000];

                //                self.startPoint = btn.center;//保存起始坐标
                
            }
            
        }
        
    }
    
}

//移动中触发，画线过程中会一直调用画线方法
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    UITouch *touch = [touches anyObject];
    if (touch) {
        
        self.endPoint = [touch locationInView:self.imageView];
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];
            if ([btn pointInside:po withEvent:nil]) {
                if (_startDraw == NO) {
                    
                    self.startPoint = btn.center;//优化 保存起始坐标 这样不会出多的线
                }
                _startDraw = YES;

                BOOL isAdd = YES;//记录是否为重复按键
                for (UIButton *seBtn in self.selectorArr) {
                    if (seBtn == btn) {
                        isAdd = NO;//已经是选中过的按键，不再重复添加
                        break;
                    }
                }
                if (isAdd) {//未添加的选中按键，添加并修改状态
                    [self.selectorArr addObject:btn];
                    btn.highlighted = YES;
//                    [_gesturePwd stringByAppendingString:[NSString stringWithFormat:@"%ld",btn.tag-1000]];
                    [_gesturePwd appendFormat:@"%ld",btn.tag-1000];

                }
                
      

            }
        }
    }
    
    if (_startDraw) {
        
        self.imageView.image = [self drawLine];//每次移动过程中都要调用这个方法，把画出的图输出显示
        
    }
    
}
//手势结束触发
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    if (self.pzxUnlockType == PZXUnlockTypeCreatePwd) {
        
        
        if (_gesturePwd.length < 4 && _gesturePwd.length != 0) {
            
            _tipsLabel.text = @"手势密码不能小于4位,请重新输入!";
            [self shakeAnimationForView:_tipsLabel];
        }else if ( _gesturePwd.length == 0){
            
            _tipsLabel.text = @"";
            
        }else{
            
            if (_lastGesturePwd.length <= 0) {
                
                _tipsLabel.text = [NSString stringWithFormat:@"请再次绘制手势"];
                [self.gesturesUnlockIndicator setGesturesPassword:_gesturePwd];
                _lastGesturePwd = _gesturePwd;

            }else{
                if ([NSString stringWithFormat:@"%@",_lastGesturePwd] == [NSString stringWithFormat:@"%@",_gesturePwd]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:_gesturePwd forKey:@"gesturePwd"];
                    
                    //-----提示框---------------------------------------------------------
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"绘制成功!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alert animated:YES completion:nil];

                    [self dismissViewControllerAnimated:YES completion:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    //------------------------------------------------------------------------

                }else{
                    _tipsLabel.text = [NSString stringWithFormat:@"两次手势不一致!"];
                    [self shakeAnimationForView:_tipsLabel];
                }
            }
        }
        
    }else if (self.pzxUnlockType == PZXUnlockTypeValidatePwd){
    
    
        if ([_gesturePwd isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"gesturePwd"]]) {
            
            _tipsLabel.text = [NSString stringWithFormat:@""];
            //-----提示框---------------------------------------------------------
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"解锁成功!" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            //------------------------------------------------------------------------
            
            
        }else{
        
        
            _tipsLabel.text = [NSString stringWithFormat:@"手势错误!"];
            [self shakeAnimationForView:_tipsLabel];
        }
    
    
    }
    NSLog(@"pwd = %@",_gesturePwd);


    self.imageView.image = nil;
    self.selectorArr = nil;
    _startDraw = NO;
    for (UIButton *btn in self.buttonArr) {
        btn.highlighted = NO;
    }
}

-(BOOL)isCreatePassWord{
    
    if (_gesturePwd.length > 0) {
        return YES;
    }else{
        return  NO;
    }
    
}

+(void)deleteGesturePwd{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturePwd"];
}

//抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

@end
