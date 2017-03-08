//
//  SSZipTest.h
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/7.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"

@interface SSZipTest : NSObject<SSZipArchiveDelegate>

+ (id)shareInstance;

- (void)unZipFileswithzipFilepath:(NSString *)filePath toDestination:(NSString *)unzippath;


- (void)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath;
@end
