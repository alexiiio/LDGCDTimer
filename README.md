# LDGCDTimer
基于GCD的简单timer工具类。真的很简单，并不是为了学习怎么上传代码到Cocopods~ [一脸正经]

# Usage
pod 'LDGCDTimer'

## 代码
使用单例时，不需要强引用timer。 循环事件如果要回到主线程，需自行处理。

```
    [LDGCDTimer runShareTimerWithInteval:1 afterDelay:2 action:^{
        //do something
        dispatch_async(dispatch_get_main_queue(), ^{
            //do some UI operation
        });
    }];
```
或者，限定循环次数：
```
    LDGCDTimer *timer = [LDGCDTimer shareTimer];
    [timer runTimerWithInteval:0.7 afterDelay:0 circleCount:10 action:^{
    // do something

    }];
```
或者，执行到某个个日期
```
    LDGCDTimer *timer = [LDGCDTimer shareTimer];
    [timer runTimerWithInteval:1 afterDelay:0 untilDate:[NSDate dateWithTimeIntervalSinceNow:30] action:^{
        // do something
    }];
```

或者使用非单例对象，可同时创建多个timer。但必须强引用timer，防止被提前释放。
```
    self.timer = [[LDGCDTimer alloc]init];
    [self.timer runTimerWithInteval:1 afterDelay:0 untilDate:[NSDate dateWithTimeIntervalSinceNow:30] action:^{
        // do something
    }];
```
