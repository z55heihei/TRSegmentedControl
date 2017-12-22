# TRSegmentedControl

```
/**
 当前选中的背景颜色
 */
@property (nonatomic,strong) UIColor  *selectedSegmentBgColor;

/**
 当前选中序号
 */
@property (nonatomic,assign,readonly) NSUInteger selectedSegmentIndex;

/**
 单元格大小
 */
@property (nonatomic,assign) CGSize itemSegmentSize;


/**
 底部分隔线条高度 (默认1px)
 */
@property (nonatomic,assign) CGFloat separatorHeight;

/**
 滚动分割位置
 */
@property (nonatomic,assign) CGRect  separatorFrame;

/**
 是否需要分隔线条
 */
@property (nonatomic,assign) BOOL  separatorEnable;

/**
 动态计算分隔栏目的字体长度
 */
@property (nonatomic,assign) BOOL  segmentAdjustText;

/**
 分隔线与标题字体长度
 */
@property (nonatomic,assign) BOOL  separatorAdjustText;

/**
 底部分隔线条颜色值 （默认红色）
 */
@property (nonatomic,strong) UIColor *separatorColor;

/**
 正常未点击Label样式
 */
@property (nonatomic,strong) NSDictionary *attributesNormalDict;

/**
 点击后Label样式
 */
@property (nonatomic,strong) NSDictionary *attributesSelectedDict;



/**
 初始化

 @param titles 标题数组
 @param images 图片数组
 @param frame  尺寸大小
 */
- (instancetype)initWithTitleItems:(NSArray <NSString *> *)titles
                        imageItems:(NSArray <UIImage *> *)images
                             frame:(CGRect)frame;

/**
 初始化

 @param frame 尺寸大小
 */
- (instancetype)initWithFrame:(CGRect)frame;


/**
 设置标题数据源和图片数据源

 @param titles 标题数据源
 @param images 图片数据源
 */
- (void)setTitleItems:(NSArray <NSString *> *)titles
           imageItems:(NSArray <UIImage *> *)images;

/**
 设置SegmentedControl背景颜色

 @param color 颜色值
 */
- (void)setSegmentedControlBackgroundColor:(UIColor *)color;

/**
 设置分段背景颜色

 @param color 颜色值
 @param segment 序号
 */
- (void)setSegmentedItemBackgroundColor:(UIColor *)color segment:(NSUInteger)segment;

/**
 设置字体样式

 @param attributes 样式
 @param state 状态
 */
- (void)setTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state;


/**
 滑动动画

 @param segment 序号
 */
- (void)setSegmentedControlAnimationAtSegment:(NSUInteger)segment;


@end


```