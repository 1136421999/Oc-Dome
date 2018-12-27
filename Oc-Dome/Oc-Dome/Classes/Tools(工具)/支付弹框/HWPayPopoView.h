//
//  HWPayPopoView.h
//  kzyjsq
//
//  Created by 李含文 on 2018/12/17.
//  Copyright © 2018年 李含文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /* 取消 */
    HWPayViewClickTypeCancel = 100,
    /* 确认 */
    HWPayViewClickTypeConfirm = 101,
    /* 忘记密码 */
    HWPayViewClickTypeForget = 102,
} HWPayViewClickType;
NS_ASSUME_NONNULL_BEGIN

@interface HWPayPopoView : UIView
+ (HWPayPopoView *)payPopoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(nonatomic, copy) void(^buttonClickBlock)(HWPayViewClickType type, NSString *password);
@end

NS_ASSUME_NONNULL_END
