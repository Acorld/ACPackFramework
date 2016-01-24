//
//  ACPackDataSource.m
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//

#import "ACPackDataSource.h"

#define kWDPackageFile  @"AC_Pack_Framework"

NSString *const kWDPackage_ProjectPath = @"WDPackageProjectPath";
NSString *const kWDPackage_ProjectName = @"WDPackageProjectName";
NSString *const kWDPackage_FMKGoalPath = @"WDPackageFMKGoalPath";
NSString *const kWDPackage_WaitSeconds = @"WDPackageWaitSeconds";

@implementation ACPackDataSource

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static ACPackDataSource *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ACPackDataSource alloc] init];
    });
    
    return instance;
}

- (NSString *)publicPatch {
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *devFolder = [docsPath stringByAppendingPathComponent:@".ACDeveloper"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:devFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:devFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return devFolder;
}

- (NSString *)packagePath {
    NSString *path = [[self publicPatch] stringByAppendingPathComponent:kWDPackageFile];
    return path;
}

#pragma mark - Businiess
#pragma mark -

- (BOOL)savePerference:(NSDictionary *)infos;
{
    BOOL success = [infos writeToFile:[self packagePath] atomically:YES];
    
    return success;
}

/**
 *  @brief  获取打包配置信息
 *
 *  @return
 */
- (NSDictionary *)packagePerference;
{
    NSDictionary *infos = [[NSDictionary alloc] initWithContentsOfFile:[self packagePath]];
    return infos;
}

@end
