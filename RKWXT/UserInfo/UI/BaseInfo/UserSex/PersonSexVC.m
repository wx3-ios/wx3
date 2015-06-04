//
//  PersonSexVC.m
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonSexVC.h"

enum{
    Personal_Sex_Boy = 0,
    Personal_Sex_Girl,
    
    Personal_Sex_Invalid,
};

@interface PersonSexVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation PersonSexVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"性别选择"];

    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Personal_Sex_Invalid;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"commonCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger row = indexPath.row;
    switch (row) {
        case Personal_Sex_Boy:
            cell.textLabel.text = @"男";
            break;
        case Personal_Sex_Girl:
            cell.textLabel.text = @"女";
            break;
        default:
            break;
    }
    if(row == _sexSelectedIndex){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if(row == _sexSelectedIndex){
        return;
    }
    _sexSelectedIndex = row;
    [_tableView reloadData];
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectAtIndex:)]){
        [_delegate didSelectAtIndex:row];
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
