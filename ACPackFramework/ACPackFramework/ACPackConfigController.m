//
//  ACPackConfigController.m
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//

#import "ACPackConfigController.h"
#import "ACPackFramework.h"
#import "ACPackDataSource.h"

@interface ACPackConfigController ()

@end

@implementation ACPackConfigController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    //打包配置
    NSDictionary *infos         = [[ACPackDataSource shared] packagePerference];
    NSString *projectPath       = infos[kWDPackage_ProjectPath];
    NSString *projectName       = infos[kWDPackage_ProjectName];
    NSString *frameworkGoalPath = infos[kWDPackage_FMKGoalPath];
    NSString *waitSecondsValue  = infos[kWDPackage_WaitSeconds];
    
    //load saved configuration
    if ([frameworkGoalPath isKindOfClass:[NSString class]] && frameworkGoalPath.length) {
        self.outputDirectoryTextField.stringValue = frameworkGoalPath;
    }
    
    if ([projectPath isKindOfClass:[NSString class]] && projectPath.length) {
        self.projectDirectoryTextField.stringValue = projectPath;
    }
    
    if ([projectName isKindOfClass:[NSString class]] && projectName.length) {
        self.nameTextField.stringValue = projectName;
    }
    
    if ([waitSecondsValue isKindOfClass:[NSString class]] && waitSecondsValue.length) {
        self.waitSecondsTextField.stringValue = waitSecondsValue;
    }
    
}


- (IBAction)selectOutDirAction:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt:@"选择"];
    [panel setTitle:@".framework输出目录"];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setAllowedFileTypes:nil];
    [panel beginWithCompletionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSString*  directory = [[[panel URLs] objectAtIndex:0] path];
             NSLog (@"directory: %@", directory);
             if (directory.length > 0)
             {
                 self.outputDirectoryTextField.stringValue = directory;
             }
         }
     }];
}

- (IBAction)selectProjectDirAction:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt:@"选择"];
    [panel setTitle:@"framework工程目录"];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setAllowedFileTypes:nil];
    [panel beginWithCompletionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSString*  directory = [[[panel URLs] objectAtIndex:0] path];
             NSLog (@"directory: %@", directory);
             if (directory.length > 0)
             {
                 self.projectDirectoryTextField.stringValue = directory;
             }
         }
     }];
}

- (IBAction)saveConfigurationAction:(id)sender {
    NSString *projectPath = self.projectDirectoryTextField.stringValue;
    NSString *frameworkGoalPath = self.outputDirectoryTextField.stringValue;
    NSString *name = self.nameTextField.stringValue;
    NSString *seconds = self.waitSecondsTextField.stringValue;
    
    NSDictionary *infos        = [[ACPackDataSource shared] packagePerference];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:infos];
    
    //projectpath
    if (projectPath && [[NSFileManager defaultManager] fileExistsAtPath:projectPath]) {
        [tempDic setObject:projectPath forKey:kWDPackage_ProjectPath];
    }
    
    //projectname
    if (name.length) {
        [tempDic setObject:name forKey:kWDPackage_ProjectName];
    }
    
    //goal path
    if (frameworkGoalPath && [[NSFileManager defaultManager] fileExistsAtPath:frameworkGoalPath]) {
        [tempDic setObject:frameworkGoalPath forKey:kWDPackage_FMKGoalPath];
    }
    
    //seconds
    if (!seconds.length) {
        seconds = @"10";
    }
    [tempDic setObject:seconds forKey:kWDPackage_WaitSeconds];
    
    //save
    [[ACPackDataSource shared] savePerference:tempDic];
    
    //dismiss window
    [self.window close];
}


- (IBAction)startPackage:(id)sender {
    
    [self.window close];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACPackOrderNotification object:nil];
    
}

@end
