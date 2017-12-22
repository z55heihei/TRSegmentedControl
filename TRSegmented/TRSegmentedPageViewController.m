//
//  EXSegmentedPageViewController.m
//  BasePackage
//
//  Created by ZYW on 17/5/5.
//  Copyright © 2017年 ZYW. All rights reserved.
//

#import "TRSegmentedPageViewController.h"
#import "TRSegmentedControl.h"

@interface TRSegmentedPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

/**
 包含的所有controller
 */
@property (nonatomic,strong) NSMutableArray        *containControllers;

/**
 当前滑动的指标
 */
@property (nonatomic,assign) NSUInteger            currentIndex;

/**
 分页Controller
 */
@property (nonatomic,strong) UIPageViewController   *pageViewController;

@end

@implementation TRSegmentedPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //序号从第一个开始
    _currentIndex = 0;
    //默认左右滑动
    _pageScrollEnable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    CGRect pageFrame = CGRectMake(0, CGRectGetHeight(self.segmentedConotrol.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.segmentedConotrol.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    self.pageViewController.view.frame = pageFrame;
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

#pragma mark -
- (void)setControllers:(NSArray <UIViewController *>*)viewControllers{
    [self setControllers:viewControllers segmentedControl:nil];
}

- (void)setControllers:(NSArray <UIViewController *>*)viewControllers
                titles:(NSArray<NSString *> *)titles
                images:(NSArray<UIImage *> *)images
      segmentedControl:(TRSegmentedControl *)segmentedControl{
    
    self.containControllers = [viewControllers copy];

    if (segmentedControl) {
        self.segmentedConotrol = segmentedControl;
        [self.segmentedConotrol addTarget:self
                                   action:@selector(didSelectSegmentControl:)
                         forControlEvents:UIControlEventValueChanged];
        [self.segmentedConotrol setTitleItems:titles
                                   imageItems:images];
        [self.view addSubview:self.segmentedConotrol];
    }

    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:0]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
}

- (void)setControllers:(NSArray<UIViewController *> *)viewControllers
      segmentedControl:(TRSegmentedControl *)segmentedControl{
    [self setControllers:viewControllers
                  titles:nil
                  images:nil
        segmentedControl:segmentedControl];
}

- (NSUInteger)indexAtView:(UIViewController *)controller{
    __block NSUInteger index;
    [self.containControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *objItemController = obj;
        if ([controller isKindOfClass:[objItemController class]]) {
            index = idx;
        }
    }];
    return index;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexAtView:viewController];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (viewController) {
        NSUInteger index = [self indexAtView:viewController];
        index++;
        if (index == [self.containControllers count]) {
            return nil;
        }
        return [self viewControllerAtIndex:index];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    UIViewController *viewController = [[_pageViewController viewControllers] objectAtIndex:0];
    if (viewController) {
        NSUInteger page = [self indexAtView:viewController];
        if (page == _currentIndex) {
            return;
        }
        [self.segmentedConotrol setSegmentedControlAnimationAtSegment:page];
        [self slidePageController:page];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - lazyload
- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:
                               UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                options:nil];
        //绑定数据源
        [_pageViewController setDataSource:self];
        //绑定翻页代理
        [_pageViewController setDelegate:self];
        //是否滚动翻页设置
        [self setPageControllerScrollDelegate:self.pageScrollEnable];
    }
    return _pageViewController;
}

- (void)didSelectSegmentControl:(TRSegmentedControl *)segmentControl{
    NSUInteger selectIndex = segmentControl.selectedSegmentIndex;
    [self slidePageController:selectIndex];
}

- (void)slidePageController:(NSUInteger)page{
    //设置当前页
    [self setActivePageControllerAtIndex:page];
}

- (void)setActivePageControllerAtIndex:(NSUInteger)pageIndex {
    NSAssert(pageIndex <= self.containControllers.count - 1, @"Default display page index is bigger than amount of  view controller");

    UIViewController *viewController = [self viewControllerAtIndex:pageIndex];
    if (viewController) {
        NSInteger direction;
        if (pageIndex > _currentIndex) {
            direction = UIPageViewControllerNavigationDirectionForward;
        } else if (pageIndex < _currentIndex) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        } else {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageViewController setViewControllers:@[self.containControllers[pageIndex]]
                                              direction:direction
                                               animated:YES
                                             completion:^(BOOL finished) {
                                                 //当前页码
                                                 _currentIndex = pageIndex;
                                             }];
        });
    }
 
}

- (void)setPageControllerScrollDelegate:(BOOL)pageEnable{
    if (pageEnable) {
        for (UIView *view in _pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)view setDelegate:self];
            }
        }
    }
}

- (void)setPageScrollEnable:(BOOL)pageScrollEnable{
    _pageScrollEnable = pageScrollEnable;
    pageScrollEnable ? [self enableViewPagerScroll] : [self disableViewPagerScroll];
}

- (void)disableViewPagerScroll {
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setScrollEnabled:NO];
        }
    }
}

- (void)enableViewPagerScroll {
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setScrollEnabled:YES];
        }
    }
}



@end
