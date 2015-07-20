//
//  AboutVC.m
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutVC.h"

enum{
    About_Section_Wx = 0,
    About_Section_Shop,
    
    About_Section_Invalid,
};

@interface AboutVC(){
    UITableView *_tableView;
}
@end

@implementation AboutVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"关于"];
}

@end
