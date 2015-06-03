//
//  OrderDetailCell.h
//  RKWXT
//
//  Created by app on 6/2/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

enum OrderDetailStyleCell{
    OrderDetailDefaultCell = 0,
    OrderDetailSwitchCell = 1
};

@interface OrderDetailCell : UITableViewCell{
    
}
@property (nonatomic,assign)NSInteger orderDetailStyle;
@property (nonatomic,strong)UILabel * defaultTitleKey;
@property (nonatomic,strong)UILabel * defaultTitleValue;


@end
