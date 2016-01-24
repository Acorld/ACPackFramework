//
//  ACPackFramework.m
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//

#import "ACPackFramework.h"
#import "ACPackConfigController.h"
#import "NSTask+Extras.h"
#import "ACPackDataSource.h"
#import "ACPackLoadingController.h"

static NSString * const pluginMenuTitle = @"Product";
NSString *ACPackOrderNotification = @"ACPackOrder";

@interface ACPackFramework()<NSWindowDelegate>

@property (nonatomic, strong, readwrite) NSBundle *bundle;

/// 配置窗口
@property (nonatomic, strong) ACPackConfigController *configurationWindowController;

/// loading
@property (nonatomic, strong) ACPackLoadingController *loadingViewController;

@end

@implementation ACPackFramework

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPackage) name:ACPackOrderNotification object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [self pluginMenu];
    if (menuItem) {
        
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"ACPackFramework" action:@selector(doMenuAction) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (NSMenuItem *)pluginMenu {
    NSMenuItem *pluginMenuItem = [[NSApp mainMenu] itemWithTitle:pluginMenuTitle];
    NSMenu *pluginMenu = [pluginMenuItem submenu];
    if (!pluginMenu) {
        pluginMenu = [[NSMenu alloc] initWithTitle:pluginMenuTitle];
        
        pluginMenuItem = [[NSMenuItem alloc] initWithTitle:pluginMenuTitle action:nil keyEquivalent:@""];
        pluginMenuItem.submenu = pluginMenu;
        
        [[NSApp mainMenu] addItem:pluginMenuItem];
    }
    
    return pluginMenuItem;
}

#pragma mark - 打包
#pragma mark -

// Sample Action, for menu item:
- (void)doMenuAction
{
    [self configAction];
}

- (void)configAction
{
    self.configurationWindowController = [[ACPackConfigController alloc] initWithWindowNibName:NSStringFromClass(ACPackConfigController.class)];
    self.configurationWindowController.window.delegate = self;
    [self.configurationWindowController.window makeKeyWindow];
}

- (void)startPackage;
{
    //loading
    self.loadingViewController = [[ACPackLoadingController alloc] initWithWindowNibName:NSStringFromClass(ACPackLoadingController.class)];
    self.loadingViewController.window.delegate = self;
    [self.loadingViewController.window makeKeyWindow];
    
    //打包配置
    NSDictionary *infos        = [[ACPackDataSource shared] packagePerference];
    NSString *projectPath      = infos[kWDPackage_ProjectPath];
    NSString *projectName      = infos[kWDPackage_ProjectName];
    NSString *outputPath       = projectPath;
    NSString *framworkGoalPath = infos[kWDPackage_FMKGoalPath];
    
    //容错处理
    if (projectPath.length == 0 || projectName.length == 0 || outputPath.length == 0 || framworkGoalPath.length == 0) {
        
        //alert failure
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"未配置完整";
        [alert addButtonWithTitle:@"OK"];
        alert.informativeText = @"请先点击【Config GLUIKit】";
        [alert beginSheetModalForWindow:self.loadingViewController.window completionHandler:^(NSModalResponse returnCode) {
            [self.loadingViewController close];
        }];
        
        return;
    }
    
    //脚本路径
    //优先使用资源文件中的，否则使用.ACDeveloper中的
    NSString *scriptName = @"buid_framework.sh";
    NSString *bundleResources = [self.bundle resourcePath];
    NSString *scriptPath = [bundleResources stringByAppendingPathComponent:scriptName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
        NSString *devFolder = [[ACPackDataSource shared] publicPatch];
        scriptPath = [devFolder stringByAppendingPathComponent:scriptName];
    }
    
    NSLog(@"__READY___");
    NSTask *task = [NSTask runBundleScript:scriptPath
                                 agruments:@[projectPath,projectName,outputPath,framworkGoalPath]];
    NSFileHandle *file;
    file = [task.standardOutput fileHandleForReading];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"%@", string);
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Success";
    [alert addButtonWithTitle:@"OK"];
    alert.informativeText = @"打包成功！";
    [alert beginSheetModalForWindow:self.loadingViewController.window completionHandler:^(NSModalResponse returnCode) {
        [self.loadingViewController close];
    }];
    
    CGFloat delaySeconds = 2;
    __weak ACPackLoadingController *weak_controller = self.loadingViewController;
    //dismiss loading
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weak_controller) {
            [weak_controller close];
        }
    });
}


@end
