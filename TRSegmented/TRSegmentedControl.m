
//
//  EXSegmentedControl.m
//  BasePackage
//
//  Created by ZYW on 17/5/4.
//  Copyright © 2017年 ZYW. All rights reserved.
//

#import "TRSegmentedControl.h"

#define DEFAULT_FRAME_HEIGHT 40
#define DEFAULT_ITEM_WIDTH 80

#define ATTRI_NORMAL_FONT [UIFont systemFontOfSize:17.f ]
#define ATTRI_NORMAL_COLOR  [UIColor grayColor]
#define ATTRI_NORMAL_BGCOLOR  [UIColor whiteColor]

#define ATTRI_SELECTED_FONT [UIFont systemFontOfSize:17.f ]
#define ATTRI_SELECTED_COLOR  [UIColor redColor]
#define ATTRI_SELECTED_BGCOLOR  [UIColor blueColor]

#define FOLLOW_ARROW_COLOR [UIColor redColor]

#define FOLLOW_ARROW_DURATION  0.15

@interface TRSegmentedControl () <UIScrollViewDelegate>

/**
 分段数据源
 */
@property (nonatomic,strong) NSMutableArray *itemArray;

/**
 标题Label数组
 */
@property (nonatomic,strong) NSMutableArray <UILabel *> *lableArray;

/**
 图片Image数组
 */
@property (nonatomic,strong) NSMutableArray <UIImage *> *imageArray;

/**
 frame位置数组
 */
@property (nonatomic,strong) NSMutableArray *rectFrameArray;

/**
 主要视图
 */
@property (nonatomic,strong) UIView *containView;

/**
 滑动视图
 */
@property (nonatomic,strong) UIScrollView *containScrollView;

/**
 底部分隔线条
 */
@property (nonatomic,strong) UIImageView  *separatorImageView;

/**
 分段颜色值
 */
@property (nonatomic,strong) UIColor *itemBackgroundColor;

/**
 分段segment序号
 */
@property (nonatomic,assign) NSUInteger segment;

@end

@implementation TRSegmentedControl

- (instancetype)initWithTitleItems:(nullable NSArray <NSString *> *)titles
                        imageItems:(nullable NSArray <UIImage *> *)images
                             frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if ([titles count] > 0) {
            CGFloat itemWidth = ([titles count] * DEFAULT_ITEM_WIDTH) > CGRectGetWidth(frame) ? DEFAULT_ITEM_WIDTH : CGRectGetWidth(self.bounds)/[titles count];
            [self initSegmentTitles:titles
                           images:images
                          itemWidth:itemWidth];
        }
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TRSegmentedControl *segmentedControl = [[self class] allocWithZone:zone];
    return segmentedControl;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //TODO
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)setTitleItems:(NSArray <NSString *> *)titles
           imageItems:(NSArray <UIImage *> *)images{
    if (CGRectIsNull(self.frame)) {
        NSLog(@"初始化尺寸为空！");
    }
	
    if ([titles count] > 0) {
		//移除视图元素
		[self removeObjectsFromeView];
		//重新布局
        CGFloat itemWidth = ([titles count] * DEFAULT_ITEM_WIDTH) > CGRectGetWidth(self.frame) ? DEFAULT_ITEM_WIDTH : CGRectGetWidth(self.bounds)/[titles count];
        [self initSegmentTitles:titles
					   images:images
					 itemWidth:itemWidth];
    }
}

- (void)initSegmentTitles:(nullable NSArray <NSString *> *)titles
                 images:(nullable NSArray <UIImage *> *)images
              itemWidth:(CGFloat)width{
    
    _selectedSegmentIndex = 0;
    _separatorHeight = 2.f;
    _separatorEnable = YES;
    _segment = 9999;
    _segmentAdjustText = NO;

    self.backgroundColor = [UIColor whiteColor];
    self.itemSegmentSize = CGSizeMake(width,  CGRectGetHeight(self.bounds));
    self.separatorImageView.backgroundColor = self.separatorColor ? self.separatorColor : FOLLOW_ARROW_COLOR;
    
    //添加数据源
    [self.itemArray addObjectsFromArray:titles];
    [self.imageArray addObjectsFromArray:images];
    
    //添加点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureRecognizer:)];
    [self.containView addGestureRecognizer:tapGestureRecognizer];
    
    //布局视图
    [self segmentLayout];
    //添加视图
    [self addSubviews];
}

