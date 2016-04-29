//
//  NewGEvalutionInfoCell.m
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NewGEvalutionInfoCell.h"
#import "WXRemotionImgBtn.h"
#import "GoodsEvaluationEntity.h"

@interface NewGEvalutionInfoCell ()
{
    WXRemotionImgBtn *_imgView;
    UILabel *_nameL;
    UILabel *_timeL;
    UILabel *_info;
    NSMutableArray *_evaluImgArr;
    NSMutableArray *_evaluImgBackArr;
}
@end

@implementation NewGEvalutionInfoCell

+ (instancetype)goodsEvalInfoCellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"NewGEvalutionInfoCell";
    NewGEvalutionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGEvalutionInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _evaluImgArr = [NSMutableArray array];
        _evaluImgBackArr = [NSMutableArray array];
        
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat btnW = 40;
        _imgView = [[WXRemotionImgBtn alloc]initWithFrame:CGRectMake(xOffset, yOffset, btnW, btnW)];
        [_imgView setBorderRadian:20 width:0 color:[UIColor clearColor]];
        [self.contentView addSubview:_imgView];
        
        xOffset += btnW + 10;
        yOffset += 5;
        CGFloat nameH = 15;
        CGFloat nameW = 120;
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameW, nameH)];
        _nameL.font = WXFont(14.0);
        _nameL.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameL];
        
        yOffset += nameH + 5;
        _timeL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameW, nameH)];
        _timeL.font = WXFont(14.0);
        _timeL.textColor = [UIColor colorWithHexString:@"969696"];
        [self.contentView addSubview:_timeL];
        
        CGFloat imgW = 14;
        CGFloat margin = 2;
        int count = 5;
        UIImage *image = [UIImage imageNamed:@"grade"];
        UIImage *imageS = [UIImage imageNamed:@"gradeS"];
        xOffset = self.width - imgW * count - 10 - (count - 1) * margin;
        for (int i = 0 ; i < 5; i++) {
            CGFloat X = xOffset + i * (imgW + 2);
          UIImageView *evaluImg = [[UIImageView alloc]initWithFrame:CGRectMake(X, 15, imgW, imgW)];
            evaluImg.image = image;
            evaluImg.hidden = YES;
            
          UIImageView *evaluImgBack = [[UIImageView alloc]initWithFrame:evaluImg.frame];
            evaluImgBack.image= imageS;
            evaluImgBack.hidden = YES;
            [self.contentView addSubview:evaluImg];
            [self.contentView addSubview:evaluImgBack];
            [_evaluImgArr addObject:evaluImg];
            [_evaluImgBackArr addObject:evaluImgBack];
        }
        
        
        yOffset = 50;
        xOffset = 10;
        _info = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameW, 0)];
        _info.font = WXFont(14.0);
        _info.textColor = [UIColor colorWithHexString:@"000000"];
        _info.numberOfLines = 0;
        _info.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_info];
        
    }
    return self;
}


-(void)load{
    GoodsEvaluationEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.userIcon];
    [_imgView load];
    
    _nameL.text = [self hiddenCharacters:entity];
    _timeL.text = [UtilTool getDateTimeFor:[entity.evalTime integerValue] type:2];
    _info.text = entity.enalContent;
    _info.height = [NSString sizeWithString:entity.enalContent font:[UIFont systemFontOfSize:14]].height;
    
    for (int i = 0; i < 5; i++) {
        if (i < entity.count) {
            UIImageView *img = _evaluImgArr[i];
            img.hidden = NO;
            
            UIImageView *image = _evaluImgBackArr[i];
            image.hidden = YES;
        }
        if (i > entity.count - 1) {
            UIImageView *img1 = _evaluImgBackArr[i];
            img1.hidden = NO;
            
            UIImageView *img = _evaluImgArr[i];
            img.hidden = YES;
        }
    }
}

- (NSString*)hiddenCharacters:(GoodsEvaluationEntity*)entity{
    NSString *userName = entity.userName.length == 0 ? entity.userPhone : entity.userName;
    if (userName.length == 1) {
        userName = @"*";
    }else if (userName.length == 2){
        NSString *name = [userName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        userName = [NSString stringWithFormat:@"%@",name];
    }else if (userName.length >= 3){
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",userName];
        NSMutableString *str1 = [[NSMutableString alloc]init];
        for (int i = 0; i < str.length - 2; i++) {
            NSString *s = @"*";
            [str1 appendString:s];
            
        }
        [str deleteCharactersInRange:NSMakeRange(1, str.length - 2)];
        [str insertString:str1 atIndex:1];
        userName = str;
    }
    
    return userName;
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    CGFloat iconH = 40;
    CGFloat marginH = 20;
    GoodsEvaluationEntity *entity = cellInfo;
    CGFloat labelH = [NSString sizeWithString:entity.enalContent font:[UIFont systemFontOfSize:14]].height;
    CGFloat rowHeight = labelH + iconH + marginH;
    return rowHeight;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

@end
