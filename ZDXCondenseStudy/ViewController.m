//
//  ViewController.m
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/2.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import "ViewController.h"
#import "ImagePart.h"
#import "VideoCompression.h"
#import "SSZipTest.h"
#import "XMLDictionary.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testImageCondense];
//    
//    [self testVideoCondense];
//    
//    [self testZipFileCondense];
    
    [self getXMLMessage];
    
}

- (void)testImageCondense{
    
    UIImage *image = [UIImage imageNamed:@"2.png"];
    UIImage *resultImage1 = [[ImagePart shareInstance] compressImageQuality:image toByte:500*1024];
    NSData *tempData1 = UIImageJPEGRepresentation(resultImage1, 1);
    NSLog(@"resultImage1=%lu",(unsigned long)tempData1.length);
    
    UIImage *resultImage2 = [[ImagePart shareInstance] compressImage2Quality:image toByte:500*1024];
    NSData *tempData2 = UIImageJPEGRepresentation(resultImage2, 1);
    NSLog(@"resultImage2=%lu",(unsigned long)tempData2.length);
    
    UIImage *resultImage3 = [[ImagePart shareInstance] compressImageSize:image toByte:500*1024];
    NSData *tempData3 = UIImageJPEGRepresentation(resultImage3, 1);
    NSLog(@"resultImage3=%lu",(unsigned long)tempData3.length);
    
    
    UIImage *resultImage4 = [[ImagePart shareInstance] compressImage:image toByte:500*1024];
    NSData *tempData4 = UIImageJPEGRepresentation(resultImage4, 1);
    NSLog(@"resultImage4=%lu",(unsigned long)tempData4.length);
    
}


- (void)testVideoCondense{
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_2841" ofType:@"MOV"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    
    [[VideoCompression shareInstance] compressVideoWithURL:videoURL compressionType:@"AVAssetExportPresetMediumQuality" compressionResultPath:nil];
    
}

- (void)testZipFileCondense{
    NSString *zipFilePath = [[NSBundle mainBundle].bundleURL
                             URLByAppendingPathComponent:@"TestArchiveLog.zip"
                             isDirectory:YES].path;
    
    NSString *unZipFilePath = [self tempUnzipPath];
    
    [[SSZipTest shareInstance] unZipFileswithzipFilepath:zipFilePath toDestination:unZipFilePath];
    
    
    NSString *reZipFilePath = [self tempZipPath];
    [[SSZipTest shareInstance] createZipFileAtPath:reZipFilePath withContentsOfDirectory:unZipFilePath];
    
}
#pragma mark - Private
- (NSString *)tempZipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@.zip",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      [NSUUID UUID].UUIDString];
    return path;
}

- (NSString *)tempUnzipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      [NSUUID UUID].UUIDString];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}







//----------------------------------------------------------
- (void)getXMLMessage{
    NSString *videoPath = [[NSBundle mainBundle].bundleURL
                           URLByAppendingPathComponent:@"config2.xml"
                           isDirectory:YES].path;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    
    NSData *data = [NSData dataWithContentsOfURL:videoURL];
    NSLog(@"data = %@", data);
    
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLFile:videoPath];
    NSLog(@"dictionary: %@", xmlDoc);
    
    //plan 1
    self.par = [[NSXMLParser alloc] initWithData:data];
    //添加代理
    self.par.delegate = self;
    //初始化数组，存放解析后的数据
    self.list = [NSMutableArray arrayWithCapacity:10];
    
    //[self.par parse];
    //NSLog(@"dict = %@", dict);
}

//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    self.currentElement = elementName;
    NSLog(@"elementName=%@",elementName);
    NSLog(@"namespaceURI=%@",namespaceURI);
    NSLog(@"qName=%@",qName);
    NSLog(@"attributeDict=%@",attributeDict);
    
//    if ([self.currentElement isEqualToString:@"student"]){
//        self.person = [[person alloc]init];
//        
//    }
    
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
//    if ([self.currentElement isEqualToString:@"name"]) {
    
        NSLog(@"string = %@",string);
//    }
//    else if ([self.currentElement isEqualToString:@"name"]){
//        [self.person setName:string];
//    }else if ([self.currentElement isEqualToString:@"sex"]){
//        [self.person setSex:string];
//    }else if ([self.currentElement isEqualToString:@"age"]){
//        
//        [self.person setAge:string];
//    }
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
//    if ([elementName isEqualToString:@"student"]) {
//        [self.list addObject:self.person];
//    }
//    self.currentElement = nil;
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidEndDocument...");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
