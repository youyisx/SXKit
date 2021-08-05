#
# Be sure to run `pod lib lint SXKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SXBaseKit'
  s.version          = '0.1.1'
  s.summary          = '常用工具库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SXKit<常用工具库>
                       DESC

  s.homepage         = 'https://github.com/youyisx/SXKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vince_wang' => 'youyisx@hotmail.com' }
  s.source           = { :git => 'https://github.com/youyisx/SXKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.platform         = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  
#   s.resource_bundles = {
#     'SXKit' => ['SXKit/Assets/*.{png,jpg,jpeg,xib}']
#   }
  # 公开头文件
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  #该pod依赖的系统framework，多个用逗号隔开
  # s.frameworks = 'UIKit', 'MapKit'
  #第三方.a文件
  #s.vendored_libraries = 'XXEncryptKit/Classes/ThirdParty/*.a'
  #第三方frameworks文件
  #s.vendored_frameworks = 'XXEncryptKit/Classes/ThirdParty/*.framework'
  
  #依赖关系，该项目所依赖的其他库，如果有多个需要填写多个s.dependency
#  s.dependency 'ReactiveObjC', '~> 3.1.1'
#  s.dependency 'Masonry', '~> 1.1.0'

   # 模块
#   s.static_framework = false
   s.subspec 'SXCommonKit' do |ss|
     ss.source_files = 'SXBaseKit/Classes/SXCommonKit/**/*'
     ss.dependency 'ReactiveObjC', '~> 3.1.1'
     ss.dependency 'Masonry', '~> 1.1.0'
     ss.frameworks = 'UIKit', 'Foundation'
   end
   s.subspec 'SXHUD' do |ss|
     ss.source_files = 'SXBaseKit/Classes/SXHUD/*'
     ss.dependency 'MBProgressHUD', '~> 1.2.0'
     ss.dependency 'SXBaseKit/SXCommonKit'
   end
   s.subspec 'SXUIKit' do |ss|
     ss.source_files = 'SXBaseKit/Classes/SXUIKit/*'
     ss.dependency 'SXBaseKit/SXCommonKit'
   end
   s.subspec 'SXPhotoLibrary' do |ss|
     ss.source_files = 'SXBaseKit/Classes/SXPhotoLibrary/**/*'
     ss.dependency 'SXBaseKit/SXCommonKit'
     ss.dependency 'SXBaseKit/SXHUD'
     ss.frameworks = 'Photos'
     # 在项目中配置宏
     ss.xcconfig = {
       "GCC_PREPROCESSOR_DEFINITIONS" => "SXPHOTOKIT"
     }
   end
   s.subspec 'SXBaseKit' do |ss|
     ss.dependency 'SXBaseKit/SXCommonKit'
     ss.dependency 'SXBaseKit/SXUIKit'
     ss.dependency 'SXBaseKit/SXHUD'
   end
   s.default_subspec = 'SXBaseKit'
   
#   s.subspec 'SXPlayer' do |ss|
#     ss.source_files = 'SXKit/Classes/SXPlayer/*.{h,m}'
#     ss.resource = [
#       'SXKit/Classes/SXPlayer/Resources/*.{png,jpg,jpeg}'
#     ]
#     ss.dependency 'SXKit/SXCommonKit'
#     ss.dependency 'SXKit/SXUIKit'
#     # 腾讯云 超级播放器
#     ss.dependency 'TXLiteAVSDK_Player', '7.4.9203'
#
##    ss.vendored_frameworks = [
##      'SXKit/Classes/SXPlayer/Frameworks/*.framework',
##    ]
##    ss.frameworks = [
##      'SystemConfiguration',
##      'CoreTelephony',
##      'VideoToolbox',
##      'CoreGraphics',
##      'AVFoundation',
##      'Accelerate'
##    ]
##    ss.libraries = [
##      'z',
##      'c++',
##      'resolv',
##      'iconv',
##      'stdc++',
##      'sqlite3',
##    ]
#   end
   s.subspec 'SXVideoTrimmerView' do |ss|
     ss.dependency 'SXBaseKit/SXCommonKit'
     ss.source_files = 'SXBaseKit/Classes/SXVideoTrimmerView/*.{h,m}'
     ss.frameworks = 'UIKit', 'Foundation'
     ss.resource = ['SXBaseKit/Classes/SXVideoTrimmerView/Resources/*.{png,jpg,jpeg}']
   end
   s.subspec 'SXScrollViewStack' do |ss|
     ss.source_files = 'SXBaseKit/Classes/SXScrollViewStack/*'
     ss.dependency 'ReactiveObjC', '~> 3.1.1'
     ss.frameworks = 'UIKit', 'Foundation'
   end
end
