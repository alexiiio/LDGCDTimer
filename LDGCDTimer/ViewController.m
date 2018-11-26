//
//  ViewController.m
//  LDGDCTimer
//
//  Created by lidi on 2018/11/21.
//  Copyright © 2018 Li. All rights reserved.
//

#import "ViewController.h"
#import "LDGCDTimer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    __block int count = 0;
    [LDGCDTimer runShareTimerWithInteval:1 afterDelay:2 action:^{
        count++;
        int red = arc4random()%255;
        int green = arc4random()%255;
        int blue = arc4random()%255;
        NSLog(@"%d",count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.view.backgroundColor = [UIColor colorWithRed:red*1.0/255 green:green*1.0/255 blue:blue*1.0/255 alpha:1];
            }];
        });
    }];
    
//    LDGCDTimer *timer = [LDGCDTimer shareTimer];
//    [timer runTimerWithInteval:0.7 afterDelay:0 circleCount:10 action:^{
//        count++;
//        int red = arc4random()%255;
//        int green = arc4random()%255;
//        int blue = arc4random()%255;
//        NSLog(@"%d",count);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.view.backgroundColor = [UIColor colorWithRed:red*1.0/255 green:green*1.0/255 blue:blue*1.0/255 alpha:1];
//            }];
//        });
//    }];
    
//    LDGCDTimer *timer = [LDGCDTimer shareTimer];
//    [timer runTimerWithInteval:0.5 afterDelay:0 untilDate:[NSDate dateWithTimeIntervalSinceNow:30] action:^{
//        count++;
//        int red = arc4random()%255;
//        int green = arc4random()%255;
//        int blue = arc4random()%255;
//        NSLog(@"%d",count);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.1 animations:^{
//                NSLog(@"-- %d",count);
//                self.view.backgroundColor = [UIColor colorWithRed:red*1.0/255 green:green*1.0/255 blue:blue*1.0/255 alpha:1];
//            }];
//        });
//    }];
    
    UIButton *suspendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    suspendButton.backgroundColor = [UIColor yellowColor];
    suspendButton.frame = CGRectMake(100, 100, 100, 40);
    [self.view addSubview:suspendButton];
    [suspendButton addTarget:self action:@selector(suspendOrResume) forControlEvents:UIControlEventTouchUpInside];
}
- (void)suspendOrResume {
    LDGCDTimer *timer = [LDGCDTimer shareTimer];
    if (timer.timerState == LDGCDTimerStateRunning) {
        [timer suspendTimer];
    } else {
        [timer resumeTimer];
    }
}


@end
