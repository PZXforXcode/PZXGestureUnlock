//
//  GesViewController.h
//  手势解锁学习
//
//  Created by 彭祖鑫 on 2017/8/7.
//  Copyright © 2017年 PZX. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger,PZXUnlockType) {
    PZXUnlockTypeCreatePwd,//创建手势密码
    PZXUnlockTypeValidatePwd//校验手势密码
};

@interface PZXGesViewController : UIViewController

@property(nonatomic,assign)PZXUnlockType pzxUnlockType;


/// 是否创建了密码 true 为已创建  false 为未创建
+(BOOL)isCreatePassWord;
/// 删除手势
+(void)deleteGesturePwd;

@end
