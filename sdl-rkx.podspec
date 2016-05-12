#
# Be sure to run `pod lib lint sdl-rkx.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = "sdl-rkx"
  s.version          = "0.1.0"
  s.summary          = "SDL visual surveys for ResearchKit"

  s.description      = "The Small Data Lab ResearchKit Extensions package is the easiest way to include SDL visual surveys (YADL, MEDL, PAM) into a ResearchKit application."

  s.homepage         = "https://github.com/cornelltech/sdl-rkx"
  s.license          = 'MIT'
  s.author           = { "James Kizer, Cornell Tech Foundry" => "jdk288 at cornell dot edu" }
  s.source           = { :git => "https://github.com/cornelltech/sdl-rkx.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'sdl-rkx/Classes/**/*'

  s.resources = 'sdl-rkx/Assets/PAM.xcassets', 'sdl-rkx/Assets/PAM.json'

  #currently fails lint'ing due to duplicate symbol errors when linking 1.3
  #see https://github.com/ResearchKit/ResearchKit/issues/679
  #and https://github.com/cornelltech/sdl-rkx/issues/1
  #Remove once resolved
  s.dependency 'ResearchKit', '~> 1.3'
end