- (void)addSubviews{
    //containView 添加到视图
    [self addSubview:self.containView];

    //containScrollView 添加到containView视图
    [self.containView addSubview:self.containScrollView];
    
    //Lable 添加到 containScrollView视图
    [self.lableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *itemLabel = obj;
        [_containScrollView addSubview:itemLabel];
    }];
    
    //separatorImageView 添加到 containScrollView视图
    if (_separatorEnable) {
        [self.containScrollView addSubview:self.separatorImageView];
    }
}

- (CGRect)boundingRect:(NSString *)text
                  size:(CGSize)size
                  font:(UIFont *)font{
    CGRect rect =  [text boundingRectWithSize:size
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    return rect;
}

- (void)segmentLayout{
    CGSize containSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGRect containFrame = CGRectMake(0, 0, containSize.width, containSize.height);
    self.containView.frame = containFrame;
    
    CGRect containScrollFrame = CGRectMake(0, 0, containSize.width, containSize.height);
    self.containScrollView.frame = containScrollFrame;

    __block CGFloat scrollWidth = 0.f;
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建UILable
        NSString *content = obj;
        UILabel *label = [self itemLabel];

        //取前一个Label
        UILabel *presLabel;
        if ([self.lableArray count] > 0 && idx > 0) {
            presLabel  = self.lableArray[(idx-1)];
        }
        
        //计算文本
        CGFloat itempx = self.segmentAdjustText ? CGRectGetMaxX(presLabel.frame) : idx * _itemSegmentSize.width;
        CGSize titleSize = [self boundingRect:content
                                      size:self.containView.frame.size
                                    font:label.font].size;
        //lable 尺寸大小
        CGRect adjustFrame = CGRectMake(itempx, 0, titleSize.width, _itemSegmentSize.height);
        CGRect originalFrame = CGRectMake(itempx, 0, _itemSegmentSize.width, _itemSegmentSize.height);
        label.frame = self.segmentAdjustText ? adjustFrame : originalFrame;
        
        //计算scroll内容宽度
        scrollWidth += CGRectGetWidth(label.frame);
        
        //分隔线条自适应
        if (_separatorEnable && idx == _selectedSegmentIndex) {
            CGRect adjustSeparatorFrame = CGRectMake(label.frame.origin.x, containSize.height - self.separatorHeight, CGRectGetWidth(label.frame), self.separatorHeight);
            if (!_segmentAdjustText) {
                adjustSeparatorFrame.origin.x = (CGRectGetWidth(originalFrame) - titleSize.width)/2 + label.frame.origin.x;
                adjustSeparatorFrame.size.width = titleSize.width;
            }
            self.separatorImageView.frame = adjustSeparatorFrame;
            self.separatorFrame = adjustSeparatorFrame;
        }
        
        //label赋值
        NSMutableAttributedString *string = (idx == _selectedSegmentIndex) ? [self getAttributedStringSelected:content] : [self getAttributedStringNormal:content];
        label.attributedText = string;

        //Label添加到数组中
        [self.lableArray addObject:label];
        //frame添加到数组中
        NSValue *value = [NSValue valueWithCGRect:label.frame];
        [self.rectFrameArray addObject:value];
    }];
    
    //设置scrollViewContent尺寸
    CGFloat width = _segmentAdjustText ? scrollWidth : _itemSegmentSize.width * [self.itemArray count];
    CGSize contentSize = CGSizeMake(width, containSize.height);
    [self.containScrollView setContentSize:contentSize];
}

- (void)removeObjectsFromeView{
	//清空移除containScrollView的Label
	for (UILabel *itemLabel in self.containScrollView.subviews) {
		if ([itemLabel isKindOfClass:[UILabel class]]) {
			[itemLabel  removeFromSuperview];
		}
	}
	//清空itemArray
	[self.itemArray removeAllObjects];
	
	//清空记录位置数组
	[self.rectFrameArray removeAllObjects];
	//清空添加lable数组
	[self.lableArray removeAllObjects];
	
	[self.separatorImageView removeFromSuperview];
	[self.containScrollView removeFromSuperview];
	[self.containView removeFromSuperview];
}

