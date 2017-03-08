//
//  ZipFilePart.m
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/3.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import "ZipFilePart.h"


@implementation ZipFilePart


- (void)downloadZipFileWithPath:(NSString *)path{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //
        NSURL *url = [NSURL URLWithString:@"http://www.icodeblog.com/wp-content/uploads/2012/08/zipfile.zip"];
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if (!error) {
            //
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
            
            [data writeToFile:zipPath options:0 error:&error];
            if (!error) {
                //TODO: Unzip
                [self unZipWithzipPath:zipPath toPath:path];
            } else {
                //
                NSLog(@"Error saving file %@",error);
            }
            
            
        } else {
            //
            NSLog(@"Error downloading zip file: %@", error);
        }
        
        
    });
}

//解压缩已下载的zip文件
- (void)unZipWithzipPath:(NSString *)zipPath toPath:(NSString *)path{
/*
 
    ZipArchive *za = [[ZipArchive alloc] init];
    // 1
    if ([za UnzipOpenFile: zipPath]) {
        // 2
        BOOL ret = [za UnzipFileTo: path overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
        
        // 3
        NSString *imageFilePath = [path stringByAppendingPathComponent:@"photo.png"];
        NSString *textFilePath = [path stringByAppendingPathComponent:@"text.txt"];
        NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
        UIImage *img = [UIImage imageWithData:imageData];
        NSString *textString = [NSString stringWithContentsOfFile:textFilePath
                                                         encoding:NSASCIIStringEncoding error:nil];
        
        // 4
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = img;
            self.label.text = textString;
        });
        
*/
        
}


//把文件压缩为一个zip文件
-(void)zipFile{
    /*
    
    // 1
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    
    // 2
    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    // 3
    NSString *zipFile = [docspath stringByAppendingPathComponent:@"newzipfile.zip"];
    
    // 4
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    // 5
    NSString *imagePath = [cachePath stringByAppendingPathComponent:@"photo.png"];
    NSString *textPath = [cachePath stringByAppendingPathComponent:@"text.txt"];
    
    // 6
    [za addFileToZip:imagePath newname:@"NewPhotoName.png"];
    [za addFileToZip:textPath newname:@"NewTextName.txt"];
    
    // 7
    BOOL success = [za CloseZipFile2];
    NSLog(@"Zipped file with result %d",success);
    
    
    */
}


@end
