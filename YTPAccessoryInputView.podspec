#
# Be sure to run `pod lib lint YTPAccessoryInputView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YTPAccessoryInputView'
  s.version          = '1.1.0'
  s.summary          = 'A category that adds accessory input view to custom input tool bar.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
YTPAccessoryInputView is a simple library for iOS. If you ever wanted to add extra functionalities to your 
chat or comment page with your custom input tool bar, for example, adding a scroll view with custom stickers or 
sending photos or location info. This library can easily allow toggle between keyboard and the accessory input view. 
With this library, you no longer need to rely on UIAlertController to create action sheet for extra functionalities.
                       DESC

  s.homepage         = 'https://github.com/carlpan/YTPAccessoryInputView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'carlpan' => 'carlpan66@gmail.com' }
  s.source           = { :git => 'https://github.com/carlpan/YTPAccessoryInputView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'YTPAccessoryInputView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YTPAccessoryInputView' => ['YTPAccessoryInputView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
