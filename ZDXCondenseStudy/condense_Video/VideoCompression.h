//
//  VideoCompression.h
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/3.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCompression : NSObject

+(id)shareInstance;

- (void)compressVideoWithURL:(NSURL *)url compressionType:(NSString *)compressionType compressionResultPath:(NSString *)tempPath;

@end
