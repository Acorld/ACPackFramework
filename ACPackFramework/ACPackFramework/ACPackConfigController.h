//
//  ACPackConfigController.h
//  ACPackFramework
//
//  Created by acorld on 16/1/24.
//  Copyright © 2016年 acorld. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ACPackConfigController : NSWindowController

@property (weak) IBOutlet NSTextField *outputDirectoryTextField;
@property (weak) IBOutlet NSTextField *projectDirectoryTextField;
@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *waitSecondsTextField;


- (IBAction)selectOutDirAction:(id)sender;
- (IBAction)selectProjectDirAction:(id)sender;

- (IBAction)saveConfigurationAction:(id)sender;
- (IBAction)startPackage:(id)sender;

@end
