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
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, NSEC_PER_SEC * delay), NSEC_PER_SEC * interval, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(self.timer, ^{
        circleAction();
    });
    //启动源
    [self resumeTimer];

}
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay circleCount:(NSUInteger)circleCount action:(dispatch_block_t)circleAction {
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
        circleAction();
        count++;
        if (count == circleCount) {
            [weakSelf cancelTimer];
        }
    });
    //启动源
    [self resumeTimer];
}
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay untilDate:(NSDate *)untilDate action:(dispatch_block_t)circleAction {
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
    if (self.timerState == LDGCDTimerStateRunning) {
        dispatch_suspend(self.timer);
        self.timerState = LDGCDTimerStateSuspend;
    }
}
- (void)resumeTimer {
    if (self.timerState == LDGCDTimerStateUnstarted || self.timerState == LDGCDTimerStateSuspend ) {
        dispatch_resume(self.timer);
        self.timerState = LDGCDTimerStateRunning;
    }
}
- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        self.timerState = LDGCDTimerStateInvalid;
    }
}

- (void)setTimer:(dispatch_source_t)timer {
    if (_timer && timer) {
        dispatch_source_cancel(timer);
    }
    _timer = timer;
    self.timerState = LDGCDTimerStateUnstarted;
}
@end
