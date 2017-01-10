#
# Be sure to run `pod lib lint sdlrkx.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = "sdlrkx"
  s.version          = "0.2.0"
  s.summary          = "SDL visual self-report for ResearchKit"

  s.description      = "The Small Data Lab ResearchKit Extensions package is the easiest way to include SDL visual self-report (YADL, MEDL, PAM) into a ResearchKit application."

  s.homepage         = "https://github.com/cornelltech/sdl-rkx"
  s.license          = 'Apache 2.0'
  s.author           = { "James Kizer, Cornell Tech Foundry" => "jdk288 at cornell dot edu" }
  s.source           = { :git => "https://github.com/cornelltech/sdl-rkx.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'source/Classes/**/*'

  s.resources = 'source/Assets/PAM.xcassets', 'source/Assets/PAM.json'

  s.dependency 'ResearchKit', '~> 1.3.1'
end
