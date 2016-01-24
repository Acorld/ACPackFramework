//
//  NSTask+Extras.m
//  ACCodeSnippetRepository
//
//  Created by Arnaud Coomans on 09/02/14.
//  Copyright (c) 2014 Arnaud Coomans. All rights reserved.
//

#import "NSTask+Extras.h"

@implementation NSTask (Extras)

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray *)arguments inCurrentDirectoryPath:(NSString*)directoryPath {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = arguments;
    task.currentDirectoryPath = directoryPath;
    [task launch];
    return task;
}


+ (NSTask *)launchAndWaitTaskWithLaunchPath:(NSString *)path arguments:(NSArray *)arguments inCurrentDirectoryPath:(NSString*)directoryPath standardOutputAndError:(NSString* __autoreleasing *)output {

    NSPipe *pipe = [NSPipe pipe];
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = arguments;
    if (directoryPath) task.currentDirectoryPath = directoryPath;
    //task.standardOutput = task.standardError = pipe; //TODO: fix
    task.standardOutput = pipe;
    [task launch];
    [task waitUntilExit];
    
    NSData *data = [[pipe fileHandleForReading] availableData];
    *output = [NSString stringWithFormat:@"$ %@ %@\n %@\n",
               task.launchPath,
               [task.arguments componentsJoinedByString:@" "],
               [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    return task;
}

+ (NSTask *)runBundleScript:(NSString *)script agruments:(NSArray *)arguments
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:arguments];
    if (script) {
        [array insertObject:script atIndex:0];
    }
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:array];
    [task setStandardInput:[NSPipe pipe]];
    
    NSLog(@"array______________:%@",array);

    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task launch];
    return task;
}

@end
