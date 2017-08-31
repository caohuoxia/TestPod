//
//  CHXTopSegmentV.h
//  ScrollviewHeadDemo
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YYAdd.h"

typedef void(^MainTopBlock)(NSInteger tag);

@interface CHXTopSegmentV : UIView
//该block暂时没用到
@property (nonatomic, copy) MainTopBlock block;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles controllers:(NSArray *)controllers parentVC:(UIViewController*)parentVC  tapView:(MainTopBlock)block;
//- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles tapView:(MainTopBlock)block;

@end
