//
//  BaseSearchLV.h
//  WXServer
//
//  Created by le ting on 6/12/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"

@protocol BaseSearchLVDelegate;
@interface BaseSearchLV : WXUIView

@property (nonatomic,readonly)WXUITableView *tableView;
@property (nonatomic,readonly)WXUISearchBar *searchBar;
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,assign)id<BaseSearchLVDelegate>delegate;

- (id)initWithFrame:(CGRect)frame searchContentsVC:(WXUIViewController*)contentsController;

////虚函数
- (WXUITableViewCell*)createSearchCellOfIdentifier:(NSString*)identifier;
- (CGFloat)cellHeightOfEntity:(id)entity;
@end

@protocol BaseSearchLVDelegate <NSObject>
- (void)didSelectCellInfo:(id)entity;
@end
