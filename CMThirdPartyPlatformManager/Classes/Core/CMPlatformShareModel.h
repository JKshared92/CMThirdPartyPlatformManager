//
//  CMPlatformShareModel.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMPlatformDefine.h"

@interface CMPlatformShareModel : NSObject

/** 分享的渠道 */
@property (strong, nonatomic) CMPlatformShareType shareType;

/** 多媒体对象格式,和mediaObject相对应 */
@property (assign, nonatomic) CMMediaType         mediaType;

/** 从哪个页面分享 */
@property (weak  , nonatomic) UIViewController     *fromViewController;

/** 分享的标题 */
@property (copy  , nonatomic) NSString     *title;

/** 分享的文字描述 */
@property (copy  , nonatomic) NSString     *describe;

/** 缩略图 */
@property (strong, nonatomic) UIImage      *image;

/** 分享的对象，目前仅支持NSURL/UIImage */
@property (strong, nonatomic) id           mediaObject;

@end
