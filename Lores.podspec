#
# Be sure to run `pod lib lint Lores.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Lores'
  s.version          = '0.1.0'
  s.summary          = 'A framework for learning programming using low-resolution (lores) graphics.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A framework for learning programming using low-resolution (lores) graphics. This is how I learned how to program back in the Apple // days, with the Apple's "lores mode" being 40x40 pixels and 16 colors, and the "hires mode" being 280x192 and 8 colors. This library lets you select your resolution and lets you use full 32-bit colors, but the principle of learning is the same.
                       DESC

  s.homepage         = 'https://github.com/wolfmcnally/Lores'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wolfmcnally' => 'wolf@wolfmcnally.com' }
  s.source           = { :git => 'https://github.com/wolfmcnally/Lores.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '4.0'
  s.ios.deployment_target = '11.0'
  s.macos.deployment_target = '10.13'

  s.source_files = 'Lores/Classes/**/*'

  # s.resource_bundles = {
  #   'Lores' => ['Lores/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'WolfCore', '~> 2.1'
end
