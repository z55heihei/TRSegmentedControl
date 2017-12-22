//
//  EXSegmentedPageView.m
//  BasePackage
//
//  Created by ZYW on 17/5/31.
//  Copyright © 2017年 ZYW. All rights reserved.
//

#import "TRSegmentedPageView.h"

@interface TRSegmentedPageView () <UICollectionViewDelegate,UICollectionViewDataSource>

/**
 包含的所有controller
 */
@property (nonatomic,strong) NSMutableArray        *containControllers;

/**
 当前滑动的指标
 */
@property (nonatomic,assign) NSUInteger            currentIndex;

/**
 外界父控制器
 */
@property (nonatomic, weak) UIViewController *parentViewController;

/**
 外界父控制视图
 */
@property (nonatomic, weak) UIView *parentView;


/**
 滚动视图
 */
@property (nonatomic, strong) UICollectionView *sgmentCollectionView;

@end

@implementation TRSegmentedPageView

- (instancetype)initWithFrame:(CGRect)frame 
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers segmentedConotrol:(TRSegmentedControl *)segmentedConotrol{
	return [self initWithFrame:frame 
		  parentViewController:nil
					parentView:parentView
			   viewControllers:viewControllers
			 segmentedConotrol:segmentedConotrol];
}

- (instancetype)initWithFrame:(CGRect)frame 
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers{
	return [self initWithFrame:frame
				  parentView:parentView 
			   viewControllers:viewControllers 
			segmentedConotrol:nil];
}


- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
			  viewControllers:(NSArray <UIViewController *>*)viewControllers segmentedConotrol:(TRSegmentedControl *)segmentedConotrol{
	return [self initWithFrame:frame 
		  parentViewController:parentViewController
					parentView:nil
			   viewControllers:viewControllers 
			 segmentedConotrol:segmentedConotrol];
}

- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
			  viewControllers:(NSArray <UIViewController *>*)viewControllers{
	return [self initWithFrame:frame 
		  parentViewController:parentViewController 
			   viewControllers:viewControllers 
			 segmentedConotrol:nil];
}

- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
			segmentedConotrol:(TRSegmentedControl *)segmentedConotrol{
	return [self initWithFrame:frame 
		  parentViewController:parentViewController 
			   viewControllers:nil 
			 segmentedConotrol:segmentedConotrol];
}

- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController 
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers 
			segmentedConotrol:(TRSegmentedControl *)segmentedConotrol{
	self = [super initWithFrame:frame];
	if (self) {
		//序号从第一个开始
		_currentIndex = 0;
		//默认左右滑动
		_pageScrollEnable = YES;
		//根视图控制器
		self.parentViewController = parentViewController;
		//根视图
		self.parentView = parentView;
		//分段
		self.segmentedConotrol = segmentedConotrol;
		//背景颜色
		self.backgroundColor = [UIColor whiteColor];
		
		//所有包含控制器			
		//添加到视图和控制器上
		if ([viewControllers count] > 0) {
			self.containControllers = [NSMutableArray arrayWithArray:viewControllers];
			[self bindViewControllers];
		}
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame 
		 parentViewController:(UIViewController *)parentViewController
				   parentView:(UIView *)parentView
			  viewControllers:(NSArray <UIViewController *>*)viewControllers{
	return [self initWithFrame:frame
		  parentViewController:parentViewController  
					parentView:parentView 
			   viewControllers:viewControllers 
			 segmentedConotrol:nil];
}

- (void)setControllers:(NSArray <UIViewController *>*)viewControllers{
	if ([viewControllers count] > 0) {
		self.containControllers = [NSMutableArray arrayWithArray:viewControllers];
		[self bindViewControllers];
	}
}

- (void)bindViewControllers{	
	if (self.parentViewController) {
		for (UIViewController *itemViewController in self.containControllers) {
			//将所有的子控制器添加父控制器中
			[self.parentViewController addChildViewController:itemViewController];	
		}
	}
	
	if (self.parentView) {
		[self.parentView addSubview:self];
	}
	
	[self addSubview:self.sgmentCollectionView];
	
	if (self.segmentedConotrol) {
		[self.segmentedConotrol addTarget:self
								action:@selector(didSelectSegmentControl:)
						 forControlEvents:UIControlEventValueChanged];
		[self addSubview:self.segmentedConotrol];
	}
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index{
	if ([self.containControllers count] > 0) {
		UIViewController *viewController = self.containControllers[index];
		return viewController;
	}
	return nil;
}

- (UIView *)viewAtIndex:(NSUInteger)index{
	if ([self viewControllerAtIndex:index]) {
		UIView *view = [self viewControllerAtIndex:index].view;
		return view;
	}
	return nil;
}

- (UICollectionView *)sgmentCollectionView {
	if (!_sgmentCollectionView) {
		EXCollectionViewFlowLayout *followLayout = [[EXCollectionViewFlowLayout alloc] initCollectionFlowLayout:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - (self.segmentedConotrol ? CGRectGetHeight(self.segmentedConotrol.frame) : 0)) sectionInset:UIEdgeInsetsMake(0, 0, 0, 0) minimumLineSpacing:0 minimumInteritemSpacing:0];
		followLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		CGRect collectionFrame =  CGRectMake(0, self.segmentedConotrol ? CGRectGetHeight(self.segmentedConotrol.frame) : 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - (self.segmentedConotrol ? CGRectGetHeight(self.segmentedConotrol.frame) : 0));
		_sgmentCollectionView = [[UICollectionView alloc] initWithFrame:collectionFrame 
										 collectionViewLayout:followLayout];
		_sgmentCollectionView.showsHorizontalScrollIndicator = NO;
		_sgmentCollectionView.pagingEnabled = YES;
		_sgmentCollectionView.bounces = NO;
		_sgmentCollectionView.delegate = self;
		_sgmentCollectionView.dataSource = self;
		_sgmentCollectionView.backgroundColor = [UIColor whiteColor];
		[_sgmentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	}
	return _sgmentCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.containControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	
	[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	NSUInteger itemIndex = indexPath.item;
	UIView *view = [self viewAtIndex:itemIndex];
	
	view.frame = CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.contentView.frame));
	[cell.contentView addSubview:view];
	
	return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSInteger pageNum = floor((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width);
	//未滑动
	if (pageNum == _currentIndex) {
		return;
	}
	[self setActivePageControllerAtIndex:pageNum];
}

- (void)didSelectSegmentControl:(TRSegmentedControl *)segmentControl{
	//滚动视图
	[self scrollAtPageIndex:segmentControl.selectedSegmentIndex];
	//点击segmentControl代理
	if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedDidSelect:selectIndex:)]) {
		[self.delegate segmentedDidSelect:self selectIndex:segmentControl.selectedSegmentIndex];
	}
}

- (void)setActivePageControllerAtIndex:(NSUInteger)pageIndex{
	//滚动视图
	[self scrollAtPageIndex:pageIndex];
	//分段滑动
	[self.segmentedConotrol setSegmentedControlAnimationAtSegment:pageIndex];
	//pageview滚动代理
	if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedScroll:scrollIndex:)]) {
		[self.delegate segmentedScroll:self scrollIndex:pageIndex];
	}
}

- (void)scrollAtPageIndex:(NSInteger)pageIndex{
	//当前页码
	_currentIndex = pageIndex;
	//滑动距离
	CGFloat offsetX = pageIndex * CGRectGetWidth(self.sgmentCollectionView.frame);
	[self.sgmentCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)setPageScrollEnable:(BOOL)pageScrollEnable{
	_pageScrollEnable = pageScrollEnable;
	self.sgmentCollectionView.scrollEnabled = pageScrollEnable;
}

@end
