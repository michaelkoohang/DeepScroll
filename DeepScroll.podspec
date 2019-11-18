#
# Be sure to run `pod lib lint DeepScroll.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DeepScroll'
  s.version          = '0.1.0'
  s.summary          = 'The toolkit allows iOS developers to create content views that recognize input from three vertical scroll lanes and dynamically resize themselves.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  The toolkit allows iOS developers to create content views that recognize input from three vertical scroll lanes and dynamically resize themselves based on a tagging system that is associated with the scroll lane input. This results in an interaction technique that allows the user to sift through content more efficiently and reduce the total amount of time they spend scrolling.
  DESC

  s.homepage         = 'https://github.com/parthv21/DeepScroll'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'parthv21' => 'parthv21@gmail.com' }
  s.author           = { 'mkoohang' => 'michael.s.k1001@gmail.com' }
  s.source           = { :git => 'https://github.com/parthv21/DeepScroll.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'DeepScroll/Classes/**/*'
  
  s.source = {
    "git": "https://github.com/parthv21/DeepScroll.git",
    "tag": "0.1.0"
  }
  
  s.swift_version =  "5"
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