- (void)reloadSegmentedControl{
	//移除视图元素
	[self removeObjectsFromeView];
    //重新布局
    [self segmentLayout];
    //重新添加视图
    [self addSubviews];
}

- (void)didTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer{
    CGPoint location = [gestureRecognizer locationInView:_containScrollView];
    if (location.x > self.containScrollView.contentSize.width) {
        return;
    }
    //获取当前点击的序号
    NSUInteger atIndex = [self getHitCurrentIndex:location];
    if (atIndex != NSNotFound) {
        if (_selectedSegmentIndex != atIndex) {
            //滑动动画
            [self slideAnimationAtIndex:atIndex];
            //响应事件
            //外部调用
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)slideAnimationAtIndex:(NSUInteger)index{
    //选中Label
    NSString *selectContent = _itemArray[index];
    UILabel *selectedLabel = _lableArray[index];
    selectedLabel.attributedText = [self getAttributedStringSelected:selectContent];
    
    //未选中Label
    NSString *deselectedContent = _itemArray[_selectedSegmentIndex];
    UILabel *deselectedLabel = _lableArray[_selectedSegmentIndex];
    deselectedLabel.attributedText = [self getAttributedStringNormal:deselectedContent];
    
    //视图滚动到点击当前Label的Frame
    CGRect selectedFrame = selectedLabel.frame;
    CGRect scrollFrame = selectedFrame;
    
    //点击判断
    if (_selectedSegmentIndex < index) {
        scrollFrame.origin.x = selectedFrame.origin.x + CGRectGetWidth(selectedFrame);
    }else if (_selectedSegmentIndex > index){
        scrollFrame.origin.x = selectedFrame.origin.x - CGRectGetWidth(selectedFrame);
    }
    
    //左边缘判断
    if (scrollFrame.origin.x < 0) {
        scrollFrame.origin.x = 0;
    }
    
    //右边缘判断
    if (scrollFrame.origin.x >= self.containScrollView.contentSize.width) {
        scrollFrame.origin.x -= CGRectGetWidth(selectedFrame);
    }
    
    [self.containScrollView scrollRectToVisible:scrollFrame animated:YES];
    
    //分隔线滑动动画
    [UIView animateWithDuration:FOLLOW_ARROW_DURATION
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //计算文本
                         CGRect separatorImageFrame =  CGRectMake(selectedFrame.origin.x, self.separatorImageView.frame.origin.y, CGRectGetWidth(selectedFrame), self.separatorHeight);
                         if (!_segmentAdjustText) {
                             CGSize titleSize = [self boundingRect:selectedLabel.text
                                                              size:self.containView.frame.size
                                                              font:selectedLabel.font].size;
                             separatorImageFrame.origin.x = (CGRectGetWidth(selectedLabel.frame) - titleSize.width)/2 + selectedLabel.frame.origin.x;
                             separatorImageFrame.size.width = titleSize.width;
                         }
                         self.separatorImageView.frame = separatorImageFrame;
                         self.separatorFrame = separatorImageFrame;
                     }
                     completion:^(BOOL finished) {
                         //选中背景颜色设置
                         selectedLabel.backgroundColor = self.selectedSegmentBgColor ? self.selectedSegmentBgColor : [UIColor clearColor];
                         //未选中颜色设置
                         deselectedLabel.backgroundColor = [UIColor clearColor];
                     }];
    //赋值当前选中序号
    _selectedSegmentIndex = index;
}

- (NSUInteger)getHitCurrentIndex:(CGPoint)point{
    __block NSUInteger currentIndex = 0;
    [self.rectFrameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *value = obj;
        CGRect frame = value.CGRectValue;
        //是否包含在保存的frame数组中
        if (CGRectContainsPoint(frame, point)) {
            currentIndex = idx;
            *stop = YES;
        }
    }];
    return currentIndex;
}

