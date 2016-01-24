//
//  ACPackFramework.h
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//

#import <AppKit/AppKit.h>

@class ACPackFramework;

static ACPackFramework *sharedPlugin;

extern NSString *ACPackOrderNotification;

@interface ACPackFramework : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

/**
 *  @brief  打包
 */
- (void)startPackage;

@end