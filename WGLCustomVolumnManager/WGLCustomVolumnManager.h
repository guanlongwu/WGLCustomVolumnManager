//
//  WGLCustomVolumnManager.h
//  WGLCustomVolumnManager
//
//  Created by wugl on 2019/2/27.
//  Copyright © 2019年 WGLKit. All rights reserved.
//
/**
 这是一个自定义系统音量的管理器。
 做法：
 先隐藏系统音量控件，再自定义音量控件。
 该组件内部封装了系统音量控件MPVolumeView，但是大小设置很小，几乎不可见。
 但是，音量获取和设置都是调用了系统音量控件MPVolumeView。
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const WGLSystemVolumeDidChangeNotification;

@interface WGLCustomVolumnManager : NSObject

//管理器
+ (instancetype)sharedManager;

//注册音量变化通知
- (void)registerVolumnChangeNotify;

//取消注册音量变化通知
- (void)unregisterVolumnChangeNotify;

/*
 *获取系统音量大小
 */
+ (CGFloat)getSystemVolumValue;

/*
 *设置系统音量大小
 */
+ (void)setSystemVolumWithValue:(double)value;

@end
