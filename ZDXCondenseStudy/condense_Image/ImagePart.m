//
//  ImagePart.m
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/2.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import "ImagePart.h"

@implementation ImagePart

static id ff;
+(id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ff = [[ImagePart alloc]init];
    });
    return ff;
}

- (void)sysMethod{
    UIImage *image = [UIImage imageNamed:@"1.png"];
    
    NSData *data1 = UIImageJPEGRepresentation(image, 1.0);
    
    NSData *data2 = UIImagePNGRepresentation(image);
    
    NSLog(@"data1=%d -- data2=%d",data1.length,data2.length);
}

//方法：压缩图片质量
//1.通过循环来逐渐减小图片质量，直到图片稍小于指定大小(maxLength)
- (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    
    CGFloat compression = 1.0;
    NSData *tempData = UIImageJPEGRepresentation(image, compression);
    
    while (tempData.length > maxLength && compression > 0) {
        //
        compression -= 0.02;
        tempData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *resultImage = [UIImage imageWithData:tempData];
    
    return resultImage;
}
//2.二分法来优化
/*
 *
 需要注意的是，当图片质量低于一定程度时，继续压缩没有效果。
 也就是说，compression 继续减小，data 也不再继续减小。
 压缩图片质量的优点:尽可能保留图片清晰度，图片不会明显模糊；
             缺点:不能保证图片压缩后小于指定大小(6次之后图片大小有可能比maxLength大)。
 *
 */
- (UIImage *)compressImage2Quality:(UIImage *)image toByte:(NSInteger)maxLength {
    
    CGFloat compression = 1.0;
    NSData *tempData = UIImageJPEGRepresentation(image, compression);
    if (tempData.length < maxLength) {
        return image;
    }
    
    //当图片大小小于 maxLength，大于 maxLength * 0.9 时，不再继续压缩。最多压缩 6 次，1/(2^6) = 0.015625 < 0.02，也能达到每次循环 compression 减小 0.02 的效果。这样的压缩次数比循环减小 compression 少，耗时短。
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; i++) {
        //
        compression = (max + min)/2;
        tempData = UIImageJPEGRepresentation(image, compression);
        if (tempData.length > maxLength) {
            max = compression;
        }else if (tempData.length < maxLength * 0.9){
            min = compression;
        } else {
            break;
        }
        
    }
    
    UIImage *resultImage = [UIImage imageWithData:tempData];
    return resultImage;
    
}


//方法：压缩图片尺寸
//压缩图片尺寸可以使图片小于指定大小，但会使图片明显模糊(比压缩图片质量模糊)
-(UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    
    while (data.length > maxLength && data.length != lastDataLength) {
        //
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat) maxLength / data.length;
        
        //每次绘制的尺寸 size，要把宽 width 和 高 height 转换为整数，防止绘制出的图片有白边
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                  (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    
    return resultImage;
}


//两种图片压缩方法结合
//如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    CGFloat conpression = 1;
    NSData *data = UIImageJPEGRepresentation(image, conpression);
    if (data.length < maxLength) {
        return image;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; i++) {
        conpression = (max + min)/2;
        data = UIImageJPEGRepresentation(image, conpression);
        
        if (data.length <maxLength*0.9) {
            min = conpression;
        } else if (data.length > maxLength){
            max = conpression;
        }else {
            break;
        }
        
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
        return resultImage;
    }
    
    
    //Compress by size
    NSUInteger lastDataLenth = 0;
    while (data.length > maxLength && data.length != lastDataLenth) {
        lastDataLenth = data.length;
        CGFloat radio = (CGFloat) maxLength / data.length;
        
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(radio)), (NSUInteger)(resultImage.size.height * sqrtf(radio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    
    
    return resultImage;
    
}













@end
