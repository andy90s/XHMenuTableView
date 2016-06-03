//
//  XHHeaderView.m
//  XHMenuTableView
//
//  Created by liangxianhua on 16/6/3.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "XHHeaderView.h"

@implementation XHHeaderView

+(XHHeaderView *)initHeaderView
{
    XHHeaderView * view = [[NSBundle mainBundle] loadNibNamed:@"XHHeaderView" owner:self options:nil][0];
    return view;
}

@end
