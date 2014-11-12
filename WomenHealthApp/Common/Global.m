//
//  Global.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-1.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "Global.h"

@implementation Global

- (id)init
{
    self = [super init];
    if (self) {

        //服务器地址
        self.SERVER_HOST = REAL_SERVER_HOST; //正式地址 (不能改)
        
        self.SERVER_HOST_TEST = TEST_SERVER_HOST;
        
        
        self.ORDER_SCAN_PATH = @"/app.php/order/get_order/";
        
        self.ORDER_DETAIL_PATH = @"/app.php/order/get_order_info/";
        
        self.USER_CHECKPHONENUM_PATH = @"/app.php/user/check_mobile/";
        
        self.USER_VERIFICATIONCODE_PATH= @"/app.php/user/send_code/";
        
        self.USER_REGISTER_PATH = @"/app.php/user/reg/";
        
        self.USER_LOGIN_PATH = @"/app.php/user/login/";
        
        self.USER_INFO_PATH = @"/app.php/user/get_info/";
        
        self.USER_LOGINOUT_PATH = @"/app.php/user/logout/";
        
        self.USER_CHANGENAME_PATH = @"/app.php/user/update_info/";
        
        self.USER_CHANGEPASSWORD_PATH = @"/app.php/user/update_pwd/";
        
        self.USER_HEADPIC_PATH = @"/app.php/user/update_pic/";
        
        self.USER_FINDVERIFICATIONCODE_PATH = @"/app.php/user/send_pwd_code/";
        
        self.USER_RESETPASSWORD_PATH = @"/app.php/user/reset_pwd/";
        
        self.ORDER_PAY_PATH = @"/app.php/order/pay_order/";
        
        self.ORDER_PAY_BACK_PATH = @"/app.php/order/pay_order_callback/";
        
        self.ORDER_RECORD_PATH = @"/app.php/order/get_order_list/";
        
        self.ORDER_REFUND_PATH = @"/app.php/order/apply_refund/";
        
        self.SET_NEWVERSION_PATH = @"/app.php/update/get_newest_version/";
        
        self.GB_LIST_PATH = @"/app.php/order/get_tuan_coupon_list/";
        
    }
    return self;
}

/**
 单例
 @returns
 */
+(Global *)share {
    static dispatch_once_t pred;
    static Global *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Global alloc] init];
    });
    return shared;
}


@end
