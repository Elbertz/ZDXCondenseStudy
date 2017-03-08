//
//  VideoCompression.m
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/3.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import "VideoCompression.h"
#import <AVFoundation/AVFoundation.h>

#define KcompressionVideoPath [NSHomeDirectory() stringByAppendingFormat:@"/Documents"]

@implementation VideoCompression

static id ff;
+(id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ff = [[VideoCompression alloc]init];
    });
    return ff;
}


- (void)compressVideoWithURL:(NSURL *)url compressionType:(NSString *)compressionType compressionResultPath:(NSString *)tempPath{
    
    NSString *resultPath = [NSString string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"before video.data=%lu",data.length);
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 所支持的压缩格式中是否有 所选的压缩格式
    if ([compatiblePresets containsObject:compressionType]) {
        //
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:compressionType];
        
        // 用时间, 给文件重新命名, 防止视频存储覆盖
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isExists = [manager fileExistsAtPath:KcompressionVideoPath];
        if (!isExists) {
            
            [manager createDirectoryAtPath:KcompressionVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        resultPath = [KcompressionVideoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"outputVideo-%@.mov", [formatter stringFromDate:[NSDate date]]]];
        NSLog(@"resultPath=%@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            //
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    
                    NSData *resultData = [NSData dataWithContentsOfFile:resultPath];
                    NSLog(@"after video.data=%lu",resultData.length);
                    break;
                }
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                    break;
                default:
                    break;
            }
        }];
        
        
        
        
    } else {
        NSLog(@"不支持 %@ 格式的压缩", compressionType);
    }
    
}



//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

//此方法可以获取视频文件的时长
- (CGFloat) getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}



@end
