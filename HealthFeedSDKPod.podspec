#
# Be sure to run `pod lib lint HealthFeedSDKPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HealthFeedSDKPod'
  s.version          = '0.1.0'
  s.summary          = 'HealthFeedSDKPod is sdk that provide you ability to use Health Feed API'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HealthFeedSDKPod is sdk that provide you ability to use Health Feed API and other features.
                       DESC

  s.homepage         = 'https://github.com/95krasovsky/HealthFeedSDKPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vladislav Krasovsky' => '95krasovsky@gmail.com' }
  s.source           = { :git => 'https://github.com/95krasovsky/HealthFeedSDKPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'HealthFeedSDKPod/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'HealthFeedSDKPod' => ['HealthFeedSDKPod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
s.dependency 'AFNetworking', '~> 3.0'
s.dependency 'AFOAuth2Manager', '~> 3.0'
s.dependency 'NSLogger'
s.dependency 'SDWebImage'
s.dependency 'PBWebViewController'
s.dependency 'MBProgressHUD'

end
