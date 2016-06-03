//
//  XHTableView.m
//  XHMenuTableView
//
//  Created by liangxianhua on 16/6/2.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "XHTableView.h"

@interface XHTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *title;

@end
static NSString *cellId = @"hello";
@implementation XHTableView

+(XHTableView *)initViewWithContent:(NSString *)content
{
    XHTableView *tableView = [[XHTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.title = content;
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    return tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = self.title;
    return cell;
}

@end
