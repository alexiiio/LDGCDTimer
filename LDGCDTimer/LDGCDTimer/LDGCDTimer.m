//
//  LDGCDTimer.m
//  LDGDCTimer
//
//  Created by lidi on 2018/11/21.
//  Copyright © 2018 Li. All rights reserved.
//

#import "LDGCDTimer.h"




@interface LDGCDTimer ()
@property(nonatomic,strong)dispatch_source_t timer;
@end
@implementation LDGCDTimer
+ (instancetype)shareTimer {
    static LDGCDTimer *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LDGCDTimer alloc]init];
    });
    return instance;
}


+ (void)runShareTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay action:(dispatch_block_t)circleAction {
    LDGCDTimer *shareTimer = [LDGCDTimer shareTimer];
    [shareTimer runTimerWithInteval:interval afterDelay:delay action:circleAction];
}

+ (void)cancelShareTimer {
    LDGCDTimer *shareTimer = [LDGCDTimer shareTimer];
    [shareTimer cancelTimer];
}



- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay action:(dispatch_block_t)circleAction {
    if (![self isValidTimerInterval:interval delay:delay action:circleAction]) {
        return;
    }
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, NSEC_PER_SEC * delay), NSEC_PER_SEC * interval, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            circleAction();
        });
    });
    //启动源
    [self resumeTimer];

}
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay circleCount:(NSUInteger)circleCount action:(dispatch_block_t)circleAction {
    if (![self isValidTimerInterval:interval delay:delay action:circleAction] || circleCount == 0) {
        return;
    }
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, NSEC_PER_SEC * delay), NSEC_PER_SEC * interval, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    __block NSInteger count = 0;
    __weak __typeof(&*self)weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            circleAction();
            count++;
            if (count == circleCount) {
                [weakSelf cancelTimer];
            }
        });
    });
    //启动源
    [self resumeTimer];
}
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay untilDate:(NSDate *)untilDate action:(dispatch_block_t)circleAction {
    if (![self isValidTimerInterval:interval delay:delay action:circleAction] || !untilDate) {
        return;
    }
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, NSEC_PER_SEC * delay), NSEC_PER_SEC * interval, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    __weak __typeof(&*self)weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        NSComparisonResult result = [[NSDate date] compare:untilDate];
        if (result == NSOrderedAscending) {
            circleAction();
        }else{
            [weakSelf cancelTimer];
        }
    });
    //启动源
    [self resumeTimer];
}

- (void)suspendTimer {
    if (self.timer && self.timerState == LDGCDTimerStateRunning) {
        dispatch_suspend(self.timer);
        self.timerState = LDGCDTimerStateSuspend;
    }
}
- (void)resumeTimer {
    if (self.timer && (self.timerState == LDGCDTimerStateUnstarted || self.timerState == LDGCDTimerStateSuspend)) {
        dispatch_resume(self.timer);
        self.timerState = LDGCDTimerStateRunning;
    }
}
- (void)cancelTimer {
    if (_timer) {
        [self cancelDispatchTimer:_timer state:self.timerState];
        _timer = nil;
        self.timerState = LDGCDTimerStateInvalid;
    }
}

- (void)setTimer:(dispatch_source_t)timer {
    if (_timer) {
        [self cancelDispatchTimer:_timer state:self.timerState];
    }
    _timer = timer;
    self.timerState = timer ? LDGCDTimerStateUnstarted : LDGCDTimerStateInvalid;
}

- (BOOL)isValidTimerInterval:(CGFloat)interval delay:(CGFloat)delay action:(dispatch_block_t)circleAction {
    return interval > 0 && delay >= 0 && circleAction;
}

- (void)cancelDispatchTimer:(dispatch_source_t)timer state:(LDGCDTimerState)state {
    // GCD timer 在 suspend 状态下直接 cancel 后释放有崩溃风险，取消前先恢复一次保持状态平衡。
    if (state == LDGCDTimerStateSuspend) {
        dispatch_resume(timer);
    }
    dispatch_source_cancel(timer);
}
@end
