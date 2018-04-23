//
//  CMViewController.m
//  CMThirdPartyPlatformManager
//
//  Created by comma on 04/23/2018.
//  Copyright (c) 2018 comma. All rights reserved.
//

/**
 * 这个主要是用于登陆和支付，微博登陆和其他分享后续会慢慢更新上来d
 */

#import "CMViewController.h"
#import "CMPayOrderModel.h"

@import CMThirdPartyPlatformManager;

@interface CMViewController ()

@end

@implementation CMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)alertMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - login
- (IBAction)loginWithWechat:(id)sender
{
    __weak typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] loginInWithPlatform:PlatformIdentifierWechat fromViewController:self loginBlock:^(CMLoginResult loginResult, NSString *accessToken, NSString *userID, NSError *error) {
        switch (loginResult) {
            case CMLoginResultSuccess:
                [weakSelf alertMessage:@"登录成功"];
                break;
            case CMLoginResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMLoginResultCancel:
                [weakSelf alertMessage:@"取消登录"];
                break;
            default:
                break;
        }
    }];
}
- (IBAction)loginWithQQ:(id)sender
{
    __weak typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] loginInWithPlatform:PlatformIdentifierQQ fromViewController:self loginBlock:^(CMLoginResult loginResult, NSString *accessToken, NSString *userID, NSError *error) {
        switch (loginResult) {
            case CMLoginResultSuccess:
                [weakSelf alertMessage:@"登录成功"];
                break;
            case CMLoginResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMLoginResultCancel:
                [weakSelf alertMessage:@"取消登录"];
                break;
            default:
                break;
        }
    }];
}
- (IBAction)loginWithWeibo:(id)sender
{
    [self alertMessage:@"正在开发中...."];
}

#pragma mark - pay
- (IBAction)payWithWechat:(id)sender
{
    CMWechatPayModel *payModel = [[CMWechatPayModel alloc] init];
    payModel.sign      = @"";
    payModel.prepayID  = @"";
    payModel.partnerID = @"";
    payModel.noncestr  = @"";
    payModel.timeStamp = 1232154;
    
    __weak typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] payWithPlateform:PlatformIdentifierWechat orderModel:payModel payBlock:^(CMPayResult payResult, NSError *error) {
        switch (payResult) {
            case CMPayResultSuccess:
                [weakSelf alertMessage:@"支付成功"];
                break;
            case CMPayResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMPayResultCancel:
                [weakSelf alertMessage:@"取消支付"];
                break;
            default:
                break;
        }
    }];
}

- (IBAction)payWithAlipay:(id)sender
{
    /**如果后台不是返回的一个调起支付宝的链接，需要自己按文档拼接一下*/
    CMPayOrderModel *payModel = [[CMPayOrderModel alloc] init];
    payModel.sign = @"";
    
    __weak typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] payWithPlateform:PlatformIdentifierAlipay orderModel:payModel payBlock:^(CMPayResult payResult, NSError *error) {
        switch (payResult) {
            case CMPayResultSuccess:
                [weakSelf alertMessage:@"支付成功"];
                break;
            case CMPayResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMPayResultCancel:
                [weakSelf alertMessage:@"取消支付"];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - share
- (IBAction)shareToWechatFriend:(id)sender
{
    CMPlatformShareModel *shareModel = [CMPlatformShareModel new];
    shareModel.shareType   = PlatformShareTypeWechatSession;
    shareModel.title       = @"分享的内容";
    shareModel.mediaType   = CMMediaText;
    shareModel.fromViewController = self;
    
    __weak __typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] shareWithPlateform:PlatformIdentifierWechat shareModel:shareModel shareBlock:^(CMShareResult shareResult, NSError *error) {
        switch (shareResult) {
            case CMShareResultSuccess:
                [weakSelf alertMessage:@"分享成功"];
                break;
            case CMShareResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMShareResultCancel:
                [weakSelf alertMessage:@"取消分享"];
                break;
            default:
                break;
        }
    }];
}

- (IBAction)shareToWechatSession:(id)sender
{
    CMPlatformShareModel *shareModel = [CMPlatformShareModel new];
    shareModel.shareType   = PlatformShareTypeWechatTimeLine;
    shareModel.title       = @"分享的标题";
    shareModel.describe    = @"分享的描述";
    shareModel.mediaType   = CMMediaURL;
    shareModel.mediaObject = [NSURL URLWithString:@"https://www.baidu.com"];
    shareModel.fromViewController = self;
    
    __weak __typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] shareWithPlateform:PlatformIdentifierWechat shareModel:shareModel shareBlock:^(CMShareResult shareResult, NSError *error) {
        switch (shareResult) {
            case CMShareResultSuccess:
                [weakSelf alertMessage:@"分享成功"];
                break;
            case CMShareResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMShareResultCancel:
                [weakSelf alertMessage:@"取消分享"];
                break;
            default:
                break;
        }
    }];
}

- (IBAction)shareToWechatCollect:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CMPlatformShareModel *shareModel = [CMPlatformShareModel new];
    shareModel.shareType   = PlatformShareTypeWechatFavorite;
    shareModel.title       = @"分享的标题";
    shareModel.describe    = @"分享的描述";
    shareModel.mediaType   = CMMediaImage;
    shareModel.mediaObject = image;
    shareModel.fromViewController = self;
    
    __weak __typeof(self)weakSelf = self;
    [[CMPlatformManager sharedManager] shareWithPlateform:PlatformIdentifierWechat shareModel:shareModel shareBlock:^(CMShareResult shareResult, NSError *error) {
        switch (shareResult) {
            case CMShareResultSuccess:
                [weakSelf alertMessage:@"分享成功"];
                break;
            case CMShareResultFailed:
                [weakSelf alertMessage:error.localizedDescription];
                break;
            case CMShareResultCancel:
                [weakSelf alertMessage:@"取消分享"];
                break;
            default:
                break;
        }
    }];
}

- (IBAction)shareToWeibo:(id)sender
{
    [self alertMessage:@"正在开发中...."];
}

- (IBAction)shareToQQZone:(id)sender
{
    [self alertMessage:@"正在开发中...."];
}

- (IBAction)shareToQQ:(id)sender
{
    [self alertMessage:@"正在开发中...."];
}

#pragma mark - shareUI
- (IBAction)clickShareUI:(id)sender
{
    
}

@end
