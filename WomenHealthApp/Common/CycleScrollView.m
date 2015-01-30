//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , strong) NSMutableArray *customViewsAry;

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
    
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration withAry:(NSMutableArray *)viewsAry  andfirstImageUrl:(NSString *)ImgrUrl;
{
    self = [self initWithFrame:frame withCount:viewsAry.count];
    _customViewsAry =[NSMutableArray array];

    [viewsAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_customViewsAry addObject:obj];
        
    }];
    
    if (_customViewsAry.count ==2) {
        
        UIImageView *obj =[[UIImageView alloc] init];
        UIImageView  *temp =[viewsAry objectAtIndex:1];
        CGRect rect =temp.frame;
        rect.origin.x =temp.frame.origin.x*2;
        obj.frame =rect;
//        [obj sd_setImageWithURL:[NSURL URLWithString:ImgrUrl]  placeholderImage:[UIImage imageNamed:@""]];
//        [obj setImageWithURL:[NSURL URLWithString:ImgrUrl]];

        [obj setImageWithURL:[NSURL URLWithString:ImgrUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        
        }];
        [_customViewsAry addObject:obj];
        
        
    }

    
    if (animationDuration > 0.0) {
        if (_totalPageCount>1) {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [self.animationTimer pauseTimer];
        }
        
    }
    _totalPageCount = _customViewsAry.count;
    if (viewsAry.count ==2) {
        _totalPageCount =2;
    }

    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        if (count>=2) {
            self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        }else if(count ==1){
            self.scrollView.scrollEnabled =NO;
            self.scrollView.contentSize = CGSizeMake(count * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        }
    
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator =NO;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width-110, self.bounds.size.height - 35, 100, 37)];
        self.pageControl.hidesForSinglePage = YES;
        [self.pageControl setCurrentPageIndicatorTintColor:FENSERGB];
        [self.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        [self addSubview:self.pageControl];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    if (_totalPageCount>=2) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }else{
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
//    if (self.fetchContentViewAtIndex) {

        if (_totalPageCount>=2) {
            
            [self.contentViews addObject:_customViewsAry[previousPageIndex]];
            [self.contentViews addObject:_customViewsAry[_currentPageIndex]];
            [self.contentViews addObject:_customViewsAry[rearPageIndex]];
            
        }else{
            if (_customViewsAry.count >_currentPageIndex && _currentPageIndex>=0) {
                [self.contentViews addObject:_customViewsAry[_currentPageIndex]];
            }
            
        }
       
//    }
    
    [self.pageControl setNumberOfPages:_totalPageCount];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{

    if (self.totalPageCount ==2) {
        if(currentPageIndex == -1) {
            return 3 - 1;
        } else if (currentPageIndex == 3) {
            return 0;
        } else {
            return currentPageIndex;
        }
    }
    
    
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
    
    
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;

        if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
            
            
            self.currentPageIndex = [self getPageIndexWithPageIndex:self.currentPageIndex + 1];
            
            [self configContentViews];
        }
        
        if(contentOffsetX <= 0) {
            self.currentPageIndex = [self getPageIndexWithPageIndex:self.currentPageIndex - 1];
            
            [self configContentViews];
            
        }
    
    
//    if (_totalPageCount ==2) {
//        self.pageControl.currentPage = (self.currentPageIndex+1)/2;
//        NSLog(@"%i",(self.currentPageIndex+1)/2+1);
//    }else{
        self.pageControl.currentPage = self.currentPageIndex;
//    }

}

- (NSInteger)getPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    

    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
