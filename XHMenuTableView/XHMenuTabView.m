//
//  XHMenuTabView.m
//  XHMenuTableView
//
//  Created by liangxianhua on 16/6/1.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "XHMenuTabView.h"
#import "Masonry.h"
#import "HMSegmentedControl.h"
#import "ColorUtility.h"

#define CellID @"xhliang"
#define segTextColor @"888888"//分段控制器标题颜色 下划线颜色
#define segStripColor @"333333"//未选中颜色


@interface XHMenuTabView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIView *segmentView;

@property (nonatomic,strong) HMSegmentedControl *segment;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSArray *contentViews;

@property (nonatomic,strong) UIScrollView *currentContentView;

@property (nonatomic,strong) UICollectionView *myCollectionView;
//头视图Y坐标约束
@property (nonatomic,strong) NSLayoutConstraint *headViewOriginYConstraint;
//头视图高约束
@property (nonatomic,strong) NSLayoutConstraint *headViewSizeHeightConstraint;

@property (nonatomic,assign) CGFloat segmentViewH;

@property (nonatomic,assign) CGFloat MasContentOffset;

@property (nonatomic,assign) CGFloat headViewH;


@property (nonatomic,assign) BOOL isSwitching;//切换状态

@end

@implementation XHMenuTabView

static void *HorizontalScrollContext = &HorizontalScrollContext;
static void *HorizontalPagingViewPanContext = &HorizontalPagingViewPanContext;


+(XHMenuTabView *)initWithHeadView:(UIView *)headView headheight:(CGFloat)height contentViews:(NSArray *)contentViews titles:(NSArray *)titles frame:(CGRect )frame segmentHeight:(CGFloat )segmentH
{
    XHMenuTabView *selfView = [[XHMenuTabView alloc]initWithFrame:frame];
    selfView.isSwitching = NO;
    selfView.headView = headView;
    selfView.titles = titles;
    selfView.headViewH = height;
    selfView.contentViews = contentViews;
    selfView.segmentViewH = segmentH;
    [selfView addSubview:selfView.myCollectionView];
    [selfView prepareForHeadView];//头视图
    [selfView prepareForSegmentView];//分段
    [selfView prepareForContentViews];//滚动视图
    return selfView;
}

#pragma mark -
#pragma mark - lazy
-(UICollectionView *)myCollectionView
{
    if (_myCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing          = 0.0;
        layout.minimumInteritemSpacing     = 0.0;
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.pagingEnabled = YES;
        
        _myCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _myCollectionView;
}

-(HMSegmentedControl *)segment
{
    if (_segment == nil) {
        _segment = [[HMSegmentedControl alloc]initWithSectionTitles:self.titles];
        _segment.frame = CGRectMake(0, 0, self.frame.size.width, _segmentViewH);
        _segment.backgroundColor = [ColorUtility colorWithHexString:@"e9e9e9"];
        _segment.selectionIndicatorHeight = 2.0f;
        _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segment.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [ColorUtility colorWithHexString:segTextColor]};
        _segment.selectionIndicatorColor = [ColorUtility colorWithHexString:segTextColor];
        _segment.selectedSegmentIndex = 0;
        _segment.borderType = HMSegmentedControlBorderTypeBottom;
        _segment.borderColor = [UIColor lightGrayColor];
        [_segment addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _segment;
}

-(UIView *)segmentView
{
    if (_segmentView == nil) {
        _segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, _headViewH, self.frame.size.width, _segmentViewH)];
        _segmentView.backgroundColor = [UIColor greenColor];
        
        [_segmentView addSubview:self.segment];
    }
    return _segmentView;
}
#pragma mark -
#pragma mark - Masonry & Prepare
-(void)prepareForHeadView
{
    //保证有头视图
    if (self.headView) {
        self.headView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.headView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        self.headViewOriginYConstraint =
        [NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:self.headViewOriginYConstraint];
        
        self.headViewSizeHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.headViewH];
        [self.headView addConstraint:self.headViewSizeHeightConstraint];
        
    }
}

