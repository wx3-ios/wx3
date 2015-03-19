//
//  ContactsCell.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-8.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorLabel.h"
#import "ContactData.h"

@interface ContactsCell : UITableViewCell{
    
    WXUIImageView * _imageView;
}


@property (nonatomic, strong) IBOutlet UILabel *alphaLabel;
@property (nonatomic, strong) IBOutlet ColorLabel *nameLabel;
@property (nonatomic, strong) IBOutlet ColorLabel *pinyinLabel;
@property (nonatomic, strong) IBOutlet ColorLabel *phoneLabel;
@property (nonatomic, strong) IBOutlet UILabel *areaLabel;

@property (nonatomic, assign) ContactData *contact;
@property (nonatomic, assign) BOOL searchMode;

@end
