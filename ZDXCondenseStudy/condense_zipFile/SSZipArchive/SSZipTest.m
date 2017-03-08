//
//  SSZipTest.m
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/7.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import "SSZipTest.h"

@implementation SSZipTest

static id ziptest;
+ (id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ziptest = [[SSZipTest alloc]init];
    });
    
    return ziptest;
}

//解压zip文件到指定文件地址
- (void)unZipFileswithzipFilepath:(NSString *)filePath toDestination:(NSString *)unzippath{
    NSError *error;
    BOOL result = [SSZipArchive unzipFileAtPath:filePath toDestination:unzippath];
    
    if (result) {
        NSLog(@"unzip success!");
        NSLog(@"unzippath=%@",unzippath);
    } else {
        NSLog(@"unzip error:%@",error);
    }
    
    
}

//对源文件进行压缩，并存放在指定文件地址的新建的zip文件中
- (void)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath{
    
    BOOL result = [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:directoryPath];
    
    if (result) {
        NSLog(@"zip success!");
        NSLog(@"zippath=%@",path);
    } else {
        NSLog(@"zip error!");
    }
}



@end
