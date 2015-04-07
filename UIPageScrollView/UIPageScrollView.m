//
//  UIPageScrollView.m
//  UIPageScrollView
//
//  Created by guojun on 4/7/15.
//  Copyright (c) 2015 guojunxu. All rights reserved.
//

#import "UIPageScrollView.h"
#import "UIColor+CustomColor.h"

typedef NS_ENUM(NSUInteger, ScrollDirection) {
  ScrollDirectionFromRighToLeft,
  ScrollDirectionFromLeftToRight
};

static const NSTimeInterval AutoPlayTimeInterval = 3.5f;
static const CGFloat PageControlMarginBottom = 14.0f;
static const CGFloat PageControlHeight = 6.0f;

@interface UIPageScrollView () <UIScrollViewDelegate> {
  NSUInteger numberOfPages;

  CGFloat WIDTH;
  CGFloat HEIGHT;

  __weak NSTimer *repeatingTimer;

  UIScrollView *autoScrollView;
  UIPageControl *pageControl;

  CGFloat lastContentOffsetX;
  ScrollDirection scrollDirection;
}

@property(nonatomic, assign, readwrite) NSUInteger currentPageIndex;

@end

@implementation UIPageScrollView

- (instancetype)initWithFrame:(CGRect)frame
               withDataSource:(id<UIPageScrollViewDataSource>)dataSource
                 withDelegate:(id<UIPageScrollViewDelegate>)delegate {

  self = [super initWithFrame:frame];
  if (self) {

    self.dataSource = dataSource;
    self.delegate = delegate;

    numberOfPages = [dataSource numberOfPagesInScrollView:self];

    WIDTH = self.bounds.size.width;
    HEIGHT = self.bounds.size.height;

    [self initScrollView];
    [self fillInImages];

    [self initPageControl];
  }

  return self;
}

- (void)initScrollView {
  // autoPlayScrollView
  autoScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

  autoScrollView.pagingEnabled = YES;
  autoScrollView.bounces = NO;
  autoScrollView.delegate = self;
  autoScrollView.userInteractionEnabled = YES;
  autoScrollView.showsHorizontalScrollIndicator = NO;
  autoScrollView.showsVerticalScrollIndicator = NO;
  autoScrollView.contentSize = CGSizeMake(numberOfPages * WIDTH, HEIGHT);

  [self addSubview:autoScrollView];
}

- (void)fillInImages {

  // fill in images
  for (int i = 0; i < numberOfPages; i++) {
    UIImageView *imageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];

    imageView.userInteractionEnabled = YES;
    imageView.image = [self.dataSource imageInScrollView:self atPageIndex:i];
    imageView.tag = i;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(imageViewDidPress:)];

    [gesture setNumberOfTouchesRequired:1];

    [imageView addGestureRecognizer:gesture];

    [autoScrollView addSubview:imageView];
  }
}

- (void)initPageControl {
  // pageControl
  pageControl = [[UIPageControl alloc]
      initWithFrame:CGRectMake(0, HEIGHT - PageControlMarginBottom, WIDTH,
                               PageControlHeight)];
  pageControl.userInteractionEnabled = NO;
  pageControl.numberOfPages = numberOfPages;

  pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
  pageControl.pageIndicatorTintColor = [UIColor grayColor];

  [self addSubview:pageControl];
}

#pragma mark - Custom Methods
- (void)turnPage {

  NSUInteger currentPage = pageControl.currentPage; // 获取当前的page
  currentPage++;
  currentPage = currentPage >= numberOfPages ? 0 : currentPage;

  [self scrollPageTo:currentPage animated:YES];
}

- (void)startAutoPlay {
  dispatch_async(dispatch_get_main_queue(), ^{
    [repeatingTimer invalidate];
    NSTimer *timer =
        [NSTimer scheduledTimerWithTimeInterval:AutoPlayTimeInterval
                                         target:self
                                       selector:@selector(turnPage)
                                       userInfo:nil
                                        repeats:YES];

    repeatingTimer = timer;
  });
}

- (void)stopAutoPlay {
  dispatch_async(dispatch_get_main_queue(), ^{
    [repeatingTimer invalidate];
    repeatingTimer = nil;
  });
}

- (void)imageViewDidPress:(UITapGestureRecognizer *)gesture {
  NSUInteger index = [gesture view].tag;

  if ([self.delegate
          respondsToSelector:@selector(pageScrollView:didSelectPageAt:)]) {
    [self.delegate pageScrollView:self didSelectPageAt:index];
  }
}

- (void)scrollPageTo:(NSUInteger)pageIndex animated:(BOOL)animated {
  if (pageIndex >= numberOfPages) {
    return;
  }
  [self.delegate pageScrollView:self willScrollToPage:pageIndex];
  [autoScrollView
      scrollRectToVisible:CGRectMake(WIDTH * pageIndex, 0, WIDTH, HEIGHT)
                 animated:animated];
  self.currentPageIndex = pageControl.currentPage = pageIndex;
  [self.delegate pageScrollView:self didScrollToPage:pageIndex];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

  [self stopAutoPlay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {

  if (scrollDirection == ScrollDirectionFromLeftToRight) {
    [self scrollPageTo:(self.currentPageIndex - 1)animated:YES];
  } else if (scrollDirection == ScrollDirectionFromRighToLeft) {
    [self scrollPageTo:(self.currentPageIndex + 1)animated:YES];
  }

  [self startAutoPlay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (lastContentOffsetX > scrollView.contentOffset.x) {
    scrollDirection = ScrollDirectionFromLeftToRight;
  } else if (lastContentOffsetX < scrollView.contentOffset.x) {
    scrollDirection = ScrollDirectionFromRighToLeft;
  }

  lastContentOffsetX = scrollView.contentOffset.x;
}

- (void)dealloc {
  [self stopAutoPlay];
}

@end
