//
//  GoodsInfoEvaluationCell.m
//  RKWXT
//
//  Created by app on 16/4/28.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsInfoEvaluationCell.h"

@implementation GoodsInfoEvaluationCell

+ (instancetype)goodsInfoEvaluationCellWithTableVie:(UITableView*)tableView{
    static NSString *identifier = @"userCutCell";
    GoodsInfoEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsInfoEvaluationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