#pragma mark lazyload
- (NSMutableAttributedString *)getAttributedStringNormal:(NSString *)text{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString setAttributes:_attributesNormalDict
                              range:NSMakeRange(0,text.length)];

    return attributedString;
}

- (NSMutableAttributedString *)getAttributedStringSelected:(NSString *)text{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString setAttributes:self.attributesSelectedDict
                              range:NSMakeRange(0,text.length)];
    return attributedString;
}

- (UILabel *)itemLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    UIFont *font = self.attributesSelectedDict[NSFontAttributeName];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}


- (UIImageView *)itemImage:(CGRect)frame image:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    return imageView;
}

- (NSTextAttachment *)itemAttachment:(UIImage *)image{
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = image;
    attch.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    return attch;
}

- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)lableArray{
    if (!_lableArray) {
        _lableArray = [NSMutableArray array];
    }
    return _lableArray;
}

- (NSMutableArray *)rectFrameArray{
    if (!_rectFrameArray) {
        _rectFrameArray = [NSMutableArray array];
    }
    return _rectFrameArray;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSDictionary *)attributesNormalDict{
    if (!_attributesNormalDict) {
        _attributesNormalDict = @{NSFontAttributeName:ATTRI_NORMAL_FONT,
                                  NSForegroundColorAttributeName:ATTRI_NORMAL_COLOR};
    }
    return _attributesNormalDict;
}

- (NSDictionary *)attributesSelectedDict{
    if (!_attributesSelectedDict) {
        _attributesSelectedDict = @{NSFontAttributeName:ATTRI_SELECTED_FONT,
                                NSForegroundColorAttributeName:ATTRI_SELECTED_COLOR};
    }
    return _attributesSelectedDict;
}

- (UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc] init];
    }
    return _containView;
}

- (UIScrollView *)containScrollView{
    if (!_containScrollView) {
        _containScrollView = [[UIScrollView alloc] init];
        _containScrollView.showsVerticalScrollIndicator = NO;
        _containScrollView.showsHorizontalScrollIndicator = NO;
        _containScrollView.delegate = self;
        _containScrollView.backgroundColor = [UIColor clearColor];
    }
    return _containScrollView;
}

- (UIImageView *)separatorImageView{
    if (!_separatorImageView) {
        _separatorImageView = [[UIImageView alloc] init];
    }
    return _separatorImageView;
}

- (void)setSeparatorEnable:(BOOL)separatorEnable{
    _separatorEnable = separatorEnable;
    if (!_separatorEnable) {
        if ([_separatorImageView superview]) {
            [_separatorImageView removeFromSuperview];
        }
    }
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    _separatorImageView.backgroundColor = separatorColor;
}

- (void)setSegmentedItemBackgroundColor:(nullable UIColor *)color segment:(NSUInteger)segment{
    _segment = segment;
    _itemBackgroundColor = color;
    [self reloadSegmentedControl];
}

- (void)setSegmentedControlBackgroundColor:(nullable UIColor *)color{
    _containView.backgroundColor = color;
}

- (void)setSelectedSegmentBgColor:(UIColor *)selectedSegmentBgColor{
    _selectedSegmentBgColor = selectedSegmentBgColor;
    [self reloadSegmentedControl];
}

- (void)setTextAttributes:(nullable NSDictionary *)attributes forState:(UIControlState)state{
    if (state == UIControlStateNormal) {
        self.attributesNormalDict = attributes;
    }
    
    if (state == UIControlStateSelected) {
        self.attributesSelectedDict = attributes;
    }

    [self reloadSegmentedControl];
}

- (void)setSegmentedControlAnimationAtSegment:(NSUInteger)segment{
    [self slideAnimationAtIndex:segment];
}

- (void)setSegmentAdjustText:(BOOL)segmentAdjustText{
	_segmentAdjustText = segmentAdjustText;
	[self reloadSegmentedControl];
}

- (void)setItemSegmentSize:(CGSize)itemSegmentSize{
    _itemSegmentSize = itemSegmentSize;
    [self reloadSegmentedControl];
}

- (void)setSeparatorFrame:(CGRect)separatorFrame{
    _separatorFrame = separatorFrame;
    self.separatorImageView.frame = separatorFrame;
}

@end
