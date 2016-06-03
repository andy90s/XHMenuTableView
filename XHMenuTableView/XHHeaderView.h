//
//  XHHeaderView.h
//  XHMenuTableView
//
//  Created by liangxianhua on 16/6/3.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHHeaderView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstaint;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

+(XHHeaderView *)initHeaderView;
@end
