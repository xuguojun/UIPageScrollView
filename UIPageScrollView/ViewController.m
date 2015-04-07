//
//  ViewController.m
//  UIPageScrollView
//
//  Created by guojun on 4/7/15.
//  Copyright (c) 2015 guojunxu. All rights reserved.
//

#import "ViewController.h"
#import "UIPageScrollView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController () <UIPageScrollViewDataSource,
                              UIPageScrollViewDelegate> {
  UIPageScrollView *pageScrollView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Pages";
  self.automaticallyAdjustsScrollViewInsets = NO;

  CGRect frame = CGRectMake(0, 64, SCREEN_WIDTH, 200);
  pageScrollView = [[UIPageScrollView alloc] initWithFrame:frame
                                            withDataSource:self
                                              withDelegate:self];

  [self.view addSubview:pageScrollView];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(startAutoPlay)
             name:UIApplicationDidBecomeActiveNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(stopAutoPlay)
             name:UIApplicationDidEnterBackgroundNotification
           object:nil];
}

#pragma mark - UIPageScrollViewDataSource
- (NSUInteger)numberOfPagesInScrollView:(UIPageScrollView *)pageScrollView {
  return 3;
}

- (UIImage *)imageInScrollView:(UIPageScrollView *)pageScrollView
                   atPageIndex:(NSUInteger)pageIndex {

  if (pageIndex % 2 == 0) {
    return [UIImage imageNamed:@"swift1"];
  } else {
    return [UIImage imageNamed:@"swift2"];
  }
}

- (id)pageInfoInScrollView:(UIPageScrollView *)pageScrollView
               atPageIndex:(NSUInteger)pageIndex {
  return nil;
}

- (void)startAutoPlay {
  [pageScrollView startAutoPlay];
}

- (void)stopAutoPlay {
  [pageScrollView stopAutoPlay];
}

#pragma mark - UIPageScrollViewDelegate
- (void)pageScrollView:(UIPageScrollView *)pageScrollView
      willScrollToPage:(NSUInteger)pageIndex {
  NSLog(@"Page Will Scroll to:%lu", (unsigned long)pageIndex);
}

- (void)pageScrollView:(UIPageScrollView *)pageScrollView
       didScrollToPage:(NSUInteger)pageIndex {
  NSLog(@"Page Did Scroll to:%lu", (unsigned long)pageIndex);
}

- (void)pageScrollView:(UIPageScrollView *)pageScrollView
       didSelectPageAt:(NSUInteger)pageIndex {
  NSLog(@"Page %lu Did Tapped", (unsigned long)pageIndex);
}
#pragma mark - Life Cycle Methods
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
