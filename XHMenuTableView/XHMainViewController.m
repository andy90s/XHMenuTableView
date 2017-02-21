//
//  XHMainViewController.m
//  XHMenuTableView
//
//  Created by liangxianhua on 16/6/1.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "XHMainViewController.h"

#import "XHHeaderView.h"

#import "Masonry.h"

#import "XHMenuTabView.h"

#import "XHTableView.h"




@interface XHMainViewController ()

{
    XHMenuTabView *_mainView;    
}

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (nonatomic,strong) UIView *headView;


@end

static NSString *way = @"normal";

@implementation XHMainViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"XHMainViewController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareForUI];
}

-(void)prepareForUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Demo";
    XHHeaderView *header = [XHHeaderView initHeaderView];
    header.imgView.image = [UIImage imageNamed:@"re0"];
    
    NSArray *titles = @[@"   今天   ",@"当月",@"自定义33333"];
    XHTableView *tab0 = [XHTableView initViewWithContent:@"我是tab0"];
    XHTableView *tab1 = [XHTableView initViewWithContent:@"我是tab1"];
    XHTableView *tab2 = [XHTableView initViewWithContent:@"我是tab2"];
    //如果想修改分段按钮样式 直接找到HMSegment修改即可
    _mainView = [XHMenuTabView initWithHeadView:header headheight:200.f contentViews:@[tab0,tab1,tab2] titles:titles frame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64) segmentHeight:40];
    //放大效果 如果不需要下面代码不要就OK
#if 1
    [header.imgView setContentMode:UIViewContentModeScaleAspectFill];
    header.imgView.clipsToBounds = YES;
    _mainView.magnifyTopConstraint = header.imageTopConstaint;
#endif
    
    [self.view addSubview:_mainView];
    [self.view bringSubviewToFront:self.navView];
}


-(void)setMasonry
{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_offset(64);
    }];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navView);
        make.bottom.equalTo(self.navView.mas_bottom).offset(-10);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
