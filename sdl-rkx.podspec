#
# Be sure to run `pod lib lint sdl-rkx.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "sdl-rkx"
  s.version          = "0.1.0"
  s.summary          = "SDL visual surveys for ResearchKit"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "The Small Data Lab ResearchKit Extensions package is the easiest way to include SDL visual surveys (YADL, MEDL, PAM) into a ResearchKit application."

  s.homepage         = "https://github.com/cornelltech/sdl-rkx"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "James Kizer, Cornell Tech Foundry" => "jdk288 at cornell dot edu" }
  s.source           = { :git => "https://github.com/cornelltech/sdl-rkx.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'sdl-rkx/Classes/**/*'

  # s.resource_bundles = {
  #   'sdl-rkx' => ['sdl-rkx/Assets/PAM.*']
  # }

  s.resources = 'sdl-rkx/Assets/PAM.xcassets', 'sdl-rkx/Assets/PAM.json'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ResearchKit', '1.3'
end
