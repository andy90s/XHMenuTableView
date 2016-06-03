//
//  XHMenuTabView.h
//  XHMenuTableView
//
//  Created by liangxianhua on 16/6/1.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface XHMenuTabView : UIView
/**
 *  参数说明
 *
 *  @param headView     头视图view
 *  @param height       头视图height
 *  @param contentViews 需滚动视图(tableview,collectionView)
 *  @param titles       分段标题
 *  @param frame        自身frame
 *  @param segmentH     分段高度
 *
 *  @return self
 */
+(XHMenuTabView *)initWithHeadView:(UIView *)headView headheight:(CGFloat)height contentViews:(NSArray *)contentViews titles:(NSArray *)titles frame:(CGRect )frame segmentHeight:(CGFloat )segmentH;
//悬停位置 距离头视图的顶端 默认悬停在导航栏下面
@property (nonatomic,assign) CGFloat segDistanceTopHeight;

//下拉时如需要放大，则传入的图片的上边距约束，默认为不放大
@property (nonatomic, strong) NSLayoutConstraint *magnifyTopConstraint;


@end
