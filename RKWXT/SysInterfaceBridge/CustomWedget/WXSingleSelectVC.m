//
//  WXSingleSelectVC.m
//  CallTesting
//
//  Created by le ting on 5/26/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXSingleSelectVC.h"

@interface WXSingleSelectVC ()<UITableViewDelegate,UITableViewDataSource>
{
    WXUITableView *_tableView;
    NSInteger _selectedIndex;
    NSInteger _defaultSelectedIndex;
}
@end

@implementation WXSingleSelectVC
@synthesize cstTitle = _cstTitle;
@synthesize textArray = _textArray;
@synthesize iconArray = _iconArray;
@synthesize delegate = _delegate;
@synthesize defaultSelectedIndex = _defaultSelectedIndex;

- (void)dealloc{
    _delegate = nil;
//    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCSTTitle:_cstTitle];
    [self setBackNavigationBarItem];
    
    _tableView = [[WXUITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];    
}

- (void)setBackgroundColor:(UIColor *)color{
    [_tableView setBackgroundColor:color];
}

- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex{
    _defaultSelectedIndex = defaultSelectedIndex;
    _selectedIndex = _defaultSelectedIndex;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_textArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    WXUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    NSInteger row = indexPath.row;
    NSString *text = [_textArray objectAtIndex:row];
    [cell.textLabel setText:text];
    if(_iconArray){
        UIImage *icon = [_iconArray objectAtIndex:row];
        [cell.imageView setImage:icon];
    }
    if(row == _selectedIndex){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger row = indexPath.row;
    if(row == _selectedIndex){
        return;
    }
    NSIndexPath *lastSelectedIndexpath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    _selectedIndex = row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lastSelectedIndexpath,indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectedAtIndex:)]){
        [_delegate didSelectedAtIndex:row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
