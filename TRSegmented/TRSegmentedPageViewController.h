//
//  EXSegmentedPageViewController.h
//  BasePackage
//
//  Created by ZYW on 17/5/5.
//  Copyright © 2017年 ZYW. All rights reserved.
//


#import "TRSegmentedControl.h"

@interface TRSegmentedPageViewController : UIViewController

/**
 分段
 */
@property (nonatomic,strong) TRSegmentedControl     *segmentedConotrol;

/**
 是否允许页面左右滑动（默认允许左右滑动）
 */
@property (nonatomic,assign) BOOL pageScrollEnable;

/**
 设置翻页控制器

 @param viewControllers 控制器数
 */
- (void)setControllers:(NSArray <UIViewController *>*)viewControllers;

/**
 设置翻页控制器

 @param viewControllers  控制器数组
 @param segmentedControl 分段
 */
- (void)setControllers:(NSArray <UIViewController *>*)viewControllers
      segmentedControl:(TRSegmentedControl *)segmentedControl;

/**
 滚动到当前页

 @param pageIndex 页码
 */
- (void)setActivePageControllerAtIndex:(NSUInteger)pageIndex;

/**
 视图添加时候调用
 */
- (void)viewDidLayoutSubviews;


@end
