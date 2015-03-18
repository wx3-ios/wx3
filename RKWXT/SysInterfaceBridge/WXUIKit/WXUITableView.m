//
//  WXUITableView.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUITableView.h"

@implementation WXUITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        [self setTableFooterView:[self defaultFootView]];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage*)image{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image] ;
    [imgView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundView:imgView];
}

- (UIView*)defaultFootView{
    WXUIView *footView = [[WXUIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)] ;
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

#pragma mark 重载
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if(UITableViewRowAnimationNone != animation){
        [self beginUpdates];
        [super reloadSections:sections withRowAnimation:animation];
        [self endUpdates];
    }else{
        [super reloadSections:sections withRowAnimation:animation];
    }
}

- (void)reloadRowsAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation{
	if (!indexPath){
		return;
	}
	return [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if(UITableViewRowAnimationNone != animation){
        [self beginUpdates];
        [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [self endUpdates];
    }else{
        [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if(UITableViewRowAnimationNone != animation){
        [self beginUpdates];
        [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [self endUpdates];
    }else{
        [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    if(UITableViewRowAnimationNone != animation){
        [self beginUpdates];
        [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [self endUpdates];
    }else{
        [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    if(UITableViewRowAnimationNone != animation){
        [self beginUpdates];
        [super deleteSections:sections withRowAnimation:animation];
        [self endUpdates];
    }else{
        [super deleteSections:sections withRowAnimation:animation];
    }
}

@end
