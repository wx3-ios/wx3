//
//  WXMutiScanView.m
//  WXScrollBrowser
//
//  Created by le ting on 6/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXMutiScanView.h"

typedef struct{
    CGFloat sectionLength;
    CGFloat rowLenght;
}S_SectionSize;

typedef struct {
    CGFloat sectionOffset;
    CGFloat rowOffset;
}S_SectionPoint;

typedef struct {
    S_SectionPoint origin;
    S_SectionSize size;
}S_SectionRect;

#define D_Unvalide_Section -1
@interface WXMutiScanView()<UIScrollViewDelegate>
{
    WXUIScrollView *_scrollView;
    E_MultiScanViewDirection _direction;
    //正在使用的cell
    NSMutableDictionary *_usingCellDictionary;
    //没有在使用的Cell
    NSMutableArray *_reusingCellArray;
}
@end

@implementation WXMutiScanView

- (void)dealloc{
    _delegate = nil;
    _dataSource = nil;
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_usingCellDictionary);
    RELEASE_SAFELY(_reusingCellArray);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame direction:(E_MultiScanViewDirection)direction{
    if(self = [super initWithFrame:frame]){
        _usingCellDictionary = [[NSMutableDictionary alloc] init];
        _reusingCellArray = [[NSMutableArray alloc] init];
        _direction = direction;
        _scrollView = [[WXUIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setDelegate:self];
//        [_scrollView setContentSize:[self currentContentSize]];
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [_scrollView setContentSize:[self currentContentSize]];
    [self loadCellsAtSectionOffset:0.0];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    for(WXMutiScanViewCell *cell in _reusingCellArray){
        if([cell.reuseIdentifier isEqualToString:identifier]){
            return cell;
        }
    }
    return nil;
}

- (void)loadCellsAtSectionOffset:(CGFloat)sectionOffset{
    S_SectionSize sectionSize = [self convertToSectionSize:self.bounds.size];
    CGFloat maxSectionOffset = sectionOffset + sectionSize.sectionLength;
    NSInteger minSection = [self sectionAtSectionOffset:sectionOffset];
    NSInteger maxSection = [self sectionAtSectionOffset:maxSectionOffset];
    
    //remove不可见的cell
    [self removeUnVisibleCellFromMinSection:minSection maxSection:maxSection];
    
    //增加新的cell
    for(NSInteger section = minSection; section <= maxSection; section++){
        NSInteger rowNumber = [self numberOfRowsInSection:section];
        for(NSInteger row = 0; row < rowNumber; row++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            //如果不存在这个cell 才会重新加载~
            if(![self cellExistAtIndexPath:indexPath]){
                WXMutiScanViewCell *cell = [_dataSource multiScanView:self cellForRowAtIndexPath:indexPath];
                CGRect cellFrame = [self frameForCellAtIndexPath:indexPath];
                if(!cell){
                    KFLog_Normal(YES, @"获取了一个空的cell");
                }else{
                    [cell setFrame:cellFrame];
                    //如果被重用了~
                    if([_reusingCellArray indexOfObject:cell] != NSNotFound){
                        [_reusingCellArray removeObject:cell];
                        KFLog_Normal(YES, @"cell 被重用了~ indexpath=%@",indexPath);
                    }
                    [_usingCellDictionary setObject:cell forKey:indexPath];
                    [_scrollView addSubview:cell];
                }
            }
        }
    }
}

#pragma mark cell的位置信息
//获取cell的indexPath
- (NSIndexPath*)indexPathOfCell:(WXMutiScanViewCell *)cell{
    return nil;
}

- (S_SectionRect)sectionRectForCellAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger sectionIndex = indexPath.section;
    NSInteger rowIndex = indexPath.row;
    
    CGFloat sectionLength = 0.0;
    CGFloat rowLength = 0.0;
    for(NSInteger section = 0; section <= sectionIndex; section++){
        CGFloat headHeight = [self heightForHeaderInSection:section];
        sectionLength += headHeight;
        NSInteger lastSection = section - 1;
        if(lastSection >= 0){
            sectionLength += [self heightForSection:lastSection];
        }
    }
    
    CGFloat rowGap = [self rowGapAtSection:sectionIndex];
    for(NSInteger row = 0; row <= rowIndex; row++){
        rowLength += rowGap;
        NSInteger lastRow = row - 1;
        if(lastRow >= 0){
            rowLength += [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
        }
    }
    S_SectionRect rect;
    S_SectionPoint point;
    point.sectionOffset = sectionLength;
    point.rowOffset = rowLength;
    rect.origin = point;
    
    S_SectionSize size;
    size.sectionLength = [self heightForSection:sectionIndex];
    size.rowLenght = [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
    rect.size = size;
    return rect;
}
- (CGRect)frameForCellAtIndexPath:(NSIndexPath*)indexPath{
    S_SectionRect rect = [self sectionRectForCellAtIndexPath:indexPath];
    return [self convertToRect:rect];
}

- (BOOL)cellExistAtIndexPath:(NSIndexPath*)indexPath{
    return [_usingCellDictionary objectForKey:indexPath] != nil;
}

- (void)removeUnVisibleCellFromMinSection:(NSInteger)minSection maxSection:(NSInteger)maxSection{
    //把没有显示的cell remove出去~
    NSArray *keys = [_usingCellDictionary allKeys];
    for(NSIndexPath *indexpathKey in keys){
        if([indexpathKey isKindOfClass:[NSIndexPath class]]){
            NSInteger section = indexpathKey.section;
            if(section < minSection || section > maxSection){
                WXMutiScanViewCell *cell = [_usingCellDictionary objectForKey:indexpathKey];
                [_reusingCellArray addObject:cell];
                [_usingCellDictionary removeObjectForKey:indexpathKey];
                if([cell superview]){
                    [cell removeFromSuperview];
                }
            }
        }
    }
}

#pragma mark 内部调用
- (CGFloat)sectionAtSectionOffset:(CGFloat)sectionOffset{
    NSInteger section = [self numberOfSections];
    CGFloat tempSectionOffset = 0;
    for(int i = 0; i < section; i++){
        CGFloat headHeight = [self heightForHeaderInSection:i];
        CGFloat sectionHeigh = [self heightForSection:i];
        tempSectionOffset += headHeight+sectionHeigh;
        if(tempSectionOffset >= sectionOffset){
            return i;
        }
    }
    KFLog_Normal(YES, @"scroll to unknown position");
    return section - 1;
}

//相当于contentSize section方向的长度~
- (CGFloat)contentSectionHeight{
    NSInteger section = [self numberOfSections];
    CGFloat contentSectionHeight = 0;
    for(int i = 0; i < section; i++){
        CGFloat headHeight = [self heightForHeaderInSection:i];
        CGFloat sectionHeigh = [self heightForSection:i];
        contentSectionHeight += headHeight+sectionHeigh;
    }
    BOOL paginEnable = [self pagingEnable];
    if(paginEnable){
        S_SectionSize sectionSize = [self convertToSectionSize:self.bounds.size];
        CGFloat sectionHeight = sectionSize.sectionLength;
        contentSectionHeight = ceilf(contentSectionHeight/sectionHeight)*sectionHeight;
    }
    return contentSectionHeight;
}

- (CGSize)currentContentSize{
    CGFloat contentSectionHeight = [self contentSectionHeight];
    CGSize size = CGSizeMake(contentSectionHeight, self.bounds.size.height);
    if(_direction == E_MultiScanViewDirection_Vertical){
        size = CGSizeMake(self.bounds.size.width, contentSectionHeight);
    }
    return size;
}

#pragma mark datasource and delegate
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    if(_dataSource && [_dataSource respondsToSelector:@selector(multiScanView:numberOfRowsInSection:)]){
        row = [_dataSource multiScanView:self numberOfRowsInSection:section];
    }
    return row;
}

- (WXMutiScanViewCell*)cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(_dataSource && [_dataSource respondsToSelector:@selector(multiScanView:cellForRowAtIndexPath:)], @"%s has not found",__func__);
    return [_dataSource multiScanView:self cellForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSections{
    NSAssert(_dataSource && [_dataSource respondsToSelector:@selector(numberOfSectionsInMutiScanView:)], @"%s has not found",__func__);
    return [_dataSource numberOfSectionsInMutiScanView:self];
}

- (CGFloat)heightForSection:(NSInteger)section{
    NSAssert(_delegate && [_delegate respondsToSelector:@selector(multiScanView:heightForSection:)], @"%s has not found",__func__);
    return [_delegate multiScanView:self heightForSection:section];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(_delegate && [_delegate respondsToSelector:@selector(multiScanView:heightForRowAtIndexPath:)], @"%s has not found",__func__);
    return [_delegate multiScanView:self heightForRowAtIndexPath:indexPath];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(_delegate && [_delegate respondsToSelector:@selector(multiScanView:heightForHeaderInSection:)]){
        height = [_delegate multiScanView:self heightForHeaderInSection:section];
    }
    return height;
}

- (BOOL)pagingEnable{
    BOOL pagingEnable = NO;
    if(_delegate && [_delegate respondsToSelector:@selector(pagingEnable:)]){
        pagingEnable = [_delegate pagingEnable:self];
    }
    return pagingEnable;
}

- (CGFloat)rowGapAtSection:(NSInteger)section{
    CGFloat mutiScanViewRowLength = [self convertToSectionRect:self.bounds].size.rowLenght;
    NSInteger rowCount = [self numberOfRowsInSection:section];
    CGFloat rowSumLength = 0;
    for(NSInteger row = 0; row < rowCount; row++){
        rowSumLength += [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    return (mutiScanViewRowLength - rowSumLength)/(rowCount + 1);
}

#pragma mark 坐标转换~
- (S_SectionSize)convertToSectionSize:(CGSize)size{
    S_SectionSize sectionSize;
    if(_direction == E_MultiScanViewDirection_Horizonal){
        sectionSize.sectionLength = size.width;
        sectionSize.rowLenght = size.height;
    }else{
        sectionSize.rowLenght = size.width;
        sectionSize.sectionLength = size.height;
    }
    return sectionSize;
}

- (S_SectionPoint)convertToSectionPoint:(CGPoint)point{
    S_SectionPoint sectionPoint;
    if(_direction == E_MultiScanViewDirection_Horizonal){
        sectionPoint.sectionOffset = point.x;
        sectionPoint.rowOffset = point.y;
    }else{
        sectionPoint.sectionOffset = point.y;
        sectionPoint.rowOffset = point.x;
    }
    return sectionPoint;
}

- (S_SectionRect)convertToSectionRect:(CGRect)rect{
    S_SectionRect sectionRect;
    sectionRect.origin = [self convertToSectionPoint:rect.origin];
    sectionRect.size = [self convertToSectionSize:rect.size];
    return sectionRect;
}

- (CGPoint)convertToPoint:(S_SectionPoint)sectionPoint{
    CGPoint pt;
    if(_direction == E_MultiScanViewDirection_Horizonal){
        pt.x = sectionPoint.sectionOffset;
        pt.y = sectionPoint.rowOffset;
    }else{
        pt.x = sectionPoint.rowOffset;
        pt.y = sectionPoint.sectionOffset;
    }
    return pt;
}

- (CGSize)convertToSize:(S_SectionSize)sectionSize{
    CGSize size;
    if(_direction == E_MultiScanViewDirection_Horizonal){
        size.width = sectionSize.sectionLength;
        size.height = sectionSize.rowLenght;
    }else{
        size.width = sectionSize.rowLenght;
        size.height = sectionSize.sectionLength;
    }
    return size;
}

- (CGRect)convertToRect:(S_SectionRect)sectionRect{
    CGRect rect;
    rect.origin = [self convertToPoint:sectionRect.origin];
    rect.size = [self convertToSize:sectionRect.size];
    return rect;
}

#pragma mark UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    S_SectionPoint sectionOffset = [self convertToSectionPoint:contentOffset];
    [self loadCellsAtSectionOffset:sectionOffset.sectionOffset];
}
@end
