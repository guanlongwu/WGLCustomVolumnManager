//
//  WGLCustomVolumnManager.m
//  WGLCustomVolumnManager
//
//  Created by wugl on 2019/2/27.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "WGLCustomVolumnManager.h"
#import <MediaPlayer/MediaPlayer.h>

NSString *const WGLSystemVolumeDidChangeNotification = @"WGLSystemVolumeDidChangeNotification";

@implementation WGLCustomVolumnManager

+ (instancetype)sharedManager {
    static WGLCustomVolumnManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addNotifications];
    }
    return self;
}

#pragma mark - 音量控制

/*
 *获取系统音量大小
 */
+ (CGFloat)getSystemVolumValue {
    return [[self getSystemVolumSlider] value];
}

/*
 *设置系统音量大小
 */
+ (void)setSystemVolumWithValue:(double)value {
    UISlider *sysVolumeSlider = [self getSystemVolumSlider];
    [sysVolumeSlider setValue:value animated:YES];
    
    if (value - sysVolumeSlider.value >= 0.1) {
        [sysVolumeSlider setValue:0.1 animated:NO];
        [sysVolumeSlider setValue:value animated:YES];
    }
}

/*
 *获取系统音量滑块
 */
+ (UISlider *)getSystemVolumSlider {
    static UISlider *volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        
        for (UIView *newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    return volumeViewSlider;
}

#pragma mark - 音量变化通知

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)volumeChange:(NSNotification *)notifi {
    NSString *style = [notifi.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    CGFloat value = [[notifi.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
    if ([style isEqualToString:@"Ringtone"]) {
        NSLog(@"铃声改变");
    }else if ([style isEqualToString:@"Audio/Video"]){
        NSLog(@"音量改变 当前值:%f",value);
        [[NSNotificationCenter defaultCenter] postNotificationName:WGLSystemVolumeDidChangeNotification object:@(value)];
    }
}

/** 改变铃声 的 通知
 
 "AVSystemController_AudioCategoryNotificationParameter" = Ringtone;    // 铃声改变
 "AVSystemController_AudioVolumeChangeReasonNotificationParameter" = ExplicitVolumeChange; // 改变原因
 "AVSystemController_AudioVolumeNotificationParameter" = "0.0625";  // 当前值
 "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" = 0; 最小值
 
 
 改变音量的通知
 "AVSystemController_AudioCategoryNotificationParameter" = "Audio/Video"; // 音量改变
 "AVSystemController_AudioVolumeChangeReasonNotificationParameter" = ExplicitVolumeChange; // 改变原因
 "AVSystemController_AudioVolumeNotificationParameter" = "0.3";  // 当前值
 "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" = 0; 最小值
 */

@end
