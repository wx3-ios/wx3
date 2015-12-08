//
//  LMSellerInfoDesCell.h
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMSellerInfoDesCellHeight (80)

@protocol LMSellerInfoDesCellDelegate;
@interface LMSellerInfoDesCell : WXUITableViewCell
@property (nonatomic,assign) id<LMSellerInfoDesCellDelegate>delegate;
@end

@protocol LMSellerInfoDesCellDelegate <NSObject>
-(void)lmShopInfoDesCallBtnClicked:(NSString*)sellerPhone;

@end
