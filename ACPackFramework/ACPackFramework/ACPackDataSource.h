//
//  ACPackDataSource.h
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kWDPackage_ProjectPath;
extern NSString *const kWDPackage_ProjectName;
extern NSString *const kWDPackage_FMKGoalPath;
extern NSString *const kWDPackage_WaitSeconds;

@interface ACPackDataSource : NSObject

+ (instancetype)shared;

/**
 *  @brief  保存打包配置
 *
 *  @param infos 配置信息
 *
 *  @return 是否成功
 */
- (BOOL)savePerference:(NSDictionary *)infos;

/**
 *  @brief  获取打包配置信息
 *
 *  @return
 */
- (NSDictionary *)packagePerference;

/**
 *  @brief  WD公共文件夹
 *
 *  @return
 */
- (NSString *)publicPatch;

@end
