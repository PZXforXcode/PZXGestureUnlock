# PZXGestureUnlock
简便的手势解锁功能封装
![效果图](https://upload-images.jianshu.io/upload_images/19409325-e5e622efec909514.gif?imageMogr2/auto-orient/strip)

使用方式：

导入**PZXGestureUnlockView**文件夹

```
#import "PZXGesViewController.h"

- (IBAction)drawGestureButtonPressed:(UIButton *)sender {
    
    PZXGesViewController *vc = [[PZXGesViewController alloc]init];
    ///创建密码
    vc.pzxUnlockType = PZXUnlockTypeCreatePwd;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)vaildGestureButtonPressed:(UIButton *)sender {
    
    PZXGesViewController *vc = [[PZXGesViewController alloc]init];
    ///验证密码
    vc.pzxUnlockType = PZXUnlockTypeValidatePwd;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)deleteGestureButtonPressed:(UIButton *)sender {
    ///删除密码
        [PZXGesViewController deleteGesturePwd];
}
```
