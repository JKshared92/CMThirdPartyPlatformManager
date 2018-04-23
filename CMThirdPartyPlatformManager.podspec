#
# Be sure to run `pod lib lint CMThirdPartyPlatformManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CMThirdPartyPlatformManager'
  s.version          = '1.0.0'
  s.summary          = '第三方平台组件'

  s.homepage         = 'https://github.com/JKshared92/CMThirdPartyPlatformManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'comma' => '506702341@qq.com' }
  s.source           = { :git => 'https://github.com/JKshared92/CMThirdPartyPlatformManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.ios.frameworks = 'UIKit','Foundation','SystemConfiguration','CFNetwork'

  s.subspec 'Core' do |core|
      core.source_files        = 'CMThirdPartyPlatformManager/Classes/Core/*.{h,m}'
      core.public_header_files = 'CMThirdPartyPlatformManager/Classes/Core/*.h'
  end

  s.subspec 'ShareUI' do |shareUI|
      shareUI.source_files        = 'CMThirdPartyPlatformManager/Classes/ShareUI/*.{h,m}'
      shareUI.public_header_files = 'CMThirdPartyPlatformManager/Classes/ShareUI/*.h'
      shareUI.dependency   'pop'
      shareUI.dependency   'Masonry'

  end

  s.subspec 'WechatSDK' do |wechatSDK|
      wechatSDK.source_files        = 'CMThirdPartyPlatformManager/Classes/ThirdParty/WechatSDK/*.{h,m}'
      wechatSDK.public_header_files = 'CMThirdPartyPlatformManager/Classes/ThirdParty/WechatSDK/*.h'
      wechatSDK.vendored_libraries  = 'CMThirdPartyPlatformManager/Classes/ThirdParty/WechatSDK/libWeChatSDK.a'
      wechatSDK.frameworks = 'UIKit','Foundation','SystemConfiguration','CFNetwork','Security','CoreTelephony','CFNetwork','CoreGraphics','CoreMotion'
      wechatSDK.libraries = 'z', 'sqlite3.0', 'c++'
  end

  s.subspec 'Wechat' do |wechat|
      wechat.source_files        = 'CMThirdPartyPlatformManager/Classes/Wechat/*.{h,m}'
      wechat.public_header_files = 'CMThirdPartyPlatformManager/Classes/Wechat/*.h'
      wechat.dependency 'CMThirdPartyPlatformManager/Core'
      wechat.dependency 'CMThirdPartyPlatformManager/WechatSDK'
  end

  s.subspec 'AlipaySDK' do |alipaySDK|
      alipaySDK.resources           = 'CMThirdPartyPlatformManager/Classes/ThirdParty/AlipaySDK/AlipaySDK.bundle'
      alipaySDK.vendored_frameworks = ['CMThirdPartyPlatformManager/Classes/ThirdParty/AlipaySDK/AlipaySDK.framework']
      alipaySDK.frameworks = 'UIKit','Foundation','SystemConfiguration','CFNetwork','CoreTelephony','CoreText','CoreGraphics','CoreMotion'
      alipaySDK.libraries = 'z', 'c++'
  end

  s.subspec 'Alipay' do |alipay|
      alipay.source_files        = 'CMThirdPartyPlatformManager/Classes/Alipay/*.{h,m}'
      alipay.public_header_files = 'CMThirdPartyPlatformManager/Classes/Alipay/*.h'
      alipay.dependency 'CMThirdPartyPlatformManager/Core'
      alipay.dependency 'CMThirdPartyPlatformManager/AlipaySDK'
  end

    s.subspec 'QQSDK' do |qqSDK|
      qqSDK.resources           = 'CMThirdPartyPlatformManager/Classes/ThirdParty/QQSDK/TencentOpenApi_IOS_Bundle.bundle'
      qqSDK.vendored_frameworks = ['CMThirdPartyPlatformManager/Classes/ThirdParty/QQSDK/TencentOpenAPI.framework']
      qqSDK.frameworks = 'UIKit','Foundation','SystemConfiguration','CoreTelephony','CoreGraphics','Security'
      qqSDK.libraries = 'z', 'c++', 'iconv', 'sqlite3.0'
  end

  s.subspec 'QQ' do |qq|
      qq.source_files        = 'CMThirdPartyPlatformManager/Classes/QQ/*.{h,m}'
      qq.public_header_files = 'CMThirdPartyPlatformManager/Classes/QQ/*.h'
      qq.dependency 'CMThirdPartyPlatformManager/Core'
      qq.dependency 'CMThirdPartyPlatformManager/QQSDK'
  end

end
