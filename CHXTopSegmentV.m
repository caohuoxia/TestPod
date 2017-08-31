//
//  CHXTopSegmentV.m
//  ScrollviewHeadDemo
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CHXTopSegmentV.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface CHXTopSegmentV ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) NSMutableArray * buttons;
@property (nonatomic, strong) UIScrollView *contentScrollview;
@property (nonatomic,strong)NSArray *controllers;
@end

@implementation CHXTopSegmentV

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles controllers:(NSArray *)controllers parentVC:(UIViewController*)parentVC  tapView:(MainTopBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.controllers = controllers;
        self.block = block;
        
        CGFloat btnW = self.width / titles.count;
        CGFloat btnH = self.height;
        CGFloat btnX;
        for (int i = 0; i < titles.count; i++) {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag = i;
            [titleButton setTitle:titles[i] forState:UIControlStateNormal];
            // 设置标题颜色
            [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // 设置标题字体
            titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
            btnX = i * btnW;
            titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
            // 监听按钮点击
            [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleButton];
            [self.buttons addObject:titleButton];
            
            // 添加下划线
            // 下划线宽度 = 按钮文字宽度
            // 下划线中心点x = 按钮中心点x
            if (i == 0) {
                CGFloat h = 2;
                CGFloat y = self.height -5;
                // 先计算文字尺寸,在给label去赋值
                [titleButton.titleLabel sizeToFit];
                UIView * lineView =[[UIView alloc] init];
                // 位置和尺寸
                lineView.height = h;
                lineView.width = titleButton.titleLabel.width;
                lineView.centerX = titleButton.centerX;
                lineView.top = y;
                lineView.backgroundColor = [UIColor whiteColor];
                self.lineView = lineView;
                [self addSubview:self.lineView];
            }
        }
        
        //添加内容scrollView
        self.contentScrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.height +5, Screen_Width, Screen_Height -(self.height +5))];
        self.contentScrollview.contentSize=CGSizeMake(Screen_Width*controllers.count, 0);
        self.contentScrollview.delegate = self;
        self.contentScrollview.pagingEnabled = YES ;
        self.contentScrollview.showsHorizontalScrollIndicator= NO;
        self.contentScrollview.bounces=NO;
        //若添加self上 则scollview无法滚动，不会响应代理
        [parentVC.view addSubview:self.contentScrollview];
        //添加控制器
        for (int i=0;i<self.controllers.count;i++)
        {
            UIViewController * contr= [[NSClassFromString(self.controllers[i]) alloc]init];
            [self.contentScrollview addSubview:contr.view];
            contr.view.frame=CGRectMake(i*frame.size.width, 0, Screen_Width,Screen_Height -(self.height +5));
            [parentVC addChildViewController:contr];
            //当我们向我们的视图控制器容器中添加（或者删除）子视图控制器后，必须调用该方法，告诉iOS，已经完成添加（或删除）子控制器的操作
            [contr didMoveToParentViewController:parentVC];
        }
    }
    
    return self;
}

- (void)scrolling:(NSInteger)tag {
    //改动下划线位置
    UIButton * button = self.buttons[tag];
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.centerX = button.centerX;
    }];
}

- (void)titleClick:(UIButton *)button {
//    self.block(button.tag);
    CGPoint point = CGPointMake(button.tag * Screen_Width ,self.contentScrollview.contentOffset.y);
    [self.contentScrollview setContentOffset:point animated:YES];
    
    [self scrolling:button.tag];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //contentScrollView的width
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger index = offsetX / Screen_Width;
    
    //标题线 跟着相应滚动
    [self scrolling:index];
    
    UIViewController * childVC = [[NSClassFromString(self.controllers[index]) alloc]init];
    //视图控制器是否加载过
    if ([childVC isViewLoaded]) return;
    childVC.view.frame = CGRectMake(offsetX, 0, Screen_Width, Screen_Height);
    [scrollView addSubview:childVC.view];
}

@end
