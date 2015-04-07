//
//  UIPageScrollView.h
//  UIPageScrollView
//
//  Created by guojun on 4/7/15.
//  Copyright (c) 2015 guojunxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPageScrollView;

#pragma mark - UIPageScrollViewDataSource
@protocol UIPageScrollViewDataSource <NSObject>

@required
- (NSUInteger)numberOfPagesInScrollView:(UIPageScrollView *)pageScrollView;
- (UIImage *)imageInScrollView:(UIPageScrollView *)pageScrollView
                   atPageIndex:(NSUInteger)pageIndex;
- (id)pageInfoInScrollView:(UIPageScrollView *)pageScrollView
               atPageIndex:(NSUInteger)pageIndex;

@end

#pragma mark - UIPageScrollViewDelegate
@protocol UIPageScrollViewDelegate <NSObject>

@optional

- (void)pageScrollView:(UIPageScrollView *)pageScrollView
      willScrollToPage:(NSUInteger)pageIndex;
- (void)pageScrollView:(UIPageScrollView *)pageScrollView
       didScrollToPage:(NSUInteger)pageIndex;
- (void)pageScrollView:(UIPageScrollView *)pageScrollView
       didSelectPageAt:(NSUInteger)pageIndex;

@end

@interface UIPageScrollView : UIView

@property(nonatomic, weak) id<UIPageScrollViewDataSource> dataSource;
@property(nonatomic, weak) id<UIPageScrollViewDelegate> delegate;
@property(nonatomic, assign, readonly) NSUInteger currentPageIndex;

- (instancetype)initWithFrame:(CGRect)frame
               withDataSource:(id<UIPageScrollViewDataSource>)dataSource
                 withDelegate:(id<UIPageScrollViewDelegate>)delegate;
- (void)startAutoPlay;
- (void)stopAutoPlay;

@end
