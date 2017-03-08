//
//  ViewController.h
//  ZDXCondenseStudy
//
//  Created by Elbert on 17/3/2.
//  Copyright © 2017年 Elbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>

//添加属性
@property (nonatomic, strong) NSXMLParser *par;
//存放每个person
@property (nonatomic, strong) NSMutableArray *list;
//标记当前标签，以索引找到XML文件内容
@property (nonatomic, copy) NSString *currentElement;

@end

