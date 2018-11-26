//
//  LDGCDTimer.h
//  LDGDCTimer
//
//  Created by lidi on 2018/11/21.
//  Copyright © 2018 Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, LDGCDTimerState) {
    LDGCDTimerStateUnstarted = 0,
    LDGCDTimerStateRunning,
    LDGCDTimerStateSuspend,
    LDGCDTimerStateInvalid
};

@interface LDGCDTimer : NSObject

/**
 定时器状态
 */
@property(nonatomic,assign)LDGCDTimerState timerState;

/**
 单例timer，无需强引用对象。
 使用非单例对象时需要对timer对象强引用。

 @return 返回timer单例
 */
+(instancetype)shareTimer;

/**
 创建并启动一个GCD timer对象。
 该对象是单例。
 每次重新赋值会先取消上次的timer。
 如果要回到主线程，需自行处理
 
 @param interval 循环时间间隔
 @param delay 首次执行的延迟
 @param circleAction 每次循环的执行事件，如果要回到主线程，需自行处理
 */
+ (void)runShareTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay action:(dispatch_block_t)circleAction;

/**
 取消并销毁单例timer
 */
+ (void)cancelShareTimer;

/**
 启动一个GCD timer。
 
 @param interval 循环时间间隔 单位秒（s）
 @param delay 首次执行的延迟 单位秒（s）
 @param circleAction 每次循环的执行事件，如果要回到主线程，需自行处理
 */
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay action:(dispatch_block_t)circleAction;
/**
 启动一个有循环次数的 GCD timer。
 
 @param interval 循环时间间隔 单位秒（s）
 @param delay 首次执行的延迟 单位秒（s）
 @param circleCount 执行次数
 @param circleAction 每次循环的执行事件，如果要回到主线程，需自行处理
 */
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay circleCount:(NSUInteger)circleCount action:(dispatch_block_t)circleAction;

/**
 启动一个有截止日期的 GCD timer。

 @param interval 循环时间间隔 单位秒（s）
 @param delay 首次执行的延迟 单位秒（s）
 @param untilDate 在截止日期前执行
 @param circleAction 每次循环的执行事件，如果要回到主线程，需自行处理
 
 */
- (void)runTimerWithInteval:(CGFloat)interval afterDelay:(CGFloat)delay untilDate:(NSDate *)untilDate action:(dispatch_block_t)circleAction;

/**
 暂停timer
 */
- (void)suspendTimer;

/**
  恢复或启动timer
 */
- (void)resumeTimer;

/**
 取消并销毁timer
 */
- (void)cancelTimer;
@end

NS_ASSUME_NONNULL_END
