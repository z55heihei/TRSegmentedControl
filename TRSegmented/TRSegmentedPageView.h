//
//  EXSegmentedPageView.h
//  BasePackage
//
//  Created by ZYW on 17/5/31.
//  Copyright © 2017年 ZYW. All rights reserved.
//
#import "TRSegmentedControl.h"

@class  TRSegmentedPageView;

@protocol segmentedPageViewDelegate <NSObject>

- (void)segmentedScroll:(TRSegmentedPageView *)pageView scrollIndex:(NSInteger)index;

- (void)segmentedDidSelect:(TRSegmentedPageView *)pageView selectIndex:(NSInteger)index;

@end

@interface TRSegmentedPageView : UIView

/**
 分段
 */
@property (nonatomic,strong) TRSegmentedControl  *segmentedConotrol;

/**
 是否允许页面左右滑动（默认允许左右滑动）
 */
@property (nonatomic,assign) BOOL pageScrollEnable;

@property (nonatomic,weak) id <segmentedPageViewDelegate> delegate;
/**
 设置翻页控制器
 
 @param frame 位置尺寸
 @param parentViewController 根视图控制器
 @param parentView 根视图
 @param viewControllers 控制器数组
 @param segmentedConotrol 分段
 */
- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController 
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers 
			segmentedConotrol:(TRSegmentedControl *)segmentedConotrol;

/**
 设置翻页控制器
 
 @param frame 位置尺寸
 @param parentViewController 根视图控制器
 @param parentView 根视图
 @param viewControllers 控制器数组
 */
- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers;


/**
 设置翻页控制器
 
 @param frame 位置尺寸
 @param parentViewController 根视图控制器
 @param viewControllers 控制器数组
 @param segmentedConotrol 分段
 */
- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
			  viewControllers:(NSArray <UIViewController *>*)viewControllers segmentedConotrol:(TRSegmentedControl *)segmentedConotrol;

/**
 设置翻页控制器
 
 @param frame 位置尺寸
 @param parentViewController 根视图控制器
 @param viewControllers 控制器数组
 */
- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
			  viewControllers:(NSArray <UIViewController *>*)viewControllers;

/**
 设置翻页控制器
 
 @param frame 位置尺寸
 @param parentView 根视图
 @param viewControllers 控制器数组
 @param segmentedConotrol 分段
 */
- (instancetype)initWithFrame:(CGRect)frame 
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers segmentedConotrol:(TRSegmentedControl *)segmentedConotrol;


/**
 设置翻页控制器

 @param frame 位置尺寸
 @param parentView 根视图
 @param segmentedConotrol 分段
 */
- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
			segmentedConotrol:(TRSegmentedControl *)segmentedConotrol;

/**
 设置翻页控制器
 
 @param frame 位置尺寸
 @param parentView 根视图
 @param viewControllers 控制器数组
 */
- (instancetype)initWithFrame:(CGRect)frame 
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers;

/**
 滚动到当前页
 
 @param pageIndex 页码
 */
- (void)setActivePageControllerAtIndex:(NSUInteger)pageIndex;

/**
 设置翻页控制器
 
 @param viewControllers 控制器数
 */
- (void)setControllers:(NSArray <UIViewController *>*)viewControllers;

@end