-(void)prepareForSegmentView
{
    if (self.segmentView) {
        self.segmentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.segmentView];
        [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self).offset(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_offset(0);
            make.height.mas_equalTo(self.segmentViewH);
        }];
        
    }
}
-(void)prepareForContentViews
{
    //保证有视图
    if (self.contentViews) {
        for (UIScrollView *scroll in self.contentViews) {
            //给头视图和分段视图腾地方
            [scroll setContentInset:UIEdgeInsetsMake(self.headViewH + self.segmentViewH, 0.f, scroll.contentInset.bottom, 0.f)];
            scroll.showsVerticalScrollIndicator = NO;
            scroll.alwaysBounceVertical = YES;
            //kvo
            [scroll addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&HorizontalScrollContext];
            //[scroll.panGestureRecognizer addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&HorizontalPagingViewPanContext];
        }
        self.currentContentView = self.contentViews[0];
    }
}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)seg
{
    [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:seg.selectedSegmentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.currentContentView.contentOffset.y < -(self.headViewH+self.segmentViewH)) {
        [self.currentContentView setContentOffset:CGPointMake(self.currentContentView.contentOffset.x, -(self.headViewH+self.segmentViewH)) animated:NO];
    }
    else
    {
        [self.currentContentView setContentOffset:self.currentContentView.contentOffset animated:NO];
    }
    self.currentContentView = self.contentViews[seg.selectedSegmentIndex];
}

#pragma mark -
#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentViews.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.isSwitching = YES;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    [cell.contentView addSubview:self.contentViews[indexPath.item]];
    UIScrollView *scroll = self.contentViews[indexPath.item];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(cell.contentView).offset(0);
        //make.bottom.equalTo(cell.contentView.mas_bottom).offset(scrollH == 0?0:scroll.frame.size.height -cell.contentView.frame.size.height);
        make.bottom.equalTo(cell.contentView).offset(0);
    }];
    self.currentContentView = scroll;
    [self updateContentView];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"----->%ld",indexPath.item);
    //self.segment.selectedSegmentIndex = indexPath.item;
    [self.segment setSelectedSegmentIndex:indexPath.item animated:YES];
}

#pragma mark -
#pragma mark - update masonry

- (void)setSegmentTopSpace:(CGFloat)segmentTopSpace {
    if(segmentTopSpace > self.headViewH) {
        _segDistanceTopHeight = self.headViewH;
    }else {
        _segDistanceTopHeight = segmentTopSpace;
    }
}

-(void)updateContentView
{
    self.isSwitching = YES;
    CGFloat headerViewDisplayHeight =self.headViewH + self.headView.frame.origin.y;
    [self.currentContentView layoutIfNeeded];
    if (self.currentContentView.contentOffset.y < -self.segmentViewH) {
        [self.currentContentView setContentOffset:CGPointMake(0, -headerViewDisplayHeight - self.segmentViewH) animated:NO];
        
    }
    else
    {
        [self.currentContentView setContentOffset:CGPointMake(0, self.currentContentView.contentOffset.y - headerViewDisplayHeight) animated:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0)), dispatch_get_main_queue(), ^{
        self.isSwitching = NO;
    });
        
    
}

//过滤手势
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if(point.x < 20) {
        return NO;
    }
    return YES;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isDescendantOfView:self.headView]||[view isDescendantOfView:self.segmentView]) {
        self.myCollectionView.scrollEnabled = NO;
    }
    return view;
}



#pragma mark -
#pragma mark - Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //过滤点击和切换状态
    if (context == &HorizontalPagingViewPanContext) {
        self.myCollectionView.scrollEnabled = YES;
        UIGestureRecognizerState state = [change[NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateFailed) {
            return;
        }
    }
    else if (context == &HorizontalScrollContext){
        if (self.isSwitching) {
            return;
        }
        CGFloat oldOffsetY = [change[NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat newOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat changeY = newOffsetY - oldOffsetY;
        CGFloat headerViewHeight    = self.headViewH;
        CGFloat headerDisplayHeight = self.headViewH+self.headViewOriginYConstraint.constant;
        //NSLog(@"---->%f",-newOffsetY);
        if (changeY >= 0) {
            if (headerDisplayHeight - changeY <= self.segDistanceTopHeight) {
                self.headViewOriginYConstraint.constant = -headerViewHeight+self.segDistanceTopHeight;
            }
            else
            {
                self.headViewOriginYConstraint.constant -= changeY;
                
            }
            if (headerDisplayHeight <= self.segDistanceTopHeight) {
                self.headViewOriginYConstraint.constant = -headerViewHeight+self.segDistanceTopHeight;
            }
            if (self.headViewOriginYConstraint.constant >= 0 && self.magnifyTopConstraint) {
                self.magnifyTopConstraint.constant = -self.headViewOriginYConstraint.constant;
            }
        }
        //向下
        else
        {
            if (headerDisplayHeight+self.segmentViewH < -newOffsetY) {
                self.headViewOriginYConstraint.constant = -self.headViewH-self.segmentViewH-self.currentContentView.contentOffset.y;
            }
            
            if (self.headViewOriginYConstraint.constant > 0 && self.magnifyTopConstraint) {
                self.magnifyTopConstraint.constant = -self.headViewOriginYConstraint.constant;
            }
        }
    }
}



@end
