//
//  ContactsCell.m
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-8.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "ContactsCell.h"
#import "ContactUitl.h"
#import "UIView+Sizing.h"
#define kImageViewSize CGSizeMake(30.0,30.0)
@implementation ContactsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageView = [[WXUIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewSize.width, kImageViewSize.height)];
        [_imageView toRound];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _nameLabel.rangeColor = _pinyinLabel.rangeColor = _phoneLabel.rangeColor = THEME_COLOR;
    _nameLabel.rangeHighlightedColor = _pinyinLabel.rangeHighlightedColor = _phoneLabel .rangeHighlightedColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContact:(ContactData *)contact
{
    
    _contact = contact;
    PhoneData *pd = _searchMode ? _contact.searchPhoneData : _contact.defaultPhoneData;
    _nameLabel.colorMode = _pinyinLabel.colorMode = _phoneLabel.colorMode = _searchMode;
    
    _areaLabel.text = pd.area;
    _pinyinLabel.hidden = contact.isEnglish || !_searchMode;
    
    [_alphaLabel setWidth:_searchMode ? 0 : CGRectGetHeight(_alphaLabel.bounds)];
    
    //已命名的联系人
    if (contact.name.length > 0) {
        _nameLabel.text = contact.name;
        _pinyinLabel.text = contact.namePinYin;
        _phoneLabel.text = [pd displayNumber];
        if (_searchMode) {
            _phoneLabel.text = pd.displayNumber;
            
            [self fillNameLabel:_nameLabel];
            [self fillPinyinLabel:_pinyinLabel];
            [self fillPhoneLabel:_phoneLabel withPhoneData:pd];
        }
    }
    else
    {
//        _alphaLabel.text = CONTACT_ALPHA_POUND;
        _nameLabel.text = [pd displayNumber];
        _phoneLabel.text = @"";
        _pinyinLabel.text = @"";
        if (_searchMode) {
            _nameLabel.text = pd.displayNumber;
            [self fillPhoneLabel:_nameLabel withPhoneData:pd];
        }
    }
}



- (void)fillPhoneLabel:(ColorLabel *)label withPhoneData:(PhoneData *)pd
{
    label.ranges = nil;
    label.ranges = @[[NSValue valueWithRange: pd.displayRange]];//pd.colorRange;
}


- (void)fillPinyinLabel:(ColorLabel *)label
{
    label.ranges = nil;
    //不是英文
    if (!_contact.isEnglish) {
        
        NSMutableArray *pyRangeArray = nil;
        if (_contact.rangeNamePinYin.length == 0 && _contact.rangeNamePY.length > 0)
        {
            pyRangeArray = [NSMutableArray array];
            int searchIndex = 0;
            for (int i = 0; i < _contact.rangeNamePY.length; i++)
            {
                NSString *key = [_contact.namePY substringWithRange:NSMakeRange(i + _contact.rangeNamePY.location, 1)];
                NSRange range = [_contact.namePinYin rangeOfString:key options:NSCaseInsensitiveSearch range:NSMakeRange(searchIndex, _contact.namePinYin.length - searchIndex)];
                searchIndex = range.location + range.length;
                [pyRangeArray addObject:[NSValue valueWithRange:range]];
            }
            
        }
        
        label.ranges = pyRangeArray  ? pyRangeArray : @[[NSValue valueWithRange: _contact.rangeNamePinYin]];
    }
}


- (void)fillNameLabel:(ColorLabel *)label
{
    label.ranges = nil;
    if (self.contact.rangeNamePY.length > 0) {
        label.ranges = @[[NSValue valueWithRange: _contact.rangeNamePY]];
    }
    else if (_contact.rangeName.length > 0)
    {
        label.ranges = @[[NSValue valueWithRange: _contact.rangeName]];
    }
}

@end
