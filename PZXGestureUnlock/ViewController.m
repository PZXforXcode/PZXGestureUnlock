//
//  ViewController.m
//  PZXGestureUnlock
//
//  Created by 彭祖鑫 on 2017/8/8.
//  Copyright © 2017年 PZX. All rights reserved.
//

#import "ViewController.h"
#import "PZXGesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)drawGestureButtonPressed:(UIButton *)sender {
    
    PZXGesViewController *vc = [[PZXGesViewController alloc]init];
    vc.pzxUnlockType = PZXUnlockTypeCreatePwd;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)vaildGestureButtonPressed:(UIButton *)sender {
    
    PZXGesViewController *vc = [[PZXGesViewController alloc]init];
    vc.pzxUnlockType = PZXUnlockTypeValidatePwd;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)deleteGestureButtonPressed:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gesturePwd"];
}

@end
