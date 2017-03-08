//
//  ImagePart.h
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/2.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImagePart : NSObject

+(id)shareInstance;

- (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

- (UIImage *)compressImage2Quality:(UIImage *)image toByte:(NSInteger)maxLength ;

-(UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
