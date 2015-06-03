//
//  CartDetailCell.m
//  RKWXT
//
//  Created by app on 5/30/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "CartDetailCell.h"

@implementation CartDetailCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviewFrame];
    }
    return self;
}

-(void)initSubviewFrame{
    UIButton * btnSelectAll = [[UIButton alloc]initWithFrame:CGRectMake(15, 30, 15, 15)];
    [btnSelectAll setImage:[UIImage imageNamed:@"CircleAll.png"] forState:UIControlStateNormal];
    [btnSelectAll addTarget:self action:@selector(selectGoods) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnSelectAll];
    
    UIImageView * ivProThumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(35, 10, 55, 55)];
    ivProThumbnail.image = [UIImage imageNamed:@"Product"];
    [self.contentView addSubview:ivProThumbnail];
    
    CGFloat titleX = CGRectGetMaxX(ivProThumbnail.frame)+6;
    CGFloat titleW = IPHONE_SCREEN_WIDTH-titleX;
    UILabel * lbProTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, 10, titleW-50, 18)];
    lbProTitle.text = @"百达翡丽PATEKPHILIPR-复艳王2015广场舞服装夏新款套装春短袖套裙裤中老年+女舞蹈演出服";
    lbProTitle.font = [UIFont systemFontOfSize:12.0];
    lbProTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:lbProTitle];
    
    UILabel * lbPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbProTitle.frame), 10, 50, 18)];
    lbPrice.text = @"￥188.00";
    lbPrice.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:lbPrice];
    
    CGFloat lbCategoryY = CGRectGetMaxY(lbProTitle.frame);
    UILabel * lbCategory = [[UILabel alloc]initWithFrame:CGRectMake(titleX, lbCategoryY, titleW, 18)];
    lbCategory.text = @"颜色分类:金壳白面男款";
    lbCategory.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:lbCategory];
    
    CGFloat lbSPriceX = CGRectGetMaxX(lbCategory.frame);
    UILabel * lbSPrice = [[UILabel alloc]initWithFrame:CGRectMake(lbSPriceX, lbCategoryY, 50, 18)];
    lbSPrice.text = @"￥388.00";
    lbSPrice.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:lbSPrice];
    
//    UIStepper *stepper = [[UIStepper alloc] init];
//    stepper.center = CGPointMake(15, 65);
//    stepper.minimumValue = 1; //设置最小值
//    stepper.maximumValue = 30; //设置最大值
//    stepper.stepValue = 1; //每次递增2
//    stepper.value = 1; //初始值
//    [stepper setWraps:YES]; //是否循环
//    [stepper addTarget:self action:@selector(doTest) forControlEvents:UIControlEventValueChanged];
//    [self.contentView addSubview:stepper];
    
//    UIButton *
}

-(void)selectGoods{
    if (!_isSelect == TRUE) {
        NSLog(@"选择了");
    }else{
        NSLog(@"没有选择");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
