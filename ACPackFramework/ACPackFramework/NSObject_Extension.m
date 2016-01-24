//
//  NSObject_Extension.m
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//


#import "NSObject_Extension.h"
#import "ACPackFramework.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[ACPackFramework alloc] initWithBundle:plugin];
        });
    }
}
@end
